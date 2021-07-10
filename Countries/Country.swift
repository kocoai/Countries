//
//  Country.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import Foundation
import RealmSwift

protocol Country {
  var name_: String { get }
  var capital_: String { get }
  var population_: Int { get }
  var area_: Float { get }
  var region_: String { get }
  var lat_: Float { get }
  var lng_: Float { get }
  var subregion_: String { get }
  var alpha2Code_: String { get }
  var alpha3Code_: String { get }
  var isFavorite_: Bool { get }
  var borders_: [String] { get }
  var neighboringCountries_: [Country] { get }
}

struct RestCountry: Decodable, Country {
  var name: String
  var capital: String
  var population: Int
  var area: Float?
  var region: String
  var latlng: [Float]
  var subregion: String
  var alpha2Code: String
  var alpha3Code: String
  var borders: [String]
  
  var name_: String { name }
  var capital_: String { capital }
  var population_: Int { population }
  var area_: Float { area ?? 0 }
  var region_: String { region }
  var lat_: Float { latlng.first ?? 0 }
  var lng_: Float { latlng.last ?? 0 }
  var subregion_: String { subregion }
  var alpha2Code_: String { alpha2Code }
  var alpha3Code_: String { alpha3Code }
  var isFavorite_: Bool { false }
  var borders_: [String] { borders }
  var neighboringCountries_: [Country] { fatalError() }
}

final class CountryObject: Object, Country {
  
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
  var borders_: [String] { Array(borders) }
  var neighboringCountries_: [Country] {
    do {
      let realm = try Realm()
      return borders_.flatMap {
        realm.objects(CountryObject.self).filter("alpha3Code_ == %@", $0)
      }
    } catch {
      print(error)
      return []
    }
  }
  let borders = List<String>()
  
  
  override class func primaryKey() -> String? {
    return "name_"
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
    self.borders.append(objectsIn: country.borders_)
//    do {
//      let realm = try Realm()
//
//      country.borders_.forEach {
//        borders.append(objectsIn: realm.objects(CountryObject.self).filter("alpha3Code_ == %@", $0))
//      }
//    } catch {
//      print(error)
//    }
  }
}

