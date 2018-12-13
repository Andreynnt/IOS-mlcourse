//
//  PushesManager.swift
//  SmartAlarm
//
//  Created by Андрей Бабков on 13/12/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import Foundation
import UserNotifications

class PushesManager {
    
    let songName = "song.caf"
    
    func setPush(alarm: Alarm, changeAlarmsViewCallback: @escaping (_ alarm: Alarm) -> Void) {
        //callback, который запустится после того, как придет ответ
        let callback = { (time: Int) -> Void in
            if time == -1 {
                print("Something goes wrong with api")
            }
            print("Duration for this journey (with time for packing) is: \(time) (seconds)")
            //нужно, чтобы минимальный интервал между пушами был 60 сек
            //let parsedTime = time < 60 ? 60 : time
            let date = self.getDateForPush(secondsForRoad: time, alarm: alarm, callback: changeAlarmsViewCallback)
            self.firePush(at: date)
        }
        
        let travelManager = TravelManager(callback: callback)
        let myAdress = String(alarm.getupLatitude) + "," + String(alarm.getupLongtitude)
        let secondAdress = String(alarm.arrivingLatitude) + "," + String(alarm.arrivingLongtitude)
        //внутри этого метода выполнится коллбэк, объявленный ранее
        travelManager.getTravelTime(origin: myAdress, destination: secondAdress,
                                    mode: TravelModes.transit, additionalMinutes: alarm.timeForFees)
    }
    
    
    //перевод полученных из апи секунд + времени на сборы в нужный формат
    func getDateForPush(secondsForRoad: Int, alarm: Alarm,
                        callback: (_ alarm: Alarm) -> Void) -> DateComponents {
        
        let nowDate = Date()
        let nowCalendar = Calendar.current
        var targetDateComponents = DateComponents()
        targetDateComponents.year = nowCalendar.component(.year, from: nowDate)
        targetDateComponents.month = nowCalendar.component(.month, from: nowDate)
        targetDateComponents.day = nowCalendar.component(.day, from: nowDate)
        targetDateComponents.hour = alarm.arrivingTimeHours
        targetDateComponents.minute = alarm.arrivingTimeMin
        let targetDate = nowCalendar.date(from: targetDateComponents)
        
        var getupDateComponents = DateComponents()
        getupDateComponents.second = -1 * secondsForRoad
        let resultDate = Calendar.current.date(byAdding: getupDateComponents, to: targetDate!)
        
        let unitFlags:Set<Calendar.Component> = [
            .hour, .day, .month,
            .year,.minute,.hour,.second,
            .calendar
        ]
        let resDateComponents = Calendar.current.dateComponents(unitFlags, from: resultDate!)
        var newAlarm = alarm
        newAlarm.getupTimeMin = resDateComponents.minute!
        newAlarm.getupTimeHours = resDateComponents.hour!
        callback(newAlarm)
        print("GET UP TIME IS:")
        print("day = \(resDateComponents.day!), hour = \(resDateComponents.hour!), minute = \(resDateComponents.minute!)")
        return resDateComponents
    }
    
    //ставим пуш на нужное время
    func firePush(at date: DateComponents?) {
        guard let parsedDate = date else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Good morning, sir"
        content.body = "Please stand up, please stand up"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: songName))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: parsedDate, repeats: true)
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
