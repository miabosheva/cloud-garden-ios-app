import SwiftUI

struct ProfileView: View {
    @State var passwordChanged: String = ""
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        VStack {
            Text(modelData.users[0].username)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 16)
            
            Spacer()
            
            
            GroupBox {
                HStack {
                    Text("Change password")
                        .padding(.leading, 16)
                    Spacer()
                }
                
                RoundedRectangle(cornerRadius: 27)
                    .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 0, y: 0)
                    .overlay{
                        TextField("**********", text: $passwordChanged)
                            .padding(.horizontal, 8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                Button {
                    // TODO: - Change password functionality
                } label: {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .foregroundColor(Color("customLemon"))
                        .overlay{
                            Text("Change Password")
                                .foregroundColor(.white)
                        }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                VStack(alignment: .center) {
                    
                    Text("Devices connected: \(modelData.devices.count)")
                    
                    Text("Total Plants: \(modelData.plants.count)")
                    
                    Button("Help"){
                        // TODO: - Go to help screen
                    }
                    
                    Button("Reset Data"){
                        // TODO: - Reset data, "confirm reset data" screen overlay
                    }
                }
            }
            
            
            Spacer()
            
            Button {
                // TODO: - Logout fucntionality
            } label: {
                RoundedRectangle(cornerRadius: 27)
                    .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                    .foregroundColor(Color("customRed"))
                    .overlay{
                        Text("Log Out")
                            .foregroundColor(.white)
                    }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    ProfileView().environment(ModelData())
}
