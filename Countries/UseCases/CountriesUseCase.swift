//
//  CountriesUseCase.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation
import RealmSwift

protocol CountriesUseCase {
  func search(region: String, keywords: String, sort: Sort, showFavoriteOnly: Bool) -> [Country]
  func fetchAll() async throws -> [Country]
  func save(countries: [Country])
}

extension CountriesUseCase {
  func search(region: String = "", keywords: String = "", sort: Sort, showFavoriteOnly: Bool = false) -> [Country] {
    return search(region: region, keywords: keywords, sort: sort, showFavoriteOnly: showFavoriteOnly)
  }
}

struct BasicCountriesUseCase: CountriesUseCase {
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
}
