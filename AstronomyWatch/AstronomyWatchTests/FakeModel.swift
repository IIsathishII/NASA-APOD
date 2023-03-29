//
//  FakeModel.swift
//  AstronomyWatchTests
//
//  Created by Sathish Kumar S on 29/03/23.
//

import Foundation
@testable import AstronomyWatch

var testModel = PictureOfDayModel(date: Date.getTodaysDateInAPIFriendlyFormat(),
                                  title: "Outbound Comet ZTF",
                                  explanation: "About Comet ZTF",
                                  url: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"),
                                  hdUrl: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"))
