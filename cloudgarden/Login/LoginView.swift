import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    
    @State var username = ""
    @State var password = ""
    
    var appBackground: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color("customLemon"), Color("customGreen")]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        
        ZStack {
            
            appBackground.ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Username")
                        .foregroundColor(.white)
                    Spacer()
                }
                .frame(width:350)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 350, height: 44, alignment: .center)
                    .foregroundColor(.white)
                    .overlay{
                        TextField("Username", text: $username).padding()
                    }
                
                HStack {
                    Text("Password")
                        .foregroundColor(.white)
                    Spacer()
                }
                .frame(width:350)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 350, height: 44, alignment: .center)
                    .foregroundColor(.white)
                    .overlay{
                        SecureField("Password", text: $password).padding()
                    }
                
                Button("Log In") {
                    self.isLoggedIn = true
                }
                .navigationTitle("Home")
                .buttonBorderShape(.capsule)
                .frame(width: 350, height: 44, alignment: .center)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(
                        cornerRadius: 15,
                        style: .continuous).fill(Color("customDarkGreen")))
                .padding()
            }
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(true))
}
