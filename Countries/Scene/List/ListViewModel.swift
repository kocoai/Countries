//
//  ListViewModel.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import SwiftUI

@MainActor
final class ListViewModel: ObservableObject {
  @Published var searchText = ""
  @Published var isGrouped: Bool = false
  @Published var showFavoriteOnly: Bool = false
  @Published var currentSort = Sort.byName(ascending: true)
  @Published var isLoaded = false
  
  let regions = ["Africa", "Americas", "Asia", "Europe", "Oceania"]
  var showIndex: Bool { searchText.isEmpty }
  private let countriesUseCase: CountriesUseCase
  let countryUseCase: CountryUseCase
  
  init(countriesUseCase: CountriesUseCase = BasicCountriesUseCase(), countryUseCase: CountryUseCase = BasicCountryUseCase()) {
    self.countriesUseCase = countriesUseCase
    self.countryUseCase = countryUseCase
  }
  
  func rows(section: String = "") -> [Country] {
    countriesUseCase.search(region: section, keywords: searchText, sort: currentSort, showFavoriteOnly: showFavoriteOnly)
  }
  
  func sectionName(for region: String = "") -> String {
    (region.isEmpty ? "Count: " : "\(region): ") + "\(rows(section: region).count)"
  }
  
  func load() async {
    if countriesUseCase.search(sort: currentSort).isEmpty {
      await refresh()
    } else {
      isLoaded = true
    }
  }
  
  func refresh() async {
    do {
      let all = try await countriesUseCase.fetchAll()
      countriesUseCase.save(countries: all)
      isLoaded = true
    } catch {
      print(error)
    }
  }
}
