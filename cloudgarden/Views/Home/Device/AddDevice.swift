import SwiftUI
import NotificationBannerSwift
import ProgressHUD
import LocalAuthentication

struct AddDevice: View {
    
    // MARK: - Properites
    @Environment(\.presentationMode) var presentationMode
    @State private var newNamePlaceholder: String = ""
    @State private var deviceIdPlaceholder: String = ""
    @State private var goToAddPlant: Bool = false
    @ObservedObject var refreshManager: RefreshManager
    private var model: DeviceAndPlantModel
    
    // MARK: - Init
    init(model: DeviceAndPlantModel, refreshManager: RefreshManager){
        self.model = model
        self.refreshManager = refreshManager
    }
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .center) {
                
                Text("Add a New Device")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.top, 32)
                
                HStack {
                    Text("Enter Device ID")
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 0, y: 0)
                    .overlay{
                        TextField("Enter Device ID", text: $deviceIdPlaceholder).padding()
                    }
                    .padding(.horizontal, 32)
                
                Text("The device ID can be found written on top of the physical device.")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
                    .padding(.horizontal, 8)
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                
                HStack {
                    Text("Device Name")
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 0, y: 0)
                    .overlay{
                        TextField("Enter Device Name", text: $newNamePlaceholder).padding()
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
                
                Button(action: addDeviceButtonTapped) {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                        .foregroundColor(Color("customLimeGreen"))
                        .overlay{
                            Text("Submit")
                                .foregroundColor(.white)
                        }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
                
                Spacer()
            }
            .onAppear(perform: authenticate)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
    // MARK: - Helper Methods
    func addDeviceButtonTapped(){
        ProgressHUD.animate()
        let successfulBanner = NotificationBanner(title: "Device successfully added.", style: .success)
        let errorBanner = NotificationBanner(title: "Error occured when adding the device.", style: .danger)
        let warningBanner = NotificationBanner(title: "Device ID or Title is invalid.", style: .warning)
        
        if deviceIdPlaceholder != "" && newNamePlaceholder != "" {
            Task {
                do {
                    let result = try await model.addNewDeviceToUser(deviceId: deviceIdPlaceholder)
                    if result {
                        DispatchQueue.main.async {
                            successfulBanner.show()
                            self.presentationMode.wrappedValue.dismiss()
                            refreshManager.triggerRefresh()
                        }
                        self.deviceIdPlaceholder = ""
                        self.newNamePlaceholder = ""
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        errorBanner.show()
                    }
                    self.deviceIdPlaceholder = ""
                    self.newNamePlaceholder = ""
                }
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
            }
        } else {
            warningBanner.show()
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    print("great")
                    // authenticated successfully
                } else {
                    print("problem")
                    // there was a problem
                }
            }
        } else {
            print("no biometrics")
            // no biometrics
        }
    }
}
