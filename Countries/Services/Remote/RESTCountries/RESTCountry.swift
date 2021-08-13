//
//  RESTCountry.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation

struct RESTCountry: Decodable, Country {
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
  var nativeName_: String { nativeName }
  var timezones_: [String] { timezones }
  var languages_: [Language] { languages }
  
  let name: String
  let capital: String
  let population: Int
  let area: Float?
  let region: String
  let latlng: [Float]
  let subregion: String
  let alpha2Code: String
  let alpha3Code: String
  let borders: [String]
  let nativeName: String
  let timezones: [String]
  let languages: [RESTLanguage]
}
