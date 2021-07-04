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
  func fetchAllSortByName(_ ascending: Bool = true) -> [Country] {
    do {
      return Array(try Realm().objects(CountryObject.self).sorted(byKeyPath: "name_", ascending: ascending))
    } catch {
      print(error)
      return []
    }
  }
  
  func fetchAllSortByPopulation(_ ascending: Bool = true) -> [Country] {
    do {
      return Array(try Realm().objects(CountryObject.self)
                    .filter("population_ > 0")
                    .sorted(byKeyPath: "population_", ascending: ascending))
    } catch {
      print(error)
      return []
    }
  }
  
  func fetchAllSortByArea(_ ascending: Bool = true) -> [Country] {
    do {
      return Array(try Realm().objects(CountryObject.self)
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
      
    }
  }
  
  func fetch(keywords: String, sort: Sort) -> [Country] {
    do {
      return Array(try Realm().objects(CountryObject.self)
                    .filter("name_ contains %@ OR capital_ contains %@ OR region_ contains %@", keywords, keywords, keywords)
                    .sorted(byKeyPath: sort.keyPath, ascending: sort.isAscending))
      
    } catch {
      print(error)
      return []
    }
  }
  
  func fetch(region: String, keywords: String, sort: Sort) -> [Country] {
    do {
      let countries = try Realm().objects(CountryObject.self).filter("region_ == %@", region)
      if keywords.isEmpty {
        return Array(countries.sorted(byKeyPath: sort.keyPath, ascending: sort.isAscending))
      } else {
        return Array(countries
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
