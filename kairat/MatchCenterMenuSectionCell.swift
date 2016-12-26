//
//  MatchCenterMenuSectionCell.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class MatchCenterMenuSectionCell: TournamentCell {
    
    override func setupViews() {
        
        backgroundColor = .white
        
        addSubview(firstClubLogoImageView)
        addSubview(secondClubLogoImageView)
        addSubview(firstClubNameLabel)
        addSubview(secondClubNameLabel)
        addSubview(aboutMatchLabel)
        
        aboutMatchLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        aboutMatchLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        
        setCenterVertically(view: aboutMatchLabel)
        setCenterVertically(view: firstClubLogoImageView)
        setCenterVertically(view: secondClubLogoImageView)
        
        firstClubLogoImageView.anchorWithConstantsToTop(top: nil, left: nil, bottom: nil, right: aboutMatchLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10)
        
        firstClubLogoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        firstClubLogoImageView.heightAnchor.constraint(equalToConstant: 104).isActive = true
        
        secondClubLogoImageView.anchorWithConstantsToTop(top: nil, left: aboutMatchLabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0)
        
        secondClubLogoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        secondClubLogoImageView.heightAnchor.constraint(equalToConstant: 104).isActive = true
        
        firstClubNameLabel.anchorWithConstantsToTop(top: firstClubLogoImageView.bottomAnchor, left: firstClubLogoImageView.leftAnchor, bottom: nil, right: firstClubLogoImageView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        secondClubNameLabel.anchorWithConstantsToTop(top: secondClubLogoImageView.bottomAnchor, left: secondClubLogoImageView.leftAnchor, bottom: nil, right: secondClubLogoImageView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func setCenterVertically(view: UIView) {
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    let firstClubLogoImageView = MatchCenterMenuSectionCell.setupClubLogoImageView()
    let secondClubLogoImageView = MatchCenterMenuSectionCell.setupClubLogoImageView()
    
    static func setupClubLogoImageView() -> UIImageView  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    let firstClubNameLabel =  MatchCenterMenuSectionCell.setupClubNameLabel()
    let secondClubNameLabel =  MatchCenterMenuSectionCell.setupClubNameLabel()
    
    static func setupClubNameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    let aboutMatchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
}

