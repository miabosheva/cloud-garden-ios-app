import SwiftUI
import ProgressHUD
import NotificationBannerSwift
import LocalAuthentication
import KeychainAccess

struct LoginView: View {
    
    var userModel: UserModel
    @State var username = ""
    @State var password = ""
    
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
                    Task {
                        do {
                            let success = try await userModel.logIn(username: authInfo.username, password: authInfo.password)
                            if success {
                                DispatchQueue.main.async {
                                    ProgressHUD.dismiss()
                                    userModel.setupViews(user: User(username: authInfo.username, password: authInfo.password))
                                }
                            } else {
                                DispatchQueue.main.async {
                                    ProgressHUD.dismiss()
                                    let banner = NotificationBanner(title: "Login with FaceID unavailable. Please input your credentials.", style: .warning)
                                    banner.show()
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                                ProgressHUD.dismiss()
                                let banner = NotificationBanner(title: "Invalid credentials. Please try again.", style: .danger)
                                banner.show()
                                print(error)
                            }
                        }
                    }
                }
            }
        } else {
            print("Biometric authentication unavailable")
        }
        ProgressHUD.dismiss()
    }
    
    func logInButtonTapped(){
        ProgressHUD.animate()
        let bannerFailed = NotificationBanner(title: "Login credentials invalid", style: .danger)
        
        let bannerError = NotificationBanner(title: "Please input valid credentials", style: .warning)
        
        if username != "" && password != "" {
            Task {
                do {
                    let success = try await userModel.logIn(username: self.username, password: self.password)
                    if success {
                        DispatchQueue.main.async {
                            ProgressHUD.dismiss()
                            userModel.setupViews(user: User(username: username, password: password))
                        }
                    } else {
                        DispatchQueue.main.async {
                            ProgressHUD.dismiss()
                            bannerFailed.show()
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                        bannerFailed.show()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                bannerError.show()
            }
        }
    }
}
