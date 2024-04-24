import SwiftUI

struct ClickOnTheLinkView: View {
    
    @Binding var isPresented: Bool
    @State var goToNextScreen: Bool = false
    
    var progress = 0.75
    
    var body: some View {
        NavigationView{
            VStack{
                
                Spacer()
                
                Text("Step 2: Click on the button")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("customDarkGreen"))
                    .padding(.top, 80)
                
                Text("The button will take you to a site where you need to enter your home Wi-Fi credentials. This will help your home device connect to the internet. After filling the form in the browser, come back to the app and click next.")
                    .font(.footnote)
                    .foregroundColor(Color("customDarkGreen"))
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                Button {
                    // TODO: - Navigate to web site
                } label: {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .foregroundColor(Color("customRed"))
                        .overlay{
                            Text("Very Important Button")
                                .foregroundColor(.white)
                        }
                }
                .padding(.horizontal, 32)
                
                HStack (spacing: 16) {
                    Button {
                        self.isPresented = false
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
                    destination: EnterIDView(isPresented: $goToNextScreen).navigationBarBackButtonHidden(true),
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
    ClickOnTheLinkView(isPresented: .constant(true))
}