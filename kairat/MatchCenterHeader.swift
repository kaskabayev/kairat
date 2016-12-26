//
//  MatchCenterHeader.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON

class MatchCenterHeader: ClubHeader {
    
    let futureMatchButton = MatchCenterHeader.setupCVButtons(title: "БУДУЩИЕ МАТЧИ", tag: 0)
    let pastMatchButton = MatchCenterHeader.setupCVButtons(title: "ПРОШЕДШИЕ МАТЧИ", tag: 1)
    
    override func setupViews() {
        backgroundView = UIImageView()
        
        addSubview(tabBarMenuView)
        addSubview(tabCollectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: tabBarMenuView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: tabCollectionView)
        
        addConstraintsWithFormat(format: "V:|[v0(44)]-[v1]|", views: tabBarMenuView, tabCollectionView)
        
        tabBarMenuView.addSubview(futureMatchButton)
        tabBarMenuView.addSubview(pastMatchButton)
        tabBarMenuView.addSubview(indicatorView)
        
        tabBarMenuView.addConstraintsWithFormat(format: "H:|[v0(v1)]-[v1]|", views: futureMatchButton, pastMatchButton)
        
        tabBarMenuView.addConstraintsWithFormat(format: "V:|[v0]|", views: futureMatchButton)
        tabBarMenuView.addConstraintsWithFormat(format: "V:|[v0]|", views: pastMatchButton)
        
        indicatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        
        indicatorView.anchorWithConstantsToTop(top: nil, left: tabBarMenuView.leftAnchor, bottom: tabBarMenuView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        addTargetToMenuButtons(button: futureMatchButton)
        addTargetToMenuButtons(button: pastMatchButton)
        
        subMenuButtons = [futureMatchButton, pastMatchButton]
        
        tabCollectionView.register(MatchCenterMenuCell.self, forCellWithReuseIdentifier: matchCenterMenuCellId)
    }
    
    static var isTurnirSelected = false
    static var selectedMatchId = ""
    
    var matches = JSON.null
    var futureMatchList = [JSON]()
    var pastMatchList = [JSON]()
    
    var futureMatches = [JSON]()
    var pastMatches = [JSON]()
    
    var matchList = JSON.null {
        didSet {
            futureMatchList.removeAll()
            pastMatchList.removeAll()
            futureMatches.removeAll()
            pastMatches.removeAll()
            
            if !MatchCenterHeader.isTurnirSelected {
                for dict in matchList.arrayValue {
                    for game in dict["games"].arrayValue {
                        if game["status"].string == "finished" {
                            pastMatchList.append(game)
                            pastMatches.append(dict)
                        }
                    }
                }
                
                for dict in matchList.arrayValue {
                    for game in dict["games"].arrayValue {
                        if game["status"].string == "wait" {
                            futureMatchList.append(game)
                            futureMatches.append(dict)
                        }
                    }
                }
            }
            else {
                for match in matchList.arrayValue {
                    if match["id"].stringValue == MatchCenterHeader.selectedMatchId {
                        matches = match
                        print(matches["name"].stringValue)
                    }
                }
                
                for game in matches["games"].arrayValue {
                    if game["status"].string == "finished" {
                        pastMatchList.append(game)
                        pastMatches.append(matches)
                    }
                }
                
                print("past: \(pastMatchList)")
                
                for game in matches["games"].arrayValue {
                    if game["status"].string == "wait" {
                        futureMatchList.append(game)
                        futureMatches.append(matches)
                    }
                }
                
            }
            
            tabCollectionView.reloadData()
        }
    }

    
    let matchCenterMenuCellId = "matchCenterMenuCellId"
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchCenterMenuCellId, for: indexPath) as! MatchCenterMenuCell
        
        cell.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 33/255, alpha: 1)
        //cell.item = indexPath.item
        cell.vcDelegate = vcDelegate
        
        switch indexPath.item {
        case 0:
            cell.matches = futureMatches
            cell.matchList = futureMatchList
            break
        case 1:
            cell.matches = pastMatches
            cell.matchList = pastMatchList
            break
        default:
            break
        }

        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        indicatorView.frame.origin.x = scrollView.contentOffset.x / 2
    }
}
