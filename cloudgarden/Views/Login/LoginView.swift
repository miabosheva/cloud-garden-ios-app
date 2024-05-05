import SwiftUI
import ProgressHUD
import NotificationBannerSwift

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
                    
                    Button (action: logInButtonTapped){
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
                
            }
            
        }
    }
    
    func logInButtonTapped(){
        ProgressHUD.animate()
        let bannerFailed = NotificationBanner(title: "Login Failed. Try Again", style: .danger)
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
                bannerFailed.show()
            }
        }
    }
}
