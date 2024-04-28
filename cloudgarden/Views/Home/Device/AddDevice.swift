import SwiftUI

struct AddDevice: View {
    
    @State var newNamePlaceholder: String = "Untitled Device"
    @State var deviceIdPlaceholder: String = "Enter the Device ID"
    @State var goToAddPlant: Bool = false
    
    var model: DeviceAndPlantModel

    init(model: DeviceAndPlantModel){
        self.model = model
    }
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .center) {
                
                Text(newNamePlaceholder)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.top, 32)
                
                HStack {
                    Text("Enter Device ID")
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 0, y: 0)
                    .overlay{
                        TextField("\(deviceIdPlaceholder)", text: $deviceIdPlaceholder).padding()
                    }
                    .padding(.horizontal, 32)
                
                Text("The device ID can be found written on top of the physical device.")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
//                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                
                
                HStack {
                    Text("Device Name")
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 0, y: 0)
                    .overlay{
                        TextField("\(newNamePlaceholder)", text: $newNamePlaceholder).padding()
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
                
                Button {
                    model.addNewDevice(deviceId: deviceIdPlaceholder)
                } label: {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                        .foregroundColor(Color("customLimeGreen"))
                        .overlay{
                            Text("Submit")
                                .foregroundColor(.white)
                        }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
                
                Spacer()
            }
        }
    }
}
