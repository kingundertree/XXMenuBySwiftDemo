//
//  MainViewController.swift
//  XXMenuBySwiftDemo
//
//  Created by xiazer on 14-8-9.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main View"
        self.view.backgroundColor = UIColor.redColor()
        
        let leftBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "leftMenu:")
        self.navigationItem.leftBarButtonItem = leftBtn

        let rightBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "rightMenu:")
        self.navigationItem.rightBarButtonItem = rightBtn

        // Do any additional setup after loading the view.
    }

    func leftMenu(sender: AnyObject) {
//        UIApplication.sharedApplication().delegate
//    [[XXAppDelegate sharedAppDelegate].XXMenuVC showMenu:YES];

//        ViewController().showMenu(true)
    }

    func rightMenu(sender: AnyObject) {
//        ViewController().showMenu(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
