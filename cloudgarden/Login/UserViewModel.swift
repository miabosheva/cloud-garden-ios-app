import Foundation

class UserViewModel: ObservableObject {
    @Published var apiResponse: String = ""
    
    func fetchData() {
        // Perform your API call here
        // For example:
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.apiResponse = "Data loaded from API"
        }
    }
}
