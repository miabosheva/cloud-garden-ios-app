import SwiftUI
import NotificationBannerSwift

struct PlantDetail: View {
    
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    private let plant: Plant
    private let imageName: String = "defaultPlant"
    private let status: String = "well watered"
    @State private var date = Date()
    @State private var showSheet = true
    @State var deviceTitle: String = ""
    @State var daysSinceLastWatering: Int = 0
    @State var plantHealthPercentage: Int = 0
    @State var measurements: [MeasurementResponse] = []
    private var model: DeviceAndPlantModel
    
    // MARK: - Init
    init(plant: Plant, model: DeviceAndPlantModel) {
        self.plant = plant
        self.model = model
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: UIImage(named: "plantBackground")!)
                .resizable()
                .frame(maxWidth: .infinity)
                .scaledToFill()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        .sheet(isPresented: $showSheet) {
            ScrollView(.vertical, showsIndicators: false) {
                // Sheet Header
                VStack(alignment: .leading) {
                    HStack{
                        Button {
                            showSheet = false
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack{
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.customGreen)
                                Text("Back").foregroundColor(.customGreen)
                            }
                        }
                    }
                    .padding(.bottom, 6)
                    
                    
                    HStack(spacing:14)  {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 75, height: 75)
                                .foregroundColor(.white)
                            Text("🌱")
                                .font(.system(size:30))
                            
                        }
                        
                        VStack(alignment:.leading) {
                            Text("\(plant.title)")
                                .font(.system(size: 24, weight: .semibold))
                            Text("Device: \(model.devices.filter{$0.deviceId == plant.deviceId}[0].title)")
                                .font(.system(size: 16, weight: .regular))
                        }
                    }
                    .padding(.bottom, 12)
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("\(daysSinceLastWatering)d ago")
                                .font(.system(size: 24, weight: .medium))
                            Text("Last Watering")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack {
                            Text("\(plantHealthPercentage)%")
                                .font(.system(size: 24, weight: .medium))
                            Text("Avg. Health")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    
                    
                }
                Divider()
                    .padding(.vertical,10)
                
                // MARK: - Chart
                Text("The chart is under construction")
                
                Divider()
                    .padding(.vertical,10)
                
                // Add A watering Entry
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .tint(.green)
                .datePickerStyle(.graphical)
                
                Button {
                    scheduleLocalNotification()
                    addWateringEntry()
                } label: {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 44)
                        .foregroundColor(.green)
                        .overlay{
                            Text("Add a Watering Entry")
                                .foregroundColor(.white)
                        }
                }
            }
            .presentationDetents([.medium,.large])
            .presentationBackground(.regularMaterial)
            .interactiveDismissDisabled()
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
        }
        .onAppear {
            self.daysSinceLastWatering = getLastWateringEntry()
            self.plantHealthPercentage = getHealth()
            Task {
                await getLastTenMeasurements()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func addWateringEntry() {
        if date > Date() {
            let banner = NotificationBanner(title: "Please choose a Date before today.", style: .warning)
            banner.show()
            return
        }
        
        Task {
            do {
                let _ = try await model.setLastWateringEntry(plantId: self.plant.plantId, date: date)
            } catch {
                DispatchQueue.main.async {
                    let banner = NotificationBanner(title: "Error while adding a new watering entry.", subtitle: "Please try again.", style: .danger)
                    banner.show()
                }
            }
        }
    }
    
    private func getHealth() -> Int {
        let plantHealth = plant.plantHealth!
        let percentage = plantHealth * 100
        return Int(percentage)
    }
    
    private func getLastWateringEntry() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var startDate = Date()
        
        if let lastWatering = plant.lastWatering {
            startDate = dateFormatter.date(from: self.plant.lastWatering!) ?? Date()
        }
        
        if let days = daysSinceDate(startDate) {
            print("Days since the start date: \(days)")
            return days
        } else {
            print("Failed to calculate the number of days.")
        }
        return 0
    }
    
    private func daysSinceDate(_ date: Date) -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.day], from: date, to: currentDate)
        return components.day
    }
    
    private func getLastTenMeasurements() async {
        do {
            let measurements = try await model.getLastTenMeasurements(plantId: self.plant.plantId)
            DispatchQueue.main.async {
                self.measurements = measurements
                print(measurements[0].date!)
            }
        } catch {
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Error loading measurements", style: .warning)
                banner.show()
            }
        }
    }
    
    private func scheduleLocalNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "CloudGarden"
        content.body = "\(self.plant.title) needs watering!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled")
            }
        }
    }
}
