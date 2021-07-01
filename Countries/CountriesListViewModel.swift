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
    @Published private var allCountries = [Country]()
    private let remote = RemoteRepository()
    private let local = LocalRepository()
    
    var searchResult: [CountryCell.ViewModel] {
      var results: [Country]
      if searchText.isEmpty {
        results = allCountries
      } else {
        let countries = try? local.fetch(keywords: searchText)
        results = countries ?? allCountries
      }
      switch currentSort {
      case .byPopulation(ascending: _):
        results = results.filter { $0.population > 0 }
      case .byArea(ascending: _):
        results = results.filter { ($0.area ?? 0) > 0 }
      default:
        break
      }
      return results.map { CountryCell.ViewModel(country: $0, keywords: searchText) }
    }
    
    var currentSort = Sort.byName(ascending: true) {
      didSet {
        switch currentSort {
        case .byName(let ascending):
          if ascending {
            allCountries.sort { $0.name < $1.name }
          } else {
            allCountries.sort { $0.name > $1.name }
          }
        case .byPopulation(let ascending):
          if ascending {
            allCountries.sort { $0.population < $1.population }
          } else {
            allCountries.sort { $0.population > $1.population }
          }
        case .byArea(let ascending):
          if ascending {
            allCountries.sort { ($0.area ?? 0) < ($1.area ?? 0) }
          } else {
            allCountries.sort { ($0.area ?? 0) > ($1.area ?? 0)}
          }
        }
      }
    }
    
    var showIndex: Bool {
      searchText.isEmpty
    }

    func load() async {
      do {
        allCountries = try local.fetchAll()
        if allCountries.isEmpty {
          await refresh()
        }
      } catch {
        print(error)
      }
    }
    
    func refresh() async {
      do {
        allCountries = try await remote.fetchAll()
        try local.save(countries: allCountries)
      } catch {
        print(error)
      }
    }
  }
}
