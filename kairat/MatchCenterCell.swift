//
//  MatchCenterCell.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON

class MatchCenterCell: ClubCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func setupViews() {
        kairatImageView.image = UIImage(named: "fon")
        
        addSubview(kairatImageView)
        
        kairatImageView.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: -64, leftConstant: 0, bottomConstant: -44, rightConstant: 0)
        
        blurView.frame = kairatImageView.bounds
        kairatImageView.addSubview(blurView)
        
        kairatImageView.addSubview(foregroundView)
        
        foregroundView.anchorToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        addSubview(turnirCollectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: turnirCollectionView)
        
        addConstraintsWithFormat(format: "V:|-16-[v0(140)]", views: turnirCollectionView)
        
        addSubview(seasonLabel)
        addSubview(seasonButton)
        
        seasonButton.leadingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        seasonButton.anchorWithConstantsToTop(top: turnirCollectionView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        seasonLabel.anchorWithConstantsToTop(top: seasonButton.topAnchor, left: nil, bottom: nil, right: seasonButton.leftAnchor, topConstant: -1.5, leftConstant: 0, bottomConstant: 0, rightConstant: 16)
        
        seasonButton.addSubview(buttonBottomLine)
        
        buttonBottomLine.anchorWithConstantsToTop(top: nil, left: seasonButton.leftAnchor, bottom: seasonButton.bottomAnchor, right: seasonButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -2, rightConstant: 0)

        turnirCollectionView.register(TournamentCell.self, forCellWithReuseIdentifier: turnirCellId)
    }
    
    let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let buttonBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    let seasonLabel: UILabel = {
        let label = UILabel()
        label.text = "СЕЗОН"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var seasonButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 14).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(MatchCenterCell.chooseDate), for: .touchUpInside)
        button.setImage(UIImage(named: "strelkaa"), for: .normal)
        button.imageView!.transform = CGAffineTransform(rotationAngle: (270.0 * CGFloat(M_PI)) / 180.0)
        button.widthAnchor.constraint(equalToConstant: 94).isActive = true
        button.imageEdgeInsets = UIEdgeInsetsMake(3, 97, 3, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, -30)
        return button
    }()
    
    lazy var turnirCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsetsMake(0, 6, 0, 0)
        return collectionView
    }()

    static var selectedMatchIndexPath = IndexPath()

    var matchList = JSON.null {
        didSet {
            turnirCollectionView.reloadData()
        }
    }
    var modelDelegate: ModelHelper?
    
    let turnirCellId = "turnirCellId"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: turnirCellId, for: indexPath) as! TournamentCell
        
        cell.nameLabel.text = matchList[indexPath.row]["name"].stringValue
        
        if MatchCenterCell.selectedMatchIndexPath == indexPath {
            cell.nameLabel.textColor = UIColor(red: 203/255, green: 18/255, blue: 32/255, alpha: 1)
        }
        else {
            cell.nameLabel.textColor = .white
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 110, height: turnirCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MatchCenterHeader.selectedMatchId = matchList[indexPath.item]["id"].stringValue
        
        MatchCenterCell.selectedMatchIndexPath = indexPath
        MatchCenterHeader.isTurnirSelected = true
        
        modelDelegate?.reloadData()
    }
    
    func chooseDate() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(MatchCenterCell.datePickerChanged), for: .valueChanged)
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: "", preferredStyle: .actionSheet)
        
        alertController.view.addSubview(datePicker)
        
        datePicker.anchorWithConstantsToTop(top: alertController.view.topAnchor, left: alertController.view.leftAnchor, bottom: nil, right: alertController.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler:  { void in
            
            self.seasonButton.setTitle(self.date, for: .normal)
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler:  { void in
            
            self.date = self.newDate
            self.modelDelegate?.fetchMatchList(date: self.date)
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    var newDate = ""
    var date = ""
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let month = formatter.string(from: sender.date)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: sender.date)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: sender.date)
        
        newDate = "\(year).\(month).\(day)"
        
        seasonButton.setTitle(newDate, for: .normal)
    }
}
