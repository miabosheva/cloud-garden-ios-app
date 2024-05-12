import SwiftUI
import NotificationBannerSwift
import ProgressHUD
import LocalAuthentication

struct AddDevice: View {
    
    // MARK: - Properites
    @Environment(\.presentationMode) var presentationMode
    @State private var titleValue: String = ""
    @State private var codeValue: String = ""
    @State private var goToAddPlant: Bool = false
    @ObservedObject var refreshManager: RefreshManager
    private var model: DeviceAndPlantModel
    
    // MARK: - Init
    init(model: DeviceAndPlantModel, refreshManager: RefreshManager){
        self.model = model
        self.refreshManager = refreshManager
    }
    
    // MARK: - Body
    var body: some View {
        
        NavigationView {
            VStack (alignment: .center) {
                
                Text("Add a New Device")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.top, 16)
                
                HStack {
                    Text("Enter Device ID")
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 0, y: 0)
                    .overlay{
                        TextField("Enter Device ID", text: $codeValue).padding()
                    }
                    .padding(.horizontal, 16)
                
                HStack {
                    Text("The device ID can be found written on top of the physical device.")
                        .font(.caption)
                        .foregroundColor(Color.secondary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 8)
                .padding(.top, 4)
                .padding(.bottom, 8)
                
                HStack {
                    Text("Device Name")
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 0, y: 0)
                    .overlay{
                        TextField("Enter Device Name", text: $titleValue).padding()
                    }
                    .padding(.horizontal, 16)
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
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                Spacer()
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        .accentColor(.customDarkGreen)
    }
    
    // MARK: - API call
    func addDeviceButtonTapped(){
        ProgressHUD.animate()
        let successfulBanner = NotificationBanner(title: "Device successfully added.", style: .success)
        let errorBanner = NotificationBanner(title: "Error occured when adding the device.", style: .danger)
        let warningBanner = NotificationBanner(title: "Device ID or Title is invalid.", style: .warning)
        
        if codeValue != "" && titleValue != "" {
            Task {
                do {
                    let _ = try await model.addUserToDevice(code: codeValue, title: titleValue)
                    DispatchQueue.main.async {
                        successfulBanner.show()
                        self.presentationMode.wrappedValue.dismiss()
                        refreshManager.triggerRefresh()
                    }
                    self.titleValue = ""
                    self.codeValue = ""
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        errorBanner.show()
                    }
                    self.codeValue = ""
                    self.titleValue = ""
                }
            }
        } else {
            warningBanner.show()
        }
        ProgressHUD.dismiss()
    }
}
