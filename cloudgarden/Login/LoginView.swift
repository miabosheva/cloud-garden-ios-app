import SwiftUI

struct LoginView: View {
    
    @StateObject private var userModel = UserViewModel()
    
    @State var isLoggedIn: Bool = false
    
    @State var username = ""
    @State var password = ""
    
    var appBackground: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color("customLemon"), Color("customGreen")]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                appBackground.ignoresSafeArea()
                
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    
                    Image("logo")
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 155)
                        .padding(.bottom, 8)
                    
                    Text("CloudGarden")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Gardening made easier.")
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                    
                    HStack {
                        Text("Username")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .foregroundColor(.white)
                        .overlay{
                            TextField("Username", text: $username).padding()
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    
                    HStack {
                        Text("Password")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .foregroundColor(.white)
                        .overlay{
                            SecureField("Password", text: $password).padding()
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    
                    Button {
                        // TODO: - Implement login functionality
                        self.isLoggedIn = true
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                            .foregroundColor(Color("customGreen"))
                            .overlay{
                                Text("Log In")
                                    .foregroundColor(.white)
                            }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 4)
                    
                    NavigationLink(destination: RegisterView()){
                        // TODO: - Go to registerView
                        Text("Dont have an account?")
                            .foregroundColor(.white)
                        Text("Sign In").underline().foregroundColor(.white)
                    }
                    
                    // TODO: - Bug when the homeview loads
                    
                    NavigationLink(destination: HomeNavigationView().navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true),
                                   isActive: $isLoggedIn,
                                   label: {
                        EmptyView()
                    })
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
