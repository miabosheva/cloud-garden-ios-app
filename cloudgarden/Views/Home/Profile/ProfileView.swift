import SwiftUI

struct ProfileView: View {
    
    // MARK: - Properites
    @State private var newPassword: String = ""
    
    @ObservedObject private var userModel: UserModel
    private var deviceAndPlantModel: DeviceAndPlantModel
    @State private var deviceCount: Int = 0
    @State private var plantCount: Int = 0
    
    @State private var imageTaken: UIImage?
    @State private var isCameraViewShown = false
    
    init(userModel: UserModel, deviceAndPlantModel: DeviceAndPlantModel) {
        self.userModel = userModel
        self.deviceAndPlantModel = deviceAndPlantModel
    }
    
    var body: some View {
        ZStack {
            Colors.appBackground.ignoresSafeArea()
            ZStack {
                VStack {
                    Spacer()
                    
                    VStack {
                        Text("\(userModel.user!.username)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.top, 80)
                        
                        Divider()
                            .padding(.vertical,10)
                        
                        HStack(spacing: 80) {
                            VStack(alignment: .leading) {
                                Text("Devices")
                                    .font(.headline)
                                    .bold()
                                Text("Connected: \(deviceCount)")
                                    .font(.subheadline)
                            }
                            VStack(alignment: .leading){
                                Text("Plants")
                                    .font(.headline)
                                Text("Connected: \(plantCount)")
                                    .font(.subheadline)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical,10)
                        
                        VStack(alignment: .center) {
                            
                            Button {
                                // TODO: - Help screens
                            } label: {
                                RoundedRectangle(cornerRadius: 27)
                                    .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                                    .foregroundColor(.customLemon)
                                    .overlay{
                                        Text("Help")
                                            .bold()
                                            .foregroundColor(.white)
                                    }
                            }
                            .disabled(true)
                            .padding(.horizontal, 32)
                            .padding(.bottom, 8)
                            
                            Button {
                                // TODO: - Backend reset API call
                            } label: {
                                RoundedRectangle(cornerRadius: 27)
                                    .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                                    .foregroundColor(.customLemon)
                                    .overlay{
                                        Text("Reset Data")
                                            .bold()
                                            .foregroundColor(.white)
                                    }
                            }
                            .disabled(true)
                            .padding(.horizontal, 32)
                            .padding(.bottom, 16)
                        }
                        
                        Spacer()
                        
                        Button {
                            userModel.logOut()
                        } label: {
                            RoundedRectangle(cornerRadius: 27)
                                .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                                .foregroundColor(.customRed)
                                .overlay{
                                    Text("Log Out")
                                        .foregroundColor(.white)
                                }
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 16)
                    }
                    .frame(maxHeight: 600)
                    .background(.regularMaterial)
                }
                
                VStack {
                    ZStack {
                        ZStack{
                            Image(uiImage: imageTaken ?? .defaultPlant)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.customOffWhite, lineWidth: 4)
                                }
                            VStack {
                                
                                Spacer()
                                
                                HStack {
                                    
                                    Button {
                                        self.isCameraViewShown.toggle()
                                    } label: {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 80, height: 44, alignment: .center)
                                            .foregroundColor(.customLimeGreen)
                                            .overlay{
                                                Text("Change Photo")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.white)
                                            }
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .frame(width: 144, height: 144)
                            
                        }
                    }
                    .padding(.top, 42)
                    .background(.clear)
                    Spacer()
                }
                
            }
        }
        .fullScreenCover(isPresented: $isCameraViewShown) {
            AccessCameraView(selectedImage: $imageTaken)
                .ignoresSafeArea()
        }
        .onAppear {
            self.deviceCount = deviceAndPlantModel.devices.count
            self.plantCount = deviceAndPlantModel.plants.count
        }
    }
}

struct AccessCameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

// Coordinator will help to preview the selected image in the View.
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: AccessCameraView
    
    init(picker: AccessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
}
