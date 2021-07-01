//
//  Repository.swift
//  Countries
//
//  Created by Kien on 30/06/2021.
//

import Foundation
import SwiftUI
import RealmSwift

struct RemoteRepository {
  func fetchAll() async throws -> [Country] {
    guard let url = URL(string: "https://restcountries.eu/rest/v2/all") else { throw RepositoryError.invalidURL }
    let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
    return try JSONDecoder().decode([RealCountry].self, from: data)
  }
}

struct LocalRepository {
  func fetchAll() throws -> [Country] {
    return Array(try Realm().objects(CountryObject.self))
  }
  
  func save(countries: [Country]) throws {
    let realm = try Realm()
    try realm.write {
      countries.map(CountryObject.init).forEach { object in
        realm.add(object, update: .all)
      }
    }
  }
  
  func fetch(keywords: String) throws -> [Country] {
    return Array(try Realm().objects(CountryObject.self).filter("name contains %@ OR capital contains %@ OR region contains %@", keywords, keywords, keywords))
  }
}

enum RepositoryError: Error {
  case invalidURL
}
