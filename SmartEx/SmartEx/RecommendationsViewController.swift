//
//  RecommendationsViewController.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/25/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit

class RecommendationsViewConroller : UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
         navigationItem.title = "Currency Converter"
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
}