//
//  ClubMenuSectionHeader.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class ClubMenuSectionHeader: UICollectionReusableView {
    
    func setupHistorySectionViews() {
        backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 33/255, alpha: 1)
        
        addSubview(aboutKairatTextView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: aboutKairatTextView)
        
        addConstraintsWithFormat(format: "V:|-6-[v0]-6-|", views: aboutKairatTextView)
    }
    
    let aboutKairatTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.text = "АФК 'Кайрат' - казахстанский футзальный клуб, базирующийся в Алматы. Основан в 1995 году, и в последние годы является одним из сильнейших клубов Европы, чему свидетельствуют два завоевания Кубка УЕФА, триумф в интерконтинентальном Кубке и 11 кратное подряд завоевания чемпионства внутреннего первенства."
        textView.textColor = .lightGray
        textView.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 33/255, alpha: 1)
        return textView
    }()
    
    func setupTeamSectionViews() {
        backButton.removeFromSuperview()
        backLabel.removeFromSuperview()
        
        addSubview(chooseButton)
        
        chooseButton.anchorWithConstantsToTop(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0)
        
        chooseButton.addSubview(bottomLine)
        
        bottomLine.anchorToTop(top: nil, left: chooseButton.leftAnchor, bottom: chooseButton.bottomAnchor, right: chooseButton.rightAnchor)
        
        bottomLine.anchorWithConstantsToTop(top: nil, left: chooseButton.leftAnchor, bottom: chooseButton.bottomAnchor, right: chooseButton.rightAnchor
            , topConstant: 0, leftConstant: 0, bottomConstant: 3, rightConstant: 0)
    }
    
    let chooseButton: UIButton = {
        let button = UIButton()
        button.setTitle("АДМИНИСТРАЦИЯ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(UIImage(named: "strelkaa"), for: .normal)
        button.imageView!.transform = CGAffineTransform(rotationAngle: (270.0 * CGFloat(M_PI)) / 180.0)
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 165, 8, 0)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -31, 0, -30)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30)
        button.titleLabel?.textAlignment = .left
        return button
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    func setupDetailedViews() {
        chooseButton.removeFromSuperview()
        bottomLine.removeFromSuperview()
        
        addSubview(backButton)
        addSubview(backLabel)
        
        backButton.widthAnchor.constraint(equalToConstant: 8).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        backButton.anchorWithConstantsToTop(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 18, rightConstant: 0)
        backLabel.anchorWithConstantsToTop(top: nil, left: backButton.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 0)
        
    }
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "strelkaa"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let backLabel: UILabel = {
        let label = UILabel()
        label.text = "ИГРОК"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
}

