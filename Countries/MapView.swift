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
  let country: Country
  @State var region = MKCoordinateRegion()
  
  var body: some View {
    ZStack {
      VStack {
        Map(coordinateRegion: $region).task {
          let delta: Double
          if country.area_ < 10000 {
            delta = 0.1
          } else if country.area_ < 100000 {
            delta = 1
          } else if country.area_ < 5000000 {
            delta = 10
          } else {
            delta = 30
          }
          
          region = MKCoordinateRegion(
            center: CLLocationCoordinate2D (latitude: CLLocationDegrees(country.lat_), longitude: CLLocationDegrees(country.lng_)),
            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
          )
        }
        VStack {
          ScrollView {
            Text(country.name_)
              .font(.largeTitle)
            VStack(alignment: .leading) {
              if !country.capital_.isEmpty {
                HStack {
                  Text("**Capital:** \(country.capital_)")
                  Spacer()
                }
              }
              if !country.subregion_.isEmpty {
                HStack {
                  Text("**Region:** \(country.subregion_)")
                  Spacer()
                }
              }
              if country.population_ > 0 {
                HStack {
                  Text("**Population:** \(country.population_.formatted)")
                  Spacer()
                }
              }
              if country.area_ > 0 {
                HStack {
                  Text("**Area:** \(country.area_.formatted) km2")
                  Spacer()
                }
              }
              if !country.borders_.isEmpty {
                HStack {
                  Text("**Neighboring countries:** \( country.neighboringCountries_.map { $0.name_ }.joined(separator: ", "))")
                  Spacer()
                }
              }
            }
            .padding(.horizontal)
          }
          Spacer()
        }
      }
      
      VStack {
        HStack {
          Spacer()
          AsyncImage(url: URL(string: "https://www.worldatlas.com/r/w425/img/flag/\(country.alpha2Code_.lowercased())-flag.jpg")) { img in
            img.resizable()
          } placeholder: {
            ProgressView()
          }
          .frame(width: 60, height: 40)
          .shadow(radius: 10)
          .padding(.top, 40)
          .padding(.trailing, 20)
        }
        Spacer()
      }
    }
  }
}
