import SwiftUI

struct AddEmptyPlant: View {
    // MARK: - Properties
    private var model: DeviceAndPlantModel
    
    // MARK: - Init
    init(model: DeviceAndPlantModel){
        self.model = model
    }
    
    var body: some View {
        VStack {
            Text("Under construction add an empty plant")
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
