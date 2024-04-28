import SwiftUI

struct DeviceList: View {
    
    // MARK: - Properties
    
    @State var goToAddDevice: Bool = false
    var model: DeviceAndPlantModel
    
    // MARK: - Init
    
    init(model: DeviceAndPlantModel){
        self.model = model
    }
    
    var body: some View {
        
        NavigationSplitView {
            ZStack {
                List{
                    ForEach(model.getAllDevices()) { device in
                        NavigationLink {
                            DeviceDetail(device: device, model: model)
                        } label: {
                            DeviceRow(device: device, model: model)
                        }
                    }
                    .onDelete(perform: deleteDevice)
                }
                .animation(.default, value: model.devices)
                .navigationTitle("Devices")
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            self.goToAddDevice.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 27)
                                .frame(maxWidth: 130, maxHeight: 50, alignment: .center)
                                .foregroundColor(Color("customDarkGreen"))
                                .overlay{
                                    Text("Add a Device")
                                        .foregroundColor(.white)
                                }
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
            .sheet(isPresented: $goToAddDevice) {
                AddDevice(model: model)
            }
        } detail: {
            Text("Devices")
        }
    }
    
    func deleteDevice(at offsets: IndexSet) {
        for index in offsets {
            let deletedItemId = model.devices[index].macAddress
            //            items.remove(at: index)
            print("Deleted item with ID:", deletedItemId)
        }
    }
}
