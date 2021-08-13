//
//  CountriesService.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation

protocol RemoteService {
  func fetchAll() async throws -> [Country]
  func fetch(alphaCode: String) async throws -> Country
}
