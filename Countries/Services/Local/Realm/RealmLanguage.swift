//
//  RealmLanguage.swift
//  Countries
//
//  Created by Kien on 13/08/2021.
//

import Foundation
import RealmSwift

final class RealmLanguage: Object, Language {
  @Persisted (primaryKey: true) var name_ = ""
  @Persisted var nativeName_ = ""
  
  convenience init(_ language: Language) {
    self.init()
    self.name_ = language.name_
    self.nativeName_ = language.nativeName_
  }
}
