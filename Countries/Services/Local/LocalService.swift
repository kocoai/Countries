//
//  LocalService.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation

protocol LocalService {
  func fetch(region: String, keywords: String, sort: Sort, showFavoriteOnly: Bool) -> [Country]
  func save(countries: [Country])
  func save(country: Country) -> Country?
  func toggleFavorite(country: Country)
}
