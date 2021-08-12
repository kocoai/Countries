//
//  Language.swift
//  Countries
//
//  Created by Kien on 11/07/2021.
//

import Foundation
import RealmSwift

protocol Language {
  var name_: String { get }
  var nativeName_: String { get }
}

struct RestLanguage: Decodable, Language {
  var name_: String { name }
  var nativeName_: String { nativeName }
  
  let name: String
  let nativeName: String
}

final class LanguageObject: Object, Language {
  @objc dynamic var name_ = ""
  @objc dynamic var nativeName_ = ""
  
  override class func primaryKey() -> String? {
    return "name_"
  }
  
  convenience init(_ language: Language) {
    self.init()
    self.name_ = language.name_
    self.nativeName_ = language.nativeName_
  }
}

