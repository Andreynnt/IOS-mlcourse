//
//  ViewController.swift
//  design
//
//  Created by Tonya on 06/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit

class AlarmsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
  
    let alarmCellId = "AlarmCell"
    var alarms = [Alarm]()
    
    let list: [String: Any] = [
        "arrivingplace": "Бауманка",
        "arrivingtimehours": 15,
        "arrivingtimemin": 43   ,
        "timeforfees": 1,
        "getuptimehours": 12,
        "getuptimemin": 10,
        "getupplace": "home"
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: alarmCellId, for: indexPath) as! AlarmCell
        cell.arrivetime.text = String(alarms[indexPath.row].arrivingtimehours)
        cell.arriveplace.text = alarms[indexPath.row].arrivingplace
        cell.timeonfees.text = String(alarms[indexPath.row].timeforfees)
        cell.arriveTimeMin.text = String(alarms[indexPath.row].arrivingtimemin)
        return cell
    }
    
    func full(){
        guard let alarm = Alarm(dict: list as NSDictionary) else { return }
        alarms.append(alarm)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        full()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "AlarmCell", bundle: nil), forCellReuseIdentifier: "AlarmCell")
        //testTime()
    }
    
}
