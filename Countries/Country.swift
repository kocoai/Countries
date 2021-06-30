//
//  Country.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import Foundation
import RealmSwift

protocol Country {
  var name: String { get }
  var capital: String { get }
  var population: Int { get }
  var area: Float? { get }
}

struct RealCountry: Decodable, Country {
  var name: String
  var capital: String
  var population: Int
  var area: Float?
}

final class CountryObject: Object, Country {
  @objc dynamic var name = ""
  @objc dynamic var capital = ""
  @objc dynamic var population = 0
  @objc dynamic var area_: Float = 0
  var area: Float? {
    get { area_ }
    set { area_ = newValue ?? 0 }
  }
  
  override class func primaryKey() -> String? {
    return "name"
  }
  
  convenience init(country: Country) {
    self.init()
    self.name = country.name
    self.area = country.area
    self.population = country.population
    self.capital = country.capital
  }
}

