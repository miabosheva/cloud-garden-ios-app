import Foundation
import UIKit

class DeviceAndPlantModel: ObservableObject {
    
    var modelData: ModelData = ModelData()
    
    private weak var window: UIWindow!
    var authInfo: AuthInfo?
    
    var devices: [Device] = []
    var plants: [Plant] = []
    
    init(authInfo: AuthInfo?){
        self.authInfo = authInfo
    }
    
    // MARK: - Helper methods - Device
    
    func changeDeviceName(title: String) {
        return 
    }
    
    func addNewDevice(deviceId: String) {
        return
    }
    
    func getAllDevices() -> [Device] {
        if self.devices.isEmpty {
            self.devices = modelData.devices
        }
        return self.devices
    }
    
    func deletePlant(deviceId: Int) {
        // TODO
        return
    }
    
    func getPlantCount(deviceId: Int) -> Optional<Int> {
        // TODO
        return 0
    }
    
    // MARK: - Helper Methods - Plant
    
    func addPlant(deviceId: Int){
        return
    }
    
    func getAllPlants() -> [Plant] {
        if self.plants.isEmpty {
            // do an api call
            self.plants = modelData.plants
        }
        return self.plants
    }
}
