//
//  ViewController.swift
//  design
//
//  Created by Tonya on 06/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var alarms = [Alarm]()
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmcell", for: indexPath) as! Cell
        cell.arrivetime.text = String(alarms[indexPath.row].arrivingtimehours)
        cell.arriveplace.text = alarms[indexPath.row].arrivingplace
        cell.timeonfees.text = String(alarms[indexPath.row].timeforfees)
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()                
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "alarmcell")
    }
    
}
