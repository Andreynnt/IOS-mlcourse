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
    var arrivingPlace = "Бауманка"
    var arrivingTimeHours = 15
    var arrivingTimeMin = 40
    var timeForFees = 14
    var getupTimeHours = 8
    var getupTimeMin = 30
    var getupPlace = "Дом"
    var transport = TransportType.auto
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
