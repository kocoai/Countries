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
}

struct RealCountry: Decodable, Country {
  var name: String
  var capital: String
  var population: Int
  var area: Float?
  var region: String
  var latlng: [Float]
  var subregion: String
  
  var name_: String { name }
  var capital_: String { capital }
  var population_: Int { population }
  var area_: Float { area ?? 0 }
  var region_: String { region }
  var lat_: Float { latlng.first ?? 0 }
  var lng_: Float { latlng.last ?? 0 }
  var subregion_: String { subregion }
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
  
  override class func primaryKey() -> String? {
    return "name_"
  }
  
  convenience init(country: Country) {
    self.init()
    self.name_ = country.name_
    self.area_ = country.area_
    self.population_ = country.population_
    self.capital_ = country.capital_
    self.region_ = country.region_
    self.subregion_ = country.subregion_
    self.lat_ = country.lat_
    self.lng_ = country.lng_
  }
}

