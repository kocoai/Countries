//
//  MapView.swift
//  Countries
//
//  Created by Kien on 01/07/2021.
//

import SwiftUI
import MapKit
import RealmSwift

struct MapView: View {
  let lat: Float
  let lng: Float
  let area: Float
  @State var region = MKCoordinateRegion()
  
  var body: some View {
    Map(coordinateRegion: $region)
      .onAppear {
        let delta: Double
        if area < 10000 {
          delta = 0.1
        } else if area < 100000 {
          delta = 1
        } else if area < 5000000 {
          delta = 10
        } else {
          delta = 30
        }

        region = MKCoordinateRegion(
          center: CLLocationCoordinate2D (latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng)),
          span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        )
      }
  }
}
