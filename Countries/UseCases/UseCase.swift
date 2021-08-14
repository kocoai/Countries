//
//  UseCase.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation
import RealmSwift

protocol UseCase {
  func search(region: String, keywords: String, sort: Sort, showFavoriteOnly: Bool) -> [Country]
  func fetchAll() async throws -> [Country]
  func save(countries: [Country])
  func save(country: Country) -> Country?
  func toggleFavorite(country: Country)
}

extension UseCase {
  func search(region: String = "", keywords: String = "", sort: Sort, showFavoriteOnly: Bool = false) -> [Country] {
    return search(region: region, keywords: keywords, sort: sort, showFavoriteOnly: showFavoriteOnly)
  }
}

struct BasicUseCase: UseCase {
  private let remote: RemoteService
  private let local: LocalService
  
  init(remote: RemoteService = RESTCountriesService(), local: LocalService = RealmRepository()) {
    self.remote = remote
    self.local = local
  }
  
  func search(region: String, keywords: String, sort: Sort, showFavoriteOnly: Bool) -> [Country] {
    return local.fetch(region: region, keywords: keywords, sort: sort, showFavoriteOnly: showFavoriteOnly)
  }
  
  func save(countries: [Country]) {
    local.save(countries: countries)
  }
  
  func fetchAll() async throws -> [Country] {
    return try await remote.fetchAll()
  }
  
  func save(country: Country) -> Country? {
    return local.save(country: country)
  }
  
  func toggleFavorite(country: Country) {
    local.toggleFavorite(country: country)
  }
}
