//
//  URL+Extension.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 26/03/23.
//

import Foundation

extension URL {
    
    func getLocalFileURL() -> URL? {
        if let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = self.lastPathComponent
            return documentDir.appendingPathComponent(fileName)
        }
        return nil
    }
    
    static func getDocumentDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
