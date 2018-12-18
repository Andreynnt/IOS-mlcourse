//
//  File.swift
//  design
//
//  Created by Tonya on 14/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import Foundation

import Foundation
import UIKit

struct Alarm {
    var arrivingPlace = "Moscow"
    var arrivingTimeHours = 12
    var arrivingTimeMin = 0
    var timeForFees = 0
    var getupTimeHours = 4
    var getupTimeMin = 20
    var getupPlace = "Moscow"
    var transport = TransportType.auto
    
    var isOn = false
    var id = 0
    var arrivingLatitude = 55.75581397971321
    var arrivingLongtitude = 37.6176349259913
    var getupLatitude = 55.75581397971321
    var getupLongtitude = 37.6176349259913
}

extension Alarm {
    init?(dict: NSDictionary) {
        guard
            let arrivingplace = dict["arrivingplace"] as? String,
            let arrivingtimehours = dict["arrivingtimehours"] as? Int,
            let arrivingtimemin = dict["arrivingtimemin"] as? Int,
            let timeforfees = dict["timeforfees"] as? Int,
            let getuptimehours = dict["getuptimehours"] as? Int,
            let getuptimemin = dict["getuptimemin"] as? Int,
            let getupplace = dict["getupplace"] as? String
            else { return nil }
        
        self.arrivingPlace = arrivingplace
        self.arrivingTimeHours = arrivingtimehours
        self.arrivingTimeMin = arrivingtimemin
        self.timeForFees = timeforfees
        self.getupTimeHours = getuptimehours
        self.getupTimeMin = getuptimemin
        self.getupPlace = getupplace
    }
}
