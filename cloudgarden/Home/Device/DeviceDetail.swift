import SwiftUI

struct DeviceDetail: View {
    
    let device: Device
    @State var newName: String = "Untitled Device"
    @State var goToAddPlant: Bool = false
    @State var goToHome: Bool = false
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .center){
                
                Text(newName)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.top, 8)
                
                Text("TODO: device ID")
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
                    // TODO: - Change name
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
                
                Spacer()
                
                // Check if list of plants is empty and prompt user to add more
                if !ModelData().plants.isEmpty {
                    Text("\(newName)'s Plants")
                        .font(.title3)
                        .bold()
                    NavigationStack {
                        List{
                            ForEach(ModelData().plants) { plant in
                                NavigationLink {
                                    PlantDetail(plant: plant)
                                } label: {
                                    PlantRow(plant: plant)
                                }
                            }
                        }
                    }
                } else {
                    LottieView(animationFileName: "empty.json", loopMode: .loop)
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 64)
                        .frame(maxWidth: .infinity)
                    Text("You havent yet added a plant for this device.")
                        .font(.caption)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 100)
                }
                
                Button{
                    // TODO: - API call to add a plant
                    goToAddPlant.toggle()
                } label: {
                    
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .foregroundColor(Color("customDarkGreen"))
                        .overlay{
                            Text("Add a New Plant")
                                .foregroundColor(.white)
                        }
                }
                .padding(.horizontal, 32)
                .padding(.top, 8)
                
                NavigationLink(
                    destination: HomeNavigationView().navigationBarBackButtonHidden(true),
                    isActive: $goToHome){}
            }
        }
        .sheet(isPresented: $goToAddPlant, content:{
            PlantDetail(plant: ModelData().plants[0])
        })
    }
}

#Preview {
    let devices = ModelData().devices
    
    return Group {
        DeviceDetail(device: devices[0])
    }
}
