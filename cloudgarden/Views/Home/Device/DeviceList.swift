import SwiftUI
import NotificationBannerSwift

class RefreshManager: ObservableObject {
    @Published var shouldRefresh = false
    
    func triggerRefresh() {
        shouldRefresh = true
    }
}

struct DeviceList: View {
    
    // MARK: - Properties
    @StateObject private var refreshManager = RefreshManager()
    @State var goToAddDevice: Bool = false
    var model: DeviceAndPlantModel
    @State private var devices: [Device] = []
    @State private var refresh: Bool = false
    
    // MARK: - Init
    init(model: DeviceAndPlantModel){
        self.model = model
    }
    
    var body: some View {
        
        NavigationSplitView {
            ZStack {
                List{
                    ForEach(devices) { device in
                        NavigationLink {
                            DeviceDetail(device: device, model: model)
                        } label: {
                            DeviceRow(device: device, model: model)
                        }
                    }
                    .onDelete(perform: deleteDevice)
                }
                .onAppear {
                    Task {
                        await getAllDevices()
                    }
                }
                .refreshable {
                    Task {
                        await getAllDevices()
                    }
                }
                .onReceive(refreshManager.$shouldRefresh) { shouldRefresh in
                    if shouldRefresh {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            refreshManager.shouldRefresh = false
                        }
                    }
                }
                .animation(.default, value: model.devices)
                .navigationTitle("Devices")
                
                VStack {
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                
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
                AddDevice(model: model, refreshManager: refreshManager)
            }
        } detail: {
            Text("Devices")
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
    
    func deleteDevice(at offsets: IndexSet) {
        for index in offsets {
            let deletedItemId = devices[index].deviceId
            Task {
                do {
                    // TODO: - implement function
                    let result = try await model.deleteDevice(deviceId: deletedItemId)
                    if result {
                        DispatchQueue.main.async {
                            let banner = NotificationBanner(title: "Sucessfuly deleted Plant \(devices[index].code)", style: .success)
                            banner.show()
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Failed to delete plant", style: .danger)
                        banner.show()
                    }
                }
            }
            print("Deleted item with ID:", deletedItemId)
        }
    }
}
