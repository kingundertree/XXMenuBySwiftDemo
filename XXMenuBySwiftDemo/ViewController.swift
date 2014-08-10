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
    var isMenuAnimate:Bool! = false
    var rootViewFrame:CGRect?
    var leftViewFrame:CGRect?
    var rightViewFrame:CGRect?
    var coverView:UIView?
    
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
        if((self.rootNav) != nil){
            rootNav?.view.removeFromSuperview()
            self.rootNav = nil
        }
        
        self.rootNav = navController
        self.view.addSubview(self.rootNav!.view)
        
        //绑定手势事件
        let panGus:UIPanGestureRecognizer! = UIPanGestureRecognizer()
        panGus.delegate = self
        panGus.addTarget(self, action: "panGesReceive:")
        self.view.addGestureRecognizer(panGus)
        
        self.rootNav.view.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<()>) {
        if (self.isMenuAnimate == true) {
            return
        }
        var navViewX:CGFloat = 0
        var navViewWidth:CGFloat = 0

        if (keyPath == "center"){
            navViewX = rootNav.view.frame.origin.x;
            navViewWidth = rootNav.view.frame.size.width;
        }
        
        println("center--->>\(navViewX)__\(navViewWidth)")
        
        //leftView定位
        var changedLeftFrame:CGRect = leftViewFrame!
        changedLeftFrame.origin.x = navViewX - menuViewWidth;
        leftMenuView.frame = changedLeftFrame;
        
        //rightView定位
        var changedRightFrame:CGRect = rightViewFrame!
        changedRightFrame.origin.x = navViewX + navViewWidth;
        rightMenuView.frame = changedRightFrame;
    }
    
