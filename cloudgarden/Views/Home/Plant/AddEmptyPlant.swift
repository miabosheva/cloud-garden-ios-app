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
    @State private var types: [PlantType] = []
    
    var body: some View {
        VStack (alignment: .center) {
            Divider()
            
            HStack {
                Text("Plant Name")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            RoundedRectangle(cornerRadius: 15)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 44)
                .foregroundColor(.white)
                .shadow(radius: 2, x: 0, y: 0)
                .overlay{
                    TextField("Enter Plant Name", text: $newNamePlaceholder)
                        .padding()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            Divider()
            
            // MARK: - Picker Plant Type
            VStack {
                Picker("Plant Type", selection: $selectedTypeIndex) {
                    ForEach(0..<types.count, id: \.self) { index in
                        Text("\(types[index].plantTypeName)")
                            .tag(index)
                    }
                }
                .pickerStyle(.navigationLink)
                .frame(maxWidth: .infinity)
            }
            .fontWeight(.semibold)
            .tint(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Divider()
            
            // MARK: - Picker Device
            VStack {
                VStack {
                    HStack {
                        Text("Select a Device")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    HStack {
                        Text("A device can monitor up to 3 plants.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
                
                Picker("Choose a Device", selection: $selectedDeviceIndex) {
                    ForEach(0..<model.devices.count, id: \.self) { index in
                        Text("\(model.devices[index].title)")
                            .tag(index)
                    }
                }
                .font(.title3)
                .fontWeight(.semibold)
                .pickerStyle(.segmented)
                .frame(maxWidth: .infinity)
            }
            .tint(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Button(action: addPlantButtonTapped) {
                RoundedRectangle(cornerRadius: 27)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 44)
                    .foregroundColor(.customLimeGreen)
                    .overlay{
                        Text("Submit")
                            .foregroundColor(.white)
                            .bold()
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            
            Spacer()
        }
        .navigationTitle("Add a Plant")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    goToAddEmptyPlant = false
                } label: {
                    Text("Close")
                        .bold()
                        .foregroundColor(.customLimeGreen)
                }
            }
        }
        .onAppear {
            Task {
                await getAllTypes()
            }
            Task {
                await getAllDevices()
            }
        }
        .accentColor(.customLimeGreen)
    }
    
    func addPlantButtonTapped(){
        ProgressHUD.animate()
        
        let successfulBanner = NotificationBanner(title: "Plant successfully added.", style: .success)
        let errorBanner = NotificationBanner(title: "Error occured when adding the plant.", style: .danger)
        let warningBanner = NotificationBanner(title: "Title is invalid.", style: .warning)
        
        if self.newNamePlaceholder != "" {
            Task {
                do {
                    let result = try await model.addPlant(title: newNamePlaceholder, deviceId: model.devices[selectedDeviceIndex].deviceId, plantTypeId: types[selectedTypeIndex].plantTypeId)
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
            try await model.getDevicesByUsername()
        } catch {
            print("Error loading devices: \(error)")
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Error occured. Refresh the page.", style: .warning)
                banner.show()
            }
        }
    }
}
