import SwiftUI
import Lottie

struct EmptyLottieView: View {
    
    private var keyword: String
    
    init(keyword: String) {
        self.keyword = keyword
    }
    
    var body: some View {
        VStack {
            LottieView(animationFileName: "empty.json", loopMode: .loop)
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 64)
                .padding(.top, 60)
                .frame(maxWidth: .infinity)
            Text("You havent added any \(keyword) yet.")
                .font(.caption)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 100)
        }
        .frame(maxWidth: .infinity, maxHeight: 700)
    }
}
