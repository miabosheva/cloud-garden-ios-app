import SwiftUI

struct DeviceDetail: View {
    
    // MARK: - Properties
    @State private var newName: String = ""
    @State private var goToAddPlant: Bool = false
    @State private var goToHome: Bool = false
    private let device: Device
    private var model: DeviceAndPlantModel
    
    // MARK: - Init
    init(device: Device, model: DeviceAndPlantModel){
        self.device = device
        self.model = model
    }
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .center){
                
                Text(device.title)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.top, 8)
                
                Text("Device ID: \(device.deviceId)")
                    .font(.footnote)
                
                
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
                        TextField("\(newName)", text: $newName).padding()
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
                
                Button {
                    model.changeDeviceName(title: newName)
                } label: {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                        .foregroundColor(Color("customLimeGreen"))
                        .overlay{
                            Text("Save Name")
                                .foregroundColor(.white)
                        }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                if (device.plants != nil) {
                    Text("\(newName)'s Plants")
                        .font(.title3)
                        .bold()
                    List{
                        ForEach(device.plants!) { plant in
                            PlantRow(plant: plant)
                        }
                    }
                } else {
                    
                }
                
                Button{
                    goToAddPlant.toggle()
                } label: {
                    
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .foregroundColor(Color("customDarkGreen"))
                        .overlay{
                            Text("Add a Plant to Device")
                                .foregroundColor(.white)
                        }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 8)
                
            }
        }
        .accentColor(.customDarkGreen) 
        .sheet(isPresented: $goToAddPlant, content:{
            AddPlant(model: model, deviceId: device.deviceId)
        })
    }
}
