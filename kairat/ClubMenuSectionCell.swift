//
//  ClubMenuSectionCell.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class ClubMenuSectionCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let shortTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .lightGray
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let readMoreLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func setupMenuFirstSectionViews() {
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(shortTextView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "H:|-6-[v0]-6-|", views: shortTextView)
        
        addConstraintsWithFormat(format: "V:|[v0]-[v1]", views: imageView, shortTextView)
        
        imageView.addSubview(titleLabel)
        
        titleLabel.anchorWithConstantsToTop(top: nil, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: imageView.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 8, rightConstant: 0)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textAlignment = .justified

    }
    
    func setupMenuSecondThirdSectionViews(isPlayers: Bool) {
        playerName.removeFromSuperview()
        aboutPlayerLabel.removeFromSuperview()
        playerAchivementLabel.removeFromSuperview()
        
        backgroundColor = UIColor(red: 38/255, green: 42/255, blue: 50/255, alpha: 1)
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: titleLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: subTitleLabel)
        
        if isPlayers {
            imageView.removeFromSuperview()
            
            addSubview(playerImageView)
            addConstraintsWithFormat(format: "H:|[v0]|", views: playerImageView)
            
            addConstraintsWithFormat(format: "V:|[v0(200)]-8-[v1]-2-[v2]", views: playerImageView, titleLabel, subTitleLabel)
        }
        else {
            playerImageView.removeFromSuperview()
            
            addSubview(imageView)
            addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
            
            addConstraintsWithFormat(format: "V:|[v0(155)]-8-[v1]-2-[v2]", views: imageView, titleLabel, subTitleLabel)
        }
        
    }
    
    func setupDetailedViews() {
        imageView.removeFromSuperview()
        titleLabel.removeFromSuperview()
        subTitleLabel.removeFromSuperview()
        
        backgroundColor = .white
        
        let playerView = UIView()
        playerView.backgroundColor = UIColor(red: 95/255, green: 13/255, blue: 18/255, alpha: 1)
        
        addSubview(playerView)
        
        playerView.addSubview(playerName)
        playerView.addSubview(aboutPlayerLabel)
        playerView.addSubview(playerAchivementLabel)
        
        addSubview(imageView)
        
        imageView.backgroundColor = .clear
        
        playerName.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: nil, right: centerXAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 0)
        
        aboutPlayerLabel.anchorWithConstantsToTop(top: playerName.bottomAnchor, left: playerView.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0)
        
        imageView.anchorWithConstantsToTop(top: playerName.topAnchor, left: playerName.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: -85, bottomConstant: 0, rightConstant: 0)
        
        playerView.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: imageView.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 35, rightConstant: 0)
        
        playerAchivementLabel.anchorWithConstantsToTop(top: playerView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
    }
    
    let playerImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(red: 203/255, green: 18/255, blue: 32/255, alpha: 1)
        return iv
    }()
    
    let playerName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let aboutPlayerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let playerAchivementLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}

