//
//  StringExtencion.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/07/23.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}
