//
//  Country.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import Foundation

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
  var nativeName_: String { get }
  var timezones_: [String] { get }
  var languages_: [Language] { get }
}

