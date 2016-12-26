//
//  ClubMenuCell.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class ClubMenuCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var clubHistory = JSON.null
    var json = JSON.null
    var clubTeam = JSON.null
    var aboutPlayer = JSON.null
    
    var item: Int? {
        didSet {
            if let page = item {
                switch page {
                case 0:
                    let URL = "http://api.kairat.com/club"
                    
                    Models.fetchJSON(URL: URL, completionHandler: { (json) -> () in
                            self.clubHistory = json["history"]
                            self.collectionView.removeFromSuperview()
                            self.setupViews()
                    })
                    break
                case 1:
                    self.collectionView.removeFromSuperview()
                    self.setupViews()
                    //self.collectionView.reloadData()
                    break
                case 2:
                    let URL = "http://api.kairat.com/club/team"
                    
                    Models.fetchJSON(URL: URL, completionHandler: { (json) -> () in
                        if json.count > 0 {
                            self.json = json
                            self.clubTeam = json["admins"]
                            self.collectionView.removeFromSuperview()
                            self.setupViews()
                            //self.collectionView.reloadData()
                        }
                    })
                    break
                default:
                    break
                }
                
            }
        }
    }
    
    var teamType = 0
    var isDetailed = false
    var vcDelegate: ViewControllerHelper?

    func setupViews() {
        
        addSubview(collectionView)
        
        collectionView.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        collectionView.register(ClubMenuSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: clubMenuSectionCell)
        collectionView.register(ClubMenuSectionCell.self, forCellWithReuseIdentifier: clubMenuSectionCell)
        
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let clubMenuSectionHeader = "clubMenuSectionCell"
    let clubMenuSectionCell = "clubMenuSectionCell"
    
    let cups = ["k7", "k6", "k5", "k4", "k3", "k2", "k1"]
    let administrations = ["9", "8", "6", "5", "4", "3", "2", "1"]
    
    let cupsTitle = ["КУБОК УЕФА", "СУПЕРКУБОК МИРА", "КУБОК ЕРЕМЕНКО", "КУБОК КАЗАХСТАНА", "ЧЕМПИОН КАЗАХСТАНА", "КУБОК УЕФА", "СУПЕРКУБОК МИРА"]
    let cupsSubTitle = ["2014/2015", "2014", "2014", "12-кратный обладатель", "11-кратный обладатлеь", "2012/2013", "Вице-чемпион 2015"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch item! {
        case 0:
            return clubHistory.count
        case 1:
            return 7
        case 2:
            if isDetailed {
                return 1
            }
            else {
                return clubTeam.count
            }
        default:
            break
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: clubMenuSectionCell, for: indexPath) as! ClubMenuSectionCell
        
        switch item! {
        case 0:
            cell.setupMenuFirstSectionViews()
            
            let historyImage = clubHistory[indexPath.item]["preview"].stringValue
            let historyImageUrl = URL(string: historyImage)
            
            cell.imageView.kf.setImage(with: historyImageUrl)
            
            let historyTitle = clubHistory[indexPath.item]["title"].stringValue
            cell.titleLabel.text = historyTitle
            
            let historyAnons = clubHistory[indexPath.item]["anons"].stringValue
            cell.shortTextView.text = historyAnons
            
            break
        case 1:
            cell.setupMenuSecondThirdSectionViews(isPlayers: false)
            cell.imageView.image = UIImage(named: cups[indexPath.row])
            cell.titleLabel.text = cupsTitle[indexPath.row]
            cell.subTitleLabel.text = cupsSubTitle[indexPath.row]
            break
        case 2:
            if isDetailed {
                cell.setupDetailedViews()
                
                cell.playerName.text = aboutPlayer["name"].stringValue
                
                let imageUrl = URL(string: aboutPlayer["thumb"].stringValue)
                cell.imageView.kf.setImage(with: imageUrl)
                
                let position = aboutPlayer["title"].stringValue
                let height = aboutPlayer["height"].stringValue
                let weight = aboutPlayer["weight"].stringValue
                var mainleg = aboutPlayer["mainleg"].stringValue
                if mainleg == "right" {
                    mainleg = "ПРАВША"
                }
                var birthyear = aboutPlayer["birthday"].stringValue
                if birthyear.characters.count > 0 {
                    let index = birthyear.index(birthyear.startIndex, offsetBy: 4)
                    birthyear = birthyear.substring(to: index)
                    
                }
                
                let contract = aboutPlayer["contract"].stringValue
                
                let attributedText = NSMutableAttributedString(string: "Позиция\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.lightGray])
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
                attributedText.append(NSAttributedString(string: "\(contract) Г\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.white]))
                
                cell.aboutPlayerLabel.attributedText = attributedText
                
                let achivements = aboutPlayer["body"].stringValue
                
                if achivements.characters.count > 0 {
                    cell.playerAchivementLabel.text = achivements
                }
                
            }
            else {
                if teamType == 2 {
                    cell.setupMenuSecondThirdSectionViews(isPlayers: true)
                    
                    let imageUrl = URL(string: clubTeam[indexPath.item]["thumb"].stringValue)
                    cell.playerImageView.kf.setImage(with: imageUrl)
                }
                else {
                    cell.setupMenuSecondThirdSectionViews(isPlayers: false)
                    
                    let imageUrl = URL(string: clubTeam[indexPath.item]["thumb"].stringValue)
                    cell.imageView.kf.setImage(with: imageUrl)
                }
                
                cell.titleLabel.text = clubTeam[indexPath.item]["name"].stringValue
                cell.subTitleLabel.text = clubTeam[indexPath.item]["title"].stringValue
            }
            
            break
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch item! {
        case 0:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: clubMenuSectionHeader, for: indexPath) as! ClubMenuSectionHeader
            cell.setupHistorySectionViews()
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: clubMenuSectionHeader, for: indexPath) as! ClubMenuSectionHeader
            
            if isDetailed {
                cell.setupDetailedViews()
                
                cell.backButton.addTarget(self, action: #selector(ClubMenuCell.backToTeamList), for: .touchUpInside)
            }
            else {
                
                cell.setupTeamSectionViews()
                
                cell.chooseButton.addTarget(self, action: #selector(ClubMenuCell.chooseTeamType), for: .touchUpInside)
                
            }
            return cell
            
        default:
            break
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch item! {
        case 0:
            return CGSize(width: self.frame.width, height: 120)
        case 1:
            return CGSize(width: 0, height: 0)
        case 2:
            if isDetailed {
                return CGSize(width: self.frame.width, height: 50)
            }
            else {
                return CGSize(width: self.frame.width, height: 44)
            }
            
        default:
            break
        }
        
        return CGSize(width: 0, height: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if item != 0 {
            if teamType != 2 {
                return CGSize(width: self.frame.width/2.35+8, height: 208)
            }
            else {
                if isDetailed {
                    return CGSize(width: self.frame.width, height: 540)
                }
                else {
                    return CGSize(width: self.frame.width/2.35, height: 250)
                }
            }
        }
        else {
            return CGSize(width: self.frame.width, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let page = item {
            switch page {
            case 0:
                let historyDetailTableVC = HistoryDetailTableViewController()
                historyDetailTableVC.history = clubHistory[indexPath.item]
                vcDelegate?.pushViewController(viewController: historyDetailTableVC)
                
                break
            case 2:
                if teamType == 2 {
                    let id = clubTeam[indexPath.item]["id"].stringValue
                    
                    let URL = "http://api.kairat.com/club/team/\(id)"
                    
                    Models.fetchJSON(URL: URL, completionHandler: { (json) -> () in
                        if json.count > 0 {
                            self.aboutPlayer = json
                            self.collectionView.reloadData()
                        }
                    })
                    
                    isDetailed = true
                    collectionView.reloadData()
                }
                
                break
            default:
                break
            }
            
        }
    }
    
    func chooseTeamType(sender: UIButton) {
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let administrationAction = UIAlertAction(title: "АДМИНИСТРАЦИЯ", style: .default, handler: { void in
            sender.setTitle("АДМИНИСТРАЦИЯ", for: .normal)
            self.teamType = 0
            self.clubTeam = self.json["admins"]
            self.collectionView.reloadData()
        })
        let trenersAction = UIAlertAction(title: "ТРЕНЕРЫ", style: .default, handler: { void in
            sender.setTitle("ТРЕНЕРЫ", for: .normal)
            self.teamType = 1
            self.clubTeam = self.json["treners"]
            self.collectionView.reloadData()
        })
        let playersAction = UIAlertAction(title: "ИГРОКИ", style: .default, handler: { void in
            sender.setTitle("ИГРОКИ", for: .normal)
            self.teamType = 2
            self.clubTeam = self.json["team"]
            self.collectionView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "ОТМЕНА", style: .cancel, handler: nil)
        
        alertController.addAction(administrationAction)
        alertController.addAction(trenersAction)
        alertController.addAction(playersAction)
        alertController.addAction(cancelAction)
        
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func backToTeamList() {
        isDetailed = false
        collectionView.reloadData()
    }

}
