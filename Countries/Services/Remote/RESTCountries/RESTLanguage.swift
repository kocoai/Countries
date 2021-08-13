//
//  RESTLanguage.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation

struct RESTLanguage: Decodable, Language {
  var name_: String { name }
  var nativeName_: String { nativeName }
  
  let name: String
  let nativeName: String
}
