//
//  DetailViewModel.swift
//  Countries
//
//  Created by Kien on 11/07/2021.
//

import SwiftUI
import MapKit
import RealmSwift

@MainActor
final class DetailViewModel: ObservableObject {
  @ObservedRealmObject var country: RealmCountry
  @Published var coordinate = MKCoordinateRegion()
  @Published var flagURL = ""
  @Published var neighboringCountries = ""
  @Published var timeZones = ""
  
  var hasNeighboringCountries: Bool { !country.borders_.isEmpty }
  var hasTimeZones: Bool { !country.timezones_.isEmpty }  
  private let countryUseCase: UseCase
  
  init(country: RealmCountry, countryUseCase: UseCase = BasicUseCase()) {
    self.country = country
    self.countryUseCase = countryUseCase
    update(with: country)
  }
  
  private func update(with country: Country) {
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
    coordinate = MKCoordinateRegion(
      center: CLLocationCoordinate2D (latitude: CLLocationDegrees(country.lat_), longitude: CLLocationDegrees(country.lng_)),
      span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
    )
    flagURL = "https://www.worldatlas.com/r/w425/img/flag/\(country.alpha2Code_.lowercased())-flag.jpg"
    neighboringCountries = country.neighboringCountries_.map { $0.name_ }.joined(separator: ", ")
    timeZones = country.timezones_.joined(separator: ", ")
  }
  
  func toggleFavorite() {
    countryUseCase.toggleFavorite(country: country)
  }
}
