import SwiftUI
import ProgressHUD
import NotificationBannerSwift
import LocalAuthentication
import KeychainAccess

struct LoginView: View {
    
    var userModel: UserModel
    @State var username = ""
    @State var password = ""
    @State var attempts: Int = 0
    
    init(userModel: UserModel){
        self.userModel = userModel
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Colors.appBackground.ignoresSafeArea()
                
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
                    
                    Button(action: logInButtonTapped) {
                        RoundedRectangle(cornerRadius: 27)
                            .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                            .foregroundColor(Color("customDarkGreen"))
                            .overlay {
                                Text("Log In")
                                    .foregroundColor(.white)
                            }
                    }
                    .modifier(Shake(animatableData: CGFloat(attempts)))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 4)
                    
                    NavigationLink(destination: RegisterView(userModel: userModel).tint(.customOffWhite)) {
                        Text("Dont have an account?")
                            .foregroundColor(.white)
                        Text("Sign Up").underline().foregroundColor(.white)
                    }
                    .padding(.bottom, 80)
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .onAppear{
            Task.detached{ @MainActor in
                authenticationWithFaceId()
            }
        }
    }
    
    func authenticationWithFaceId() {
        
        let context = LAContext()
        var error: NSError?
        
        let keychain = Keychain(service: "com.finki.cloudgarden")
        guard let savedAuthInfo = try? keychain.getData("authInfo") else { return }
        let decoder = JSONDecoder()
        guard let authInfo = try? decoder.decode(User.self, from: savedAuthInfo) else { return }
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Authenticate to access the app"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success, authenticationError in
                if success {
                    ProgressHUD.animate()
                    Task { @MainActor in
                        do {
                            let success = try await userModel.logIn(username: authInfo.username, password: authInfo.password)
                            if success {
                                userModel.setupViews(user: User(username: authInfo.username, password: authInfo.password))
                            } else {
                                let banner = NotificationBanner(title: "Login with FaceID unavailable. Please input your credentials.", style: .warning)
                                banner.show()
                            }
                        } catch {
                            let banner = NotificationBanner(title: "Invalid credentials. Please try again.", style: .danger)
                            banner.show()
                            print(error)
                        }
                        ProgressHUD.dismiss()
                    }
                }
            }
        } else {
            let banner = NotificationBanner(title: "Biometric authentication unavailable.", style: .warning)
            banner.show()
        }
    }
    
    func logInButtonTapped(){
        ProgressHUD.animate()
        let loginFailedBanner = NotificationBanner(title: "Login credentials invalid", style: .danger)
        let invalidCredentialsBanner = NotificationBanner(title: "Please input valid credentials", style: .warning)
        
        if username != "" && password != "" {
            Task { @MainActor in
                do {
                    let _ = try await userModel.logIn(username: self.username, password: self.password)
                    userModel.setupViews(user: User(username: username, password: password))
                } catch {
                    withAnimation(.default) {
                        self.attempts += 1
                    }
                    loginFailedBanner.show()
                }
                ProgressHUD.dismiss()
            }
        } else {
            withAnimation(.default) {
                self.attempts += 1
            }
            ProgressHUD.dismiss()
            invalidCredentialsBanner.show()
        }
    }
}

// MARK: - Shake Effect for TextField
struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}
