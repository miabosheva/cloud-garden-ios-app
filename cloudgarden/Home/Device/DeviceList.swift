//
//  DeviceList.swift
//  cloudgarden
//
//  Created by Mia Bosheva on 16.4.24.
//

import SwiftUI

struct DeviceList: View {
    
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        NavigationSplitView {
            List{
                ForEach(modelData.devices) { device in
                    NavigationLink {
                        DeviceDetail(device: device)
                    } label: {
                        DeviceRow(device: device)
                    }
                }
            }
            .animation(.default, value: modelData.devices)
            .navigationTitle("Devices")
        } detail: {
            Text("Devices")
        }
        
        // TODO: - Add button for adding Device + View
    }
}

#Preview {
    
    DeviceList().environment(ModelData())
}
