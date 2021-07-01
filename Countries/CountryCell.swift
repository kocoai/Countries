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
    HStack {
      VStack(alignment: .leading) {
        if showRegion {
          Text(viewModel.region)
            .font(.caption)
            .foregroundColor(.secondary)
        }
        Text(viewModel.name)
          .font(.title2.bold())
        if let capital = viewModel.capital  {
          Text(capital)
            .font(.headline)
        }
        Text(viewModel.population)
          .font(.caption)
        if let area = viewModel.area {
          Text(area)
            .font(.caption)
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
      
      name = AttributedString(country.name_)
      if let range = name.range(of: keywords) {
        name[range].backgroundColor = .yellow
        name[range].foregroundColor = .black
      }
      
      if !country.capital_.isEmpty {
        capital = AttributedString(country.capital_)
        if let range = capital?.range(of: keywords) {
          capital?[range].backgroundColor = .yellow
          capital?[range].foregroundColor = .black
        }
      }
      
      region = AttributedString(country.region_)
      if let range = region.range(of: keywords) {
        region[range].backgroundColor = .yellow
        region[range].foregroundColor = .black
      }
      
      population = "Population: \(country.population_.formatted)"
      if country.area_ > 0 {
        area = "Area: \(country.area_.formatted) km2"
      }
    }
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
