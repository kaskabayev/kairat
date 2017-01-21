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
        removeReviewSectionViewsFromSuperView()
        removeTeamSectionViewsFromSuperView()
        removeChatSectionViewsFromSuperView()
        removeMediaSectionViewsFromSuperView()
        
        firstTeamLabel.font=UIFont(name: "OpenSans", size: 12)
        firstTeamLabel.textAlignment = .right
        secondTeamLabel.font=UIFont(name: "OpenSans", size: 12)
        secondTeamLabel.textAlignment = .left
        middleLabel.font=UIFont(name: "OpenSans", size: 12)
        middleTimeLabel.font=UIFont(name: "OpenSans-Bold", size: 12)
        
        addSubview(firstTeamLabel)
        addSubview(middleLabel)
        addSubview(secondTeamLabel)
        addSubview(middleTimeLabel)
        addSubview(verticalLine)
        addSubview(firstIcon)
        addSubview(secondIcon)
        
        middleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        middleTimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        verticalLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addConstraintsWithFormat(format: "H:|-10-[v0]-8-[v1]-10-[v2]-10-[v3]-8-[v4]-10-|", views: firstTeamLabel,firstIcon, middleTimeLabel, secondIcon,secondTeamLabel)
        
        addConstraintsWithFormat(format: "H:[v0(30)]", views: middleTimeLabel)
        
        firstIcon.centerYAnchor.constraint(equalTo: middleTimeLabel.centerYAnchor).isActive = true
        secondIcon.centerYAnchor.constraint(equalTo: middleTimeLabel.centerYAnchor).isActive = true
        
        firstTeamLabel.centerYAnchor.constraint(equalTo: middleTimeLabel.centerYAnchor).isActive = true
        secondTeamLabel.centerYAnchor.constraint(equalTo: middleTimeLabel.centerYAnchor).isActive = true
        
        addConstraintsWithFormat(format: "V:|-10-[v0(20)]-(10)-[v1(16)]-(-10)-|", views: middleLabel, verticalLine)
        addConstraintsWithFormat(format: "V:|-10-[v0(30)]-(10)-[v1(16)]-(-10)-|", views: middleTimeLabel, verticalLine)
        
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
    let firstIcon:UIImageView={
        let img=UIImageView()
        img.clipsToBounds=true
        img.widthAnchor.constraint(equalToConstant: 15).isActive=true
        img.heightAnchor.constraint(equalToConstant: 15).isActive=true
        return img
    }()
    let secondIcon:UIImageView={
        let img=UIImageView()
        img.clipsToBounds=true
        img.widthAnchor.constraint(equalToConstant: 15).isActive=true
        img.contentMode = .scaleAspectFit
        //img.heightAnchor.constraint(equalToConstant: 20).isActive=true
        return img
    }()
    
    let middleTimeLabel = MatchMenuSectionCell.setupReviewLabels()
    
    static func setupReviewLabels() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }
    
    let verticalLine: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 2).isActive = true
        view.backgroundColor = .darkGray
        return view
    }()
    
    func setupTeamSectionViews(isFirstCell: Bool) {
        self.layoutMargins=UIEdgeInsetsMake(10, 10, 10, 10)
        removeChatSectionViewsFromSuperView()
        removeReviewSectionViewsFromSuperView()
        removeMediaSectionViewsFromSuperView()
        
        if isFirstCell {
            removeTeamSectionViewsFromSuperView()
            backgroundColor = .clear
            
            addSubview(titleLabel)
            titleLabel.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 13, leftConstant: 10, bottomConstant: 6, rightConstant: 10)
        }
        else {
            titleLabel.removeFromSuperview()
            backgroundColor = .clear
            
            teamView.addSubview(playerNumberLabel)
            teamView.addSubview(aboutPlayerLabel)
            
            addSubview(teamView)
            teamView.anchorWithConstantsToTop(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10)
            
            addConstraintsWithFormat(format: "H:|-8-[v0(25)]-8-[v1]", views: playerNumberLabel, aboutPlayerLabel)
            
            addConstraintsWithFormat(format: "V:|-5-[v0]|", views: aboutPlayerLabel)
            
            playerNumberLabel.heightAnchor.constraint(equalTo: playerNumberLabel.widthAnchor).isActive = true
            
            playerNumberLabel.centerYAnchor.constraint(equalTo: aboutPlayerLabel.centerYAnchor).isActive = true
            
        }
        
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let teamView:UIView={
        let view=UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
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
    
    let aboutPlayerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isVideo=false
    func setupMediaSectionViews() {
        removeReviewSectionViewsFromSuperView()
        removeTeamSectionViewsFromSuperView()
        removeChatSectionViewsFromSuperView()
        
        backgroundColor = .clear
        
        addSubview(mediaImageView)
        addSubview(filterImageView)
        filterImageView.anchorToTop(mediaImageView.topAnchor, left: mediaImageView.leftAnchor, bottom: mediaImageView.bottomAnchor, right: mediaImageView.rightAnchor)
        
        addSubview(playerImageView)
        playerImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playerImageView.anchorWithConstantsToTop(self.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 59, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: mediaImageView)
        addConstraintsWithFormat(format: "V:|-6-[v0(180)]-6-|", views: mediaImageView)
        
    }
    
    let mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let filterImageView:UIImageView={
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image=#imageLiteral(resourceName: "filtre")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let playerImageView:UIImageView={
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image=#imageLiteral(resourceName: "video")
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.clipsToBounds = true
        imageView.isHidden=true
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
        firstIcon.removeFromSuperview()
        secondIcon.removeFromSuperview()
    }
    
    func removeTeamSectionViewsFromSuperView() {
        titleLabel.removeFromSuperview()
        teamView.removeFromSuperview()
        playerNumberLabel.removeFromSuperview()
        aboutPlayerLabel.removeFromSuperview()
        
    }
    
    func removeMediaSectionViewsFromSuperView() {
        mediaImageView.removeFromSuperview()
        filterImageView.removeFromSuperview()
        playerImageView.removeFromSuperview()
    }
    
    func removeChatSectionViewsFromSuperView()  {
        messageLabel.removeFromSuperview()
    }
}

