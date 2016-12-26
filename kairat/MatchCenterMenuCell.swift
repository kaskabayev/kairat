//
//  MatchCenterMenuCell.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON

class MatchCenterMenuCell: ClubMenuCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        collectionView.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        collectionView.register(MatchCenterMenuSectionCell.self, forCellWithReuseIdentifier: matchCenterMenuSectionCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var matches = [JSON]()
    
    var matchList = [JSON]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let matchCenterMenuSectionCellId = "matchCenterMenuSectionCellId"
    
    //var vcDelegate: ViewControllerHelper?
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchList.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchCenterMenuSectionCellId, for: indexPath) as! MatchCenterMenuSectionCell
        
        let score = matchList[indexPath.item]["info"]["score"].stringValue
        let name = matches[indexPath.item]["name"].stringValue
        
        let scoreAttributedText = NSMutableAttributedString(attributedString: NSMutableAttributedString(string: "\(score)\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 40)]))
        scoreAttributedText.append(NSAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.lightGray]))
        
        cell.aboutMatchLabel.attributedText = scoreAttributedText
        
        let homeLogo: String = matchList[indexPath.item]["home"]["logo"].stringValue
        let homeLogoUrl = URL(string: homeLogo)
        cell.firstClubLogoImageView.kf.setImage(with: homeLogoUrl)
        
        let guestLogo: String = matchList[indexPath.item]["guest"]["logo"].stringValue
        let guestLogoUrl = URL(string: guestLogo)
        cell.secondClubLogoImageView.kf.setImage(with: guestLogoUrl)
        
        let homeName = matchList[indexPath.item]["home"]["name"].stringValue
        cell.firstClubNameLabel.text = homeName
        
        let guestName = matchList[indexPath.item]["guest"]["name"].stringValue
        cell.secondClubNameLabel.text = guestName
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let matchViewController = MatchViewController()
        matchViewController.matchId = matchList[indexPath.item]["id"].stringValue
        
        vcDelegate?.pushViewController(viewController: matchViewController)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 165)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 0, height: 0)
    }
}

