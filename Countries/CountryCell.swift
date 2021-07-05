//
//  CountryCell.swift
//  Countries
//
//  Created by Kien on 30/06/2021.
//

import SwiftUI

struct CountryCell: View {
  @ObservedObject var viewModel: CountryCellViewModel
  let showIndex: Bool
  
  var body: some View {
    NavigationLink(destination: MapView(latitude: viewModel.country.lat_, longitude: viewModel.country.lng_).edgesIgnoringSafeArea(.all)) {
      HStack {
        VStack(alignment: .leading) {
          Text(viewModel.subregion)
            .font(.caption)
            .foregroundColor(.secondary)
          HStack {
            Text(viewModel.name).font(.title2.bold())
            if viewModel.isFavorite {
              Image(systemName: "star.fill")
            }
          }
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
          ZStack {
            Circle()
              .foregroundColor(Color(UIColor.quaternarySystemFill))
              .frame(width: 60)
            Text("\(viewModel.index + 1)")
              .font(.title.bold())
              .foregroundColor(.secondary)
          }
        }
      }
      .id(viewModel.country.name_)
    }
    .swipeActions(edge: .leading) {
      if viewModel.isFavorite {
        Button(role: .destructive) {
          viewModel.toggleFavorite()
        } label: {
          Label("Unfavorite", systemImage: "star.slash.fill")
        }
      } else {
        Button() {
          viewModel.toggleFavorite()
        } label: {
          Label( "Favorite", systemImage: "star.fill")
        }
        .tint(.blue)
      }
    }
  }
}

final class CountryCellViewModel: ObservableObject {
  var country: Country
  var name: AttributedString
  var capital: AttributedString?
  var subregion: AttributedString
  var population: String
  var area: String?
  var index: Int
  @Published var isFavorite: Bool
  
  init(country: Country, keywords: String, index: Int) {
    self.country = country
    self.index = index
    name = country.name_.highlight(keywords)
    if !country.capital_.isEmpty {
      capital = country.capital_.highlight(keywords)
    }
    subregion = country.subregion_.highlight(keywords)
    population = "Population: \(country.population_.formatted)"
    if country.area_ > 0 {
      area = "Area: \(country.area_.formatted) km2"
    }
    isFavorite = country.isFavorite_
  }
  
  func toggleFavorite() {
    isFavorite.toggle()
    let localRepository = LocalRepository()
    localRepository.toggleFavorite(country: country)
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
