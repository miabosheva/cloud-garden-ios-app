import SwiftUI

struct RegisterView: View {
    
    @StateObject private var userModel = UserViewModel()
    
    @State var showOnboarding: Bool = false
    @State var username = ""
    @State var password = ""
    
    var appBackground: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color("customLemon"), Color("customGreen")]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        NavigationView{
            
            ZStack {
                
                appBackground.ignoresSafeArea()
                
                VStack(alignment: .center) {
                    
                    Text("Welcome to")
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Cloud Garden")
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .fontWeight(.bold)
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
                        // TODO: - Implement register functionality
                        // if the user is succesfully logged in then:
                        showOnboarding = true
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                            .foregroundColor(Color("customGreen"))
                            .overlay{
                                Text("Sign Up")
                                    .foregroundColor(.white)
                            }
                    }
                    .padding(.horizontal, 16)
                    
                    NavigationLink(
                        destination: WelcomeView().navigationBarBackButtonHidden(true),
                        isActive: $showOnboarding,
                        label: {
                            EmptyView()
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
