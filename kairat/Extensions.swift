//
//  Extensions.swift
//  BaiBol
//
//  Created by Daulet on 10/1/16.
//  Copyright © 2016 tungatarovdaulet. All rights reserved.
//

import UIKit
import SwiftyJSON

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

extension UIImage{
    func imageByCroppingImage(size : CGSize) -> UIImage{
        let refWidth : CGFloat = CGFloat(self.cgImage!.width)
        let refHeight : CGFloat = CGFloat(self.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect =  CGRect(x: x, y: y, width: size.height, height: size.width)
        let imageRef = self.cgImage!.cropping(to: cropRect)
        
        let cropped : UIImage = UIImage(cgImage: imageRef!, scale: 0, orientation: self.imageOrientation)
        
        return cropped
    }
}
extension UILabel{
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func requiredWidth() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.width
    }

}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlString=link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        URLSession.shared.dataTask( with: URL.init(string: urlString!)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

extension UIViewController{
    
    func showAlert(msg:String,actions:[UIAlertAction]?) {
        let alertController = UIAlertController(title: "Сообщение", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        if actions != nil{
            for item in actions! {
                alertController.addAction(item)
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showLoading(){
        let loading = UIAlertController(title: "", message: "Загрузка ...", preferredStyle: UIAlertControllerStyle.alert)
        self.present(loading, animated: true, completion: nil)
    }
}

extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor=UIColor.clear
        setNavigationBarHidden(false, animated:true)
    }
    
    public func hideTransparentNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
        navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
    
    public func setBG2(){
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.isOpaque=false
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor=UIColor.black
        setNavigationBarHidden(false, animated:true)
    }
    
    public func setBG(){
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.isOpaque=false
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        setNavigationBarHidden(false, animated:true)
    }
}

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
        }
    }
    
    func anchorWithConstantsToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
        }
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func anchorToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top: top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
}

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case favs
        case info
    }
    
    //Detect if user authorized
    func setIsLoggedIn(_ value: Bool) {
        setValue(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    //info
    func setInfo(_ value:[String:String]){
         setValue([:], forKey: UserDefaultsKeys.info.rawValue)
         setValue(value, forKey: UserDefaultsKeys.info.rawValue)
         UserDefaults.standard.synchronize()
    }
    
    func getInfo()->[String:String]{
        if let f=dictionary(forKey: UserDefaultsKeys.info.rawValue){
            return f as! [String : String]
        }
        return [:]
    }
    
    //Favs
    func setNewFav(_ value:String,key:String){
        if var f=dictionary(forKey: UserDefaultsKeys.favs.rawValue){
            f[key]=value
            setValue(f, forKey: UserDefaultsKeys.favs.rawValue)
        }else{
            var f:[String:String]=[String:String]()
            f[key]=value
            setValue(f, forKey: UserDefaultsKeys.favs.rawValue)
        }
        UserDefaults.standard.synchronize()
    }
    
    func getFavs()->[String:String]{
        if let f=dictionary(forKey: UserDefaultsKeys.favs.rawValue){
            return f as! [String : String]
        }
        return [:]
    }
    
    func deletFavs(key:String){
        var f=getFavs()
        if f.isEmpty==false{
            if f[key] != nil{
                f.removeValue(forKey:key)
                setValue(f, forKey: UserDefaultsKeys.favs.rawValue)
            }
        }
    }
    
    func isFaved(key:String)->Bool{
        let f=getFavs()
        if f.isEmpty==false{
            if f[key] != nil{
                return true
            }
        }
        return false
    }
}
