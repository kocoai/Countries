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
    return Array(try Realm().objects(CountryObject.self).filter("name_ contains %@ OR capital_ contains %@ OR region_ contains %@", keywords, keywords, keywords))
  }
  
  func fetch(region: String, keywords: String) throws -> [Country] {
    let countries = try Realm().objects(CountryObject.self).filter("region_ == %@", region)
    if keywords.isEmpty {
      return Array(countries.sorted(byKeyPath: "name_"))
    } else {
      return Array(countries
                    .filter("name_ contains %@ OR capital_ contains %@", keywords, keywords)
                    .sorted(byKeyPath: "name_"))
    }
    
  }
}

enum RepositoryError: Error {
  case invalidURL
}
