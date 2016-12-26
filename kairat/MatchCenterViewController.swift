//
//  MatchCenterViewController.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ModelHelper {
    func fetchMatchList(date: String)
    
    func reloadData()
}

class MatchCenterViewController: ClubViewController, ModelHelper {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.removeFromSuperview()
        self.statusBarView.removeFromSuperview()
        
        matchViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "МАТЧ-ЦЕНТР"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = ""
    }
    
    var dateStr = ""
    var isSended = false
    var matchList = JSON.null
    
    let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.addSubview(indicator)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    func matchViewDidLoad() {
        let currentDate = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let month = formatter.string(from: currentDate as Date)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: currentDate as Date)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: currentDate as Date)
        
        dateStr = "\(year).\(month).\(day)"

        
        fetchMatchList(date: dateStr)
    }
    
    internal func fetchMatchList(date: String) {
        let URL = "http://api.kairat.com/games?date=\(date)"
        view.addSubview(loadingView)
        loadingView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        Models.fetchJSON(URL: URL, completionHandler: { (json) -> () in
            
                self.matchList = json
                
                self.tableView.removeFromSuperview()
                self.statusBarView.removeFromSuperview()
                self.setupTableView(inTop: false)
                self.tableView.register(MatchCenterHeader.self, forHeaderFooterViewReuseIdentifier: self.headerId)
                self.tableView.register(MatchCenterCell.self, forCellReuseIdentifier: self.cellId)
                self.tableView.reloadData()
                self.loadingView.removeFromSuperview()
           
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MatchCenterCell
            
            cell.modelDelegate = self
            cell.matchList = matchList
            
            if !isSended {
                cell.date = dateStr
                cell.seasonButton.setTitle(dateStr, for: .normal)
                isSended = true
            }
            
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! MatchCenterHeader
            
            //header.contentView.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 33/255, alpha: 1)
            header.vcDelegate = self
            header.matchList = matchList
            
            return header
        }
    }
    
    internal func reloadData() {
        tableView.reloadData()
    }
}
