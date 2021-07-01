//
//  MapView.swift
//  Countries
//
//  Created by Kien on 01/07/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
  var latitude: Float
  var longitude: Float
  @State private var region = MKCoordinateRegion()
  
  var body: some View {
    VStack {
      Map(coordinateRegion: $region)
        .onAppear {
          region = MKCoordinateRegion(
            center: CLLocationCoordinate2D (latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
          )
        }
    }
  }
}
