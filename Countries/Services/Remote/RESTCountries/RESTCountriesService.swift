//
//  RESTCountriesService.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation

struct RESTCountriesService: RemoteService {
  func fetchAll() async throws -> [Country] {
    guard let url = URL(string: "https://restcountries.eu/rest/v2/all") else { throw RepositoryError.invalidURL }
    let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
    return try JSONDecoder().decode([RESTCountry].self, from: data)
  }
  
  func fetch(alphaCode: String) async throws -> Country {
    guard let url = URL(string: "https://restcountries.eu/rest/v2/alpha/\(alphaCode)") else { throw RepositoryError.invalidURL }
    let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
    return try JSONDecoder().decode(RESTCountry.self, from: data)
  }
}
