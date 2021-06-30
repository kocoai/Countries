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
    private let remote: Repository = RemoteRepository()
    
    var searchResult: [CountryCell.ViewModel] {
      guard !searchText.isEmpty else { return viewModels }
      return viewModels.filter { $0.name.contains(searchText) }
    }
    
    var currentSort = Sort.byName(ascending: true) {
      didSet {
        switch currentSort {
        case .byName(let ascending):
          if ascending {
            viewModels.sort { $0.country.name < $1.country.name }
          } else {
            viewModels.sort { $0.country.name > $1.country.name }
          }
        case .byPopulation(let ascending):
          if ascending {
            viewModels.sort { $0.country.population < $1.country.population }
          } else {
            viewModels.sort { $0.country.population > $1.country.population }
          }
        case .byArea(let ascending):
          if ascending {
            viewModels.sort { ($0.country.area ?? 0) < ($1.country.area ?? 0) }
          } else {
            viewModels.sort { ($0.country.area ?? 0) > ($1.country.area ?? 0)}
          }
        }
      }
    }

    func fetch() async {
      do {
        let countries = try await remote.fetch()
        viewModels = countries.map(CountryCell.ViewModel.init)
      } catch {
        viewModels = []
        print(error)
      }
    }
    
    func toggleSort() {
      currentSort.toggle()
    }
  }
}
