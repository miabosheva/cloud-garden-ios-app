import SwiftUI
import NotificationBannerSwift
import ProgressHUD
import LocalAuthentication

struct AddDevice: View {
    
    // MARK: - Properites
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var model: DeviceAndPlantModel
    @Binding var goToAddDevice: Bool
    @State private var titleValue: String = ""
    @State private var codeValue: String = ""
    @State private var goToAddPlant: Bool = false
    
    // MARK: - Body
    var body: some View {
        
        VStack (alignment: .center) {
            
            Divider()
            
            VStack {
                HStack {
                    Text("Enter Device ID")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                Text("The device ID can be found written on top of the physical device.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            RoundedRectangle(cornerRadius: 15)
                .frame(maxWidth: .infinity,
                       maxHeight: 44,
                       alignment: .center)
                .foregroundColor(.white)
                .shadow(radius: 2, x: 0, y: 0)
                .overlay{
                    TextField("Enter Device ID", text: $codeValue).padding()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            Divider()
            
            HStack {
                Text("Device Name")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            RoundedRectangle(cornerRadius: 15)
                .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                .foregroundColor(.white)
                .shadow(radius: 2, x: 0, y: 0)
                .overlay{
                    TextField("Enter Device Name", text: $titleValue)
                        .padding()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            Divider()
            
            Button(action: addDeviceButtonTapped) {
                RoundedRectangle(cornerRadius: 27)
                    .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                    .foregroundColor(.customLimeGreen)
                    .overlay{
                        Text("Submit")
                            .foregroundColor(.white)
                    }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            Spacer()
        }
        .navigationTitle("Add a Device")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .toolbar {
            ToolbarItem {
                Button("Close") {
                    goToAddDevice = false
                }
                .bold()
                .foregroundColor(.customLimeGreen)
            }
        }
    }
    
    // MARK: - API call
    func addDeviceButtonTapped(){
        ProgressHUD.animate()
        let successfulBanner = NotificationBanner(title: "Device successfully added.", style: .success)
        let errorBanner = NotificationBanner(title: "Incorrect Device ID.", style: .danger)
        let warningBanner = NotificationBanner(title: "Device ID or Title is invalid.", style: .warning)
        
        if codeValue != "" && titleValue != "" {
            Task {
                do {
                    try await model.addUserToDevice(code: codeValue, title: titleValue)
                    DispatchQueue.main.async {
                        successfulBanner.show()
                        self.presentationMode.wrappedValue.dismiss()
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
