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
    @Published private var all = [CountryCell.ViewModel]()
    
    var rows: [CountryCell.ViewModel] {
      guard searchText.isEmpty else {
        let countries = try? local.fetch(keywords: searchText, sort: currentSort)
        return countries?.map { CountryCell.ViewModel(country: $0, keywords: searchText) } ?? all
      }
      return all
    }
    
    let regions = ["Africa", "Americas", "Asia", "Europe", "Oceania"]
    private let remote = RemoteRepository()
    private let local = LocalRepository()
    var sectionName: String { "Count: \(rows.count)" }
    var currentSort = Sort.byName(ascending: true) {
      didSet {
        isGrouped = false
        switch currentSort {
        case .byName(let ascending):
          all = local.fetchAllSortByName(ascending).map { CountryCell.ViewModel(country: $0, keywords: searchText) }
        case .byPopulation(let ascending):
          all = local.fetchAllSortByPopulation(ascending).map { CountryCell.ViewModel(country: $0, keywords: searchText) }
        case .byArea(let ascending):
          all = local.fetchAllSortByArea(ascending).map { CountryCell.ViewModel(country: $0, keywords: searchText) }
        }
      }
    }
    
    var showIndex: Bool {
      searchText.isEmpty && !isGrouped
    }

    func load() async {
      all = local.fetchAllSortByName().map { CountryCell.ViewModel(country: $0, keywords: searchText) }
      if all.isEmpty {
        await refresh()
      }
    }
    
    func refresh() async {
      do {
        let result = try await remote.fetchAll()
        all = result.map { CountryCell.ViewModel(country: $0, keywords: searchText) }
        try local.save(countries: result)
      } catch {
        print(error)
      }
    }
    
    func groupByRegion() {
      isGrouped = true
    }
    
    func rowsForSection(section: String) -> [CountryCell.ViewModel] {
      let viewModels = try? local.fetch(region: section, keywords: searchText, sort: currentSort).map { CountryCell.ViewModel(country: $0, keywords: searchText) }
      return viewModels ?? []
    }
  }
}
