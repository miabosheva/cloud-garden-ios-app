import SwiftUI

struct DeviceDetail: View {
    
    let device: Device
    
    var body: some View {
        Text(device.title)
    }
}

#Preview {
    
    let devices = ModelData().devices
    
    return Group {
        DeviceDetail(device: devices[0])
    }
}
