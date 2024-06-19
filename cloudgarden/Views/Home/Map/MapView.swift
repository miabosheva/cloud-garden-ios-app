import SwiftUI
import _MapKit_SwiftUI
import CoreLocation

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @Binding var goToMap: Bool
    
    var body: some View {
        Map(initialPosition: .region(region))
        
        VStack(alignment: .leading) {
            
            Text("Current Statistics for")
                .foregroundColor(.secondary)
                .padding(.top, 8)
            
            Text("\(locationManager.city), \(locationManager.country)")
                .font(.title2)
                .foregroundColor(.black)
                .padding(.bottom, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                VStack {
                    HStack {
                        Text("Temperature:")
                            .font(.headline)
                        Spacer()
                        Text("28")
                            .font(.headline)
                    }
                    HStack {
                        Text("Low")
                        ProgressView(value: 0.1)
                            .tint(.customLimeGreen)
                        Text("High")
                    }
                }
                .padding(.vertical, 8)
                
                Divider()
                Text("Temperature: 38")
                Divider()
                Text("Temperature: 38")
                Divider()
                Text("Temperature: 38")
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Close") {
                    self.goToMap.toggle()
                }
                .foregroundColor(.customLimeGreen)
                .bold()
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            locationManager.startUpdatingLocation()
        }
        
        Spacer()
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()

    @Published var city: String = "Unknown"
    @Published var country: String = "Unknown"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchCity(for location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found")
                return
            }
            
            if let city = placemark.locality {
                DispatchQueue.main.async {
                    self.city = city
                }
            }
            
            if let country = placemark.country {
                DispatchQueue.main.async {
                    self.country = country
                }
            }
        }
    }
    
    func startUpdatingLocation() {
            locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            fetchCity(for: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

