//
//  CountryCell.swift
//  Countries
//
//  Created by Kien on 30/06/2021.
//

import SwiftUI
import RealmSwift

struct CountryCell: View {
  @State private var isFavorite: Bool
  
  private let name: AttributedString
  private let capital: AttributedString?
  private let subregion: AttributedString
  private let population: String?
  private let area: String?
  private let index: Int
  private let country: Country
  private let useCase: CountryUseCase
  
  init(country: Country, keywords: String, index: Int, useCase: CountryUseCase) {
    self.country = country
    self.index = index
    self.useCase = useCase
    name = country.name_.highlight(keywords)
    capital = country.capital_.isEmpty ? nil : country.capital_.highlight(keywords)
    subregion = country.subregion_.highlight(keywords)
    population = country.population_ > 0 ? "Population: \(country.population_.formatted)" : nil
    area = country.area_ > 0 ? "Area: \(country.area_.formatted) km2" : nil
    _isFavorite = .init(initialValue: country.isFavorite_)
  }
  
  var body: some View {
    NavigationLink(destination: DetailView(country: country).edgesIgnoringSafeArea(.all)) {
      HStack {
        VStack(alignment: .leading) {
          Text(subregion)
            .font(.caption)
            .foregroundColor(.secondary)
          HStack(alignment: .firstTextBaseline) {
            Text(name).font(.title2.bold())
            if isFavorite {
              Image(systemName: "star.fill")
            }
          }
          if let capital = capital  {
            Text(capital).font(.headline)
          }
          if let population = population {
            Text(population).font(.caption)
          }
          if let area = area {
            Text(area).font(.caption)
          }
        }
        Spacer()
        ZStack {
          Circle()
            .foregroundColor(Color(UIColor.quaternarySystemFill))
            .frame(width: 60)
          Text("\(index + 1)")
            .font(.title.bold())
            .foregroundColor(.secondary)
        }
      }
    }
    .swipeActions(edge: .leading) {
      if isFavorite {
        Button(role: .destructive) {
          toggleFavorite()
        } label: {
          Label("Unfavorite", systemImage: "star.slash")
        }
      } else {
        Button() {
          toggleFavorite()
        } label: {
          Label( "Favorite", systemImage: "star")
        }
        .tint(.blue)
      }
    }
  }
  
  func toggleFavorite() {
    isFavorite.toggle()
    useCase.toggleFavorite(alpha3Code: country.alpha3Code_)
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
