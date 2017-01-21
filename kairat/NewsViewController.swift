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
    let limit=10
    var is_nxt_active=false
    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var fon_blur: UIImageView!
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
        
        let lBtn = UIButton()
        lBtn.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        lBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        lBtn.addTarget(self, action: #selector(open), for: .touchUpInside)
        menuBtn.customView=lBtn
        self.navigationItem.setLeftBarButtonItems([menuBtn], animated: false)
        
        self.view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)
        fon.image=#imageLiteral(resourceName: "fon").imageByCroppingImage(size: CGSize(width: 1200, height: 1200))
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
    
    let menuBtn=UIBarButtonItem()
    func open(_ sender: Any) {
        self.slideMenuController()?.toggleLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch selectedIndex {
        case 5:
            loadData()
            break
        default:
            break
        }
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
                    self.newsTable.reloadData()
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
                    self.is_nxt_active=false
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
        if message.count==0{
            return 1
        }else{
            return (message.array?.count)!+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message.count>0{
            if indexPath.row<(message.array?.count)!{
                var m=(message.array?[indexPath.row])!
                if m["preview"] == nil{
                    let cell=tableView.dequeueReusableCell(withIdentifier: "noimage_cell", for: indexPath) as! NewsNoImageCell
                    if let title=m["title"].string{
                        cell.titleTxt.text=title
                    }
                    if let anons=m["anons"].string{
                        let fullString = NSMutableAttributedString(string: anons)
                        cell.detailTxt.attributedText=fullString
                    }
                    if let comCount=m["comments_count"].int{
                        if comCount>0{
                            cell.com_img.isHidden=false
                            cell.com_count.isHidden=false
                            cell.bottom.constant=35
                            cell.com_count.text="\(comCount)"
                        }
                        else{
                            cell.com_img.isHidden=true
                            cell.com_count.isHidden=true
                            cell.bottom.constant=5
                        }
                    }else{
                        cell.com_img.isHidden=true
                        cell.com_count.isHidden=true
                        cell.bottom.constant=5
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
                        cell.detailTxt.attributedText=fullString
                    }
                    if let comCount=m["comments_count"].int{
                        if comCount>0{
                            cell.com_img.isHidden=false
                            cell.com_count.isHidden=false
                            cell.bottom.constant=35
                            cell.com_count.text="\(comCount)"
                        }
                        else{
                            cell.com_img.isHidden=true
                            cell.com_count.isHidden=true
                            cell.bottom.constant=5
                        }
                    }else{
                        cell.com_img.isHidden=true
                        cell.com_count.isHidden=true
                        cell.bottom.constant=5
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
            return UITableViewCell()
//            if selectedIndex==0{
//                let cell=tableView.dequeueReusableCell(withIdentifier: "last", for: indexPath) as! LastCell
//                cell.nextBtn.addTarget(self, action: #selector(loadNext), for: .touchUpInside)
//                return cell
//            }else{
//                return UITableViewCell()
//            }
            
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
        if message.count>0{
            var m=(message.array?[indexPath.row])!
            if m != nil{
                if let id=m["id"].string{
                    selectedID = id
                    performSegue(withIdentifier: "newsDetail", sender: self)
                }
            }

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if message.count==0{
            return 70
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.clear
        switch selectedIndex {
        case 0:
            if message.count>0{
                if indexPath.row==message.count{
                    if is_nxt_active==false{
                        is_nxt_active=true
                        loadNext()
                    }
                }
            }
            break
        default:
            break
        }
    }
    
}

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var dataTxt: UILabel!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var detailTxt: UILabel!
    @IBOutlet weak var com_img: UIImageView!
    @IBOutlet weak var com_count: UILabel!
    @IBOutlet weak var bottom: NSLayoutConstraint!
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
    @IBOutlet weak var com_img: UIImageView!
    @IBOutlet weak var com_count: UILabel!
    @IBOutlet weak var bottom: NSLayoutConstraint!
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
