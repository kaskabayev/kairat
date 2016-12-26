//
//  TournamentCell.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class TournamentCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(circleView)
        addSubview(nameLabel)
        
        circleView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor).isActive = true
        
        circleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        circleView.anchorToTop(top: topAnchor, left: nil, bottom: nil, right: nil)
        
        nameLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true
        
        nameLabel.anchorWithConstantsToTop(top: circleView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        circleView.addSubview(imageView)
        
        imageView.anchorToTop(top: circleView.topAnchor, left: circleView.leftAnchor, bottom: circleView.bottomAnchor, right: circleView.rightAnchor)

    }
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 88/255, green: 63/255, blue: 76/255, alpha: 1)
        view.layer.cornerRadius = 45
        view.clipsToBounds = true
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "k3")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}
