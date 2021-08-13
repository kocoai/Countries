//
//  CountryUseCase.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation
import RealmSwift

protocol CountryUseCase {
  func toggleFavorite(alpha3Code: String)
  func save(country: Country) -> Country?
  func fetch(alphaCode: String) async throws -> Country
}

struct BasicCountryUseCase: CountryUseCase {
  private let remote: RemoteService
  private let local: LocalService
  
  init(remote: RemoteService = RESTCountriesService(), local: LocalService = RealmRepository()) {
    self.remote = remote
    self.local = local
  }
  
  func fetch(alphaCode: String) async throws -> Country {
    return try await remote.fetch(alphaCode: alphaCode)
  }
  
  func save(country: Country) -> Country? {
    return local.save(country: country)
  }
  
  func toggleFavorite(alpha3Code: String) {
    do {
      let realm = try Realm()
      try realm.write {
        if let object = realm.object(ofType: RealmCountry.self, forPrimaryKey: alpha3Code) {
          object.isFavorite_.toggle()
          realm.add(object, update: .all)
        }
      }
    } catch {
      print(error)
    }
  }
}
