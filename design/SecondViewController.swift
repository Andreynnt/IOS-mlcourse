//
//  SecondViewController.swift
//  design
//
//  Created by Tonya on 18/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit

protocol dataToFirst {
    func SaveData(list: Alarm)
}

class SecondViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var DataDelegate: dataToFirst!
    
    var list2: [String: Any] = [
        "arrivingplace": "Бауманка",
        "arrivingtimehours": 15,
        "arrivingtimemin": 43   ,
        "timeforfees": 1,
        "getuptimehours": 12,
        "getuptimemin": 10,
        "getupplace": "home"
    ]
    
    @IBOutlet weak var hours: UIPickerView!
    
    
    @IBAction func save(_ sender: Any) {
        guard let alarm = Alarm(dict: list2 as NSDictionary) else { return }
        DataDelegate.SaveData(list: alarm)
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var TableView: UITableView!
    
    let hoursarr = Array(0...23)
    let minutsarr = Array(0...59)
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return String(hoursarr[row]);
        } else{
            return String(minutsarr[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0{
            let titleData = String(hoursarr[row])
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
            return myTitle
        } else {
            let titleData = String(minutsarr[row])
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
            return myTitle
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            self.list2["arrivingtimehours"] = hoursarr[row]
        }else{
            self.list2["arrivingtimemin"] = minutsarr[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return hoursarr.count
        } else{
            return minutsarr.count
        }
    }
    let listForSecond = [
        "Установить время на сборы",
        "Откуда поедете",
        "Куда поедете",
        "На чем поедете",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        TableView.register(UINib.init(nibName: "SecondTableViewCell", bundle: nil), forCellReuseIdentifier: "secondCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listForSecond.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as! SecondTableViewCell
        cell.LabelForSecond.text = String(listForSecond[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "timeForFees", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let FeesVC = segue.destination as! FeesController
        FeesVC.timeDelegate = self
    }
    

}

extension SecondViewController: dataToSecond{
    func SaveTime(time: Int) {
        self.list2["timeforfees"] = time
    }
}