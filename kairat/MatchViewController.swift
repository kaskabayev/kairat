//
//  MatchViewController.swift
//  kairat
//
//  Created by dreamwings on 13.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class MatchViewController: MatchCenterViewController {
    
    override func matchViewDidLoad() {
        
        tableView.removeFromSuperview()
        statusBarView.removeFromSuperview()
        
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(MatchViewController.openLeft))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "МАТЧ"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = ""
    }
    
    var match = JSON.null
    
    var matchId: String? {
        didSet {
            if let id = matchId {
                view.addSubview(loadingView)
                loadingView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
                
                let URL = "http://api.kairat.com/game/\(id)"
                Models.fetchJSON(URL: URL, completionHandler: { (json) -> () in
                    
                    if json.count > 0 {
                        self.match = json
                        self.tableView.removeFromSuperview()
                        self.statusBarView.removeFromSuperview()
                        
                        self.setupTableView(inTop: false)
                        self.tableView.register(MatchHeader.self, forHeaderFooterViewReuseIdentifier: self.matchHeaderId)
                        self.tableView.register(MatchCell.self, forCellReuseIdentifier: self.matchCellId)
                        
                        self.loadingView.removeFromSuperview()
                    }
                })
            }
        }
    }
    
    let matchCellId = "matchCellId"
    let matchHeaderId = "matchHeaderId"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: matchCellId, for: indexPath) as! MatchCell
            
            if match.count > 0 {
                let score: String = match["info"]["score"].string!
                
                let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "31 августа, 22:00\n", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 12)]))
                attributedText.append(NSAttributedString(string: score, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 40)]))
                
                cell.aboutMatchLabel.attributedText = attributedText
                
                var url = URL(string: match["home"]["logo"].string!)
                cell.firstClubImageView.kf.setImage(with: url)
                url = URL(string: match["guest"]["logo"].string!)
                cell.secondClubImageView.kf.setImage(with: url)
                
                cell.firstClubNameLabel.text = match["home"]["name"].string!
                cell.secondClubNameLabel.text = match["guest"]["name"].string!
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
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: matchHeaderId) as! MatchHeader
            
            header.match = match

            
            return header
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let headerOrigin = scrollView.contentOffset.y/2
        
        if headerOrigin > 40 {
            
            if !isHeaderAnimated {
                let header = tableView.headerView(forSection: 1) as! MatchHeader
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MatchCell
                
                UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.statusBarView.backgroundColor = .black
                    header.tabBarMenuView.backgroundColor = .black
                    cell.foregroundView.backgroundColor = .black
                    self.navigationController?.navigationBar.backgroundColor = .black
                    
                }, completion: nil)
                
                isHeaderAnimated = true
                
            }
        }
        else if headerOrigin < 40 && isHeaderAnimated {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MatchCell
            let header = tableView.headerView(forSection: 1) as! MatchHeader
            
            UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.statusBarView.backgroundColor = .clear
                header.tabBarMenuView.backgroundColor = .clear
                cell.foregroundView.backgroundColor = .clear
                self.navigationController?.navigationBar.backgroundColor = .clear
            }, completion: nil)
            
            isHeaderAnimated = false
            
        }
    }

}
