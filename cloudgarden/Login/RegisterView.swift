import SwiftUI

struct RegisterView: View {
    
    @State var showOnboarding: Bool = false
    
    @State var username = ""
    @State var password = ""
    
    var appBackground: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color("customLemon"), Color("customGreen")]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        
        ZStack {
            
            appBackground.ignoresSafeArea()
            
            VStack {
                
                Image("logo")
                    .resizable()
                    .frame(width: 80, height: 120)
                    .padding(.top, 30)
                    .padding(.bottom, 16)
                
                Text("Welcome\n to Cloud Garden")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
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
                
                // TODO: - Fix the button
                
                Button("Sign Up") {
                    self.showOnboarding = true
                }
                .navigationTitle("Home")
                .buttonStyle(.bordered)
                .frame(width: 350, height: 44, alignment: .center)
//                .foregroundColor(.white)
//                .background(
//                    RoundedRectangle(
//                        cornerRadius: 15,
//                        style: .continuous).fill(Color("customDarkGreen")))
                .padding(.bottom, 150)
                .padding(.top, 16)
                
                
                
            }
        }
    }
}

#Preview {
    RegisterView()
}
