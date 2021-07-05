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
    return try JSONDecoder().decode([RestCountry].self, from: data)
  }
}

struct LocalRepository {
#if DEBUG
  static var count = 0
#endif
  
  func fetch(region: String = "", keywords: String = "", sort: Sort, showFavoriteOnly: Bool = false) -> [Country] {
#if DEBUG
    if region.isEmpty {
      LocalRepository.count += 1
      print("fetch \(LocalRepository.count)")
    }
#endif
    
    do {
      var result = try Realm().objects(CountryObject.self)
      
      if !region.isEmpty {
        result = result.filter("region_ == %@", region)
      }
      
      if showFavoriteOnly {
        result = result.filter("isFavorite_ == true")
      }
      
      if !sort.filter.isEmpty {
        result = result.filter(sort.filter)
      }
      
      if !keywords.isEmpty {
        result = result.filter("name_ contains %@ OR capital_ contains %@ OR region_ contains %@", keywords, keywords, keywords)
      }
      return Array(result.sorted(byKeyPath: sort.keyPath, ascending: sort.isAscending))
      
    } catch {
      print(error)
      return []
    }
  }
  
  func save(countries: [Country]) {
    do {
      let realm = try Realm()
      try realm.write {
        countries.map(CountryObject.init).forEach { object in
          realm.add(object, update: .all)
        }
      }
    } catch {
      print(error)
    }
  }
  
  func toggleFavorite(primaryKey: String) {
    do {
      let realm = try Realm()
      try realm.write {
        if let object = realm.object(ofType: CountryObject.self, forPrimaryKey: primaryKey) {
          object.isFavorite_.toggle()
          realm.add(object, update: .all)
        }
      }
    } catch {
      print(error)
    }
  }
}

enum RepositoryError: Error {
  case invalidURL
}
