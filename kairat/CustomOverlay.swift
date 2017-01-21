//
//  CustomOverlay.swift
//  kairat
//
//  Created by beka on 1/12/17.
//  Copyright © 2017 Beka. All rights reserved.
//

import Foundation
import UIKit
import INSNibLoading
import INSPhotoGallery

class CustomOverlay:INSNibLoadedView,INSPhotosOverlayViewable {
    
    open weak var photosViewController: INSPhotosViewController?
    // Pass the touches down to other views
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    var currentPhoto: CustomVideoModel?
    
    override func awakeFromNib() {
        navBar.backgroundColor = UIColor.clear
        navBar.barTintColor = nil
        navBar.isTranslucent = true
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) , hitView != self {
            return hitView
        }
        return nil
    }
    @IBAction func close(_ sender: Any) {
        photosViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func open(_ sender: Any) {
        print("open")
    }
    @IBAction func open_btn(_ sender: Any) {
        UIApplication.shared.openURL(URL.init(string: (currentPhoto?.videoURL)!)!)
    }
    
    func populateWithPhoto(_ photo: INSPhotoViewable) {
        self.currentPhoto = photo as? CustomVideoModel
    }
    
    func setHidden(_ hidden: Bool, animated: Bool) {
        if self.isHidden == hidden {
            return
        }
        
        if animated {
            self.isHidden = false
            self.alpha = hidden ? 1.0 : 0.0
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { () -> Void in
                self.alpha = hidden ? 0.0 : 1.0
            }, completion: { result in
                self.alpha = 1.0
                self.isHidden = hidden
            })
        } else {
            self.isHidden = hidden
        }
    }
}
