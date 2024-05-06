import SwiftUI

struct DeviceRow: View {
    
    // MARK: - Properties
    
    var imageName = "defaultPlant"
    
    var device: Device
    var model: DeviceAndPlantModel
    
    // MARK: - Init
    
    init(device: Device, model: DeviceAndPlantModel){
        self.device = device
        self.model = model
    }
    
    var body: some View {
        
        HStack {
            
            Image(imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .padding(.trailing, 10)
            
            VStack (alignment: .leading) {
                
                // TODO: - When you add a title to the model change this
                Text(device.code)
                    .font(.title2)
                
                Text("Number of plants: \(model.getPlantCount(deviceId: device.deviceId) ?? 0)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
