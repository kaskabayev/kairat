//
//  NewsViewController.swift
//  kairat
//
//  Created by Beka on 12/3/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class NewsViewController: UIViewController {
    
    var message=JSON.null
    var selectedID = ""
    var page=0
    let limit=5
    @IBOutlet weak var fon: UIImageView!
    var blur:UIBlurEffect?
    let blurView = UIVisualEffectView()
    
    @IBOutlet weak var newsTable: UITableView!
    var refreshControl: UIRefreshControl!
    var loadingView:UIView={
        let l=UIView()
        l.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive=true
        l.backgroundColor=UIColor.black.withAlphaComponent(0.4)
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
    var loadingViewHeght:NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        switch selectedIndex {
        case 0:
            self.title="НОВОСТИ"
            break
        case 5:
            self.title="ИЗБРАННОЕ"
            break
        default:
            break
        }
        self.navigationController?.setBG()
        self.view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)
        
        blur=UIBlurEffect(style: .light)
        blurView.effect=blur
        self.blurView.frame = fon.bounds
        self.blurView.alpha=0.8
        self.blurView.translatesAutoresizingMaskIntoConstraints=false
        self.view.insertSubview(blurView, belowSubview: newsTable)
        blurView.anchorWithConstantsToTop(top: self.fon.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor , topConstant: (self.navigationController?.navigationBar.frame.height)!, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        newsTable.addSubview(refreshControl)
        newsTable.translatesAutoresizingMaskIntoConstraints=false
        newsTable.anchorWithConstantsToTop(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 30+(navigationController?.navigationBar.bounds.size.height)!, leftConstant: 5, bottomConstant: 0, rightConstant: 5)
        newsTable.tableFooterView=UIView()
        newsTable.separatorStyle = .none
        newsTable.backgroundColor=UIColor.clear
        newsTable.estimatedRowHeight=100
        newsTable.rowHeight=UITableViewAutomaticDimension
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        switch selectedIndex {
        case 0:
            view.addSubview(loadingView)
            loadingViewHeght=NSLayoutConstraint(item: loadingView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)
            loadingView.addConstraint(loadingViewHeght!)
            loadingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
            CustomRequests.getNews(view: self,loading: loadingView,page: 0,limit: limit+page){
                response in
                self.loadingView.removeFromSuperview()
                self.refreshControl.endRefreshing()
                if response != nil{
                    self.message=response
                    self.newsTable.reloadData()
                }
            }
            break
        case 5:
            if UserDefaults.standard.isLoggedIn()==false{
                if UserDefaults.standard.getFavs().isEmpty==false{
                    let data=UserDefaults.standard.getFavs()
                    var jsonArr=[JSON]()
                    for key in data.keys {
                        let d=data[key]?.data(using: .utf8)
                        let anyObj=JSON.init(data: d!)
                        jsonArr.append(anyObj)
                    }
                    self.message=JSON.init(jsonArr)
                }
            }else{
                view.addSubview(loadingView)
                loadingViewHeght=NSLayoutConstraint(item: loadingView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)
                loadingView.addConstraint(loadingViewHeght!)
                loadingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                CustomRequests.getFav(view: self, loading: loadingView,page: page){
                    response in
                    self.loadingView.removeFromSuperview()
                    self.refreshControl.endRefreshing()
                    if response != nil{
                        self.message=response
                        self.newsTable.reloadData()
                    }
                }
            }
            break
        default:
            break
        }
        refreshControl.endRefreshing()
        newsTable.reloadData()
    }
    
    func loadNext(){
        page+=limit
        view.addSubview(loadingView)
        loadingView.removeConstraint(loadingViewHeght!)
        loadingViewHeght=NSLayoutConstraint(item: loadingView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 60)
        loadingView.addConstraint(loadingViewHeght!)
        loadingView.anchorWithConstantsToTop(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        switch selectedIndex {
        case 0:
            CustomRequests.getNews(view: self,loading: loadingView,page: page,limit: limit){
                response in
                self.loadingView.removeFromSuperview()
                if response != nil{
                    var d=self.message.arrayValue
                    d+=response.arrayValue
                    self.message=JSON(d)
                    self.newsTable.reloadData()
                }
            }
            break
        case 5:
            CustomRequests.getFav(view: self, loading: loadingView,page: page){
                response in
                self.loadingView.removeFromSuperview()
                if response != nil{
                    var d=self.message.arrayValue
                    d+=response.arrayValue
                    self.message=JSON(d)
                    self.newsTable.reloadData()
                }
            }
            break
        default:
            break
        }
    }
    
    @IBAction func open(_ sender: Any) {
        self.slideMenuController()?.toggleLeft()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier=="newsDetail"{
            let dc=segue.destination as! NewsDetailViewController
            dc.id=selectedID
        }
    }
}