//    if (isMenuAnimate) {
//    return;
//    }
//    float rootViewX;
//    float rootViewWidth;
//    if([keyPath isEqualToString:@"center"]) {
//    rootViewX = rootVC.view.frame.origin.x;
//    rootViewWidth = rootVC.view.frame.size.width;
//    }
//    //leftView定位
//    CGRect changedLeftFrame = leftViewFrame;
//    changedLeftFrame.origin.x = rootViewX - menuViewWidth;
//    leftMenuView.frame = changedLeftFrame;
//    
//    //rightView定位
//    CGRect changedRightFrame = rightViewFrame;
//    changedRightFrame.origin.x = rootViewX + rootViewWidth;
//    rightMenuView.frame = changedRightFrame;

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldReceiveTouch touch: UITouch!) -> Bool {
        if(menuStatus == menuStatusType.menuOnMain && gestureRecognizer.isKindOfClass(UITapGestureRecognizer)){
            return false
        }
        let nav:UINavigationController = rootNav
        let i:NSInteger = nav.viewControllers.count
        
        if(i > 1){
            return false
        }
        
        return true
    }

    func tapGus(tapGus : UITapGestureRecognizer) {
        self.isMenuAnimate = false
        self.resetRootViewAndMenuView()
    }
    
    func panGesReceive(panGes:UIPanGestureRecognizer){
        if(self.isMenuAnimate == true){
            return
        }
        var translation:CGPoint = panGes.translationInView(self.view)
        println("translation:CGPoint--->>\(translation.x)")

        if (panGes.state == UIGestureRecognizerState.Began){
            rootViewFrame = rootNav.view.frame
            leftViewFrame = leftMenuView.frame
            rightViewFrame = rightMenuView.frame
        
            if(rootViewFrame?.origin.x == 0){
                menuStatus = menuStatusType.menuOnMain
            }else if(rootViewFrame?.origin.x == menuViewWidth){
                menuStatus = menuStatusType.menuOnLeft
                self.addCoverView()
            }else if(rootViewFrame?.origin.x == -menuViewWidth){
                menuStatus = menuStatusType.menuOnRight
                self.addCoverView()
            }
        }else if(panGes.state == UIGestureRecognizerState.Changed){
            var moveX:CGFloat = translation.x
            if (menuStatus == menuStatusType.menuOnMain){
                if (moveX > 0) {
                    var scale:CGFloat = 1.0 - translation.x/2000
                    if (translation.x >= menuViewWidth) {
                        scale = 1.0 - menuViewWidth/2000;
                        moveX = menuViewWidth
                    }
                    
                    //缩放rootView
                    rootNav.view.transform = CGAffineTransformMakeScale(scale, scale)
                    rootNav.view.center = CGPointMake(moveX + ScreenWidth*scale/2, self.view.bounds.size.height/2)
                }else {
                    var scale:CGFloat = 1.0 + translation.x/2000
                    if (translation.x <= -menuViewWidth) {
                        scale = 1.0 - menuViewWidth/2000;
                        moveX = -menuViewWidth;
                    }

                    //缩放rootView
                    rootNav.view.transform = CGAffineTransformMakeScale(scale, scale)
                    rootNav.view.center = CGPointMake(320+moveX-ScreenWidth*scale/2, self.view.bounds.size.height/2)
                }
            }else if (menuStatus == menuStatusType.menuOnLeft){
                if (moveX < 0){
                    return;
                }else{
                    var scale:CGFloat = 0.0
                    if (translation.x <= menuViewWidth) {
                        scale = 1.0 - menuViewWidth/2000 + moveX/2000
                    }else if (translation.x < 3*menuViewWidth-ScreenWidth && translation.x > menuViewWidth) {
                        scale = 1.0 - (moveX-menuViewWidth)/2000
                    }else if (translation.x >= 3*menuViewWidth-ScreenWidth) {
                        moveX = 3*menuViewWidth-ScreenWidth
                        scale = 1.0 - (moveX-menuViewWidth)/2000
                    }
                    
                    //缩放rootView
                    rootNav.view.transform = CGAffineTransformMakeScale(scale, scale);
                    rootNav.view.center = CGPointMake(ScreenWidth-menuViewWidth-ScreenWidth*scale/2+moveX, self.view.bounds.size.height/2);
                }
            }else if (menuStatus == menuStatusType.menuOnRight){
                if (moveX > 0){
                    return
                }else{
                    var scale:CGFloat = 0.0
                    if (translation.x >= -menuViewWidth) {
                        scale = 1.0 - menuViewWidth/2000 - moveX/2000
                    }else if (translation.x > -(3*menuViewWidth-ScreenWidth) && translation.x < -menuViewWidth) {
                        scale = 1.0 + (moveX+menuViewWidth)/2000
                    }else if (translation.x <= -(3*menuViewWidth-ScreenWidth)) {
                        moveX = -(3*menuViewWidth-ScreenWidth)
                        scale = 1.0 + (moveX+menuViewWidth)/2000
                    }
                    
                    //缩放rootView
                    rootNav.view.transform = CGAffineTransformMakeScale(scale, scale);
                    rootNav.view.center = CGPointMake(menuViewWidth + moveX + ScreenWidth*scale/2, self.view.bounds.size.height/2);
                }
            }
        }else if (panGes.state == UIGestureRecognizerState.Cancelled || panGes.state == UIGestureRecognizerState.Ended || panGes.state == UIGestureRecognizerState.Failed || panGes.state == UIGestureRecognizerState.Possible) {
            var moveX:CGFloat = translation.x;
            self.resetRootOrMenView(moveX)
        }
    }

    func resetRootOrMenView(moveX: CGFloat) {
        if (menuStatus == menuStatusType.menuOnMain) {
            if ((moveX > 0 && moveX <= 50) || (moveX < 0 && moveX >= -50)) {
                self.isMenuAnimate = false;
                self.resetRootViewAndMenuView()
            }
            
            if (moveX > 50 && moveX < menuViewWidth) {
                self.showMenu(true)
            }
            if (moveX == menuViewWidth) {
                self.menuStatus = menuStatusType.menuOnRight
                self.addCoverView()
            }
            if (moveX < 0 && moveX >= -menuViewWidth) {
                self.showMenu(false)
            }
        }else if (menuStatus == menuStatusType.menuOnRight){
            if (moveX > 0) {
                return
            }
            if (moveX < 0 && moveX >= -50) {
                self.showMenu(true)
            }
            if (moveX == -menuViewWidth) {
                menuStatus = menuStatusType.menuOnLeft
                self.addCoverView()
            }
            if (moveX < -50 && moveX > -menuViewWidth-50) {
                self.isMenuAnimate = false
                self.resetRootViewAndMenuView()
            }
            if (moveX < -menuViewWidth-50) {
                self.showMenu(false)
            }
        }else if (menuStatus == menuStatusType.menuOnLeft){
            if (moveX < 0) {
                return;
            }
            if (moveX > 0 && moveX <= 50) {
                self.showMenu(false)
            }
            if (moveX == menuViewWidth) {
                self.menuStatus = menuStatusType.menuOnLeft
                self.addCoverView()
            }
            if (moveX > 50 && moveX < menuViewWidth+50) {
                self.isMenuAnimate = false
                self.resetRootViewAndMenuView()
            }
            if (moveX > menuViewWidth+50) {
                self.showMenu(true)
            }
        }
    }

    func resetRootViewAndMenuView(){
        if (self.isMenuAnimate == true) {
            return
        }
        self.isMenuAnimate = true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            //leftViewMenu or rightViewMenu重置
            if (self.rootNav.view.frame.origin.x < 0) {
                var frame:CGRect = self.rightMenuView.frame;
                frame.origin.x = ScreenWidth;
                self.rightMenuView.frame = frame;
            }else{
                var frame:CGRect = self.leftMenuView.frame;
                frame.origin.x = -menuViewWidth;
                self.leftMenuView.frame = frame;
            }
            //rootView重置
            //CGPoint rootPoint = rootVC.view.center;
            self.rootNav.view.center = self.view.center;
            self.rootNav.view.transform = CGAffineTransformMakeScale(1, 1);
            
        }) { (finished: Bool) -> Void in
            self.isMenuAnimate = false
            self.menuStatus = menuStatusType.menuOnMain
        }
    }
    
    func showMenu(isLeftMenu: Bool){
        if (self.isMenuAnimate == true) {
            return
        }
        if (isLeftMenu) {
            if (leftMenuView.frame.origin.x == 0) {
                self.isMenuAnimate = false
                self.resetRootViewAndMenuView()
                return
            }
            self.isMenuAnimate = true
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                var frame:CGRect = self.leftMenuView.frame
                frame.origin.x = 0
                self.leftMenuView.frame = frame
                
                //rootNav缩小
                self.rootNav!.view.transform = CGAffineTransformMakeScale(scaleValue, scaleValue)
                self.rootNav!.view.center = CGPointMake(menuViewWidth + ScreenWidth*scaleValue/2, self.view.bounds.size.height/2)
                }, completion: { (finished: Bool) -> Void in
                    self.isMenuAnimate = false
                    self.menuStatus = menuStatusType.menuOnRight
                    self.addCoverView()
            })
        }else {
            if (rightMenuView.frame.origin.x == ScreenWidth - menuViewWidth) {
                self.isMenuAnimate = false
                self.resetRootViewAndMenuView()
                return
            }
            self.isMenuAnimate = true
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                var frame:CGRect = self.rightMenuView.frame
                frame.origin.x = ScreenWidth - menuViewWidth
                self.rightMenuView.frame = frame
                
                //rootNav缩小
                self.rootNav.view.transform = CGAffineTransformMakeScale(scaleValue, scaleValue)
                self.rootNav.view.center = CGPointMake(320 - menuViewWidth-ScreenWidth*scaleValue/2, self.view.bounds.size.height/2)
            }, completion: { (finished: Bool) -> Void in
                self.isMenuAnimate = false
                self.menuStatus = menuStatusType.menuOnLeft
                self.addCoverView()
            })
        }
    }
    
    func hideCoverView() {
        if ((self.coverView) == nil) {
            return
        }
        self.coverView?.removeFromSuperview()
    }
    
    func addCoverView() {
        self.createCoverView().frame = rootNav.view.frame
        self.view.insertSubview(self.createCoverView(), aboveSubview: rootNav.view)
    }
    
    func createCoverView() -> UIView {
        if ((self.coverView) == nil) {
            self.coverView = UIView()
            self.coverView?.backgroundColor = UIColor.clearColor()
        }
        //绑定手势事件
        let panGus:UIPanGestureRecognizer! = UIPanGestureRecognizer()
        panGus.delegate = self
        panGus.addTarget(self, action: "panGesReceive:")
        self.coverView?.addGestureRecognizer(panGus)

        let tapGes:UITapGestureRecognizer! = UITapGestureRecognizer()
        tapGes.delegate = self
        tapGes.addTarget(self, action: "tapGus:")
        tapGes.numberOfTapsRequired = 1
        tapGes.numberOfTouchesRequired = 1
        self.coverView?.addGestureRecognizer(tapGes)

        
        self.rootNav.view.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
        
        return self.coverView!
    }
}

