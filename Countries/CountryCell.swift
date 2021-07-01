//
//  CountryCell.swift
//  Countries
//
//  Created by Kien on 30/06/2021.
//

import SwiftUI

struct CountryCell: View {
  let index: Int
  let viewModel: ViewModel
  let showIndex: Bool
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(viewModel.name)
          .font(.title2.bold())
        HStack(alignment: .lastTextBaseline) {
          if let capital = viewModel.capital  {
            Text(capital)
              .font(.headline)
          }
          Text(viewModel.region)
            .font(.caption)
            .foregroundColor(.secondary)
          
        }
        Text(viewModel.population)
          .font(.caption)
        if let area = viewModel.area {
          Text(area)
            .font(.caption)
        }
      }
      if showIndex {
        Spacer()
        Text("\(index + 1)")
          .font(.largeTitle)
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
    
    init(country: Country, keywords: String) {
      self.country = country
      
      name = AttributedString(country.name_)
      if let range = name.range(of: keywords) {
        name[range].backgroundColor = .yellow
      }
      
      if !country.capital_.isEmpty {
        capital = AttributedString(country.capital_)
        if let range = capital?.range(of: keywords) {
          capital?[range].backgroundColor = .yellow
        }
      }
      
      region = AttributedString(country.region_)
      if let range = region.range(of: keywords) {
        region[range].backgroundColor = .yellow
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
