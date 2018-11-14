//
//  cell.swift
//  design
//
//  Created by Tonya on 07/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//
import UIKit


class Cell: UITableViewCell {
    
    
    @IBOutlet weak var arrivetime: UITextField!
    
    @IBOutlet weak var arriveplace: UITextField!
    
    @IBOutlet weak var timeonfees: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
