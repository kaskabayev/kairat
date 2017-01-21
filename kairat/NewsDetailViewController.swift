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

class NewsDetailViewController: UIViewController,UIWebViewDelegate,UIScrollViewDelegate {
    
    var id="201"
    var message=JSON.null
    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var gradient: UIImageView!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var gr_top: NSLayoutConstraint!
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
    let shareBtn=UIBarButtonItem()
    // @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        self.title="НОВОСТИ"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont(name: "CenturyGothic-Bold", size: 24)!]
        
        let sBtn = UIButton()
        sBtn.setImage(#imageLiteral(resourceName: "zakladka"), for: .normal)
        sBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        sBtn.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        shareBtn.customView=sBtn
        
        switch selectedIndex {
        case 0:
            let lBtn = UIButton()
            lBtn.setImage(#imageLiteral(resourceName: "zakladka"), for: .normal)
            lBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            lBtn.addTarget(self, action: #selector(addLove), for: .touchUpInside)
            loveBtn.customView=lBtn
            self.navigationItem.setRightBarButtonItems([loveBtn], animated: false)
            break
        case 5:
            self.title="ИЗБРАННОЕ"
            let lBtn = UIButton()
            lBtn.setImage(#imageLiteral(resourceName: "zakladka_active"), for: .normal)
            lBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            lBtn.addTarget(self, action: #selector(removeLove), for: .touchUpInside)
            loveBtn.customView=lBtn
            self.navigationItem.setRightBarButtonItems([loveBtn], animated: false)
            break
        default:
            break
        }
        self.navigationController?.setBG()
        fon.image=#imageLiteral(resourceName: "fon").imageByCroppingImage(size: CGSize(width: 1200, height: 1200))
        showComment.addTarget(self, action: #selector(showCom))
        view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)
        webView.translatesAutoresizingMaskIntoConstraints=false
        webView.anchorWithConstantsToTop(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant:(navigationController?.navigationBar.bounds.size.height)!, leftConstant: 5, bottomConstant: 60, rightConstant: 5)
        webView.isOpaque=false
        webView.backgroundColor=UIColor.clear
        webView.delegate=self
        webView.scrollView.delegate=self
        webView.scrollView.showsVerticalScrollIndicator=false
        webView.scrollView.showsHorizontalScrollIndicator=false
        gradient.isHidden=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y=scrollView.contentOffset.y
        if y>10{
            self.navigationController?.setBG2()
        }else{
            self.navigationController?.setBG()
        }
        gr_top.constant=10-y
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
    
    func back(){
        self.navigationController?.popViewController(animated: true)
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
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    UserDefaults.standard.setNewFav(data, key: id)
                }
                self.showAlert(msg: "Пост добавлен в избранные", actions: [cancel])
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
    
    func share(_ sender: Any) {
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
                var mainDiv="<html>\n <head>\n <style type=\"text/css\">\n body {font-size: 16px; color:black;padding:0 5px;background-color: transparent;font-family:'OpenSans'}\n img {width:100%;max-height:\((UIScreen.main.bounds.width-70)*2)px;}\n p{padding:0 10px}\n .h2{color:black;padding:0 10px;font-size:20px;font-family:'CenturyGothic-Bold'}\n.mTop_0{margin-top:-20px;padding-top:0;padding-bottom:10px;}\n .date{color:white;font-size: 15px;position:absolute;left:10px;bottom:5px;font-family:'CenturyGothic';font-size:16px;}\n.tags{margin-left:10px;margin-top:2px;line-height: 1.8; word-wrap: normal; display: inline-block;padding:2px 5px;border-style:solid;border-width:1px;border-color:gray;color:gray;}\n img.titleImg{width:100%;height:200px}\n.content{font-family:'OpenSans-Light';font-size:16px;}\n header{background-color:transparent;height:30px;}\n iframe{width:100%;max-height:\((UIScreen.main.bounds.width-70)*2)px;}\n</style>\n</head>\n<body>"
                mainDiv+="<header></header>"
                var imageDiv=""
                if let preview=self.message["preview"].string{
                    if preview.characters.count > 0{
                        self.gradient.isHidden=false
                        imageDiv="<div style='position:relative;'>"
                        if let url=self.message["preview"].string{
                            imageDiv+="<img class='titleImg' src='\(url)'/>"
                        }
                        if let dtime=self.message["dtime"].string{
                            let date=Date(timeIntervalSince1970: TimeInterval.init(dtime)!)
                            let dateFormat=DateFormatter()
                            dateFormat.locale=Locale(identifier: "ru")
                            dateFormat.dateFormat="d MMMM,HH:mm"
                            let date_label:UILabel={
                                let l=UILabel()
                                l.textColor=UIColor.white
                                l.text=dateFormat.string(from: date)
                                l.font=UIFont(name: "CenturyGothic", size: 16)
                                return l
                            }()
                            self.view.insertSubview(date_label, aboveSubview: self.gradient)
                            date_label.anchorWithConstantsToTop(nil, left: self.gradient.leftAnchor, bottom: self.gradient.bottomAnchor, right: self.gradient.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 10, rightConstant: 10)
                            //imageDiv+="<span class='date'>\(dateFormat.string(from: date))</span>"
                        }
                        imageDiv+="</div>"
                    }
                }
                var contentDiv=""
                if let title=self.message["title"].string{
                    contentDiv="<div class='mTop_0' style='background-color: white;'>"
                    contentDiv+="<p class='h2'>\(title)</p>"
                }
                if self.message["tags"].array?.isEmpty==false{
                    if let tags=self.message["tags"].arrayObject as? [String]{
                        for item in 0...tags.count-1{
                            contentDiv+="<span class='tags'>\(tags[item])</span>"
                        }
                    }
                }
                if let content=self.message["content"].string{
                    contentDiv+="<div class='content'>\(content)</div>"
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
                    var str=""
                    if comment.count>0{
                        if comment.count<10{
                            switch comment.count{
                            case 0:
                                str=comment_s.d.rawValue
                                break
                            case 1:
                                str=comment_s.a.rawValue
                                break
                            case 2...4:
                                str=comment_s.b.rawValue
                                break
                            case 5...9:
                                str=comment_s.c.rawValue
                                break
                            default:
                                break
                            }
                        }else{
                            switch comment.count%10{
                            case 1:
                                str=comment_s.a.rawValue
                                break
                            case 2...4:
                                str=comment_s.b.rawValue
                                break
                            case 0,5...9:
                                str=comment_s.c.rawValue
                                break
                            default:
                                break
                            }
                        }
                    }
                    fullString.append(NSAttributedString(string: " \(comment.count) \(str)"))
                    self.commentTxt?.attributedText=fullString
                }
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    enum comment_s:String {
        case a="коментарий"
        case b="коментария"
        case c="коментариев"
        case d="нет коментариев"
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        loadingView.isHidden=true
        loadingView.removeFromSuperview()
    }
}
