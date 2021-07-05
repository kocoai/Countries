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
    @Published var isGrouped: Bool = false {
      didSet {
        update()
      }
    }
    @Published var showFavoriteOnly: Bool = false {
      didSet {
        update()
      }
    }
    @Published var currentSort = Sort.byName(ascending: true) {
      didSet {
        update()
      }
    }
    @Published var isLoaded = false
    @Published private var all = [Country]()
    
    let regions = ["Africa", "Americas", "Asia", "Europe", "Oceania"]
    var sectionName: String { "Count: \(rows.count)" }
    var showIndex: Bool { searchText.isEmpty }
    private let remote = RemoteRepository()
    private let local = LocalRepository()
    
    var rows: [CountryCell.ViewModel] {
      guard searchText.isEmpty else {
        let countries = local.fetch(keywords: searchText, sort: currentSort, showFavoriteOnly: showFavoriteOnly)
        return countries.enumerated().map { CountryCell.ViewModel(country: $1, keywords: searchText, index: $0) }
      }
      return all.enumerated().map { CountryCell.ViewModel(country: $1, keywords: searchText, index: $0) }
    }
    
    func rowsForSection(section: String) -> [CountryCell.ViewModel] {
      local.fetch(region: section, keywords: searchText, sort: currentSort, showFavoriteOnly: showFavoriteOnly).enumerated().map { CountryCell.ViewModel(country: $1, keywords: searchText, index: $0) }
    }
    
    func load() async {
      update()
      if all.isEmpty {
        await refresh()
      } else {
        isLoaded = true
      }
    }
    
    func refresh() async {
      do {
        all = try await remote.fetchAll()
        local.save(countries: all)
        isLoaded = true
      } catch {
        print(error)
      }
    }
    
    private func update() {
      guard !isGrouped else { return }
      all = local.fetch(sort: currentSort, showFavoriteOnly: showFavoriteOnly)
    }
  }
}
