//
//  ClubHeader.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class ClubHeader: UITableViewHeaderFooterView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundView = UIImageView()
        
        addSubview(tabBarMenuView)
        addSubview(tabCollectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: tabBarMenuView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: tabCollectionView)
        
        addConstraintsWithFormat(format: "V:|[v0(44)]-[v1]|", views: tabBarMenuView, tabCollectionView)
        
        tabBarMenuView.addSubview(historyButton)
        tabBarMenuView.addSubview(achivementButton)
        tabBarMenuView.addSubview(teamButton)
        tabBarMenuView.addSubview(indicatorView)
        
        tabBarMenuView.addConstraintsWithFormat(format: "H:|[v0(v2)]-[v1(v2)]-[v2]|", views: historyButton, achivementButton, teamButton)
        
        tabBarMenuView.addConstraintsWithFormat(format: "V:|[v0(44)]|", views: historyButton)
        tabBarMenuView.addConstraintsWithFormat(format: "V:|[v0(44)]|", views: achivementButton)
        tabBarMenuView.addConstraintsWithFormat(format: "V:|[v0(44)]|", views: teamButton)

        indicatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33).isActive = true
        
        indicatorView.anchorWithConstantsToTop(top: nil, left: tabBarMenuView.leftAnchor, bottom: tabBarMenuView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        addTargetToMenuButtons(button: historyButton)
        addTargetToMenuButtons(button: achivementButton)
        addTargetToMenuButtons(button: teamButton)
        
        subMenuButtons = [historyButton, achivementButton, teamButton]
        
        tabCollectionView.register(ClubMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    var vcDelegate: ViewControllerHelper?
    
    var subMenuButtons = [UIButton]()
    
    let tabBarMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let historyButton = ClubHeader.setupCVButtons(title: "ИСТОРИЯ", tag: 0)
    let achivementButton = ClubHeader.setupCVButtons(title: "ДОСТИЖЕНИЯ", tag: 1)
    let teamButton = ClubHeader.setupCVButtons(title: "СОСТАВ", tag: 2)
    
    static func setupCVButtons(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.5)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .clear
        button.tag = tag
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        if tag == 0 {
            button.setTitleColor(UIColor(red: 203/255, green: 18/255, blue: 32/255, alpha: 1), for: .normal)
            
        }
        return button
    }
    
    func addTargetToMenuButtons(button: UIButton) {
        button.addTarget(self, action: #selector(ClubHeader.selectMenu(sender:)), for: .touchUpInside)
    }
    
    let indicatorView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        view.backgroundColor = UIColor(red: 203/255, green: 18/255, blue: 32/255, alpha: 1)
        return view
    }()
    
    lazy var tabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 33/255, alpha: 1)
        return collectionView
    }()
    
    let cellId = "clubSubMenuCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ClubMenuCell
        
        cell.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 33/255, alpha: 1)
        cell.item = indexPath.item
        cell.vcDelegate = vcDelegate
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        indicatorView.frame.origin.x = scrollView.contentOffset.x / 3
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let item = Int(targetContentOffset.pointee.x / screenWidth)
        
        changeMenuTitleColor(tag: item)
    }
    
    func selectMenu(sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        
        tabCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        changeMenuTitleColor(tag: sender.tag)
    }
    
    func changeMenuTitleColor(tag: Int) {
        for i in 0..<subMenuButtons.count {
            
            if subMenuButtons[i].tag == tag {
                subMenuButtons[i].setTitleColor(UIColor(red: 203/255, green: 18/255, blue: 32/255, alpha: 1), for: .normal)
            }
            else {
                subMenuButtons[i].setTitleColor(.white, for: .normal)
            }
        }
    }

}
