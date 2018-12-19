//
//  ViewController.swift
//  design
//
//  Created by Tonya on 06/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit

class AlarmsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var alarms = [Alarm]()
    var selectedAlarm: Alarm?
    
    var alarmsCoreData = [AlarmCoreData]()
    var selectedAlarmCoreData: AlarmCoreData?

    var selectedIndexPath: IndexPath?
    var fetchedResultsController = CoreDataManager.instance
        .fetchedResultsController(entityName: "AlarmCoreData", keyForSort: "id")
    
    let cellIdentifier = "alarmcell"
    
    var lastId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        do {
            try self.fetchedResultsController.performFetch()
            alarmsCoreData = self.fetchedResultsController.fetchedObjects as! [AlarmCoreData]
        } catch {
            print("ERROR WITH try self.fetchedResultsController.performFetch()")
        }
        
        if !alarmsCoreData.isEmpty {
            lastId = Int(alarmsCoreData.last!.id)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "AlarmCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    //изменение будильника
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAlarmCoreData = alarmsCoreData[indexPath.row]
        selectedAlarm = selectedAlarmCoreData?.makeAlarm()
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "toSecond", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func createNewAlarm(_ sender: UIBarButtonItem) {
        selectedAlarm = nil
        performSegue(withIdentifier: "toSecond", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecond" {
            let settigsViewController = segue.destination as! AlarmSettingsViewController
            settigsViewController.alarm = selectedAlarm
            settigsViewController.lastAlarmId = lastId
            settigsViewController.indexPathInAlarmsView = selectedIndexPath
            settigsViewController.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmsCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AlarmCell
        cell.fill(alarm: alarmsCoreData[indexPath.row])
        //print("Id = \(alarmsCoreData[indexPath.row].id)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let delete = deleteAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [delete])
    }
    
    @available(iOS 11.0, *)
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            let coreDataObject = self.alarmsCoreData[indexPath.row]
            self.alarmsCoreData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            CoreDataManager.instance.managedObjectContext.delete(coreDataObject)
            CoreDataManager.instance.saveContext()
            completion(true)
        }
        action.image = UIImage(named: "icons8-waste-70")
        return action
    }
}

extension AlarmsViewController: AlarmSettingsDelegate {
    func addAlarm(alarmCoreData: AlarmCoreData) {
        alarmsCoreData.append(alarmCoreData)
        lastId += 1
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func changeAlarm(alarm: Alarm, indexPath: IndexPath) {
        alarmsCoreData[indexPath.row].fill(from: alarm)
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
