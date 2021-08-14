//
//  ListViewModel.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import SwiftUI
import RealmSwift

@MainActor
final class ListViewModel: ObservableObject {
  @ObservedResults(RealmCountry.self) var countries
  @Published var searchText = ""
  @Published var isGrouped: Bool = false
  @Published var showFavoriteOnly: Bool = false
  @Published var currentSort = Sort.byName(ascending: true)
  @Published var isLoaded = false
  
  let regions = ["Africa", "Americas", "Asia", "Europe", "Oceania"]
  let useCase: UseCase
  
  init(useCase: UseCase = BasicUseCase()) {
    self.useCase = useCase
  }
  
  func rows(section: String = "") -> [Country] {
    useCase.search(region: section, keywords: searchText, sort: currentSort, showFavoriteOnly: showFavoriteOnly)
  }
  
  func sectionName(for region: String = "") -> String {
    (region.isEmpty ? "Count: " : "\(region): ") + "\(rows(section: region).count)"
  }
  
  func load() async {
    if useCase.search(sort: currentSort).isEmpty {
      await refresh()
    } else {
      isLoaded = true
    }
  }
  
  func refresh() async {
    do {
      useCase.save(countries: try await useCase.fetchAll())
      isLoaded = true
    } catch {
      print(error)
    }
  }
}
