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
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    var alarmCoreData: AlarmCoreData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(alarm: AlarmCoreData) {
        alarmCoreData = alarm
        arrivetime.text = String(alarm.arrivingTimeHours)
        arriveplace.text = String(alarm.arrivingPlace!)
        timeonfees.text = String(alarm.timeForFees)
        arriveTimeMin.text = getTwoNumbersString(alarm.arrivingTimeMin)
        getupHourLabel.text = String(alarm.getupTimeHours)
        getupMinuteLabel.text = getTwoNumbersString(alarm.getupTimeMin)
        if alarm.isOn {
            alarmSwitch.isOn = true
        } else {
            alarmSwitch.isOn = false
        }
    }
    
    @IBAction func clickOnSwitch(_ sender: UISwitch) {
        guard let alarm = alarmCoreData else { return }
        if alarm.isOn {
            alarm.setValue(false, forKey: "isOn")
            alarm.isOn = false
            PushesManager.shared().deletePush(alarmId: Int(alarm.id))
        } else {
            alarm.setValue(true, forKey: "isOn")
            alarm.isOn = true
            let filledAlarm = alarm.makeAlarm()
            PushesManager.shared().setPush(alarm: filledAlarm) { (_: Alarm) -> Void in
                
            }
        }
        
        CoreDataManager.instance.saveContext()
    }
    
    //если у нас число 5, то вернет строку 05
    func getTwoNumbersString(_ digit: Int16) -> String {
        if digit < 10 {
            return "0" + String(digit)
        }
        return String(digit)
    }
}
