import SwiftUI

struct PlantDetail: View {
    
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    private let plant: Plant
    private let imageName: String = "defaultPlant"
    private let status: String = "well watered"
    @State private var date = Date()
    @State private var showSheet = true
    private var model: DeviceAndPlantModel
    
//    let measurements: [MeasurementResponse]
    
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
                            Text("\(getLastWateringEntry())d ago")
                                .font(.system(size: 24, weight: .medium))
                            Text("Last Watering")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                            
                        }
                        Spacer()
                        VStack {
                            Text("\(getHealth())%")
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
                    print(date)
                } label: {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 44)
                        .foregroundColor(.green)
                        .overlay{
                            Text("Add watering Entry")
                                .foregroundColor(.white)
                        }
                }
            }
            .presentationDetents([.medium,.large])
            .presentationBackground(.regularMaterial)
            .interactiveDismissDisabled()
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
        }
//        .modifier(SwipeToDismissModifier {
//            print("im Here")
//            showSheet = false
//        })
        .navigationBarBackButtonHidden()
    }
    
    func addWateringEntry() {
        
    }
    
    func getHealth() -> Int {
        let plantHealth = plant.plantHealth!
        let percentage = plantHealth * 100
        let formattedPercentage = String(format: "%.2f%%", percentage)
        return Int(percentage)
    }
    
    func getLastWateringEntry() -> Int {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        if let startDate = dateFormatter.date(from: date) {
//            if let days = daysSinceDate(startDate) {
//                print("Days since the start date: \(days)")
//                return days
//            } else {
//                print("Failed to calculate the number of days.")
//            }
//        } else {
//            print("Invalid start date format.")
//        }
        return 0
    }
    
    func daysSinceDate(_ date: Date) -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.day], from: date, to: currentDate)
        return components.day
    }
}
