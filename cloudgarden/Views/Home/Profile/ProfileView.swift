import SwiftUI

struct ProfileView: View {
    
    // MARK: - Properites
    @State private var newPassword: String = ""
    
    private var userModel: UserModel
    private var deviceAndPlantModel: DeviceAndPlantModel
    @State private var deviceCount: Int = 0
    @State private var plantCount: Int = 0
    
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
                            Circle()
                                .foregroundColor(.customLimeGreen)
                                .frame(height: 140)
                            Circle()
                                .foregroundColor(.customOffWhite)
                                .frame(height: 134)
                            Text("👤")
                                .font(.system(size: 50))
                        }
                    }
                    .padding(.top, 42)
                    .background(.clear)
                    Spacer()
                }
                
            }
        }
        .onAppear {
            self.deviceCount = deviceAndPlantModel.devices.count
            self.plantCount = deviceAndPlantModel.plants.count
        }
    }
}
