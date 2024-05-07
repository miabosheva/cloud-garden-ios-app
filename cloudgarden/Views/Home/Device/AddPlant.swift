import SwiftUI

struct AddPlant: View {
    
    // MARK: - UNDER CONSTRUCTION
    private var model: DeviceAndPlantModel
    private var deviceId: Int
    
    init(model: DeviceAndPlantModel, deviceId: Int){
        self.model = model
        self.deviceId = deviceId
    }
    
    var body: some View {
        Text("Add plant")
        
        // TODO: - UI Not finished
        
        Button {
            // send form info to model
//            model.addPlant(deviceId: deviceId)
        } label: {
            Text("Submit")
        }
    }
}
