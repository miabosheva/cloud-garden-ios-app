import SwiftUI
import NotificationBannerSwift
import ProgressHUD

struct AddEmptyPlant: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var model: DeviceAndPlantModel
    @Binding var goToAddEmptyPlant: Bool
    @State var newNamePlaceholder: String = ""
    @State private var selectedTypeIndex: Int = 0
    @State private var selectedDeviceIndex: Int = 0
    @State private var devices: [Device] = []
    @State private var types: [PlantType] = []
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center) {
                
                Text("Add a New Plant")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.top, 16)
                
                HStack {
                    Text("Plant Name")
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 38)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 0, y: 0)
                    .overlay{
                        TextField("Enter Plant Name", text: $newNamePlaceholder).padding()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                // MARK: - Picker Plant Type
                GroupBox{
                    VStack {
                        Picker("Choose a Plant Type", selection: $selectedTypeIndex) {
                            ForEach(0..<types.count, id: \.self) { index in
                                Text("\(types[index].plantTypeName)").tag(index)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .frame(maxWidth: .infinity)
                    }
                    .tint(.black)
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 4)
                
                // MARK: - Picker Device
                VStack {
                    HStack {
                        Text("Select a Device")
                        Spacer()
                    }
                    
                    Picker("Choose a Device", selection: $selectedDeviceIndex) {
                        ForEach(0..<devices.count, id: \.self) { index in
                            Text("\(devices[index].title)").tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                }
                .tint(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                
                // MARK: - Picker Sensor
                VStack {
                    HStack {
                        Text("Select a Sensor")
                        Spacer()
                    }
                    
                    Picker("Choose a Device", selection: $selectedDeviceIndex) {
                        ForEach(0..<devices.count, id: \.self) { index in
                            Text("\(devices[index].code)").tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                }
                .tint(.black)
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 4)
                
                Spacer()
                
                Button(action: addPlantButtonTapped) {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 38)
                        .foregroundColor(.green)
                        .overlay{
                            Text("Submit")
                                .foregroundColor(.white)
                                .bold()
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        goToAddEmptyPlant = false
                    }
                }
            }
        }
        .onAppear {
            Task {
                await getAllTypes()
                print(self.types)
            }
            Task {
                await getAllDevices()
                print(self.devices)
            }
        }
        .accentColor(.customGreen)
    }
    
    func addPlantButtonTapped(){
        ProgressHUD.animate()
        
        let successfulBanner = NotificationBanner(title: "Plant successfully added.", style: .success)
        let errorBanner = NotificationBanner(title: "Error occured when adding the plant.", style: .danger)
        let warningBanner = NotificationBanner(title: "Title is invalid.", style: .warning)
        
        if self.newNamePlaceholder != "" {
            Task {
                do {
                    let result = try await model.addPlant(title: newNamePlaceholder, deviceId: devices[selectedDeviceIndex].deviceId, plantTypeId: types[selectedTypeIndex].plantTypeId)
                    if result {
                        DispatchQueue.main.async {
                            successfulBanner.show()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        self.newNamePlaceholder = ""
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        errorBanner.show()
                    }
                    self.newNamePlaceholder = ""
                }
            }
        } else {
            warningBanner.show()
        }
        ProgressHUD.dismiss()
    }
    
    func getAllTypes() async {
        do {
            let types = try await model.getTypes()
            self.types = types
        } catch {
            print("Error loading types: \(error)")
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Error occured. Refresh the page.", style: .warning)
                banner.show()
            }
        }
    }
    
    func getAllDevices() async {
        do {
            let devices = try await model.getDevicesByUsernameRequest()
            self.devices = devices
        } catch {
            print("Error loading devices: \(error)")
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Error occured. Refresh the page.", style: .warning)
                banner.show()
            }
        }
    }
}
