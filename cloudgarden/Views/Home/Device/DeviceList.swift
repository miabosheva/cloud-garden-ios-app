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
    @ObservedObject private var model: DeviceAndPlantModel
    @StateObject private var refreshManager = RefreshManager()
    @State private var goToAddDevice: Bool = false
    
    // MARK: - Init
    init(model: DeviceAndPlantModel){
        self.model = model
    }
    
    var body: some View {
        
        NavigationSplitView {
            ZStack {
                List{
                    if model.devices.count > 0 {
                        ForEach(model.devices) { device in
                            NavigationLink {
                                DeviceDetail(device: device, model: model)
                            } label: {
                                DeviceRow(device: device, model: model)
                            }
                        }
                        .onDelete(perform: deleteDevice)
                    } else {
                        EmptyLottieView(keyword: "devices")
                    }
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
                NavigationStack {
                    AddDevice(goToAddDevice: $goToAddDevice).environmentObject(model)
                }
            }
        } detail: {
            Text("Devices")
        }
        .accentColor(.customGreen)
    }
    
    
    // MARK: - Helper Methods
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
    
    func deleteDevice(at offsets: IndexSet) {
        for index in offsets {
            let deletedItemId = model.devices[index].deviceId
            Task {
                do {
                    let deviceCode = model.devices[index].code
                    try await model.deleteDevice(deviceId: deletedItemId)
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Sucessfuly deleted Device \(deviceCode)", style: .success)
                        banner.show()
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Failed to delete device.", style: .danger)
                        banner.show()
                    }
                }
            }
            
            Task {
                do {
                    try await model.getDevicesByUsername()
                } catch {
                    let banner = NotificationBanner(title: "Error occured while loading devices.", style: .danger)
                    banner.show()
                }
            }
            
            print("Deleted device with ID:", deletedItemId)
        }
    }
}
