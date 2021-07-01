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
    @Published private var allCountries = [CountryCell.ViewModel]()
    private let remote = RemoteRepository()
    private let local = LocalRepository()
    private var groupedCountries = [[Country]]()
    private var regions = [String]()
    
    var viewModels: [[CountryCell.ViewModel]] {
      guard isGrouped else {
        var results: [CountryCell.ViewModel]
        if searchText.isEmpty {
          results = allCountries
        } else {
          let countries = try? local.fetch(keywords: searchText)
          results = countries?.map { CountryCell.ViewModel(country: $0, keywords: searchText) } ?? allCountries
        }
        switch currentSort {
        case .byPopulation(ascending: _):
          results = results.filter { $0.country.population_ > 0 }
        case .byArea(ascending: _):
          results = results.filter { $0.country.area_ > 0 }
        default:
          break
        }
        return [results]
      }
      
      return regions.map {
         try! local.fetch(region: $0, keywords: searchText)
          .map { CountryCell.ViewModel(country: $0, keywords: searchText) }
      }
      
    }
    
    var currentSort = Sort.byName(ascending: true) {
      didSet {
        switch currentSort {
        case .byName(let ascending):
          if ascending {
            allCountries.sort { $0.country.name_ < $1.country.name_ }
          } else {
            allCountries.sort { $0.country.name_ > $1.country.name_ }
          }
        case .byPopulation(let ascending):
          if ascending {
            allCountries.sort { $0.country.population_ < $1.country.population_ }
          } else {
            allCountries.sort { $0.country.population_ > $1.country.population_ }
          }
        case .byArea(let ascending):
          if ascending {
            allCountries.sort { $0.country.area_ < $1.country.area_ }
          } else {
            allCountries.sort { $0.country.area_ > $1.country.area_ }
          }
        }
        regions = []
      }
    }
    
    var showIndex: Bool {
      searchText.isEmpty
    }
    
    var isGrouped: Bool {
      regions.count > 1
    }

    func load() async {
      do {
        allCountries = try local.fetchAll()
          .map { CountryCell.ViewModel(country: $0, keywords: searchText) }
        if allCountries.isEmpty {
          await refresh()
        }
      } catch {
        print(error)
      }
    }
    
    func refresh() async {
      do {
        let all = try await remote.fetchAll()
        allCountries = all.map { CountryCell.ViewModel(country: $0, keywords: searchText) }
        try local.save(countries: all)
      } catch {
        print(error)
      }
    }
    
    func groupByRegion() {
      regions = ["Africa", "Americas", "Asia", "Europe", "Oceania"]
    }

    func sectionName(section: Int) -> String {
      guard isGrouped else { return "Count: \(viewModels.first?.count ?? 0)" }
      return "\(regions[section]): \(viewModels[section].count)"
    }

  }
}
