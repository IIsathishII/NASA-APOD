//
//  PictureOfDayModel.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation

public struct PictureOfDayModel: Codable {
    
    var date: String?
    var title: String?
    var explanation: String?
    var url: URL?
    var hdurl: URL?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try? container.decode(String.self, forKey: .date)
        title = try? container.decode(String.self, forKey: .title)
        explanation = try? container.decode(String.self, forKey: .explanation)
        
        if let urlStr = try? container.decode(String.self, forKey: .url) {
            url = URL(string: urlStr)
        }
        
        if let hdurlStr = try? container.decode(String.self, forKey: .hdurl) {
            hdurl = URL(string: hdurlStr)
        }
    }
    
    public init(date: String?, title: String?, explanation: String?, url: URL?, hdUrl: URL?) {
        self.date = date
        self.title = title
        self.explanation = explanation
        self.url = url
        self.hdurl = hdUrl
    }
}
