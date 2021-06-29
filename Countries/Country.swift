//
//  Country.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import Foundation

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
