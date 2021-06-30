//
//  Repository.swift
//  Countries
//
//  Created by Kien on 30/06/2021.
//

import Foundation
import SwiftUI
import RealmSwift

protocol Repository {
  func fetchAll() async throws -> [Country]
  func save(countries: [Country]) async throws
}

struct RemoteRepository: Repository {
  func fetchAll() async throws -> [Country] {
    guard let url = URL(string: "https://restcountries.eu/rest/v2/all") else { throw RepositoryError.invalidURL }
    let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
    return try JSONDecoder().decode([RealCountry].self, from: data)
  }
  
  func save(countries: [Country]) async throws {}
  func fetch(keywords: String) async throws -> [Country] { fatalError() }
}

struct LocalRepository: Repository {
  func fetchAll() async throws -> [Country] {
    return Array(try Realm().objects(CountryObject.self))
  }
  
  func save(countries: [Country]) async throws {
    let realm = try Realm()
    try realm.write {
      countries.map(CountryObject.init).forEach { object in
        realm.add(object, update: .all)
      }
    }
  }
  
}

enum RepositoryError: Error {
  case invalidURL
}
