//
//  Bundle+Extension.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation

extension Bundle {
    
    func getValueFromInfoPlist(ForKey key: ConfigKeys) -> String? {
        self.object(forInfoDictionaryKey: key.rawValue) as? String
    }
}
