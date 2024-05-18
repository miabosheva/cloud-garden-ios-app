import SwiftUI
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

struct HomeNavigationView: View {
    
    // MARK: - Properites
    @State private var selection = 1
    @State private var notificationPermissionRequested = false
    @StateObject var userModel: UserModel
    @StateObject var deviceAndPlantModel: DeviceAndPlantModel
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var notificationDelegate = NotificationDelegate()
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            DeviceList(model: deviceAndPlantModel)
                .tabItem {
                    Text("")
                    Image(selection == 0 ? "list-active" : "list")
                }
                .tag(0)
            
            PlantList(model: deviceAndPlantModel)
                .tabItem {
                    Text("")
                    Image(selection == 1 ? "flower-active" : "flower")
                }
                .tag(1)
            
            ProfileView(model: userModel)
                .tabItem {
                    Text("")
                    Image(selection == 2 ? "user-active" : "user")
                }
                .tag(2)
        }
        .onAppear {
            if !notificationPermissionRequested {
                requestNotificationPermission()
                notificationPermissionRequested = true
            }
        }
        .accentColor(.customDarkGreen)
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
}
