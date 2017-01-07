//
//  MatchDetailViewController.swift
//  kairat
//
//  Created by Beka on 1/4/17.
//  Copyright © 2017 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import INSPhotoGallery

protocol MatchDetailDelegate {
    func set(tag:Int)
}
class MatchDetailViewController: UIViewController,MatchDetailDelegate {
    
    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var header: UIView!
    
    var message=JSON.null
    var textReview = JSON.null
    var teamList = JSON.null
    var mediaList = JSON.null
    let matchMenuSectionCellId = "matchMenuSectionCellId"
    var match_id=""
    var selected_index=0
    
    let formatter = DateFormatter()
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
        self.title="МАТЧ"
        navigationController?.setBG()
        table.backgroundColor=UIColor.clear
        table.estimatedRowHeight=100
        table.rowHeight=UITableViewAutomaticDimension
        table.register(MatchMenuSectionCell.self, forCellReuseIdentifier: matchMenuSectionCellId)
        
        btn1.isSelected=true
        btn2.isSelected=true
        btn3.isSelected=true
        btn4.isSelected=true
        setup()
        formatter.dateFormat = "yyyy.MM.dd"
        loadData(id:match_id)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(id:String){
        CustomRequests.getGames(view: self,loading: loadingView,id: id){
            response in
            if response != nil{
                self.message=response
                if let dtime=self.message["dtime"].string{
                    let date=Date(timeIntervalSince1970: TimeInterval.init(dtime)!)
                    let dateFormat=DateFormatter()
                    dateFormat.locale=Locale(identifier: "ru")
                    dateFormat.dateFormat="d MMMM,HH:mm"
                    self.data.text=dateFormat.string(from: date)
                }
                if let score=self.message["info"]["score"].string{
                    self.score.text=String(score)?.replacingOccurrences(of: "-", with: ":")
                }
                if let name=self.message["home"]["name"].string{
                    self.name1.text=name
                }
                if let logo=self.message["home"]["logo"].string{
                    self.img1.kf.indicatorType = .activity
                    UIImageView().kf.setImage(with: URL.init(string: logo),completionHandler: {
                        (image, error, cacheType, imageUrl) in
                        if image != nil{
                            self.img1.image=image?.imageByCroppingImage(size: CGSize(width: 140, height: 140))
                        }
                    })
                }
                if let name=self.message["guest"]["name"].string{
                    self.name2.text=name
                }
                if let logo=self.message["guest"]["logo"].string{
                    self.img2.kf.indicatorType = .activity
                    UIImageView().kf.setImage(with: URL.init(string: logo),completionHandler: {
                        (image, error, cacheType, imageUrl) in
                        if image != nil{
                            self.img2.image=image?.imageByCroppingImage(size: CGSize(width: 140, height: 140))
                        }
                    })
                }
                
                let url = "http://api.kairat.com/game/\(id)/text"
                Models.fetchJSON(URL: url, completionHandler: { (json) -> () in
                    self.textReview = json
                    let url = "http://api.kairat.com/game/\(id)/list"
                    Models.fetchJSON(URL: url, completionHandler: { (json) -> () in
                        self.teamList = json
                        let url = "http://api.kairat.com/game/\(id)/media"
                        Models.fetchJSON(URL: url, completionHandler: { (json) -> () in
                            self.mediaList = json
                            self.table.reloadData()
                        })
                    })
                })
            }
        }
    }
    
