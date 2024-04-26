import SwiftUI

struct PlantDetail: View {
    
    let plant: Plant
    let imageName: String = "defaultPlant"
    let status: String = "well watered"
    let Elements: [any View] = []
    
    var body: some View {
        VStack {
//            ZStack{
//                Rectangle()
//                    .fill(Colors.appBackground)
//                    .frame(width: .infinity, height: .infinity)
//                
//                VStack {
//                    Text(plant.title)
//                        .font(.title)
//                        .bold()
//                        .foregroundColor(.white)
//                    
//                    Image(imageName)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(maxWidth: 200)
//                        .padding(.horizontal, 32)
//                        .clipShape(Circle())
//                }
//                
//                ScrollView(.vertical) {
//                    
//                    RoundedRectangle(cornerRadius: 27)
//                        .frame(width: 400, height: 900, alignment: .center)
//                        .foregroundColor(Color("customLemon"))
//                        .overlay{
//                            Text("Change 1")
//                                .foregroundColor(.white)
//                        }
//                }
//            }
        
        }
    }
}

#Preview {
    let plants = ModelData().plants
    
    return Group {
        PlantDetail(plant: plants[1])
    }
    
}
