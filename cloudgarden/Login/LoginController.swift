//
//  LoginController.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 3.4.24.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        navigateToHome()
    }
}

// MARK - Navigate to Home
private extension LoginViewController {
    
    func navigateToHome() {
        let tabBarController = UITabBarController()
        let storyboard = UIStoryboard(name: "Navigation", bundle: nil)
        
        let homeController = storyboard.instantiateViewController(withIdentifier: "homeController") as! HomeViewController
        let deviceController = storyboard.instantiateViewController(withIdentifier: "deviceController") as! DeviceViewController
        
        let controllers = [homeController, deviceController]
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
//        tabBarController.tabBar.tintColor = UIColor(named: "primary-color")
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }
}
