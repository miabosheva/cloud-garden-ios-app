import SwiftUI
import NotificationBannerSwift
import ProgressHUD

struct AddPlant: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var model: DeviceAndPlantModel
    @State var newNamePlaceholder: String = ""
    @State private var selectedTypeIndex: Int = 0
    @State private var types: [PlantType] = []
    private var device: Device
    
    // MARK: - Init
    init(model: DeviceAndPlantModel, device: Device) {
        self.model = model
        self.device = device
    }
    
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
                    TextField("Enter Plant Name", text: $newNamePlaceholder).padding()
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
            
            Button(action: addPlantButtonTapped) {
                RoundedRectangle(cornerRadius: 27)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 44)
                    .foregroundColor(.customGreen)
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
        .navigationTitle("Add a Plant to Device: \(device.title)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Close")
                        .bold()
                        .foregroundColor(.customGreen)
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            Task {
                await getAllTypes()
                print(self.types)
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
                    let result = try await model.addPlant(title: newNamePlaceholder, deviceId: self.device.deviceId, plantTypeId: types[selectedTypeIndex].plantTypeId)
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
}
