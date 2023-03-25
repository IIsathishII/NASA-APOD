//
//  UserDefaults+Extension.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 26/03/23.
//

import Foundation

extension UserDefaults {
    
    var pictureOfDayModel: PictureOfDayModel? {
        get {
            if let data = UserDefaults.standard.object(forKey: "pictureOfDayModel") as? Data,
               let value = try? JSONDecoder().decode(PictureOfDayModel.self, from: data) {
               return value
            }
            return nil
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "pictureOfDayModel")
        }
    }
}