    var btn1:UIButton={
        let b=UIButton()
        b.tag=0
        b.setTitle("ОБЗОР", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor.red, for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var btn2:UIButton={
        let b=UIButton()
        b.tag=1
        b.setTitle("СОСТАВ", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor.red, for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var btn3:UIButton={
        let b=UIButton()
        b.tag=2
        b.setTitle("МЕДИА", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor.red, for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var btn4:UIButton={
        let b=UIButton()
        b.tag=3
        b.setTitle("ЧАТ", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor.red, for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var indicator:UIView={
        let v=UIView()
        v.backgroundColor=UIColor.red
        v.heightAnchor.constraint(equalToConstant: 4).isActive=true
        v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4).isActive=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    func setup(){
        top.constant=0-150
        fon.image=#imageLiteral(resourceName: "fon").imageByCroppingImage(size: CGSize(width: 1200, height: 1200))
        img1.layer.cornerRadius=35
        img2.layer.cornerRadius=35
        view.addSubview(loadingView)
        loadingViewHeght=NSLayoutConstraint(item: loadingView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)
        loadingView.addConstraint(loadingViewHeght!)
        loadingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        btn1.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        btn3.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        btn4.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        
        btn1.isSelected=true
        btn2.isSelected=false
        btn3.isSelected=false
        btn4.isSelected=false
        
        header.addSubview(btn1)
        header.addSubview(btn2)
        header.addSubview(btn3)
        header.addSubview(btn4)
        header.addSubview(indicator)
        
        indicator.anchorWithConstantsToTop(nil, left: header.leftAnchor, bottom: header.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        btn1.anchorWithConstantsToTop(nil, left: header.leftAnchor, bottom: indicator.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
        btn2.anchorWithConstantsToTop(nil, left: btn1.rightAnchor, bottom: indicator.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
        btn3.anchorWithConstantsToTop(nil, left: btn2.rightAnchor, bottom: indicator.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
        btn4.anchorWithConstantsToTop(nil, left: btn3.rightAnchor, bottom: indicator.topAnchor, right: header.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.table.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.table.addGestureRecognizer(swipeLeft)
        
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if selected_index>0{
                    selected_index-=1
                    setXPosition(tag: selected_index)
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                if selected_index<3{
                    selected_index+=1
                    setXPosition(tag: selected_index)
                }
                break
            default:
                break
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y=scrollView.contentOffset.y
        if y>150{
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.navigationController?.setBG2()
                self.header.backgroundColor=UIColor.black
            }, completion: nil)
            self.header.frame.origin.y=y
        }else{
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.navigationController?.setBG()
                self.header.backgroundColor=UIColor.clear
            }, completion: nil)
            let top=150+y
            self.top.constant=0-top
        }
    }
    internal func set(tag: Int) {
        selected_index=tag
        setXPosition(tag: tag)
    }
    func setSelected(sender:UIButton){
        selected_index=sender.tag
        setXPosition(tag: sender.tag)
    }
    func setXPosition(tag:Int){
        switch tag {
        case 0:
            btn1.isSelected=true
            btn2.isSelected=false
            btn3.isSelected=false
            btn4.isSelected=false
            indicator.frame.origin.x=0
            table.reloadData()
            break
        case 1:
            btn1.isSelected=false
            btn2.isSelected=true
            btn3.isSelected=false
            btn4.isSelected=false
            indicator.frame.origin.x=UIScreen.main.bounds.width*1/4
            table.reloadData()
            break
        case 2:
            btn1.isSelected=false
            btn2.isSelected=false
            btn3.isSelected=true
            btn4.isSelected=false
            indicator.frame.origin.x=UIScreen.main.bounds.width*2/4
            table.reloadData()
            break
        case 3:
            btn1.isSelected=false
            btn2.isSelected=false
            btn3.isSelected=false
            btn4.isSelected=true
            indicator.frame.origin.x=UIScreen.main.bounds.width*3/4
            table.reloadData()
            break
        default:
            break
        }
    }
}
extension MatchDetailViewController:UITableViewDataSource{
    
    func setupTopBottomLine() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }

    func getAttributedText(image: String, string: String, type: Bool, isCard: Bool) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: image)
        
        if isCard {
            attachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 18)
        }
        else {
            attachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        }
        
        
        if type {
            let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(string)  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10)]))
            attributedText.append(NSAttributedString(attachment: attachment))
            
            return attributedText
        }
        else {
            let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            attributedText.append(NSAttributedString(string: "  \(string)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10)]))
            
            return attributedText
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selected_index {
        case 0:
            if textReview != nil{
                return (textReview.array?.count)!
            }
            return 0
        case 1:
            return teamList["in"]["guest"].count+teamList["in"]["home"].count+2
        case 2:
            return mediaList["photos"].count + mediaList["videos"].count
        case 3:
            return 1
        default:
            break
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = indexPath.row
        let index = textReview.count - row - 1
        
        switch selected_index {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: matchMenuSectionCellId, for: indexPath) as! MatchMenuSectionCell
            
            cell.selectionStyle = .none
            cell.setupReviewSectionViews()
            cell.backgroundColor = .clear
            
            let team: String = textReview[index][1].string!
            let type: String = textReview[index][2].string!
            let player: String = textReview[index][3].string!
            
            if team == "0" && (type == "I" || type == "FN") {
                let comment: String = textReview[index][5].string!
                
                let middleAttributedText = getAttributedText(image: "svist", string: comment, type: false, isCard: false)
                
                let bottomLine = setupTopBottomLine()
                
                cell.middleLabel.addSubview(bottomLine)
                bottomLine.anchorToTop(top: nil, left: cell.middleLabel.leftAnchor, bottom: cell.middleLabel.bottomAnchor, right: cell.middleLabel.rightAnchor)
                
                if comment == "Перерыв." {
                    let topLine = setupTopBottomLine()
                    
                    cell.middleLabel.addSubview(topLine)
                    topLine.anchorToTop(top: cell.middleLabel.topAnchor, left: cell.middleLabel.leftAnchor, bottom: nil, right: cell.middleLabel.rightAnchor)
                }
                
                cell.middleLabel.attributedText = middleAttributedText
                
                cell.middleTimeLabel.text = ""
                cell.middleTimeLabel.layer.borderWidth = 0
                
                cell.firstTeamLabel.text = ""
                cell.secondTeamLabel.text = ""
            }
            else {
                let time: String = textReview[index][0].string!
                
                cell.middleTimeLabel.text = "\(time)'"
                
                cell.middleLabel.text = ""
                
                switch type {
                case "GL":
                    switch team {
                    case "1":
                        let firstAttributedText = getAttributedText(image: "ball", string: player, type: true, isCard: false)
                        cell.firstTeamLabel.attributedText = firstAttributedText
                        break
                    case "2":
                        let secondAttributedText = getAttributedText(image: "ball", string: player, type: false, isCard: false)
                        cell.secondTeamLabel.attributedText = secondAttributedText
                        break
                    default:
                        break
                    }
                    break
                case "YC":
                    switch team {
                    case "1":
                        let firstAttributedText = getAttributedText(image: "yc", string: player, type: true, isCard: true)
                        cell.firstTeamLabel.attributedText = firstAttributedText
                        break
                    case "2":
                        let secondAttributedText = getAttributedText(image: "yc", string: player, type: false, isCard: true)
                        cell.secondTeamLabel.attributedText = secondAttributedText
                        break
                    default:
                        break
                    }
                case "SW":
                    let player2: String = textReview[index][4].string!
                    
                    switch team {
                    case "1":
                        let firstAttributedText = getAttributedText(image: "zamena", string: "\(player)\n\(player2)", type: true, isCard: false)
                        cell.firstTeamLabel.attributedText = firstAttributedText
                        break
                    case "2":
                        let secondAttributedText = getAttributedText(image: "zamena", string: "\(player)\n\(player2)", type: false, isCard: false)
                        cell.secondTeamLabel.attributedText = secondAttributedText
                        break
                    default:
                        break
                    }
                    break
                default:
                    break
                }
                
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: matchMenuSectionCellId, for: indexPath) as! MatchMenuSectionCell
            
            cell.selectionStyle = .none
            
            let guestIndex = teamList["in"]["home"].count+1
            
            if row == 0 || row == guestIndex {
                
                cell.setupTeamSectionViews(isFirstCell: true)
                
                
                let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "СОСТАВ КОМАНДЫ: ", attributes: [NSForegroundColorAttributeName: UIColor.darkGray]))
                
                if row == 0 {
                    attributedText.append(NSAttributedString(string: message["home"]["name"].stringValue, attributes: [NSForegroundColorAttributeName: UIColor.white]))
                }
                else {
                    attributedText.append(NSAttributedString(string: message["guest"]["name"].stringValue, attributes: [NSForegroundColorAttributeName: UIColor.white]))
                }
                
                cell.titleLabel.attributedText = attributedText
                
                
            }
            else {
                
                cell.setupTeamSectionViews(isFirstCell: false)
                
                var playerName = ""
                var aboutPlayer = ""
                
                if row >= 0 && row < guestIndex {
                    playerName = teamList["in"]["home"][row-1][1].string! + "\n"
                    aboutPlayer = "20 лет, 191 см, 0 мин, 1 гол, 0 гп"
                }
                else {
                    playerName = teamList["in"]["guest"][row-guestIndex-1][1].string! + "\n"
                    aboutPlayer = "20 лет, 191 см, 0 мин, 1 гол, 0 гп"
                }
                
                let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: playerName, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]))
                attributedText.append(NSAttributedString(string: aboutPlayer, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.lightGray]))
                
                cell.aboutPlayerLabel.attributedText = attributedText
                
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: matchMenuSectionCellId, for: indexPath) as! MatchMenuSectionCell
            cell.selectionStyle = .none
            cell.setupMediaSectionViews()
            
            if row >= 0 && row < mediaList["photos"].count {
                let url = URL(string: mediaList["photos"][row]["thumb"].string!)
                cell.mediaImageView.kf.setImage(with: url)
                cell.playerImageView.isHidden=true
            }
            else {
                let videoIndex = mediaList["photos"].count
                
                let url = URL(string: mediaList["videos"][row - videoIndex]["thumb"].string!)
                cell.mediaImageView.kf.setImage(with: url)
                cell.playerImageView.isHidden=false
            }
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: matchMenuSectionCellId, for: indexPath) as! MatchMenuSectionCell
            
