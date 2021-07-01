//
//  CountriesSort.swift
//  Countries
//
//  Created by Kien on 30/06/2021.
//

enum Sort: CaseIterable, Equatable, Identifiable {
  case byName(ascending: Bool), byPopulation(ascending: Bool), byArea(ascending: Bool)
  
  static var allCases: [Sort] = [.byName(ascending: true), .byPopulation(ascending: true), .byArea(ascending: true)]
  
  var id: String {
    switch self {
    case .byName(let ascending):
      return "byName\(ascending)"
    case .byPopulation(let ascending):
      return "byPopulation\(ascending)"
    case .byArea(let ascending):
      return "byArea\(ascending)"
    }
  }
  
  var shortLabel: String {
    switch self {
    case .byName(_):
      return "Name"
    case .byPopulation(_):
      return "Population"
    case .byArea(_):
      return "Area"
    }
  }
  
  var label: String {
    switch self {
    case .byName(_):
      return "Sort by Name"
    case .byPopulation(_):
      return "Sort by Population"
    case .byArea(_):
      return "Sort by Area"
    }
  }
  
  var keyPath: String {
    switch self {
    case .byName(_):
      return "name_"
    case .byPopulation(_):
      return "population_"
    case .byArea(_):
      return "area_"
    }
  }
  
  var isAscending: Bool {
    switch self {
    case .byName(let ascending):
      return ascending
    case .byPopulation(let ascending):
      return ascending
    case .byArea(let ascending):
      return ascending
    }
  }
  
  func toggle(_ current: inout Sort) {
    guard case self = current else {
      switch self {
      case .byName(_):
        current = .byName(ascending: true)
      case .byPopulation(_):
        current = .byPopulation(ascending: false)
      case .byArea(_):
        current = .byArea(ascending: false)
      }
      return
    }
    current.toggleAscending()
  }
  
  mutating func toggleAscending() {
    switch self {
    case .byName(let ascending):
      self = .byName(ascending: !ascending)
    case .byPopulation(let ascending):
      self = .byPopulation(ascending: !ascending)
    case .byArea(let ascending):
      self = .byArea(ascending: !ascending)
    }
  }
  
  func icon(_ current: Sort) -> String? {
    guard case self = current else { return nil }
    return current.isAscending ? "arrow.up.circle" : "arrow.down.circle"
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    switch(lhs, rhs) {
    case (.byName(_), .byName(_)),
      (.byPopulation(_), .byPopulation(_)),
      (.byArea(_), .byArea(_)):
      return true
    default:
      return false
    }
  }
}
