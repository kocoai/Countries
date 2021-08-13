//
//  RealmCountry.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation
import RealmSwift

final class RealmCountry: Object, Country {
  @objc dynamic var name_ = ""
  @objc dynamic var capital_ = ""
  @objc dynamic var population_ = 0
  @objc dynamic var region_ = ""
  @objc dynamic var area_: Float = 0
  @objc dynamic var lat_: Float = 0
  @objc dynamic var lng_: Float = 0
  @objc dynamic var subregion_ = ""
  @objc dynamic var alpha2Code_ = ""
  @objc dynamic var alpha3Code_ = ""
  @objc dynamic var isFavorite_ = false
  @objc dynamic var nativeName_ = ""
  
  var borders_: [String] { Array(borders) }
  let borders = List<String>()
  var timezones_: [String] { Array(timezones) }
  let timezones = List<String>()
  var languages_: [Language] { Array(languages) }
  let languages = List<RealmLanguage>()
  
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
  
  override class func primaryKey() -> String? {
    return "alpha3Code_"
  }
  
  convenience init(_ country: Country) {
    self.init()
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
  }
  
  func updateDetail(with country: Country) {
    self.nativeName_ = country.nativeName_
    self.borders.append(objectsIn: country.borders_)
    self.timezones.append(objectsIn: country.timezones_)
    self.languages.append(objectsIn: country.languages_.map(RealmLanguage.init))
  }
}