extension NewsViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if message == nil{
            return 1
        }else{
            return (message.array?.count)!+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message != nil{
            if indexPath.row<(message.array?.count)!{
                var m=(message.array?[indexPath.row])!
                if m["preview"] == nil{
                    let cell=tableView.dequeueReusableCell(withIdentifier: "noimage_cell", for: indexPath) as! NewsNoImageCell
                    if let title=m["title"].string{
                        cell.titleTxt.text=title
                    }
                    if let anons=m["anons"].string{
                        let fullString = NSMutableAttributedString(string: anons)
                        if let comCount=m["comments_count"].int{
                            let image1Attachment = NSTextAttachment()
                            image1Attachment.image = #imageLiteral(resourceName: "comment")
                            image1Attachment.bounds=CGRect(x: 0, y: -5, width: 15, height: 15)
                            let image1String = NSAttributedString(attachment: image1Attachment)
                            fullString.append(image1String)
                            fullString.append(NSAttributedString(string: " \(comCount)"))
                        }
                        cell.detailTxt.attributedText=fullString
                    }
                    return cell
                }else{
                    let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCell
                    if let url=m["preview"].string{
                        cell.newsImg?.kf.setImage(with: URL.init(string: url))
                        
                    }
                    if let title=m["title"].string{
                        cell.titleTxt.text=title
                    }
                    if let anons=m["anons"].string{
                        let fullString = NSMutableAttributedString(string: anons)
                        if let comCount=m["comments_count"].int{
                            let image1Attachment = NSTextAttachment()
                            image1Attachment.image = #imageLiteral(resourceName: "comment")
                            image1Attachment.bounds=CGRect(x: 10, y: 2, width: 13, height: 10)
                            let image1String = NSAttributedString(attachment: image1Attachment)
                            fullString.append(image1String)
                            fullString.append(NSAttributedString(string: " \(comCount)"))
                        }
                        cell.detailTxt.attributedText=fullString
                    }
                    if let dtime=m["dtime"].string{
                        let date=Date(timeIntervalSince1970: TimeInterval.init(dtime)!)
                        let dateFormat=DateFormatter()
                        dateFormat.locale=Locale(identifier: "ru")
                        dateFormat.dateFormat="d MMMM,HH:mm"
                        cell.dataTxt.text=dateFormat.string(from: date)
                    }
                    return cell
                }
                
            }
            let cell=tableView.dequeueReusableCell(withIdentifier: "last", for: indexPath) as! LastCell
            cell.nextBtn.addTarget(self, action: #selector(loadNext), for: .touchUpInside)
            return cell
        }else{
            switch selectedIndex {
            case 0:
                return UITableViewCell()
            case 5:
                let cell=tableView.dequeueReusableCell(withIdentifier: "empty", for: indexPath)
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
}

extension NewsViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var m=(message.array?[indexPath.row])!
        if m != nil{
            if let id=m["id"].string{
                selectedID = id
                performSegue(withIdentifier: "newsDetail", sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if message == nil{
            return 70
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.clear
    }
    
}

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var dataTxt: UILabel!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var detailTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class NewsNoImageCell: UITableViewCell {
    
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var detailTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class LastCell:UITableViewCell{
    
    @IBOutlet weak var nextBtn: UIButton!
    
}
