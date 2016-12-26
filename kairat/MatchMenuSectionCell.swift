//
//  MatchMenuSectionCell.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class MatchMenuSectionCell: UITableViewCell {
    
    func setupReviewSectionViews() {
        removeTeamSectionViewsFromSuperView()
        removeChatSectionViewsFromSuperView()
        removeMediaSectionViewsFromSuperView()

        addSubview(firstTeamLabel)
        addSubview(middleLabel)
        addSubview(secondTeamLabel)
        addSubview(middleTimeLabel)
        addSubview(verticalLine)
        
        middleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        middleTimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        verticalLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addConstraintsWithFormat(format: "H:[v0]-16-[v1]-16-[v2]", views: firstTeamLabel, middleTimeLabel, secondTeamLabel)
        
        addConstraintsWithFormat(format: "H:[v0(30)]", views: middleTimeLabel)
        
        firstTeamLabel.centerYAnchor.constraint(equalTo: middleTimeLabel.centerYAnchor).isActive = true
        secondTeamLabel.centerYAnchor.constraint(equalTo: middleTimeLabel.centerYAnchor).isActive = true
        
        addConstraintsWithFormat(format: "V:|[v0(20)]-[v1(16)]|", views: middleLabel, verticalLine)
        addConstraintsWithFormat(format: "V:|[v0(30)]-2-[v1(16)]|", views: middleTimeLabel, verticalLine)
        
        middleTimeLabel.layer.cornerRadius = 15
        middleTimeLabel.clipsToBounds = true
        middleTimeLabel.textAlignment = .center
        middleTimeLabel.layer.borderWidth = 2
        middleTimeLabel.layer.borderColor = UIColor(red: 203/255, green: 18/255, blue: 32/255, alpha: 1).cgColor
        middleTimeLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    let firstTeamLabel = MatchMenuSectionCell.setupReviewLabels()
    let middleLabel = MatchMenuSectionCell.setupReviewLabels()
    let secondTeamLabel = MatchMenuSectionCell.setupReviewLabels()
    
    let middleTimeLabel = MatchMenuSectionCell.setupReviewLabels()
    
    static func setupReviewLabels() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }
    
    let verticalLine: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .darkGray
        return view
    }()
    
    func setupTeamSectionViews(isFirstCell: Bool) {
        removeChatSectionViewsFromSuperView()
        removeReviewSectionViewsFromSuperView()
        removeMediaSectionViewsFromSuperView()
        
        if isFirstCell {
            removeTeamSectionViewsFromSuperView()
            backgroundColor = .clear
            
            addSubview(titleLabel)
            titleLabel.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 13, leftConstant: 0, bottomConstant: 6, rightConstant: 0)
        }
        else {
            titleLabel.removeFromSuperview()
            backgroundColor = .white
            
            addSubview(playerNumberLabel)
            addSubview(playerPositionLabel)
            addSubview(aboutPlayerLabel)
            
            addConstraintsWithFormat(format: "H:|-8-[v0(25)]-8-[v1]-8-[v2]", views: playerNumberLabel, playerPositionLabel, aboutPlayerLabel)
            
            addConstraintsWithFormat(format: "V:|-5-[v0]|", views: aboutPlayerLabel)
            
            playerNumberLabel.heightAnchor.constraint(equalTo: playerNumberLabel.widthAnchor).isActive = true
            
            playerNumberLabel.centerYAnchor.constraint(equalTo: aboutPlayerLabel.centerYAnchor).isActive = true
            
            playerPositionLabel.centerYAnchor.constraint(equalTo: playerNumberLabel.centerYAnchor).isActive = true
        }
        
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let playerNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.layer.cornerRadius = 12.5
        label.clipsToBounds = true
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 0.6
        return label
    }()
    
    let playerPositionLabel: UILabel = {
        let label = UILabel()
        label.text = "зщ"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let aboutPlayerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupMediaSectionViews() {
        removeReviewSectionViewsFromSuperView()
        removeTeamSectionViewsFromSuperView()
        removeChatSectionViewsFromSuperView()
        
        backgroundColor = .clear
        
        addSubview(mediaImageView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: mediaImageView)
        addConstraintsWithFormat(format: "V:|-6-[v0(180)]-6-|", views: mediaImageView)
        
    }
    
    let mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func setupChatSectionViews() {
        removeReviewSectionViewsFromSuperView()
        removeTeamSectionViewsFromSuperView()
        removeMediaSectionViewsFromSuperView()
        
        backgroundColor = .clear
        
        addSubview(messageLabel)
        
        messageLabel.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Данный раздел находиться в стадии разработки"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func removeReviewSectionViewsFromSuperView() {
        firstTeamLabel.removeFromSuperview()
        middleLabel.removeFromSuperview()
        secondTeamLabel.removeFromSuperview()
        middleTimeLabel.removeFromSuperview()
        verticalLine.removeFromSuperview()
    }
    
    func removeTeamSectionViewsFromSuperView() {
        titleLabel.removeFromSuperview()
        playerNumberLabel.removeFromSuperview()
        playerPositionLabel.removeFromSuperview()
        aboutPlayerLabel.removeFromSuperview()
        
    }
    
    func removeMediaSectionViewsFromSuperView() {
        mediaImageView.removeFromSuperview()
    }
    
    func removeChatSectionViewsFromSuperView()  {
        messageLabel.removeFromSuperview()
    }
}

