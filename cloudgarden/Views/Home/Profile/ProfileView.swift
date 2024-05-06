import SwiftUI

struct ProfileView: View {
    
    // MARK: - Properites
    @State private var newPassword: String = ""
    private var model: UserModel
    
    init(model: UserModel){
        self.model = model
    }
    
    var body: some View {
        VStack {
            Text(model.user!.username)
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
                        TextField("**********", text: $newPassword)
                            .padding(.horizontal, 8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                Button {
                    // TODO: - Change password functionality
                    model.changePasswordForUser(newPassword: newPassword)
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
                    
                    Text("Devices connected: \(model.getDeviceCount())")
                    
                    Text("Total Plants: \(model.getPlantCount())")
                    
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
                model.logOut()
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
