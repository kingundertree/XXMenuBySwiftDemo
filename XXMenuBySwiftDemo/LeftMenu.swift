//
//  LeftMenu.swift
//  XXMenuBySwiftDemo
//
//  Created by xiazer on 14-8-9.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

import UIKit

class LeftMenu: UIView, UITableViewDelegate, UITableViewDataSource {

    var tableData:NSArray = ["leftMenu1","leftMenu2","leftMenu3","leftMenu4","leftMenu5","leftMenu6","leftMenu7","leftMenu8","leftMenu9","leftMenu10"]
    var tableList : UITableView!
    

    override func layoutSubviews() {
        self.tableList = UITableView(frame : CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), style : UITableViewStyle.Plain)
        self.tableList!.delegate = self
        self.tableList!.dataSource = self
        self.tableList!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(self.tableList!)
    }
    
    // UITableViewDataSource Methods
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return 1
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return self.tableData.count;
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath : indexPath) as UITableViewCell!
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel.text = self.tableData.objectAtIndex(indexPath.row) as String
        
        return cell
    }
    
    
    // UITableViewDelegate Methods
    func tableView(tableView : UITableView!, didSelectRowAtIndexPath indexPath : NSIndexPath!)
    {
        tableView!.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
