import Foundation
import UIKit

class LauchScreenViewController: UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let gradientView = GradientView()
        gradientView.frame = view.bounds
        view.addSubview(gradientView)
    }
}

class GradientView: UIView {
    private var gradientLayer = CAGradientLayer()

    // Define the colors of the gradient
    var colors: [CGColor] = [UIColor(named: "customLemon")?.cgColor ?? UIColor.green.cgColor, (UIColor(named: "customGreen")?.cgColor ?? UIColor.blue.cgColor)] {
        didSet {
            setupGradient()
        }
    }

    // Initialize the view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    // Setup the gradient settings
    private func setupGradient() {
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]  // Gradient from top (0.0) to bottom (1.0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Ensure the gradient layer covers the full view size
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
