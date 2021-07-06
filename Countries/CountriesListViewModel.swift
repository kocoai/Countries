//
//  CountriesListViewModel.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import SwiftUI

final class CountriesListViewModel: ObservableObject {
  @Published var searchText = ""
  @Published var isGrouped: Bool = false
  @Published var showFavoriteOnly: Bool = false
  @Published var currentSort = Sort.byName(ascending: true)
  @Published var isLoaded = false
  
  let regions = ["Africa", "Americas", "Asia", "Europe", "Oceania"]
  var showIndex: Bool { searchText.isEmpty }
  private let remote = RemoteRepository()
  private let local = LocalRepository()
  
  func rows(section: String = "") -> [Country] {
    local.fetch(region: section, keywords: searchText, sort: currentSort, showFavoriteOnly: showFavoriteOnly)
  }
  
  func sectionName(for region: String = "") -> String {
    (region.isEmpty ? "Count: " : "\(region): ") + "\(rows(section: region).count)"
  }
  
  func load() async {
    if local.fetch(sort: currentSort).isEmpty {
      await refresh()
    } else {
      isLoaded = true
    }
  }
  
  func refresh() async {
    do {
      let all = try await remote.fetchAll()
      local.save(countries: all)
      isLoaded = true
    } catch {
      print(error)
    }
  }
}
