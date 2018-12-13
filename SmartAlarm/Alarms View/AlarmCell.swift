//
//  cell.swift
//  design
//
//  Created by Tonya on 07/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//
import UIKit


class AlarmCell: UITableViewCell {
    @IBOutlet weak var arrivetime: UILabel!
    @IBOutlet weak var arriveplace: UILabel!
    @IBOutlet weak var timeonfees: UILabel!
    @IBOutlet weak var getUpTime: UILabel!
    @IBOutlet weak var getUpMin: UILabel!
    @IBOutlet weak var arriveTimeMin: UILabel!
    @IBOutlet weak var getupHourLabel: UILabel!
    @IBOutlet weak var getupMinuteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(alarm: AlarmCoreData) {
        arrivetime.text = String(alarm.arrivingTimeHours)
        arriveplace.text = String(alarm.arrivingPlace!)
        timeonfees.text = String(alarm.timeForFees)
        arriveTimeMin.text = getTwoNumbersString(alarm.arrivingTimeMin)
        getupHourLabel.text = String(alarm.getupTimeHours)
        getupMinuteLabel.text = getTwoNumbersString(alarm.getupTimeMin)
    }
    
    //если у нас число 5, то вернет строку 05
    func getTwoNumbersString(_ digit: Int16) -> String {
        if digit < 10 {
            return "0" + String(digit)
        }
        return String(digit)
    }
}
