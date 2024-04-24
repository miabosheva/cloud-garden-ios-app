import SwiftUI

struct ConnectToWifiView: View {
    
    @Binding var isPresented: Bool
    @State var goToNextScreen: Bool = false
    
    var progress = 0.5
    
    var body: some View {
        NavigationView{
            VStack{
                
                Spacer()
                
                Text("Step 1: Connect to your Home Wi-Fi")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("customDarkGreen"))
                    .padding(.top, 80)
                
                Text("Open Settings > Wi-Fi and connect to your home network. Make sure you know your password. Go to next step after connecting.")
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundColor(Color("customDarkGreen"))
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                HStack (spacing: 16) {
                    Button {
                        self.isPresented = false
                    } label: {
                        RoundedRectangle(cornerRadius: 27)
                            .frame(maxWidth: 150, maxHeight: 44, alignment: .center)
                            .foregroundColor(Color("customDarkGreen"))
                            .overlay{
                                Text("Back")
                                    .foregroundColor(.white)
                            }
                    }
                    
                    Button {
                        self.goToNextScreen.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 27)
                            .frame(maxWidth: 150, maxHeight: 44, alignment: .center)
                            .foregroundColor(Color("customLimeGreen"))
                            .overlay{
                                Text("Next")
                                    .foregroundColor(.white)
                            }
                    }
                }
                
                NavigationLink(
                    destination: ClickOnTheLinkView(isPresented: $goToNextScreen).navigationBarBackButtonHidden(true),
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
}

#Preview {
    ConnectToWifiView(isPresented: .constant(true))
}
