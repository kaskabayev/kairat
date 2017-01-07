//
//  CustomWebView.swift
//  kairat
//
//  Created by Beka on 12/31/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class CustomWebView: UIWebView,UIWebViewDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.scrollView.isScrollEnabled = false
        self.scrollView.bounces = false
        self.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.scrollView.isScrollEnabled = false
        self.scrollView.bounces = false
        self.delegate = self
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webViewResizeToContent(webView: webView)
    }
    
    func webViewResizeToContent(webView: UIWebView) {
        webView.layoutSubviews()
        
        // Set to smallest rect value
        var frame:CGRect = webView.frame
        frame.size.height = 1.0
        webView.frame = frame
        
        var height:CGFloat = webView.scrollView.contentSize.height
        //webView.setHeight(height: height)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: height)
        webView.addConstraint(heightConstraint)
        
        // Set layout flag
        webView.window?.setNeedsUpdateConstraints()
        webView.window?.setNeedsLayout()
    }}
