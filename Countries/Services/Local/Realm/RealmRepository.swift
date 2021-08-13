//
//  LocalRepository.swift
//  Countries
//
//  Created by Kien on 30/06/2021.
//

import Foundation
import SwiftUI
import RealmSwift

struct RealmRepository: LocalService {
  func fetch(region: String, keywords: String, sort: Sort, showFavoriteOnly: Bool) -> [Country] {
    do {
      var result = try Realm().objects(RealmCountry.self)
      
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
        result = result.filter("name_ CONTAINS[cd] %@ OR capital_ CONTAINS[cd] %@ OR subregion_ CONTAINS[cd] %@", keywords, keywords, keywords)
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
        countries.map(RealmCountry.init).forEach { object in
          realm.add(object, update: .all)
        }
      }
    } catch {
      print(error)
    }
  }
  
  func save(country: Country) -> Country? {
    do {
      let realm = try Realm()      
      let object = RealmCountry(country)
      object.updateDetail(with: country)
      try realm.write {
        realm.add(object, update: .all)
      }
      return object
    } catch {
      print(error)
      return nil
    }
  }
}

enum RepositoryError: Error {
  case invalidURL
}

extension Sort {
  var filter: String {
    switch self {
    case .byName(_):
      return ""
    case .byPopulation(_):
      return "population_ > 0"
    case .byArea(_):
      return "area_ > 0"
    }
  }
}
