//
//  CountriesListView.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import SwiftUI

struct CountriesListView: View {
  @StateObject private var viewModel = ViewModel()
  
  var body: some View {
    NavigationView {
      List(viewModel.searchResult, id: \.name, rowContent: CountryCell.init)
        .searchable(text: $viewModel.searchText)
        .disableAutocorrection(true)
        .refreshable { await viewModel.fetch() }
        .listStyle(.insetGrouped)
        .onAppear { async { await viewModel.fetch() } }
        .navigationTitle("Countries list")
    }
  }
}

struct CountryCell: View {
  let viewModel: ViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(viewModel.name)
        .font(.headline)
      if let capital = viewModel.capital {
        Text(capital)
          .foregroundColor(.secondary)
      }
      Text(viewModel.population)
        .font(.caption)
      if let area = viewModel.area {
        Text(area)
          .font(.caption)
      }
    }
    .id(viewModel.name)
  }
}

extension CountryCell {
  struct ViewModel {
    var name: String
    var capital: String?
    var population: String
    var area: String?
    
    init(country: Country) {
      name = country.name
      capital = country.capital.isEmpty ? nil : country.capital
      population = "Population: \(country.population)"
      if let a = country.area {
        area = String(format: "Area: %.0f km2", a)
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    CountriesListView()
  }
}
