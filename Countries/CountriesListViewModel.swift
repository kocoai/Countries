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
    @Published var isGrouped: Bool = false
    @Published private var all = [Country]()
    @Published var currentSort = Sort.byName(ascending: true) {
      didSet {
        guard !isGrouped else { return }
        switch currentSort {
        case .byName(let ascending):
          all = local.fetchAllSortByName(ascending)
        case .byPopulation(let ascending):
          all = local.fetchAllSortByPopulation(ascending)
        case .byArea(let ascending):
          all = local.fetchAllSortByArea(ascending)
        }
      }
    }
    
    var rows: [CountryCell.ViewModel] {
      guard searchText.isEmpty else {
        let countries = try? local.fetch(keywords: searchText, sort: currentSort)
        return countries?.enumerated().map { CountryCell.ViewModel(country: $1, keywords: searchText, index: $0) } ?? all.enumerated().map { CountryCell.ViewModel(country: $1, keywords: searchText, index: $0) }
      }
      return all.enumerated().map { CountryCell.ViewModel(country: $1, keywords: searchText, index: $0) }
    }
    
    let regions = ["Africa", "Americas", "Asia", "Europe", "Oceania"]
    private let remote = RemoteRepository()
    private let local = LocalRepository()
    var sectionName: String { "Count: \(rows.count)" }
    
    var showIndex: Bool { searchText.isEmpty }

    func load() async {
      all = local.fetchAllSortByName()
      if all.isEmpty {
        await refresh()
      }
    }
    
    func refresh() async {
      do {
        all = try await remote.fetchAll()
        try local.save(countries: all)
      } catch {
        print(error)
      }
    }
    
    func rowsForSection(section: String) -> [CountryCell.ViewModel] {
      let viewModels = try? local.fetch(region: section, keywords: searchText, sort: currentSort).enumerated().map { CountryCell.ViewModel(country: $1, keywords: searchText, index: $0) }
      return viewModels ?? []
    }
  }
}
