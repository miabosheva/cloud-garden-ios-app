import SwiftUI

struct DeviceRow: View {
    
    var device: Device
    
    var imageName = "defaultPlant"
    var deviceName = "Device Name"
    var plantNumber = 0
    
    var body: some View {
        HStack {
            
            Image(imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .padding(.trailing, 10)
            
            VStack (alignment: .leading) {
                
                
                Text(device.title)
                    .font(.title2)
                
                Text("Plants: \(device.numberOfPlants)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                
                HStack {
                    
                    Button{
                        // TODO: - Popup add device
                    } label: {
                        RoundedRectangle(cornerRadius: 27)
                            .frame(maxWidth: .infinity, maxHeight: 30, alignment: .center)
                            .foregroundColor(Color("customGreen"))
                            .overlay{
                                Text("Add Device")
                                    .fontWeight(.semibold)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                    }
                    
                    Button{
                        // TODO: - Popup are you sure you want to delete?
                    } label: {
                        RoundedRectangle(cornerRadius: 27)
                            .frame(maxWidth: .infinity, maxHeight: 30, alignment: .center)
                            .foregroundColor(Color("customRed"))
                            .overlay{
                                Text("Delete Device")
                                    .fontWeight(.semibold)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                    }
                    
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    
    let devices = ModelData().devices
    
    return Group {
        DeviceRow(device: devices[0])
    }
}
