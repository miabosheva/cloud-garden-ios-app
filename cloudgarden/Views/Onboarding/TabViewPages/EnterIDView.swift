import SwiftUI
import NotificationBannerSwift
import ProgressHUD

struct EnterIDView: View {
    
    // MARK: - Properties
    @State var goToNextScreen: Bool = false
    @Binding var tab: OnboardingTab
    @State var deviceId = ""
    @State var deviceName = ""
    var progress = 1.0
    
    @EnvironmentObject private var userModel: UserModel
    @EnvironmentObject private var deviceAndPlantModel: DeviceAndPlantModel
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("Step 3: Enter the ID you see on the Device")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 32)
                .padding(.bottom, 8)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("customDarkGreen"))
                .padding(.top, 50)
            
            Text("Your device comes with a unique ID. You can find it written on the device. Enter the ID below.")
                .font(.footnote)
                .foregroundColor(Color("customDarkGreen"))
                .padding(.horizontal, 32)
                .padding(.bottom, 8)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            HStack{
                Text("Device ID")
                    .font(.headline)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 4)
                    .foregroundColor(.black)
                Spacer()
            }
            
            RoundedRectangle(cornerRadius: 27)
                .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                .shadow(radius: 2, x: 0, y: 0)
                .overlay{
                    TextField("Device ID", text: $deviceId)
                        .padding()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.bottom, 8)
            HStack{
                Text("Device Name")
                    .font(.headline)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 4)
                    .foregroundColor(.black)
                Spacer()
            }
            
            RoundedRectangle(cornerRadius: 27)
                .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                .shadow(radius: 2, x: 0, y: 0)
                .overlay{
                    TextField("Name your device", text: $deviceName)
                        .padding()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
            
            HStack (spacing: 16) {
                Button {
                    self.tab = .step3
                } label: {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .foregroundColor(Color("customDarkGreen"))
                        .overlay{
                            Text("Back")
                                .foregroundColor(.white)
                        }
                }
                
                Button (action: processAddNewDevice) {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .foregroundColor(Color("customLimeGreen"))
                        .overlay{
                            Text("Next")
                                .foregroundColor(.white)
                        }
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            ProgressView(value: progress, label: { Text("")
                .font(.subheadline)})
            .frame(maxWidth: .infinity)
            .tint(Color("customLimeGreen"))
            .padding(.horizontal, 32)
            
            HStack (spacing: 60) {
                Spacer()
                
                Image("drop-1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 20)
                Image("drop-2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 20)
                Image("drop-3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 20)
                Image("drop-4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 20)
                    .padding(.trailing, 24)
            }
            .padding(.bottom, 32)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func processAddNewDevice(){
        ProgressHUD.animate()
        let banner = GrowingNotificationBanner(title: "Please Enter a Valid ID", style: .danger)
        if deviceId != "" && deviceName != "" {
            Task {
                do {
                    let _ = try await deviceAndPlantModel.addUserToDevice(code: deviceId, title: deviceName)
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                        userModel.dismissView()
                    }
                } catch {
                    DispatchQueue.main.async {
                        banner.show()
                        ProgressHUD.dismiss()
                    }
                }
            }
        } else {
            banner.show()
            ProgressHUD.dismiss()
        }
    }
}
