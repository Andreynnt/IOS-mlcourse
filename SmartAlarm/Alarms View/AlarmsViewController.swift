//
//  ViewController.swift
//  design
//
//  Created by Tonya on 06/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit
import UserNotifications


class AlarmsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let songName = "s.caf"
    var alarms = [Alarm]()
    
    var selectedAlarm: Alarm?
    var selectedIndexPath: IndexPath?
    
    let cellIdentifier = "alarmcell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to do заменить на бд
        let alarm1 = Alarm()
        let alarm2 = Alarm()
        let alarm3 = Alarm()
        alarms.append(alarm1)
        alarms.append(alarm2)
        alarms.append(alarm3)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "AlarmCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        //testTime()
    }
    
    //изменение будильника
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAlarm = alarms[indexPath.row]
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "toSecond", sender: self)
    }
    
    @IBAction func createNewAlarm(_ sender: UIBarButtonItem) {
        selectedAlarm = nil
        performSegue(withIdentifier: "toSecond", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecond" {
            let settigsViewController = segue.destination as! AlarmSettingsViewController
            settigsViewController.alarm = selectedAlarm
            settigsViewController.indexPathInAlarmsView = selectedIndexPath
            settigsViewController.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AlarmCell
        cell.fill(alarm: alarms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
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

extension AlarmsViewController: AlarmSettingsDelegate {
    func addAlarm(alarm: Alarm)  {
        alarms.append(alarm)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func  changeAlarm(alarm: Alarm, indexPath: IndexPath) {
        alarms[indexPath.row] = alarm
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
