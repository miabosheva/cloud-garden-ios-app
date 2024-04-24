import SwiftUI

struct DeviceList: View {
    
    @Environment(ModelData.self) var modelData
    
    @State var goToAddDevice: Bool = false
    
    var body: some View {
        
        NavigationSplitView {
            ZStack {
                List{
                    ForEach(modelData.devices) { device in
                        NavigationLink {
                            DeviceDetail(device: device)
                        } label: {
                            DeviceRow(device: device)
                        }
                    }
                }
                .animation(.default, value: modelData.devices)
                .navigationTitle("Devices")
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            self.goToAddDevice.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 27)
                                .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
                                .foregroundColor(Color("customDarkGreen"))
                                .overlay{
                                    Text("+")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                        }
                        .padding(.trailing, 32)
                        .padding(.bottom, 16)
                    }
                    
                    NavigationLink(destination: AddDevice(), isActive: $goToAddDevice) {}
                }
            }
        } detail: {
            Text("Devices")
        }
    }
}

#Preview {
    
    DeviceList().environment(ModelData())
}
