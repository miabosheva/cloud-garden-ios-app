import SwiftUI

struct RegisterView: View {
    
    @State var showOnboarding: Bool = false
    @State var username = ""
    @State var password = ""
    
    private var userModel: UserModel
    
    init(userModel: UserModel) {
        self.userModel = userModel
    }
    
    var body: some View {
        NavigationView{
            
            ZStack {
                
                Colors.appBackground.ignoresSafeArea()
                
                VStack(alignment: .center) {
                    
                    Text("Let's start by")
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("signing you up.")
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
                        if userModel.register(username: username, password: password){
                            showOnboarding = true
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 27)
                            .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                            .foregroundColor(Color("customDarkGreen"))
                            .overlay{
                                Text("Sign Up")
                                    .foregroundColor(.white)
                            }
                    }
                    .padding(.bottom, 80)
                    .padding(.horizontal, 16)
                    
                    NavigationLink(
                        destination: OnboardingView(userModel: userModel).navigationBarBackButtonHidden(true),
                        isActive: $showOnboarding){}
                }
            }
        }
    }
}
