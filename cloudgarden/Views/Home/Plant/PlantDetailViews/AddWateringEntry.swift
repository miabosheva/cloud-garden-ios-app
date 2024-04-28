import SwiftUI

struct AddWateringEntry: View {
    @State private var date = Date()
    
    var body: some View {
        VStack(alignment: .center) {
            // MARK: - Contents
            GroupBox{
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding(.horizontal, 16)
                
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 27)
                        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                        .padding(.horizontal, 16)
                        .foregroundColor(Colors.green)
                        .overlay{
                            Text("Add watering Entry")
                                .foregroundColor(.white)
                        }
                }
            }
            
        }
    }
}
