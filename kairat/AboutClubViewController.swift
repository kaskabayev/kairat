//
//  AboutClubViewController.swift
//  kairat
//
//  Created by Beka on 12/26/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

protocol IndicatorDelegate {
    func set(tag:Int)
    func show(json:JSON)
    func show_alert()
    func show_detail(id:Int)
    func back()
    func reload()
}

class AboutClubViewController: UIViewController,IndicatorDelegate,UIWebViewDelegate {
   
    internal func reload() {
        self.isFirstLoad=false
        table.reloadData()
    }
    internal func back() {
        self.isDetail=false
        self.selected_team = 2
        self.table.reloadData()
    }
    internal func show_detail(id:Int) {
        load_sostav_detail(id: id)
    }
    internal func show_alert() {
        chooseTeamType()
    }
    internal func show(json: JSON) {
        detail_mess=json
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    internal func set(tag: Int) {
        index=tag
        setXPosition(tag: index)
    }
    
    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var header_view: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var message=JSON.null
    var detail_mess=JSON.null
    var message_sostav=JSON.null
    var sostav_detail=JSON.null
    
    var index=0
    var selected_team=0
    var isDetail=false
    var isFirstLoad=true
    
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
        self.title="КЛУБ"
        self.navigationController?.setBG()
        self.view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 16/255, alpha: 1)
        fon.image=#imageLiteral(resourceName: "Kaitrat").imageByCroppingImage(size: CGSize(width: 1000, height: 1000))
        table.backgroundColor=UIColor.clear
        table.contentInset=UIEdgeInsetsMake(0, 0, 0, 0)
        table.estimatedRowHeight=UIScreen.main.bounds.height
        table.rowHeight=UITableViewAutomaticDimension
        table.reloadData()
        setup()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func open(_ sender: Any) {
        self.toggleLeft()
    }
    
