//
//  HistoryDetailTableViewController.swift
//  kairat
//
//  Created by dreamwings on 09.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class HistoryDetailTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "ИСТОРИЯ"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        navigationItem.titleView = titleLabel
        
        view.backgroundColor = .black
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "Kaitrat")
        
        let blurEffect = UIView()
        blurEffect.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        view.addSubview(bgImageView)
        view.addSubview(statusBarView)
        view.addSubview(tableView)
        
        bgImageView.anchorWithConstantsToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: view.frame.width/2, rightConstant: 0)
        
        bgImageView.addSubview(blurEffect)
        blurEffect.anchorToTop(top: bgImageView.topAnchor, left: bgImageView.leftAnchor, bottom: bgImageView.bottomAnchor, right: bgImageView.rightAnchor)
        
        statusBarView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor)
        
        tableView.anchorWithConstantsToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 64, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        tableView.register(HistoryDetailCell.self, forCellReuseIdentifier: cellId)
    }
    
    let statusBarView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.backgroundColor = .black
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.sectionHeaderHeight = 16
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }()
    
    let cellId = "detailCell"
    
    var history = JSON.null {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryDetailCell

        let historyImage = history["preview"].stringValue
        let historyImageUrl = URL(string: historyImage)
        cell.historyImageView.kf.setImage(with: historyImageUrl)
        
        let historyTitle = history["title"].stringValue
        cell.titleLabel.text = historyTitle
        
        let historyText = history["content"].stringValue
        cell.fullTextView.text = historyText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

class HistoryDetailCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .white
        
        addSubview(historyImageView)
        addSubview(fullTextView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: historyImageView)
        addConstraintsWithFormat(format: "H:|-6-[v0]-6-|", views: fullTextView)
        
        addConstraintsWithFormat(format: "V:|[v0]-[v1]|", views: historyImageView, fullTextView)
        
        historyImageView.addSubview(titleLabel)
        
        titleLabel.anchorWithConstantsToTop(top: nil, left: historyImageView.leftAnchor, bottom: historyImageView.bottomAnchor, right: historyImageView.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 8, rightConstant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let historyImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    let fullTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .darkGray
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        return textView
    }()

}
