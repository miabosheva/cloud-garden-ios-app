import SwiftUI

struct DeviceRow: View {
    
    // MARK: - Properties
    private var imageName = "defaultPlant"
    private var device: Device
    private var model: DeviceAndPlantModel
    
    // MARK: - Init
    init(device: Device, model: DeviceAndPlantModel){
        self.device = device
        self.model = model
    }
    
    var body: some View {
        
        HStack {
            
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 75, height: 75)
                .foregroundColor(.customOffWhite)
                .overlay {
                    Text("🤖")
                        .font(.system(size:33))
                }
                .padding(.trailing, 10)
            
            
            VStack (alignment: .leading) {
                
                Text(device.title)
                    .fontWeight(.semibold)
                    .font(.title2)
                
                Text("Device ID: \(device.deviceId)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 4)
                
                Text("Number of Plants: \(model.getPlantCount(deviceId: device.deviceId))")
                    .font(.footnote)
            }
        }
        .padding(.vertical, 8)
    }
}
