//
//  ViewController.swift
//  kairat
//
//  Created by Beka on 12/3/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebKit

class NewsDetailViewController: UIViewController,UIWebViewDelegate {
    
    var id="201"
    var message=JSON.null
    @IBOutlet weak var fon: UIImageView!
    var blur:UIBlurEffect?
    let blurView = UIVisualEffectView()
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var commentTxt: UILabel!
    @IBOutlet var showComment: UITapGestureRecognizer!
    var loadingView:UIView={
        let l=UIView()
        l.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive=true
        l.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive=true
        l.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        l.translatesAutoresizingMaskIntoConstraints=false
        let activity=UIActivityIndicatorView()
        activity.startAnimating()
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.translatesAutoresizingMaskIntoConstraints=false
        l.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: l.centerXAnchor).isActive=true
        activity.centerYAnchor.constraint(equalTo: l.centerYAnchor).isActive=true
        l.isHidden=false
        return l
    }()
    
    let loveBtn=UIBarButtonItem()
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        switch selectedIndex {
        case 0:
            self.title="НОВОСТИ"
            let lBtn = UIButton()
            lBtn.setImage(#imageLiteral(resourceName: "favs"), for: .normal)
            lBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            lBtn.addTarget(self, action: #selector(addLove), for: .touchUpInside)
            loveBtn.customView=lBtn
            self.navigationItem.setRightBarButtonItems([loveBtn,shareBtn], animated: false)
            break
        case 5:
            self.title="ИЗБРАННОЕ"
            let lBtn = UIButton()
            lBtn.setImage(#imageLiteral(resourceName: "favs_active"), for: .normal)
            lBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            lBtn.addTarget(self, action: #selector(removeLove), for: .touchUpInside)
            loveBtn.customView=lBtn
            self.navigationItem.setRightBarButtonItems([loveBtn,shareBtn], animated: false)
            break
        default:
            break
        }
        self.navigationController?.setBG()
        
        showComment.addTarget(self, action: #selector(showCom))
        view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)
        
        blur=UIBlurEffect(style: .light)
        blurView.effect=blur
        self.blurView.frame = fon.bounds
        self.blurView.alpha=0.8
        self.blurView.translatesAutoresizingMaskIntoConstraints=false
        self.view.insertSubview(blurView, belowSubview: webView)
        blurView.anchorWithConstantsToTop(top: self.fon.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor , topConstant: (self.navigationController?.navigationBar.frame.height)!, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        webView.translatesAutoresizingMaskIntoConstraints=false
        webView.anchorWithConstantsToTop(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 30+(navigationController?.navigationBar.bounds.size.height)!, leftConstant: 5, bottomConstant: 60, rightConstant: 5)
        webView.isOpaque=false
        webView.backgroundColor=UIColor.clear
        webView.delegate=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if segue.identifier=="showComment"{
            let dc=segue.destination as! NewsCommentViewController
            dc.message=self.message["comments"]
            if let id=self.message["id"].string{
                dc.id=id
            }
        }
    }
    
    func addLove(){
        if UserDefaults.standard.isLoggedIn(){
            if let id=message["id"].string{
                CustomRequests.addFav(view: self, loading: loadingView,id: id){
                    response in
                    if response != nil{
                        if response["status"].string=="ok"{
                            let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                                (result:UIAlertAction)->Void in
                                
                            }
                            self.showAlert(msg: "Пост добавлен в избранные", actions: [cancel])
                        }else{
                            let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                                (result:UIAlertAction)->Void in
                                
                            }
                            self.showAlert(msg: "Произошла ошибка. Повторите попытку", actions: [cancel])
                        }
                    }
                }
            }
        }else{
            let data=message.rawString(.utf8, options: .prettyPrinted)!
            if let id=message["id"].string{
                UserDefaults.standard.setNewFav(data, key: id)
            }
        }
    }
    
    func removeLove(){
        if UserDefaults.standard.isLoggedIn(){
            if let id=message["id"].string{
                CustomRequests.removeFav(view: self, loading: loadingView,id: id){
                    response in
                    if response != nil{
                        if response["status"].string=="ok"{
                            let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                                (result:UIAlertAction)->Void in
                                
                            }
                            self.showAlert(msg: "Пост удален из избранные", actions: [cancel])
                        }else{
                            let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                                (result:UIAlertAction)->Void in
                                
                            }
                            self.showAlert(msg: "Произошла ошибка. Повторите попытку", actions: [cancel])
                        }
                    }
                }
            }
        }else{
            if let id=message["id"].string{
                UserDefaults.standard.deletFavs(key: id)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func share(_ sender: Any) {
        if let msg=message["anons"].string{
            let activityViewController = UIActivityViewController(activityItems: [msg], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityType.mail]
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func showCom(){
        performSegue(withIdentifier: "showComment", sender: self)
    }
    
    func loadData(){
        view.addSubview(loadingView)
        loadingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        CustomRequests.getNewsDetail(view: self,loading: loadingView,id: id){
            response in
            if response != nil{
                self.message=response
                var mainDiv="<html>\n <head>\n <style type=\"text/css\">\n body {font-size: 10px; color:black;padding:5px;background-color: transparent;}\n p>img {width:100%;max-width:\(UIScreen.main.bounds.width-70)px;max-height:150px;}\n p{padding:0 10px}\n h2{color:black;padding:0 10px;}\n.mTop_0{margin-top:-5px;padding-top:10px;padding-bottom:10px;}\n .date{color:white;font-size: 15px;position:absolute;left:10px;bottom:5px}\n.tags{margin-left:10px;margin-top:2px;line-height: 1.8; word-wrap: normal; display: inline-block;padding:2px 5px;border-style:solid;border-width:1px;border-color:gray;color:gray;}\n img.titleImg{width:100%;}\n</style>\n </head>\n<body>"
                var imageDiv=""
                if self.message["preview"] != nil{
                    imageDiv="<div style='position:relative;'>"
                    if let url=self.message["preview"].string{
                        imageDiv+="<img class='titleImg' src='\(url)'/>"
                    }
                    if let dtime=self.message["dtime"].string{
                        let date=Date(timeIntervalSince1970: TimeInterval.init(dtime)!)
                        let dateFormat=DateFormatter()
                        dateFormat.locale=Locale(identifier: "ru")
                        dateFormat.dateFormat="d MMMM,HH:mm"
                        imageDiv+="<span class='date'>\(dateFormat.string(from: date))</span>"
                    }
                    imageDiv+="</div>"
                }
                var contentDiv=""
                if let title=self.message["title"].string{
                    contentDiv="<div class='mTop_0' style='background-color: white;'>"
                    contentDiv+="<h2>\(title)</h2>"
                }
                if self.message["tags"].array?.isEmpty==false{
                    if let tags=self.message["tags"].arrayObject as? [String]{
                        for item in 0...tags.count-1{
                            contentDiv+="<span class='tags'>\(tags[item])</span>"
                        }
                    }
                }
                if let content=self.message["content"].string{
                    contentDiv+=content
                }
                if let author=self.message["author"]["name"].string{
                    contentDiv+="<span style='padding:0 10px;'>\(author)</span>"
                    contentDiv+="</div>"
                }
                mainDiv+=imageDiv
                mainDiv+=contentDiv
                mainDiv+="</body>\n </html>"
                self.webView.loadHTMLString(mainDiv, baseURL: nil)
                if let comment=self.message["comments"].arrayObject{
                    let fullString = NSMutableAttributedString(string: "")
                    let image1Attachment = NSTextAttachment()
                    image1Attachment.image = #imageLiteral(resourceName: "comment")
                    image1Attachment.bounds=CGRect(x: 0, y: -5, width: 15, height: 15)
                    let image1String = NSAttributedString(attachment: image1Attachment)
                    fullString.append(image1String)
                    fullString.append(NSAttributedString(string: " \(comment.count) комментариев"))
                    self.commentTxt?.attributedText=fullString
                }
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        loadingView.isHidden=true
        loadingView.removeFromSuperview()
    }
}
