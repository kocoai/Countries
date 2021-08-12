//
//  DetailViewModel.swift
//  Countries
//
//  Created by Kien on 11/07/2021.
//

import SwiftUI
import MapKit

@MainActor
final class DetailViewModel: ObservableObject {
  @Published var coordinate = MKCoordinateRegion()
  @Published var flagURL = ""
  @Published var name = ""
  @Published var nativeName = ""
  @Published var capital = ""
  @Published var subregion = ""
  @Published var population = 0
  @Published var area: Float = 0.0
  @Published var neighboringCountries = ""
  @Published var timeZones = ""
 
  var hasNeighboringCountries: Bool { !country.borders_.isEmpty }
  var hasTimeZones: Bool { !country.timezones_.isEmpty }
  
  private let remote = RemoteRepository()
  private let local = LocalRepository()
  private let country: Country
  
  init(country: Country) {
    self.country = country
    
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
    name = country.name_
    capital = country.capital_
    subregion = country.subregion_
    population = country.population_
    area = country.area_
    
    updateDetail(with: country)
  }
  
  func loadDetail() async {
    guard country.nativeName_.isEmpty else { return }
    do {
      let country = try await remote.fetch(code: country.alpha3Code_)
      if let detail = local.save(country: country) {
        updateDetail(with: detail)
      }
    } catch {
      print(error)
    }
  }
  
  func updateDetail(with country: Country) {
    nativeName = country.nativeName_
    neighboringCountries = country.neighboringCountries_.map { $0.name_ }.joined(separator: ", ")
    timeZones = country.timezones_.joined(separator: ", ")
  }
}
