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
      List(viewModel.searchResult.indices, id: \.self) {
        CountryCell(index: $0, viewModel: viewModel.searchResult[$0], showIndex: viewModel.searchText.isEmpty)
      }
      .searchable(text: $viewModel.searchText)
      .disableAutocorrection(true)
      .refreshable { await viewModel.refresh() }
      .listStyle(.insetGrouped)
      .onAppear { async { await viewModel.fetch() } }
      .navigationTitle("Countries list")
      .navigationBarItems(trailing: sortMenu)
    }
  }
  
  private var sortMenu: some View {
    Menu {
      ForEach(CountriesListView.Sort.allCases) { sort in
        Button {
          sort.update(current: &viewModel.currentSort)
        } label: {
          if let image = sort.icon(current: viewModel.currentSort) {
            Label(sort.label, systemImage: image)
          } else {
            Text(sort.label)
          }
        }
      }
    } label: {
      HStack {
        Text(viewModel.currentSort.shortLabel)
          .font(.caption)
        Image(systemName: viewModel.currentSort.isAscending ? "arrow.up.circle" : "arrow.down.circle")
      }
    } primaryAction: {
      viewModel.toggleSort()
    }
  }
}

struct CountryCell: View {
  let index: Int
  let viewModel: ViewModel
  let showIndex: Bool
  
  var body: some View {
    HStack {
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
      if showIndex {
        Spacer()
        Text("\(index+1)")
          .font(.largeTitle)
          .foregroundColor(.secondary)
      }
    }
    .id(viewModel.name)
  }
}

extension CountryCell {
  struct ViewModel {
    let country: Country
    var name: String
    var capital: String?
    var population: String
    var area: String?
    
    init(country: Country) {
      self.country = country
      name = country.name
      capital = country.capital.isEmpty ? nil : country.capital
      population = "Population: \(country.population.formatted)"
      if let a = country.area, a > 0 {
        area = "Area: \(a.formatted) km2"
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    CountriesListView()
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
