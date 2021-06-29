//
//  CountriesListViewModel.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import SwiftUI

extension CountriesListView {
  final class ViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var viewModels = [CountryCell.ViewModel]()
    
    var searchResult: [CountryCell.ViewModel] {
      guard !searchText.isEmpty else { return viewModels }
      return viewModels.filter { $0.name.contains(searchText) }
    }
    
    func fetch() async {
      guard let url = URL(string: "https://restcountries.eu/rest/v2/all") else { return }
      do {
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        let countries = try JSONDecoder().decode([RealCountry].self, from: data)
        viewModels = countries.map(CountryCell.ViewModel.init)
      } catch {
        viewModels = []
        print(error)
      }
    }
  }
}