            cell.selectionStyle = .none
            cell.setupChatSectionViews()
            
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
}
extension MatchDetailViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath)
        if selected_index == 2 {
            
            let row = indexPath.row
            let videoIndex = mediaList["photos"].count
            
            if row >= 0 && row < mediaList["photos"].count {
                var photos = [INSPhotoViewable]()
                
                for gallery in mediaList["photos"].arrayValue {
                    let photo = gallery["photo"].stringValue
                    photos.append(INSPhoto(imageURL: URL.init(string: photo), thumbnailImageURL: URL.init(string: photo)))
                }
                
                if (photos.count)>0{
                    let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: photos[0], referenceView: cell)
                    galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
                        if (photos.index(where: {$0 === photo})) != nil {
                            return cell
                        }
                        return nil
                    }
                    if let window = UIApplication.shared.keyWindow {
                        window.rootViewController?.present(galleryPreview, animated: true, completion: nil)
                    }
                }
                
            }
            else  {
                let url = mediaList["videos"][row - videoIndex]["src"].string!
                UIApplication.shared.open(URL.init(string: url)!, options: [:], completionHandler: nil)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch selected_index {
        case 0:
            return 24
        case 1:
            return 0
        case 2:
            return 5
        case 3:
            return 5
        default:
            break
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
