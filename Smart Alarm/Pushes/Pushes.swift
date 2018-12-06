//
//  Pushes.swift
//  design
//
//  Created by Андрей Бабков on 06/12/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import Foundation
import UserNotifications

class Pushes {
    
    let songName = "s.caf"
    
    func testTime() {
        //callback, который запустится после того, как придет ответ
        let callback = { (time: Int) -> Void in
            if time == -1 {
                // у написано так, что в случае любой ошибки вызовется
                // этот колббек с парметром -1. Можно изменить
                print("Something goes wrong")
            }
            print("Duration for this journey (with time for packing) is: \(time) (seconds)")
            //нужно, чтобы минимальный интервал между пушами был 60 сек
            let parsedTime = time < 60 ? 60 : time
            let date = self.getDateForPush(seconds: parsedTime)
            self.firePush(at: date)
        }
        let travelManager = TravelManager(callback: callback)
        let myAdress = "55.683494,37.528046"
        let secondAdress = "55.685939,37.532917"
        //время на сборы в минутах
        let timeForPacking = 2
        //внутри этого метода выполнится коллбэк, объявленный ранее
        travelManager.getTravelTime(origin: myAdress, destination: secondAdress, mode: TravelModes.transit, additionalMinutes: timeForPacking)
    }
    
    //перевод полученных из апи секунд + времени на сборы в нужный формат
    func getDateForPush(seconds: Int) -> DateComponents {
        let now = Date()
        let newDate =  Calendar.current.date(byAdding: .second, value: seconds, to: now)
        let unitFlags:Set<Calendar.Component> = [
            .hour, .day, .month,
            .year,.minute,.hour,.second,
            .calendar]
        let dateComponents = Calendar.current.dateComponents(unitFlags, from: newDate!)
        return dateComponents
    }
    
    //ставим пуш на нужное время
    func firePush(at date: DateComponents?) {
        guard let parsedDate = date else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Good morning"
        content.body = "Please stand up, please stand up"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: songName))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: parsedDate, repeats: true)
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
