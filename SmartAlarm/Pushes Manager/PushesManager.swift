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
    
    private static let pushesManager = {
        return PushesManager()
    }()
    
    class func shared() -> PushesManager {
        return pushesManager
    }
    
    private init() {
        
    }
    
    let defaultAlarmIdentifier = "alarm_"
    
    let alarmsTexts = [
        ("Wake up, sir", "You need to go to ", "queen_0-30.caf"),
        ("Ohhh, what a lazy bone", "Wake up, pleaseee", "queen_30-60.caf"),
        ("UPPPP NOW", "🤬🤬🤬", "queen_60-90.caf")
    ]
    
    func setPush(alarm: Alarm, changeAlarmsViewCallback: @escaping (_ alarm: Alarm) -> Void) {
        //callback, который запустится после того, как придет ответ
        let arrivalPlace = alarm.arrivingPlace
        let callback = { (time: Int) -> Void in
            if time == -1 {
                print("Something goes wrong with api")
            }
            print("Duration for this journey (with time for packing) is: \(time) (seconds)")
            //нужно, чтобы минимальный интервал между пушами был 60 сек
            //let parsedTime = time < 60 ? 60 : time
            let date = self.getDateForPush(secondsForRoad: time, alarm: alarm, callback: changeAlarmsViewCallback)
            self.createPushes(at: date, arrivalPlace: arrivalPlace, alarmId: alarm.id)
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
        
        let unitFlags: Set<Calendar.Component> = [
            .hour, .day, .month,
            .year, .minute, .hour, .second,
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
    func createPushes(at date: DateComponents?, arrivalPlace: String, alarmId: Int) {
        guard let parsedDate = date else { return }
        let phrases = getPhrasesWithPlace(place: arrivalPlace)
        for repeatNum in 0...self.alarmsTexts.count - 1 {
            let idetifier = "\(defaultAlarmIdentifier)\(String(alarmId))_\(repeatNum)"
            let titleText = phrases[repeatNum].0
            let bodyText = phrases[repeatNum].1
            let songName = phrases[repeatNum].2
            addNewPush(at: parsedDate, additionalSeconds: repeatNum * 30, identifier: idetifier,
                       titleText: titleText, bodyText: bodyText, song: songName)
        }
    }
    
    func getPhrasesWithPlace(place: String) -> [(String, String, String)] {
        var texts = alarmsTexts
        texts[0] =  (alarmsTexts.first!.0, alarmsTexts.first!.1 + place, alarmsTexts.first!.2)
        return texts
    }
    
    func addNewPush(at date: DateComponents, additionalSeconds: Int, identifier: String,
                    titleText: String, bodyText: String, song: String) {
        let calendar = Calendar.current
        let date = calendar.date(from: date)!
        let resultDate = date.addingTimeInterval(TimeInterval(additionalSeconds))
        let unitFlags: Set<Calendar.Component> = [
            .hour, .day, .month,
            .year, .minute, .hour, .second,
            .calendar
        ]
        let resDateComponents = Calendar.current.dateComponents(unitFlags, from: resultDate)
        
        let content = UNMutableNotificationContent()
        content.title = titleText
        content.body = bodyText
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: song))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: resDateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func deletePush(alarmId: Int) {
        var identifiers = [String]()
        for repeatNum in 0...self.alarmsTexts.count - 1 {
            let identifier = "\(defaultAlarmIdentifier)\(String(alarmId))_\(repeatNum)"
            identifiers.append(identifier)
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
