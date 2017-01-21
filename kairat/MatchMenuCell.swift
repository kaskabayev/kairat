//
//  MatchMenuCell.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import INSPhotoGallery

class MatchMenuCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(tableView)
        
        tableView.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        tableView.register(MatchMenuSectionCell.self, forCellReuseIdentifier: matchMenuSectionCellId)
        
    }
    
    let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.addSubview(indicator)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.anchorWithConstantsToTop(view.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        return view
    }()
    
    var page: Int? {
        didSet {
            if let id = page {
                switch id {
                case 0:
                    fetchAboutMatchJSON()
                    break
                case 1:
                    fetchAboutMatchJSON()
                    break
                case 2:
                    fetchAboutMatchJSON()
                    break
                case 3:
                    self.tableView.reloadData()
                    break
                default:
                    break
                }
            }
        }
    }
    
    func fetchAboutMatchJSON() {
        let URL = "http://api.kairat.com/game/\(match["id"].stringValue)/text"
        self.tableView.removeFromSuperview()
        addSubview(loadingView)
        loadingView.anchorToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        Models.fetchJSON(URL: URL, completionHandler: { (json) -> () in
            self.textReview = json
            
            let URL = "http://api.kairat.com/game/9130/list"
            
            Models.fetchJSON(URL: URL, completionHandler: { (json) -> () in
                self.teamList = json
                print(self.teamList["in"]["guest"].count+self.teamList["in"]["home"].count)
                let URL = "http://api.kairat.com/game/\(self.match["id"].stringValue)/media"
                
                Models.fetchJSON(URL: URL, completionHandler: { (json) -> () in
                    self.mediaList = json
                    
                    self.setupViews()
                    self.tableView.reloadData()
                    
                    self.loadingView.removeFromSuperview()
                })
            })
        })
    }
    
    var textReview = JSON.null
    var teamList = JSON.null
    var mediaList = JSON.null
    
    var match = JSON.null
    
    let matchMenuSectionCellId = "matchMenuSectionCellId"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionId = page {
            switch sectionId {
            case 0:
                return textReview.count
            case 1:
                return teamList["in"]["guest"].count+teamList["in"]["home"].count+2
            case 2:
                return mediaList["photos"].count + mediaList["videos"].count
            case 3:
                return 1
            default:
                break
            }
        }
        
        return 0
    }
    
    func setupTopBottomLine() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: matchMenuSectionCellId, for: indexPath) as! MatchMenuSectionCell
        
        cell.selectionStyle = .none
        let row = indexPath.row
        let index = textReview.count - row - 1
        
        if let sectionId = page {
            switch sectionId {
            case 0:
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
                
                break
            case 1:
                
                let guestIndex = teamList["in"]["home"].count+1
                
                if row == 0 || row == guestIndex {
                    
                        cell.setupTeamSectionViews(isFirstCell: true)
                        
                        
                        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "СОСТАВ КОМАНДЫ: ", attributes: [NSForegroundColorAttributeName: UIColor.darkGray]))
                        
                        if row == 0 {
                            attributedText.append(NSAttributedString(string: match["home"]["name"].stringValue, attributes: [NSForegroundColorAttributeName: UIColor.white]))
                        }
                        else {
                            attributedText.append(NSAttributedString(string: match["guest"]["name"].stringValue, attributes: [NSForegroundColorAttributeName: UIColor.white]))
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
                
                break
            case 2:
                cell.setupMediaSectionViews()
                
                if row >= 0 && row < mediaList["photos"].count {
                    let url = URL(string: mediaList["photos"][row]["thumb"].string!)
                    cell.mediaImageView.kf.setImage(with: url)
                }
                else {
                    let videoIndex = mediaList["photos"].count
                    let url = URL(string: mediaList["videos"][row - videoIndex]["thumb"].string!)
                    cell.mediaImageView.kf.setImage(with: url)
                }
                
                break
            case 3:
                cell.setupChatSectionViews()
                break
            default:
                break
            }
        }
        
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sectionId = page, sectionId == 2 {
            
            let row = indexPath.row
            let videoIndex = mediaList["photos"].count
            
            if row >= 0 && row < mediaList["photos"].count {
                var photos = [INSPhotoViewable]()
                
                for gallery in mediaList["photos"].arrayValue {
                    let photo = gallery["photo"].stringValue
                    photos.append(INSPhoto(imageURL: URL.init(string: photo), thumbnailImageURL: URL.init(string: photo)))
                }
                
                if (photos.count)>0{
                    let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: photos[0], referenceView: self)
                    galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
                        if (photos.index(where: {$0 === photo})) != nil {
                            return self
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
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL.init(string: url)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionId = page {
            switch sectionId {
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
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
