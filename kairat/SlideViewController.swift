//
//  SlideViewController.swift
//  kairat
//
//  Created by Beka on 12/2/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class SlideViewController: SlideMenuController,SlideMenuControllerDelegate{
    
    var blur:UIBlurEffect?
    let blurView = UIVisualEffectView()
    override func awakeFromNib() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "News") {
            self.mainViewController = controller
        }
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Menu") {
            self.leftViewController = controller
        }
        SlideMenuOptions.leftViewWidth=UIScreen.main.bounds.width*3/4
        SlideMenuOptions.hideStatusBar=false
        SlideMenuOptions.contentViewScale=1
        self.leftPanGesture?.isEnabled = false
        self.removeLeftGestures()
        super.awakeFromNib()
    }
    
    func openLeftMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blur=UIBlurEffect(style: .light)
        blurView.effect=blur
        blurView.alpha=0.987
        self.slideMenuController()?.delegate=self
    }
    
    func leftWillClose() {
        UIView.animate(withDuration: 0.3) {
            self.blurView.removeFromSuperview()
        }
    }
    func leftDidClose() {
        UIView.animate(withDuration: 0.3) {
            self.blurView.removeFromSuperview()
        }
    }
    
    func leftWillOpen() {
        if let main=self.mainViewController{
            self.blurView.removeFromSuperview()
            UIView.animate(withDuration: 0.3) {
                self.blurView.frame = main.view.bounds
                self.blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                main.view.addSubview(self.blurView)
            }
        }
    }
    
    func leftDidOpen() {
        if let main=self.mainViewController{
            self.blurView.removeFromSuperview()
            UIView.animate(withDuration: 0.3) {
                self.blurView.frame = main.view.bounds
                self.blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                main.view.addSubview(self.blurView)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
