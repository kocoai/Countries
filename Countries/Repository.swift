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
  func fetchAllSortByName(ascending: Bool = true, showFavoriteOnly: Bool = false) -> [Country] {
    do {
      var result = try Realm().objects(CountryObject.self)
      if showFavoriteOnly {
        result = result.filter("isFavorite_ == true")
      }
      return Array(result
                    .sorted(byKeyPath: "name_", ascending: ascending))
    } catch {
      print(error)
      return []
    }
  }
  
  func fetchAllSortByPopulation(ascending: Bool = true, showFavoriteOnly: Bool = false) -> [Country] {
    do {
      var result = try Realm().objects(CountryObject.self)
      if showFavoriteOnly {
        result = result.filter("isFavorite_ == true")
      }
      return Array(result
                    .filter("population_ > 0")
                    .sorted(byKeyPath: "population_", ascending: ascending))
    } catch {
      print(error)
      return []
    }
  }
  
  func fetchAllSortByArea(ascending: Bool = true, showFavoriteOnly: Bool = false) -> [Country] {
    do {
      var result = try Realm().objects(CountryObject.self)
      if showFavoriteOnly {
        result = result.filter("isFavorite_ == true")
      }
      return Array(result
                    .filter("area_ > 0")
                    .sorted(byKeyPath: "area_", ascending: ascending))
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
  
  func toggleFavorite(country: Country) {
    do {
      let realm = try Realm()
      try realm.write {
        if let object = realm.object(ofType: CountryObject.self, forPrimaryKey: country.name_) {
          object.isFavorite_.toggle()
          realm.add(object, update: .all)
        }
      }
    } catch {
      print(error)
    }
  }
  
  func fetch(keywords: String, sort: Sort, showFavoriteOnly: Bool = false) -> [Country] {
    do {
      var result = try Realm().objects(CountryObject.self)
      if showFavoriteOnly {
        result = result.filter("isFavorite_ == true")
      }
      return Array(result
                    .filter("name_ contains %@ OR capital_ contains %@ OR region_ contains %@", keywords, keywords, keywords)
                    .sorted(byKeyPath: sort.keyPath, ascending: sort.isAscending))
      
    } catch {
      print(error)
      return []
    }
  }
  
  func fetch(region: String, keywords: String, sort: Sort, showFavoriteOnly: Bool = false) -> [Country] {
    do {
      var result = try Realm().objects(CountryObject.self).filter("region_ == %@", region)
      if showFavoriteOnly {
        result = result.filter("isFavorite_ == true")
      }
      if keywords.isEmpty {
        return Array(result.sorted(byKeyPath: sort.keyPath, ascending: sort.isAscending))
      } else {
        return Array(result
                      .filter("name_ contains %@ OR capital_ contains %@", keywords, keywords)
                      .sorted(byKeyPath: sort.keyPath, ascending: sort.isAscending))
      }
    } catch {
      print(error)
      return []
    }
    
  }
}

enum RepositoryError: Error {
  case invalidURL
}