    func chooseTeamType() {
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let administrationAction = UIAlertAction(title: "АДМИНИСТРАЦИЯ", style: .default, handler: { void in
            //sender.setTitle("АДМИНИСТРАЦИЯ", for: .normal)
            self.selected_team = 0
            self.table.reloadData()
        })
        let trenersAction = UIAlertAction(title: "ТРЕНЕРЫ", style: .default, handler: { void in
            //sender.setTitle("ТРЕНЕРЫ", for: .normal)
            self.selected_team = 1
            self.table.reloadData()
        })
        let playersAction = UIAlertAction(title: "ИГРОКИ", style: .default, handler: { void in
            //sender.setTitle("ИГРОКИ", for: .normal)
            self.selected_team = 2
            self.table.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "ОТМЕНА", style: .cancel, handler: nil)
        
        alertController.addAction(administrationAction)
        alertController.addAction(trenersAction)
        alertController.addAction(playersAction)
        alertController.addAction(cancelAction)
        
       self.present(alertController, animated: true, completion: nil)
    }
    
    func loadData(){
        view.addSubview(loadingView)
        loadingViewHeght=NSLayoutConstraint(item: loadingView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)
        loadingView.addConstraint(loadingViewHeght!)
        loadingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        CustomRequests.getClub(view: self,loading: loadingView){
            response in
            if response != nil{
                self.message=response
                CustomRequests.getTeam(view: self,loading: self.loadingView){
                    response2 in
                    if response2 != nil{
                        self.message_sostav=response2
                        self.table.reloadData()
                    }
                }
            }
        }
    }
    
    func load_sostav_detail(id:Int){
        CustomRequests.getTeam(view: self,loading: self.loadingView,id:id){
            response in
            if response != nil{
                self.isFirstLoad=true
                self.isDetail=true
                self.sostav_detail=response
                self.table.reloadData()
            }
        }
    }
    
    var btn1:UIButton={
        let b=UIButton()
        b.tag=0
        b.setTitle("ИСТОРИЯ", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor.red, for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var btn2:UIButton={
        let b=UIButton()
        b.tag=1
        b.setTitle("ДОСТИЖЕНИЯ", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor.red, for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var btn3:UIButton={
        let b=UIButton()
        b.tag=2
        b.setTitle("СОСТАВ", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor.red, for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var indicator:UIView={
        let v=UIView()
        v.backgroundColor=UIColor.red
        v.heightAnchor.constraint(equalToConstant: 4).isActive=true
        v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3).isActive=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    func setup(){
        btn1.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        btn3.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        
        btn1.isSelected=true
        btn2.isSelected=true
        btn3.isSelected=true
        
        header_view.addSubview(btn1)
        header_view.addSubview(btn2)
        header_view.addSubview(btn3)
        header_view.addSubview(indicator)
        
        indicator.anchorWithConstantsToTop(nil, left: header_view.leftAnchor, bottom: header_view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        btn1.anchorWithConstantsToTop(nil, left: header_view.leftAnchor, bottom: indicator.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
        btn2.anchorWithConstantsToTop(nil, left: btn1.rightAnchor, bottom: indicator.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
        btn3.anchorWithConstantsToTop(nil, left: btn2.rightAnchor, bottom: indicator.topAnchor, right: header_view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y=scrollView.contentOffset.y
        if y>150{
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.navigationController?.setBG2()
                self.header_view.backgroundColor=UIColor.black
            }, completion: nil)
            self.header_view.frame.origin.y=y
        }else{
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.navigationController?.setBG()
                self.header_view.backgroundColor=UIColor.clear
            }, completion: nil)
            let top=44+y
            self.topConstraint.constant=0-top
        }
    }
    func setSelected(sender:UIButton){
        index=sender.tag
        setXPosition(tag: index)
    }
    func setXPosition(tag:Int){
        switch tag {
        case 0:
            btn1.isSelected=true
            btn2.isSelected=false
            btn3.isSelected=false
            indicator.frame.origin.x=0
            table.reloadData()
            break
        case 1:
            btn1.isSelected=false
            btn2.isSelected=true
            btn3.isSelected=false
            indicator.frame.origin.x=UIScreen.main.bounds.width*1/3
            table.reloadData()
            break
        case 2:
            btn1.isSelected=false
            btn2.isSelected=false
            btn3.isSelected=true
            indicator.frame.origin.x=UIScreen.main.bounds.width*2/3
            table.reloadData()
            break
        default:
            break
        }
    }
}
extension AboutClubViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch index {
        case 0:
            let cell=tableView.dequeueReusableCell(withIdentifier: "istoria", for: indexPath) as! IstoriaCell
            cell.delegate=self
            cell.index=index
            cell.message=self.message
            return cell
        case 1:
            let cell=tableView.dequeueReusableCell(withIdentifier: "dostijenie", for: indexPath) as! DostijenieCell
            cell.delegate=self
            cell.index=index
            cell.message=message
            return cell
        case 2:
            switch selected_team {
            case 0:
                let cell=tableView.dequeueReusableCell(withIdentifier: "admin", for: indexPath) as! AdminCell
                cell.delegate=self
                cell.index=index
                cell.message=message_sostav
                return cell
            case 1:
                let cell=tableView.dequeueReusableCell(withIdentifier: "trener", for: indexPath) as! TrenerCell
                cell.delegate=self
                cell.index=index
                cell.message=message_sostav
                return cell
            case 2:
                if isDetail{
                    self.header_view.frame.origin.y=150
                    let cell=tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! SostavDetailCell
                    cell.delegate=self
                    cell.index=index
                    cell.isFirstLoad=isFirstLoad
                    cell.message=sostav_detail
                    return cell
                }else{
                    let cell=tableView.dequeueReusableCell(withIdentifier: "sostav", for: indexPath) as! SostavCell
                    cell.delegate=self
                    cell.index=index
                    cell.message=message_sostav
                    return cell
                }
            default:
                let cell=tableView.dequeueReusableCell(withIdentifier: "admin", for: indexPath) as! AdminCell
                cell.delegate=self
                cell.index=index
                cell.message=message_sostav
                return cell
            }
            
        default:
            let cell=tableView.dequeueReusableCell(withIdentifier: "istoria", for: indexPath) as! IstoriaCell
            cell.delegate=self
            cell.index=index
            cell.message=self.message
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.clear
        btn1.isSelected=true
        btn2.isSelected=false
        btn3.isSelected=false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier=="showDetail"{
            let dc=segue.destination as! HistoryDetailViewController
            dc.message=detail_mess
        }
    }
}

class CustomGesture: UIGestureRecognizer {
    var json=JSON.null
}
class IstoriaCell: UITableViewCell {
    
    var index=0
    var delegate:IndicatorDelegate?
    var message:JSON?{
        didSet{
            setup()
        }
    }
    override func awakeFromNib() {
        isUserInteractionEnabled=true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeLeft)
    }
    var lbl:UILabel={
        let l=UILabel()
        l.numberOfLines=0
        l.font=UIFont(name: "Century Gothic", size: 12)
        l.textColor=UIColor.darkGray
        l.translatesAutoresizingMaskIntoConstraints=false
        return l
    }()
    func tap(sender:UIButton){
        if let history=message?["history"].array{
            let m=history[sender.tag]
            delegate?.show(json: m)
        }
    }
    func setup(){
        if message != nil{
            addSubview(lbl)
            lbl.anchorWithConstantsToTop(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 10)
            if let about=message?["about"].string{
                lbl.text=about
            }
            if let history=message?["history"].array{
                if history.count>0{
                    var top=lbl.bottomAnchor
                    for i in 0...history.count-1{
                        let preview:UIImageView={
                            let img=UIImageView()
                            img.tag=i
                            img.contentMode = .scaleAspectFill
                            img.heightAnchor.constraint(equalToConstant: 200).isActive=true
                            img.clipsToBounds=true
                            img.isUserInteractionEnabled=true
                            img.translatesAutoresizingMaskIntoConstraints=false
                            return img
                        }()
                        let filtre=UIImageView(image: #imageLiteral(resourceName: "filtre"))
                        let title:UILabel={
                            let l=UILabel()
                            l.numberOfLines=0
                            l.font=UIFont.boldSystemFont(ofSize: 20)
                            l.textColor=UIColor.white
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let anons:UILabel={
                            let l=UILabel()
                            l.numberOfLines=0
                            l.font=UIFont(name: "Century Gothic", size: 16)
                            l.textColor=UIColor.white
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        
                        addSubview(preview)
                        addSubview(filtre)
                        addSubview(title)
                        addSubview(anons)
                        
                        let gesture_btn:UIButton={
                            let g=UIButton()
                            g.tag=i
                            g.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
                            g.backgroundColor=UIColor.clear
                            g.isUserInteractionEnabled=true
                            g.translatesAutoresizingMaskIntoConstraints=false
                            return g
                        }()
                        addSubview(gesture_btn)
                        gesture_btn.anchorToTop(preview.topAnchor, left: preview.leftAnchor, bottom: preview.bottomAnchor, right: preview.rightAnchor)
                        
                        let m=history[i]
                        if let p=m["preview"].string{
                            preview.kf.indicatorType = .activity
                            preview.kf.setImage(with: URL.init(string: p))
                        }
                        if let t=m["title"].string{
                            title.text=t
                        }
                        if let a=m["anons"].string{
                            anons.text=a
                        }
                        if i < history.count-1{
                            preview.anchorWithConstantsToTop(top, left: lbl.leftAnchor, bottom: nil, right: lbl.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                            filtre.anchorToTop(preview.topAnchor, left: preview.leftAnchor, bottom: preview.bottomAnchor, right: preview.rightAnchor)
                            anons.anchorWithConstantsToTop(nil, left: preview.leftAnchor, bottom: preview.bottomAnchor, right: preview.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 5, rightConstant: 5)
                            title.anchorWithConstantsToTop(nil, left: anons.leftAnchor, bottom: anons.topAnchor, right: anons.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
                            top=preview.bottomAnchor
                        }else{
                            preview.anchorWithConstantsToTop(top, left: lbl.leftAnchor, bottom: self.bottomAnchor, right: lbl.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 10, rightConstant: 0)
                            filtre.anchorToTop(preview.topAnchor, left: preview.leftAnchor, bottom: preview.bottomAnchor, right: preview.rightAnchor)
                            anons.anchorWithConstantsToTop(nil, left: preview.leftAnchor, bottom: preview.bottomAnchor, right: preview.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 5, rightConstant: 5)
                            title.anchorWithConstantsToTop(nil, left: anons.leftAnchor, bottom: anons.topAnchor, right: anons.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
                            top=preview.bottomAnchor
                        }
                    }
                }
            }
        }
        
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if index>0{
                    index-=1
                    delegate?.set(tag: index)
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                if index<2{
                    index+=1
                    delegate?.set(tag: index)
                }
                break
            default:
                break
            }
        }
    }
}

class DostijenieCell: UITableViewCell {
    
    var index=0
    var delegate:IndicatorDelegate?
    var message:JSON?{
        didSet{
            setup()
        }
    }
    override func awakeFromNib() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeLeft)
    }
    func setup(){
        if message != nil{
            if let achievements=message?["achievements"].array{
                if achievements.count>0{
                    var top=self.topAnchor
                    for i in 0...achievements.count/2{
                        let h=(UIScreen.main.bounds.width-25)/2
                        let img_1:UIImageView={
                            let img=UIImageView()
                            img.image=#imageLiteral(resourceName: "filtre")
                            img.widthAnchor.constraint(equalToConstant: h).isActive=true
                            img.heightAnchor.constraint(equalToConstant: h).isActive=true
                            img.contentMode = .scaleAspectFill
                            img.clipsToBounds=true
                            img.translatesAutoresizingMaskIntoConstraints=false
                            return img
                        }()
                        let img_2:UIImageView={
                            let img=UIImageView()
                            img.image=#imageLiteral(resourceName: "suret")
                            img.widthAnchor.constraint(equalToConstant: h).isActive=true
                            img.heightAnchor.constraint(equalToConstant: h).isActive=true
                            img.contentMode = .scaleAspectFill
                            img.clipsToBounds=true
                            img.translatesAutoresizingMaskIntoConstraints=false
                            return img
                        }()
                        let lbl_1:UILabel={
                            let l=UILabel()
                            l.numberOfLines=0
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 12)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.backgroundColor=UIColor(colorLiteralRed: 35/255, green: 36/255, blue: 39/255, alpha: 1)
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let lbl_2:UILabel={
                            let l=UILabel()
                            l.numberOfLines=0
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 12)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.backgroundColor=UIColor(colorLiteralRed: 35/255, green: 36/255, blue: 39/255, alpha: 1)
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        
                        var max_value=0
                        var txt_1=0
                        var txt_2=0
                        let index=i*2
                        
                        
                        
                        if i<achievements.count/2{
                            if let txt=achievements[index]["title"].string{
                                lbl_1.text=String(txt)?.uppercased()
                                txt_1=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            if let txt=achievements[index+1]["title"].string{
                                lbl_2.text=String(txt)?.uppercased()
                                txt_2=Int(lbl_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            max_value=max(txt_1, txt_2)
                            lbl_1.heightAnchor.constraint(equalToConstant: CGFloat(max_value)).isActive=true
                            lbl_2.heightAnchor.constraint(equalToConstant: CGFloat(max_value)).isActive=true
                            
                            if let preview=achievements[index]["preview"].string{
                                img_1.kf.setImage(with: URL.init(string: preview))
                            }
                            if let preview=achievements[index+1]["preview"].string{
                                img_2.kf.setImage(with: URL.init(string: preview))
                            }
                        }else{
                            if achievements.count%2==0{
                                if let txt=achievements[index]["title"].string{
                                    lbl_1.text=String(txt)?.uppercased()
                                    txt_1=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                if let txt=achievements[index+1]["title"].string{
                                    lbl_2.text=String(txt)?.uppercased()
                                    txt_2=Int(lbl_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                max_value=max(txt_1, txt_2)
                                lbl_1.heightAnchor.constraint(equalToConstant: CGFloat(max_value)).isActive=true
                                lbl_2.heightAnchor.constraint(equalToConstant: CGFloat(max_value)).isActive=true
                                
                                if let preview=achievements[index]["preview"].string{
                                    img_1.kf.setImage(with: URL.init(string: preview))
                                }
                                if let preview=achievements[index+1]["preview"].string{
                                    img_2.kf.setImage(with: URL.init(string: preview))
                                }
                            }else{
                                img_2.isHidden=true
                                if let txt=achievements[index]["title"].string{
                                    lbl_1.text=String(txt)?.uppercased()
                                    max_value=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                
                                if let preview=achievements[index]["preview"].string{
                                    img_1.kf.setImage(with: URL.init(string: preview))
                                }
                            }
                        }
                        
                        let row_view:UIView={
                            let v=UIView()
                            v.backgroundColor=UIColor.clear
                            v.heightAnchor.constraint(equalToConstant: h+CGFloat(max_value)).isActive=true
                            v.translatesAutoresizingMaskIntoConstraints=false
                            return v
                        }()
                        
                        row_view.addSubview(img_1)
                        row_view.addSubview(img_2)
                        row_view.addSubview(lbl_1)
                        row_view.addSubview(lbl_2)
                        
                        img_1.anchorWithConstantsToTop(row_view.topAnchor, left: row_view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        img_2.anchorWithConstantsToTop(row_view.topAnchor, left: img_1.rightAnchor, bottom: nil, right: row_view.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0)
                        lbl_1.anchorWithConstantsToTop(img_1.bottomAnchor, left: img_1.leftAnchor, bottom: nil, right: img_1.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        lbl_2.anchorWithConstantsToTop(img_2.bottomAnchor, left: img_2.leftAnchor, bottom: nil, right: img_2.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        
                        addSubview(row_view)
                        if i<achievements.count/2{
                            row_view.anchorWithConstantsToTop(top, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10)
                            top=row_view.bottomAnchor
                        }else{
                            row_view.anchorWithConstantsToTop(top, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10)
                            top=row_view.bottomAnchor
                        }
                        
                    }
                }
            }
        }
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if index>0{
                    index-=1
                    delegate?.set(tag: index)
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                if index<2{
                    index+=1
                    delegate?.set(tag: index)
                }
                break
            default:
                break
            }
        }
    }
}

class AdminCell: UITableViewCell {
    
    var index=0
    var delegate:IndicatorDelegate?
    var message:JSON?{
        didSet{
            addSubview(btn)
            btn.addSubview(bottomLine)
            btn.anchorWithConstantsToTop(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0)
            bottomLine.anchorToTop(top: nil, left: btn.leftAnchor, bottom: btn.bottomAnchor, right: btn.rightAnchor)
            setup()
        }
    }
    override func awakeFromNib() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeLeft)
        
    }
    lazy var btn:UIButton={
        let b=UIButton()
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitle("АДМИНИСТРАЦИЯ", for: .normal)
        b.setImage(UIImage(named: "strelkaa"), for: .normal)
        b.imageView!.transform = CGAffineTransform(rotationAngle: (270.0 * CGFloat(M_PI)) / 180.0)
        b.widthAnchor.constraint(equalToConstant: 150).isActive = true
        b.imageEdgeInsets = UIEdgeInsetsMake(10, 165, 8, 0)
        b.contentEdgeInsets = UIEdgeInsetsMake(0, -31, 2, -30)
        b.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30)
        b.titleLabel?.textAlignment = .left
        b.addTarget(self, action: #selector(chooseTeam(sender:)), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    func chooseTeam(sender:UIButton){
        delegate?.show_alert()
    }
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    func setup(){
        if message != nil{
            if let arr=message?["admins"].array{
                if arr.count>0{
                    var top=btn.bottomAnchor
                    for i in 1...(arr.count)/2{
                        let h=(UIScreen.main.bounds.width-25)/2
                        let img_1:UIImageView={
                            let img=UIImageView()
                            img.image=#imageLiteral(resourceName: "filtre")
                            img.widthAnchor.constraint(equalToConstant: h).isActive=true
                            img.heightAnchor.constraint(equalToConstant: h).isActive=true
                            img.contentMode = .scaleAspectFill
                            img.clipsToBounds=true
                            img.translatesAutoresizingMaskIntoConstraints=false
                            return img
                        }()
                        let img_2:UIImageView={
                            let img=UIImageView()
                            img.image=#imageLiteral(resourceName: "suret")
                            img.widthAnchor.constraint(equalToConstant: h).isActive=true
                            img.heightAnchor.constraint(equalToConstant: h).isActive=true
                            img.contentMode = .scaleAspectFill
                            img.clipsToBounds=true
                            img.translatesAutoresizingMaskIntoConstraints=false
                            return img
                        }()
                        let lbl_1:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 12)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let lbl_2:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 12)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let tit_1:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 8)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let tit_2:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 8)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        
                        var max_value=0
                        var txt_1=0
                        var txt_2=0
                        let index=(i-1)*2
                        
                        if i<arr.count/2{
                            if let txt=arr[index]["name"].string{
                                lbl_1.text=String(txt)?.uppercased()
                                txt_1+=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            if let txt=arr[index+1]["name"].string{
                                lbl_2.text=String(txt)?.uppercased()
                                txt_2+=Int(lbl_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            if let txt=arr[index]["title"].string{
                                tit_1.text=String(txt)?.uppercased()
                                txt_1+=Int(tit_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            if let txt=arr[index+1]["title"].string{
                                tit_2.text=String(txt)?.uppercased()
                                txt_2+=Int(tit_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            max_value=max(txt_1, txt_2)
                            
                            if let preview=arr[index]["thumb"].string{
                                img_1.kf.setImage(with: URL.init(string: preview))
                            }
                            if let preview=arr[index+1]["thumb"].string{
                                img_2.kf.setImage(with: URL.init(string: preview))
                            }
                        }else{
                            if arr.count%2==0{
                                if let txt=arr[index]["name"].string{
                                    lbl_1.text=String(txt)?.uppercased()
                                    txt_1+=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                if let txt=arr[index+1]["name"].string{
                                    lbl_2.text=String(txt)?.uppercased()
                                    txt_2+=Int(lbl_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                if let txt=arr[index]["title"].string{
                                    tit_1.text=String(txt)?.uppercased()
                                    txt_1+=Int(tit_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                if let txt=arr[index+1]["title"].string{
                                    tit_2.text=String(txt)?.uppercased()
                                    txt_2+=Int(tit_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                max_value=max(txt_1, txt_2)
                                
                                if let preview=arr[index]["thumb"].string{
                                    img_1.kf.setImage(with: URL.init(string: preview))
                                }
                                if let preview=arr[index+1]["thumb"].string{
                                    img_2.kf.setImage(with: URL.init(string: preview))
                                }
                            }else{
                                img_2.isHidden=true
                                if let txt=arr[index]["name"].string{
                                    lbl_1.text=String(txt)?.uppercased()
                                }
                                if let txt=arr[index]["title"].string{
                                    tit_1.text=String(txt)?.uppercased()
                                }
                                max_value=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)+Int(tit_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                if let preview=arr[index]["preview"].string{
                                    img_1.kf.setImage(with: URL.init(string: preview))
                                }
                            }
                        }
                        
                        let title_view_1:UIView={
                            let v=UIView()
                            v.backgroundColor=UIColor(colorLiteralRed: 35/255, green: 36/255, blue: 39/255, alpha: 1)
                            v.translatesAutoresizingMaskIntoConstraints=false
                            return v
                        }()
                        let title_view_2:UIView={
                            let v=UIView()
                            v.backgroundColor=UIColor(colorLiteralRed: 35/255, green: 36/255, blue: 39/255, alpha: 1)
                            v.translatesAutoresizingMaskIntoConstraints=false
                            return v
                        }()
                        
                        title_view_1.addSubview(lbl_1)
                        title_view_2.addSubview(lbl_2)
                        title_view_1.addSubview(tit_1)
                        title_view_2.addSubview(tit_2)
                        
                        lbl_1.anchorWithConstantsToTop(title_view_1.topAnchor, left: title_view_1.leftAnchor, bottom: nil, right: title_view_1.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        lbl_2.anchorWithConstantsToTop(title_view_2.topAnchor, left: title_view_2.leftAnchor, bottom: nil, right: title_view_2.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        tit_1.anchorWithConstantsToTop(lbl_1.bottomAnchor, left: title_view_1.leftAnchor, bottom: title_view_1.bottomAnchor, right: title_view_1.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
                        tit_2.anchorWithConstantsToTop(lbl_2.bottomAnchor, left: title_view_2.leftAnchor, bottom: title_view_2.bottomAnchor, right: title_view_2.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
                        
                        let row_view:UIView={
                            let v=UIView()
                            v.backgroundColor=UIColor.clear
                            v.heightAnchor.constraint(equalToConstant: h+CGFloat(max_value+max_value*2/3)).isActive=true
                            v.translatesAutoresizingMaskIntoConstraints=false
                            return v
                        }()
                        
                        row_view.addSubview(img_1)
                        row_view.addSubview(img_2)
                        row_view.addSubview(title_view_1)
                        row_view.addSubview(title_view_2)
                        
                        img_1.anchorWithConstantsToTop(row_view.topAnchor, left: row_view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        img_2.anchorWithConstantsToTop(row_view.topAnchor, left: img_1.rightAnchor, bottom: nil, right: row_view.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0)
                        title_view_1.anchorWithConstantsToTop(img_1.bottomAnchor, left: img_1.leftAnchor, bottom: row_view.bottomAnchor, right: img_1.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
                        title_view_2.anchorWithConstantsToTop(img_2.bottomAnchor, left: img_2.leftAnchor, bottom: row_view.bottomAnchor, right: img_2.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
                        
                        addSubview(row_view)
                        if i<arr.count/2{
                            row_view.anchorWithConstantsToTop(top, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10)
                            top=row_view.bottomAnchor
                        }else{
                            row_view.anchorWithConstantsToTop(top, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10)
                            top=row_view.bottomAnchor
                        }
                        
                    }
                }
            }
        }
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if index>0{
                    index-=1
                    delegate?.set(tag: index)
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                if index<2{
                    index+=1
                    delegate?.set(tag: index)
                }
                break
            default:
                break
            }
        }
    }
}
class TrenerCell: UITableViewCell {
    
    var index=0
    var delegate:IndicatorDelegate?
    var message:JSON?{
        didSet{
            addSubview(btn)
            btn.addSubview(bottomLine)
            btn.anchorWithConstantsToTop(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0)
            bottomLine.anchorToTop(top: nil, left: btn.leftAnchor, bottom: btn.bottomAnchor, right: btn.rightAnchor)
            setup()
        }
    }
    override func awakeFromNib() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeLeft)
        
    }
    lazy var btn:UIButton={
        let b=UIButton()
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitle("ТРЕНЕРЫ", for: .normal)
        b.setImage(UIImage(named: "strelkaa"), for: .normal)
        b.imageView!.transform = CGAffineTransform(rotationAngle: (270.0 * CGFloat(M_PI)) / 180.0)
        b.widthAnchor.constraint(equalToConstant: 150).isActive = true
        b.imageEdgeInsets = UIEdgeInsetsMake(10, 165, 8, 0)
        b.contentEdgeInsets = UIEdgeInsetsMake(0, -31, 2, -30)
        b.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30)
        b.titleLabel?.textAlignment = .left
        b.addTarget(self, action: #selector(chooseTeam(sender:)), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    func chooseTeam(sender:UIButton){
        delegate?.show_alert()
    }
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    func setup(){
        if message != nil{
            if let arr=message?["treners"].array{
                if arr.count>0{
                    var top=btn.bottomAnchor
                    for i in 1...(arr.count)/2{
                        let h=(UIScreen.main.bounds.width-25)/2
                        let img_1:UIImageView={
                            let img=UIImageView()
                            img.image=#imageLiteral(resourceName: "filtre")
                            img.widthAnchor.constraint(equalToConstant: h).isActive=true
                            img.heightAnchor.constraint(equalToConstant: h).isActive=true
                            img.contentMode = .scaleAspectFill
                            img.clipsToBounds=true
                            img.translatesAutoresizingMaskIntoConstraints=false
                            return img
                        }()
                        let img_2:UIImageView={
                            let img=UIImageView()
                            img.image=#imageLiteral(resourceName: "suret")
                            img.widthAnchor.constraint(equalToConstant: h).isActive=true
                            img.heightAnchor.constraint(equalToConstant: h).isActive=true
                            img.contentMode = .scaleAspectFill
                            img.clipsToBounds=true
                            img.translatesAutoresizingMaskIntoConstraints=false
                            return img
                        }()
                        let lbl_1:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 12)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let lbl_2:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 12)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let tit_1:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 8)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let tit_2:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 8)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        
                        var max_value=0
                        var txt_1=0
                        var txt_2=0
                        let index=(i-1)*2
                        
                        if i<arr.count/2{
                            if let txt=arr[index]["name"].string{
                                lbl_1.text=String(txt)?.uppercased()
                                txt_1+=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            if let txt=arr[index+1]["name"].string{
                                lbl_2.text=String(txt)?.uppercased()
                                txt_2+=Int(lbl_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            if let txt=arr[index]["title"].string{
                                tit_1.text=String(txt)?.uppercased()
                                txt_1+=Int(tit_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            if let txt=arr[index+1]["title"].string{
                                tit_2.text=String(txt)?.uppercased()
                                txt_2+=Int(tit_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            max_value=max(txt_1, txt_2)
                            
                            if let preview=arr[index]["thumb"].string{
                                img_1.kf.setImage(with: URL.init(string: preview))
                            }
                            if let preview=arr[index+1]["thumb"].string{
                                img_2.kf.setImage(with: URL.init(string: preview))
                            }
                        }else{
                            if arr.count%2==0{
                                if let txt=arr[index]["name"].string{
                                    lbl_1.text=String(txt)?.uppercased()
                                    txt_1+=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                if let txt=arr[index+1]["name"].string{
                                    lbl_2.text=String(txt)?.uppercased()
                                    txt_2+=Int(lbl_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                if let txt=arr[index]["title"].string{
                                    tit_1.text=String(txt)?.uppercased()
                                    txt_1+=Int(tit_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                if let txt=arr[index+1]["title"].string{
                                    tit_2.text=String(txt)?.uppercased()
                                    txt_2+=Int(tit_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                max_value=max(txt_1, txt_2)
                                
                                if let preview=arr[index]["thumb"].string{
                                    img_1.kf.setImage(with: URL.init(string: preview))
                                }
                                if let preview=arr[index+1]["thumb"].string{
                                    img_2.kf.setImage(with: URL.init(string: preview))
                                }
                            }else{
                                img_2.isHidden=true
                                if let txt=arr[index]["name"].string{
                                    lbl_1.text=String(txt)?.uppercased()
                                }
                                if let txt=arr[index]["title"].string{
                                    tit_1.text=String(txt)?.uppercased()
                                }
                                max_value=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)+Int(tit_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                if let preview=arr[index]["preview"].string{
                                    img_1.kf.setImage(with: URL.init(string: preview))
                                }
                            }
                        }
                        
                        let title_view_1:UIView={
                            let v=UIView()
                            v.backgroundColor=UIColor(colorLiteralRed: 35/255, green: 36/255, blue: 39/255, alpha: 1)
                            v.translatesAutoresizingMaskIntoConstraints=false
                            return v
                        }()
                        let title_view_2:UIView={
                            let v=UIView()
                            v.backgroundColor=UIColor(colorLiteralRed: 35/255, green: 36/255, blue: 39/255, alpha: 1)
                            v.translatesAutoresizingMaskIntoConstraints=false
                            return v
                        }()
                        
                        title_view_1.addSubview(lbl_1)
                        title_view_2.addSubview(lbl_2)
                        title_view_1.addSubview(tit_1)
                        title_view_2.addSubview(tit_2)
                        
                        lbl_1.anchorWithConstantsToTop(title_view_1.topAnchor, left: title_view_1.leftAnchor, bottom: nil, right: title_view_1.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        lbl_2.anchorWithConstantsToTop(title_view_2.topAnchor, left: title_view_2.leftAnchor, bottom: nil, right: title_view_2.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        tit_1.anchorWithConstantsToTop(lbl_1.bottomAnchor, left: title_view_1.leftAnchor, bottom: nil, right: title_view_1.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        tit_2.anchorWithConstantsToTop(lbl_2.bottomAnchor, left: title_view_2.leftAnchor, bottom: nil, right: title_view_2.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        
                        let row_view:UIView={
                            let v=UIView()
                            v.backgroundColor=UIColor.clear
                            v.heightAnchor.constraint(equalToConstant: h+CGFloat(max_value+max_value*2/3)).isActive=true
                            v.translatesAutoresizingMaskIntoConstraints=false
                            return v
                        }()
                        
                        row_view.addSubview(img_1)
                        row_view.addSubview(img_2)
                        row_view.addSubview(title_view_1)
                        row_view.addSubview(title_view_2)
                        
                        img_1.anchorWithConstantsToTop(row_view.topAnchor, left: row_view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        img_2.anchorWithConstantsToTop(row_view.topAnchor, left: img_1.rightAnchor, bottom: nil, right: row_view.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0)
                        title_view_1.anchorWithConstantsToTop(img_1.bottomAnchor, left: img_1.leftAnchor, bottom: row_view.bottomAnchor, right: img_1.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
                        title_view_2.anchorWithConstantsToTop(img_2.bottomAnchor, left: img_2.leftAnchor, bottom: row_view.bottomAnchor, right: img_2.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
                        
                        addSubview(row_view)
                        if i<arr.count/2{
                            row_view.anchorWithConstantsToTop(top, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10)
                            top=row_view.bottomAnchor
                        }else{
                            row_view.anchorWithConstantsToTop(top, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10)
                            top=row_view.bottomAnchor
                        }
                        
                    }
                }
            }
        }
    }
   
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if index>0{
                    index-=1
                    delegate?.set(tag: index)
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                if index<2{
                    index+=1
                    delegate?.set(tag: index)
                }
                break
            default:
                break
            }
        }
    }
}
class SostavCell: UITableViewCell {
    
    var index=0
    var delegate:IndicatorDelegate?
    var message:JSON?{
        didSet{
            addSubview(btn)
            btn.addSubview(bottomLine)
            btn.anchorWithConstantsToTop(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0)
            bottomLine.anchorToTop(top: nil, left: btn.leftAnchor, bottom: btn.bottomAnchor, right: btn.rightAnchor)
            setup()
        }
    }
    override func awakeFromNib() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeLeft)
        
    }
    lazy var btn:UIButton={
        let b=UIButton()
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitle("ИГРОКИ", for: .normal)
        b.setImage(UIImage(named: "strelkaa"), for: .normal)
        b.imageView!.transform = CGAffineTransform(rotationAngle: (270.0 * CGFloat(M_PI)) / 180.0)
        b.widthAnchor.constraint(equalToConstant: 150).isActive = true
        b.imageEdgeInsets = UIEdgeInsetsMake(10, 165, 8, 0)
        b.contentEdgeInsets = UIEdgeInsetsMake(0, -31, 2, -30)
        b.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30)
        b.titleLabel?.textAlignment = .left
        b.addTarget(self, action: #selector(chooseTeam(sender:)), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    func chooseTeam(sender:UIButton){
        delegate?.show_alert()
    }
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    func tap(sender:UIButton){
        delegate?.show_detail(id: sender.tag)
    }
    func setup(){
        if message != nil{
            if let arr=message?["team"].array{
                if arr.count>0{
                    var top=btn.bottomAnchor
                    for i in 1...(arr.count)/2{
                        let h=(UIScreen.main.bounds.width-25)/2
                        let img_1:UIImageView={
                            let img=UIImageView()
                            img.widthAnchor.constraint(equalToConstant: h).isActive=true
                            img.heightAnchor.constraint(equalToConstant: h*2).isActive=true
                            img.contentMode = .scaleAspectFill
                            img.clipsToBounds=true
                            img.backgroundColor=UIColor(colorLiteralRed: 200/255, green: 27/255, blue: 34/255, alpha: 1)
                            img.translatesAutoresizingMaskIntoConstraints=false
                            return img
                        }()
                        let img_2:UIImageView={
                            let img=UIImageView()
                            img.widthAnchor.constraint(equalToConstant: h).isActive=true
                            img.heightAnchor.constraint(equalToConstant: h*2).isActive=true
                            img.contentMode = .scaleAspectFill
                            img.clipsToBounds=true
                            img.backgroundColor=UIColor(colorLiteralRed: 200/255, green: 27/255, blue: 34/255, alpha: 1)
                            img.translatesAutoresizingMaskIntoConstraints=false
                            return img
                        }()
                        let lbl_1:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 12)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let lbl_2:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 12)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let tit_1:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 8)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        let tit_2:CustomLabel={
                            let l=CustomLabel()
                            l.numberOfLines=3
                            l.lineBreakMode = .byWordWrapping
                            l.font=UIFont(name: "Century Gothic", size: 8)
                            l.textColor=UIColor.white
                            l.textAlignment = .center
                            l.translatesAutoresizingMaskIntoConstraints=false
                            return l
                        }()
                        
                        let gesture_btn_1:UIButton={
                            let g=UIButton()
                            g.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
                            g.backgroundColor=UIColor.clear
                            g.isUserInteractionEnabled=true
                            g.translatesAutoresizingMaskIntoConstraints=false
                            return g
                        }()
                        let gesture_btn_2:UIButton={
                            let g=UIButton()
                            g.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
                            g.backgroundColor=UIColor.clear
                            g.isUserInteractionEnabled=true
                            g.translatesAutoresizingMaskIntoConstraints=false
                            return g
                        }()
                        
                        var max_value=0
                        var txt_1=0
                        var txt_2=0
                        let index=(i-1)*2
                        
                        if i<arr.count/2{
                            if let txt=arr[index]["name"].string{
                                lbl_1.text=String(txt)?.uppercased()
                                txt_1+=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            if let txt=arr[index+1]["name"].string{
                                lbl_2.text=String(txt)?.uppercased()
                                txt_2+=Int(lbl_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            if let txt=arr[index]["title"].string{
                                tit_1.text=String(txt)?.uppercased()
                                txt_1+=Int(tit_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            if let txt=arr[index+1]["title"].string{
                                tit_2.text=String(txt)?.uppercased()
                                txt_2+=Int(tit_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                            }
                            max_value=max(txt_1, txt_2)
                            
                            if let preview=arr[index]["thumb"].string{
                                img_1.kf.setImage(with: URL.init(string: preview))
                                img_1.isHidden=false
                            }
                            if let preview=arr[index+1]["thumb"].string{
                                img_2.kf.setImage(with: URL.init(string: preview))
                                img_2.isHidden=false
                            }
                            if let id=arr[index]["id"].string{
                                gesture_btn_1.tag=Int(id)!
                            }
                            if let id=arr[index+1]["id"].string{
                                gesture_btn_2.tag=Int(id)!
                            }
                        }else{
                            if arr.count%2==0{
                                if let txt=arr[index]["name"].string{
                                    lbl_1.text=String(txt)?.uppercased()
                                    txt_1+=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                if let txt=arr[index+1]["name"].string{
                                    lbl_2.text=String(txt)?.uppercased()
                                    txt_2+=Int(lbl_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                if let txt=arr[index]["title"].string{
                                    tit_1.text=String(txt)?.uppercased()
                                    txt_1+=Int(tit_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                if let txt=arr[index+1]["title"].string{
                                    tit_2.text=String(txt)?.uppercased()
                                    txt_2+=Int(tit_2.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                }
                                max_value=max(txt_1, txt_2)
                                
                                if let preview=arr[index]["thumb"].string{
                                    img_1.kf.setImage(with: URL.init(string: preview))
                                    img_1.isHidden=false
                                }
                                if let preview=arr[index+1]["thumb"].string{
                                    img_2.kf.setImage(with: URL.init(string: preview))
                                    img_2.isHidden=false
                                }
                                if let id=arr[index]["id"].string{
                                    gesture_btn_1.tag=Int(id)!
                                }
                                if let id=arr[index+1]["id"].string{
                                    gesture_btn_2.tag=Int(id)!
                                }
                            }else{
                                img_2.isHidden=true
                                gesture_btn_2.isHidden=true
                                if let txt=arr[index]["name"].string{
                                    lbl_1.text=String(txt)?.uppercased()
                                }
                                if let txt=arr[index]["title"].string{
                                    tit_1.text=String(txt)?.uppercased()
                                }
                                max_value=Int(lbl_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)+Int(tit_1.sizeThatFits(CGSize(width: h, height: CGFloat.greatestFiniteMagnitude)).height)
                                if let preview=arr[index]["thumb"].string{
                                    img_1.kf.setImage(with: URL.init(string: preview))
                                    img_1.isHidden=false
                                }
                                if let id=arr[index]["id"].string{
                                    gesture_btn_1.tag=Int(id)!
                                }
                            }
                        }
                        
                        let title_view_1:UIView={
                            let v=UIView()
                            v.backgroundColor=UIColor(colorLiteralRed: 35/255, green: 36/255, blue: 39/255, alpha: 1)
                            v.translatesAutoresizingMaskIntoConstraints=false
                            return v
                        }()
                        let title_view_2:UIView={
                            let v=UIView()
                            v.backgroundColor=UIColor(colorLiteralRed: 35/255, green: 36/255, blue: 39/255, alpha: 1)
                            v.translatesAutoresizingMaskIntoConstraints=false
                            return v
                        }()
                        
                        title_view_1.addSubview(lbl_1)
                        title_view_2.addSubview(lbl_2)
                        title_view_1.addSubview(tit_1)
                        title_view_2.addSubview(tit_2)
                        
                        lbl_1.anchorWithConstantsToTop(title_view_1.topAnchor, left: title_view_1.leftAnchor, bottom: nil, right: title_view_1.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        lbl_2.anchorWithConstantsToTop(title_view_2.topAnchor, left: title_view_2.leftAnchor, bottom: nil, right: title_view_2.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        tit_1.anchorWithConstantsToTop(lbl_1.bottomAnchor, left: title_view_1.leftAnchor, bottom: nil, right: title_view_1.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        tit_2.anchorWithConstantsToTop(lbl_2.bottomAnchor, left: title_view_2.leftAnchor, bottom: nil, right: title_view_2.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        
                        let row_view:UIView={
                            let v=UIView()
                            v.backgroundColor=UIColor.clear
                            v.heightAnchor.constraint(equalToConstant: h*2+CGFloat(max_value+max_value*2/3)).isActive=true
                            v.translatesAutoresizingMaskIntoConstraints=false
                            return v
                        }()
                        
                        row_view.addSubview(img_1)
                        row_view.addSubview(img_2)
                        row_view.addSubview(title_view_1)
                        row_view.addSubview(title_view_2)
                        
                        row_view.addSubview(gesture_btn_1)
                        gesture_btn_1.anchorToTop(img_1.topAnchor, left: img_1.leftAnchor, bottom: img_1.bottomAnchor, right: img_1.rightAnchor)
                        row_view.addSubview(gesture_btn_2)
                        gesture_btn_2.anchorToTop(img_2.topAnchor, left: img_2.leftAnchor, bottom: img_2.bottomAnchor, right: img_2.rightAnchor)
                        
                        img_1.anchorWithConstantsToTop(row_view.topAnchor, left: row_view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
                        img_2.anchorWithConstantsToTop(row_view.topAnchor, left: img_1.rightAnchor, bottom: nil, right: row_view.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0)
                        title_view_1.anchorWithConstantsToTop(img_1.bottomAnchor, left: img_1.leftAnchor, bottom: row_view.bottomAnchor, right: img_1.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
                        title_view_2.anchorWithConstantsToTop(img_2.bottomAnchor, left: img_2.leftAnchor, bottom: row_view.bottomAnchor, right: img_2.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
                        
                        addSubview(row_view)
                        if i<arr.count/2{
                            row_view.anchorWithConstantsToTop(top, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10)
                            top=row_view.bottomAnchor
                        }else{
                            row_view.anchorWithConstantsToTop(top, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10)
                            top=row_view.bottomAnchor
                        }
                        
                    }
                }
            }
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if index>0{
                    index-=1
                    delegate?.set(tag: index)
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                if index<2{
                    index+=1
                    delegate?.set(tag: index)
                }
                break
            default:
                break
            }
        }
    }
}
class SostavDetailCell: UITableViewCell,UIWebViewDelegate {
    
    var isFirstLoad=true
    var index=0
    var delegate:IndicatorDelegate?
    var message:JSON?{
        didSet{
            if isFirstLoad{
                web.removeFromSuperview()
                addSubview(btn)
                btn.anchorWithConstantsToTop(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0)
                setup()
            }
        }
    }
    override func awakeFromNib() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeLeft)
        
    }
    lazy var btn:UIButton={
        let b=UIButton()
        b.titleLabel?.font=UIFont(name: "Century Gothic - Bold", size: 20)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitle("ИГРОК", for: .normal)
        b.setImage(UIImage(named: "strelkaa"), for: .normal)
        b.widthAnchor.constraint(equalToConstant: 150).isActive = true
        b.heightAnchor.constraint(equalToConstant: 45).isActive=true
        b.imageEdgeInsets = UIEdgeInsetsMake(10, -75, 10, 10)
        b.contentEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 0)
        b.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0)
        b.titleLabel?.textAlignment = .left
        b.backgroundColor = .clear
        b.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    let h=UIScreen.main.bounds.width-20
    lazy var info_view:UIView={
        let v=UIView()
        v.backgroundColor=UIColor(colorLiteralRed: 96/255, green: 15/255, blue: 18/255, alpha: 1)
        //v.heightAnchor.constraint(equalToConstant: self.h).isActive=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    var infoHeght:NSLayoutConstraint?
    lazy var web:UIWebView={
        let w=UIWebView()
        w.backgroundColor=UIColor.white
        w.delegate=self
        w.scrollView.isScrollEnabled=false
        w.translatesAutoresizingMaskIntoConstraints=false
        return w
    }()
    var webHeght:NSLayoutConstraint?
    func back(sender:UIButton){
        delegate?.back()
    }
    func tap(sender:UIButton){
        delegate?.show_detail(id: sender.tag)
    }
    func setup(){
        if message != nil{
            let info:UILabel={
                let l=UILabel()
                l.numberOfLines=0
                l.widthAnchor.constraint(equalToConstant: h/2).isActive=true
                l.translatesAutoresizingMaskIntoConstraints=false
                return l
            }()
            
            var playerName=""
            var position = ""
            var height = ""
            var weight = ""
            var mainleg = ""
            var birthyear = ""
            var contract = ""
            
            if let n=message?["name"].string{
                playerName=String(n).uppercased()
            }
            if let t=message?["title"].string{
                position=String(t).uppercased()
            }
            if let h=message?["height"].string{
                height=String(h).uppercased()
            }
            if let w=message?["weight"].string{
                weight=String(w).uppercased()
            }
            if let m=message?["mainleg"].string{
                if m=="right"{
                    mainleg=String("ПРАВША")
                }else{
                    mainleg=String("ЛЕВША")
                }
            }
            if var b=message?["birthday"].string{
                if b.characters.count > 0 {
                    let index = b.index(b.startIndex, offsetBy: 4)
                    b = b.substring(to: index)
                }
                birthyear=String(b).uppercased()
            }
            if let c=message?["contract"].string{
                contract=String(c).uppercased()
            }

            let attributedText = NSMutableAttributedString(string: "\(playerName)\n\n", attributes: [NSFontAttributeName: UIFont(name: "Century Gothic", size: 18)!, NSForegroundColorAttributeName: UIColor.white])
            attributedText.append(NSAttributedString(string: "Позиция\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.lightGray]))
            attributedText.append(NSAttributedString(string: "\(position)\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.white]))
            attributedText.append(NSAttributedString(string: "Рост\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.lightGray]))
            attributedText.append(NSAttributedString(string: "\(height)\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.white]))
            attributedText.append(NSAttributedString(string: "Вес\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.lightGray]))
            attributedText.append(NSAttributedString(string: "\(weight)\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.white]))
            attributedText.append(NSAttributedString(string: "Основная нога\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.lightGray]))
            attributedText.append(NSAttributedString(string: "\(mainleg)\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.white]))
            attributedText.append(NSAttributedString(string: "Год рождения\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.lightGray]))
            attributedText.append(NSAttributedString(string: "\(birthyear) Г\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.white]))
            attributedText.append(NSAttributedString(string: "Контракт\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.lightGray]))
            attributedText.append(NSAttributedString(string: "\(contract) Г", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.white]))
            
            info.attributedText=attributedText
            
            info_view.addSubview(info)
            info.anchorWithConstantsToTop(top: info_view.topAnchor, left: info_view.leftAnchor, bottom: info_view.bottomAnchor, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 5, rightConstant: 0)
            addSubview(info_view)
            addSubview(web)
            info_view.anchorWithConstantsToTop(btn.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10)
            web.anchorWithConstantsToTop(info_view.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 10, rightConstant: 10)
            if let body=message?["body"].string{
                web.loadHTMLString(body, baseURL: nil)
            }
            if let thumb=message?["thumb"].string{
                let img:UIImageView={
                    let i=UIImageView()
                    i.kf.indicatorType = .activity
                    i.kf.setImage(with: URL.init(string: thumb))
                    i.contentMode = .scaleAspectFill
                    i.clipsToBounds = true
                    i.widthAnchor.constraint(equalToConstant: h/2).isActive=true
                    i.heightAnchor.constraint(equalToConstant: h).isActive=true
                    i.translatesAutoresizingMaskIntoConstraints=false
                    return i
                }()
                self.addSubview(img)
                img.anchorWithConstantsToTop(nil, left: nil, bottom: info_view.bottomAnchor, right: info_view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -(h*1/15), rightConstant: 0)
            }
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        webHeght=NSLayoutConstraint(item: web, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: webView.scrollView.contentSize.height)
        self.addConstraint(webHeght!)
        delegate?.reload()
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if index>0{
                    index-=1
                    delegate?.set(tag: index)
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                if index<2{
                    index+=1
                    delegate?.set(tag: index)
                }
                break
            default:
                break
            }
        }
    }
}
