//
//  MatchCell.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        kairatImageView.image = UIImage(named: "fon")
        
        addSubview(kairatImageView)
        
        kairatImageView.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: -64, leftConstant: 0, bottomConstant: -44, rightConstant: 0)
        
        addSubview(aboutMatchLabel)
        addSubview(firstClubWhiteView)
        addSubview(secondClubWhiteView)
        addSubview(firstClubNameLabel)
        addSubview(secondClubNameLabel)
        
        firstClubWhiteView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        secondClubWhiteView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        aboutMatchLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        aboutMatchLabel.topAnchor.constraint(equalTo: firstClubWhiteView.topAnchor).isActive = true
        
        addConstraintsWithFormat(format: "H:[v0]-8-[v1]-8-[v2]", views: firstClubWhiteView, aboutMatchLabel, secondClubWhiteView)
        
        firstClubNameLabel.anchorWithConstantsToTop(top: firstClubWhiteView.bottomAnchor, left: firstClubWhiteView.leftAnchor, bottom: nil, right: firstClubWhiteView.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        
        secondClubNameLabel.anchorWithConstantsToTop(top: secondClubWhiteView.bottomAnchor, left: secondClubWhiteView.leftAnchor, bottom: nil, right: secondClubWhiteView.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        firstClubWhiteView.addSubview(firstClubImageView)
        secondClubWhiteView.addSubview(secondClubImageView)
        
        firstClubImageView.anchorToTop(top: firstClubWhiteView.topAnchor, left: firstClubWhiteView.leftAnchor, bottom: firstClubWhiteView.bottomAnchor, right: firstClubWhiteView.rightAnchor)
        
        secondClubImageView.anchorToTop(top: secondClubWhiteView.topAnchor, left: secondClubWhiteView.leftAnchor, bottom: secondClubWhiteView.bottomAnchor, right: secondClubWhiteView.rightAnchor)
        
        addSubview(foregroundView)
        
        foregroundView.anchorToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    let kairatImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "fon")
        iv.clipsToBounds = true
        return iv
    }()
    
    let foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    
    let firstClubWhiteView = MatchCell.setupBackgroundWhiteView()
    let secondClubWhiteView = MatchCell.setupBackgroundWhiteView()
    
    static func setupBackgroundWhiteView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        return view
    }
    
    let firstClubImageView = MatchCell.setupClubImageView()
    let secondClubImageView = MatchCell.setupClubImageView()
    
    static func setupClubImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }
    
    let aboutMatchLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let firstClubNameLabel = MatchCell.setupClubNameLabel()
    let secondClubNameLabel = MatchCell.setupClubNameLabel()
    
    static func setupClubNameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }

}
