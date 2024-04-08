//
//  LoginSwiftUI.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 8.4.24.
//

import SwiftUI

struct LoginSwiftUI: View {
    
    @State var username = ""
    @State var password = ""
    
    var appBackground: LinearGradient = LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Username")
                        .foregroundColor(.white)
                    Spacer()
                }.frame(width:350)
                
                RoundedRectangle(cornerRadius: 15).frame(width: 350, height: 44, alignment: .center)
                    .foregroundColor(.white)
                    .overlay{
                        TextField("Username", text: $username).padding()
                }
                
                
                HStack {
                    Text("Password").foregroundColor(.white)
                    Spacer()
                }.frame(width:350)
                
                
                RoundedRectangle(cornerRadius: 15).frame(width: 350, height: 44, alignment: .center)
                    .foregroundColor(.white)
                    .overlay{
                        SecureField("Password", text: $password).padding()
                }
                

                Button {
                            // TODO: Write code to handle login action
                         } label: {
                            Text("Log In")
                         }
                        .buttonBorderShape(.capsule)
                        .frame(width: 350, height: 44, alignment: .center)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(
                            cornerRadius: 15,
                            style: .continuous).fill(Color("customDarkGreen")))
                        .padding()
                

            }
        }.containerRelativeFrame([.horizontal, .vertical])
            .background(Gradient(colors: [Color("customLemon"), Color("customGreen")]))
    }
    
    
}

#Preview {
    LoginSwiftUI()
}
