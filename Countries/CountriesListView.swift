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
        .refreshable {
          await viewModel.fetch()
        }
        .listStyle(.insetGrouped)
        .onAppear {
          async {
             await viewModel.fetch()
          }
        }
        .navigationTitle("Countries list")
    }
  }
}

struct CountryCell: View {
  let country: Country
  var body: some View {
    VStack(alignment: .leading) {
      Text(country.name)
        .font(.headline)
      Text(country.capital)
        .foregroundColor(.secondary)
    }
    .id(country.name)
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    CountriesListView()
  }
}
