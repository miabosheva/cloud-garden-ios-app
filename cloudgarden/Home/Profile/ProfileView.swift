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
            
            Text("Change password")
            
            TextField("**********", text: $passwordChanged)
                .background(Color("customGrey"))
                .frame(width: 300, height: 44, alignment: .leading)
            
            Button ("Change Password"){
                // TODO: - Change password functionality
            }
            .buttonStyle(.bordered)
            .frame(width: 300, height: 44, alignment: .center)
            
            VStack(alignment: .leading) {
                
                Text("Devices connected: \(modelData.devices.count)")
                
                Text("Total Plants: \(modelData.plants.count)")
                
                Button("Help"){
                    // TODO: - Go to help screen
                }
                
                Button("Reset Data"){
                    // TODO: - Reset data, "confirm reset data" screen overlay
                }
            }
            
            Spacer()
            
            Button ("Log Out") {
                // TODO: - Log Out funcitonality
            }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ProfileView().environment(ModelData())
}
