import Foundation
import SwiftUI

final class Colors {
    
    // MARK: - Gradients
    static var appBackground: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color("customLemon"), Color("customGreen")]), startPoint: .top, endPoint: .bottom)

    // MARK: - Colors
    static var white: Color = Color("customOffWhite")
    static var green: Color = Color("customGreen")
    static var darkGreen: Color = Color("customDarkGreen")
    static var limeGreen: Color = Color("customLimeGreen")
    static var lemon: Color = Color("customLemon")
    static var red: Color = Color("customRed")
    static var grey: Color = Color("customGrey")
}
