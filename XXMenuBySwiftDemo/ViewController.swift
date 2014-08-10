//
//  ViewController.swift
//  XXMenuBySwiftDemo
//
//  Created by xiazer on 14-8-7.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

import UIKit

//定义屏幕高度
let ScreenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height
//定义屏幕宽度
let ScreenWidth:CGFloat =  UIScreen.mainScreen().bounds.size.width

let scaleValue:CGFloat = 0.875
let menuViewWidth:CGFloat = 250.0

//enum PushBckType{
//    case PushBackWithScale
//    case PushBackWithSlowMove
//}

enum menuStatusType{
    case menuOnLeft
    case menuOnRight
    case menuOnMain
    case menuOnelse
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    var leftMenuView:UIView = LeftMenu(frame: CGRectMake(-menuViewWidth, ScreenHeight*(1-scaleValue)/2, menuViewWidth, ScreenHeight*scaleValue))
    var rightMenuView:UIView = RightMenu(frame: CGRectMake(ScreenWidth, ScreenHeight*(1-scaleValue)/2, menuViewWidth, ScreenHeight*scaleValue))
    var menuStatus:menuStatusType = menuStatusType.menuOnMain
    var rootNav:UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()

        let bgImgView:UIImageView = UIImageView(frame: self.view.bounds)
        bgImgView.image = UIImage(named: "bgImg.png")
        bgImgView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(bgImgView)
        
        // Do any additional setup after loading the view, typically from a nib.
        initMenuView()
    }

    func initMenuView(){
        self.view.addSubview(leftMenuView)
        self.view.addSubview(rightMenuView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initWithRootNavgationController(navController:UINavigationController){
        if(self.rootNav){
            rootNav?.view.removeFromSuperview()
        }
        
        self.rootNav = navController as UINavigationController
        self.view.addSubview(self.rootNav!.view)
        
        //绑定手势事件
        let panGus:UIPanGestureRecognizer! = UIPanGestureRecognizer()
        panGus.delegate = self
        panGus.addTarget(self, action: "panGesReceive:")
        self.view.addGestureRecognizer(panGus)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldReceiveTouch touch: UITouch!) -> Bool {
        return true
    }
    
    
    func panGesReceive(panGesReceive:UIPanGestureRecognizer){
        
    }
}

