import SwiftUI

struct EnterIDView: View {
    
    @State var goToNextScreen: Bool = false
    @Binding var tab: OnboardingTab
    
    @State var deviceId = ""

    // TODO: save the response in this var
    var device = ModelData().devices[0]
    
    var progress = 1.0
    
    var body: some View {
            VStack{
                
                Spacer()
                
                Text("Step 3: Enter the ID you see on the Device")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("customDarkGreen"))
                    .padding(.top, 70)
                
                Text("Your device comes with a unique ID. You can find it written on the device. Enter the ID below.")
                    .font(.footnote)
                    .foregroundColor(Color("customDarkGreen"))
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                RoundedRectangle(cornerRadius: 27)
                    .frame(maxWidth: .infinity, maxHeight: 38, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 0, y: 0)
                    .overlay{
                        TextField("Device ID", text: $deviceId).padding()
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
                
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
                    
                    Button {
                        // TODO: - API Call Add a Device with DeviceID
                        // Open up the view from the specified DeviceID
                        // call get device by deviceid
                        // Call DeviceDetail(device)
                        self.goToNextScreen.toggle()
                    } label: {
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
                
                NavigationLink(
                    destination: AddDevice().navigationBarBackButtonHidden(true),
                    isActive: $goToNextScreen){}
                
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
        }
}

#Preview {
    EnterIDView(tab: .constant(OnboardingTab.step4))
}
