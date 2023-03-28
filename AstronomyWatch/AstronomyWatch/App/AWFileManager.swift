//
//  AWFileManager.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 28/03/23.
//

import Foundation

protocol AWFileManagerProtocol {
    
    func copyItem(at target: URL, to destination: URL) throws
    func removeFilesFromDocumentDirectory() throws
}

class AWFileManager: AWFileManagerProtocol {
    
    func copyItem(at target: URL, to destination: URL) throws {
        try FileManager.default.copyItem(at: target, to: destination)
    }
    
    func removeFilesFromDocumentDirectory() throws {
        if let documentDirectory = URL.getDocumentDirectory(), let files = try? FileManager.default.contentsOfDirectory(atPath: documentDirectory.path) {
            for file in files {
                let filePath = documentDirectory.appendingPathComponent(file)
                try FileManager.default.removeItem(at: filePath)
            }
        }
    }
}
