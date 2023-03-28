//
//  AWFileManagerSpy.swift
//  AstronomyWatchTests
//
//  Created by Sathish Kumar S on 28/03/23.
//

import Foundation
@testable import AstronomyWatch

class AWFileManagerSpy: AWFileManagerProtocol {
    
    var didCopyItem = false
    var didRemoveAllFilesFromDirectory = false
    
    func copyItem(at target: URL, to destination: URL) throws {
        self.didCopyItem = true
    }
    
    func removeFilesFromDocumentDirectory() throws {
        self.didRemoveAllFilesFromDirectory = true
    }
}
