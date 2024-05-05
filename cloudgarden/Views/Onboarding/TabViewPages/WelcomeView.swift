import SwiftUI

struct WelcomeView: View {
    
    @Binding var tab: OnboardingTab
    
    var progress = 0.25
    
    var body: some View {
            VStack{
                
                Spacer()
                
                Text("Welcome to\n CloudGarden")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("customGreen"))
                    .padding(.top, 80)
                
                Text("We will setup your virtual garden in 4 steps.")
                    .fontWeight(.semibold)
                    .font(.title3)
                    .foregroundColor(Color("customDarkGreen"))
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                Button {
                    self.tab = .step2
                } label: {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: 150, maxHeight: 44, alignment: .center)
                        .foregroundColor(Color("customLimeGreen"))
                        .overlay{
                            Text("Next")
                                .foregroundColor(.white)
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
        }
}
