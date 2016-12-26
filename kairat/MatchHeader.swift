//
//  MatchHeader.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON

class MatchHeader: ClubHeader {
    
    let reviewButton = MatchCenterHeader.setupCVButtons(title: "ОБЗОР", tag: 0)
    let aboutTeamButton = MatchCenterHeader.setupCVButtons(title: "СОСТАВ", tag: 1)
    let mediaButton = MatchCenterHeader.setupCVButtons(title: "МЕДИА", tag: 2)
    let chatButton = MatchCenterHeader.setupCVButtons(title: "ЧАТ", tag: 3)

    override func setupViews() {
        backgroundView = UIImageView()
        
        addSubview(tabBarMenuView)
        addSubview(tabCollectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: tabBarMenuView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: tabCollectionView)
        
        addConstraintsWithFormat(format: "V:|[v0(44)]-[v1]|", views: tabBarMenuView, tabCollectionView)
        
        tabBarMenuView.addSubview(reviewButton)
        tabBarMenuView.addSubview(aboutTeamButton)
        tabBarMenuView.addSubview(mediaButton)
        tabBarMenuView.addSubview(chatButton)
        tabBarMenuView.addSubview(indicatorView)
        
        tabBarMenuView.addConstraintsWithFormat(format: "H:|[v0(v3)]-[v1(v3)]-[v2(v3)]-[v3]|", views: reviewButton, aboutTeamButton, mediaButton, chatButton)
        
        tabBarMenuView.addConstraintsWithFormat(format: "V:|[v0]|", views: reviewButton)
        tabBarMenuView.addConstraintsWithFormat(format: "V:|[v0]|", views: aboutTeamButton)
        tabBarMenuView.addConstraintsWithFormat(format: "V:|[v0]|", views: mediaButton)
        tabBarMenuView.addConstraintsWithFormat(format: "V:|[v0]|", views: chatButton)
        
        indicatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        
        indicatorView.anchorWithConstantsToTop(top: nil, left: tabBarMenuView.leftAnchor, bottom: tabBarMenuView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        addTargetToMenuButtons(button: reviewButton)
        addTargetToMenuButtons(button: aboutTeamButton)
        addTargetToMenuButtons(button: mediaButton)
        addTargetToMenuButtons(button: chatButton)

        subMenuButtons = [reviewButton, aboutTeamButton, mediaButton, chatButton]
        
        tabCollectionView.register(MatchMenuCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    var match = JSON.null {
        didSet {
            tabCollectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MatchMenuCell
        
        cell.match = match
        cell.page = indexPath.item
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        indicatorView.frame.origin.x = scrollView.contentOffset.x / 4
    }

}
