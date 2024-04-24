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
                    
                    Button ("Add Plant") {
                        
                    }
                    // TODO: - Design
//                    .frame(width: 80, height:37)
                    .background(Color("customGreen"))
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
//                    .padding(.leading, 8)
                    
                    Button ("Delete Device") {
                        
                    }
                    // TODO: - Design
//                    .frame(width: 80, height:37)
                    .foregroundColor(.white)
                    .background(Color("customRed"))
                    .buttonStyle(.bordered)
                    
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
