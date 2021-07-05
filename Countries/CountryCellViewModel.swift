//
//  CountryCellViewModel.swift
//  Countries
//
//  Created by Kien on 05/07/2021.
//

import Foundation

final class CountryCellViewModel: ObservableObject {
  let name: AttributedString
  let capital: AttributedString?
  let subregion: AttributedString
  let population: String
  let area: String?
  let index: Int
  let primaryKey: String
  let lat: Float
  let lng: Float
  @Published var isFavorite: Bool
  
  init(country: Country, keywords: String, index: Int) {
    primaryKey = country.name_
    self.index = index
    name = country.name_.highlight(keywords)
    capital = country.capital_.isEmpty ? nil : country.capital_.highlight(keywords)
    subregion = country.subregion_.highlight(keywords)
    population = "Population: \(country.population_.formatted)"
    area = country.area_ > 0 ? "Area: \(country.area_.formatted) km2" : nil
    isFavorite = country.isFavorite_
    lat = country.lat_
    lng = country.lng_
  }
  
  func toggleFavorite() {
    isFavorite.toggle()
    let localRepository = LocalRepository()
    localRepository.toggleFavorite(primaryKey: primaryKey)
  }
}

extension String {
  func highlight(_ keywords: String) -> AttributedString {
    var atr = AttributedString(self)
    if let range = atr.range(of: keywords, options: [.caseInsensitive, .diacriticInsensitive]) {
      atr[range].backgroundColor = .yellow
      atr[range].foregroundColor = .black
    }
    return atr
  }
}

extension Formatter {
  static let withSeparator: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = true
    formatter.groupingSeparator = " "
    formatter.groupingSize = 3
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    formatter.roundingMode = .halfUp
    return formatter
  }()
}

extension Numeric {
  var formatted: String { Formatter.withSeparator.string(for: self) ?? "" }
}
