//
//  Repository.swift
//  Countries
//
//  Created by Kien on 30/06/2021.
//

import Foundation
import SwiftUI

protocol Repository {
  func fetch() async throws -> [Country]
}

struct RemoteRepository: Repository {
  func fetch() async throws -> [Country] {
    guard let url = URL(string: "https://restcountries.eu/rest/v2/all") else { throw RepositoryError.invalidURL }
    let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
    return try JSONDecoder().decode([RealCountry].self, from: data)
  }
}

enum RepositoryError: Error {
  case invalidURL
}
