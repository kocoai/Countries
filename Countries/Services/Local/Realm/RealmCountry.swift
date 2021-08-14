//
//  RealmCountry.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation
import RealmSwift

final class RealmCountry: Object, Country, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var alpha3Code_ = ""
  @Persisted var name_ = ""
  @Persisted var capital_ = ""
  @Persisted var population_ = 0
  @Persisted var region_ = ""
  @Persisted var area_: Float = 0
  @Persisted var lat_: Float = 0
  @Persisted var lng_: Float = 0
  @Persisted var subregion_ = ""
  @Persisted var alpha2Code_ = ""
  @Persisted var isFavorite_ = false
  @Persisted var nativeName_ = ""
  
  var borders_: [String] { Array(borders) }
  @Persisted var borders = List<String>()
  
  var timezones_: [String] { Array(timezones) }
  @Persisted var timezones = List<String>()
  
  var languages_: [Language] { Array(languages) }
  @Persisted var languages = List<RealmLanguage>()
  
  var neighboringCountries_: [Country] {
    do {
      let realm = try Realm()
      return borders_.flatMap {
        realm.objects(RealmCountry.self).filter("alpha3Code_ == %@", $0)
      }
    } catch {
      print(error)
      return []
    }
  }
  
  convenience init(_ country: Country) {
    self.init()
    update(with: country)
  }
  
  func update(with country: Country) {
    self.name_ = country.name_
    self.area_ = country.area_
    self.population_ = country.population_
    self.capital_ = country.capital_
    self.region_ = country.region_
    self.subregion_ = country.subregion_
    self.lat_ = country.lat_
    self.lng_ = country.lng_
    self.alpha2Code_ = country.alpha2Code_
    self.alpha3Code_ = country.alpha3Code_
    self.nativeName_ = country.nativeName_
    self.borders.append(objectsIn: country.borders_)
    self.timezones.append(objectsIn: country.timezones_)
    self.languages.append(objectsIn: country.languages_.map(RealmLanguage.init))
  }
}
