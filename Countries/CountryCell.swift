//
//  CountryCell.swift
//  Countries
//
//  Created by Kien on 30/06/2021.
//

import SwiftUI

struct CountryCell: View {
  let viewModel: ViewModel
  let showIndex: Bool
  let showRegion: Bool
  
  var body: some View {
    NavigationLink(destination: MapView(latitude: viewModel.country.lat_, longitude: viewModel.country.lng_).edgesIgnoringSafeArea(.all)) {
      HStack {
        VStack(alignment: .leading) {
          if showRegion {
            Text(viewModel.region)
              .font(.caption)
              .foregroundColor(.secondary)
          }
          Text(viewModel.name).font(.title2.bold())
          if let capital = viewModel.capital  {
            Text(capital).font(.headline)
          }
          Text(viewModel.population).font(.caption)
          if let area = viewModel.area {
            Text(area).font(.caption)
          }
        }
        Spacer()
        if showIndex {
          Text("\(viewModel.index + 1)")
            .font(.title.bold())
            .foregroundColor(.secondary)
        }
      }
      .id(viewModel.country.name_)
    }
  }
}

extension CountryCell {
  final class ViewModel:ObservableObject {
    let country: Country
    var name: AttributedString
    var capital: AttributedString?
    var region: AttributedString
    var population: String
    var area: String?
    var index: Int
    
    init(country: Country, keywords: String, index: Int) {
      self.country = country
      self.index = index
      name = country.name_.highlight(keywords)
      if !country.capital_.isEmpty {
        capital = country.capital_.highlight(keywords)
      }
      region = country.region_.highlight(keywords)
      population = "Population: \(country.population_.formatted)"
      if country.area_ > 0 {
        area = "Area: \(country.area_.formatted) km2"
      }
    }
  }
}

extension String {
  func highlight(_ keywords: String) -> AttributedString {
    var atr = AttributedString(self)
    if let range = atr.range(of: keywords) {
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
