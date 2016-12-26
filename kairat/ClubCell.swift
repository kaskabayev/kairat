//
//  ClubCell.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class ClubCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(kairatImageView)
        
        kairatImageView.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: -64, leftConstant: 0, bottomConstant: -44, rightConstant: 0)
        
        kairatImageView.addSubview(foregroundView)
        
        foregroundView.anchorToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    let kairatImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "Kaitrat")
        iv.clipsToBounds = true
        return iv
    }()
    
    let foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

}
