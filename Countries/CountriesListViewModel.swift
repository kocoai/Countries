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
    @Published private var allViewModels = [CountryCell.ViewModel]()
    private let remote: Repository = RemoteRepository()
    private let local: Repository = LocalRepository()
    var searchResult: [CountryCell.ViewModel] {
      var results: [CountryCell.ViewModel]
      if searchText.isEmpty {
        results = allViewModels
      } else {
        results = allViewModels.filter { $0.name.contains(searchText) || ($0.capital ?? "").contains(searchText) }
      }
      switch currentSort {
      case .byPopulation(ascending: _):
        results = results.filter { $0.country.population > 0 }
      case .byArea(ascending: _):
        results = results.filter { ($0.country.area ?? 0) > 0 }
      default:
        break
      }
      return results
    }
    
    var currentSort = Sort.byName(ascending: true) {
      didSet {
        switch currentSort {
        case .byName(let ascending):
          if ascending {
            allViewModels.sort { $0.country.name < $1.country.name }
          } else {
            allViewModels.sort { $0.country.name > $1.country.name }
          }
        case .byPopulation(let ascending):
          if ascending {
            allViewModels.sort { $0.country.population < $1.country.population }
          } else {
            allViewModels.sort { $0.country.population > $1.country.population }
          }
        case .byArea(let ascending):
          if ascending {
            allViewModels.sort { ($0.country.area ?? 0) < ($1.country.area ?? 0) }
          } else {
            allViewModels.sort { ($0.country.area ?? 0) > ($1.country.area ?? 0)}
          }
        }
      }
    }

    func fetch() async {
      do {
        let countries = try await local.fetchAll()
        if countries.isEmpty {
          await refresh()
        } else {
          allViewModels = countries.map(CountryCell.ViewModel.init)
        }
      } catch {
        print(error)
      }
    }
    
    func refresh() async {
      do {
        let countries = try await remote.fetchAll()
        allViewModels = countries.map(CountryCell.ViewModel.init)
        try await local.save(countries: countries)
      } catch {
        print(error)
      }
    }
    
    func toggleSort() {
      currentSort.toggle()
    }
  }
}
