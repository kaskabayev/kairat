//
//  ClubViewController.swift
//  kairat
//
//  Created by Beka on 12/13/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

protocol ViewControllerHelper {
    
    func pushViewController(viewController: UIViewController)
    
}

class ClubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerHelper {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setBG()
        navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = .black
        
        setupTableView(inTop: true)
        
        tableView.register(ClubHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(ClubCell.self, forCellReuseIdentifier: cellId)

    }
    
    func setupTableView(inTop: Bool) {
        view.addSubview(tableView)
        view.addSubview(statusBarView)
        
        if inTop {
            tableView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        }
        else {
            tableView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 64, leftConstant: 0, bottomConstant: 0, rightConstant: 0)

        }
        
        statusBarView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "КЛУБ"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = ""
    }
    
    @IBAction func open(_ sender: Any) {
        self.slideMenuController()?.toggleLeft()
    }
    
    let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    let headerId = "clubHeader"
    let cellId = "clubCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) 
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! ClubHeader
            
            header.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 33/255, alpha: 1)
            header.vcDelegate = self
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else {
            return view.frame.height - 64
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        }
        else {
            return 0
        }
    }
    
    var isHeaderAnimated = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let headerOrigin = scrollView.contentOffset.y/2
        
        if headerOrigin > 40 {
            let header = tableView.headerView(forSection: 1) as! ClubHeader

            if !isHeaderAnimated {
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ClubCell
                
                UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.statusBarView.backgroundColor = .black
                    header.tabBarMenuView.backgroundColor = .black
                    cell.foregroundView.backgroundColor = .black
                    self.navigationController?.navigationBar.backgroundColor = .black
                    
                }, completion: nil)
                
                isHeaderAnimated = true
                
            }
            
//            let bottomCVCell = header.tabCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! ClubMenuCell
//            
//            if headerOrigin >= 58 {
//                print("disable")
//                bottomCVCell.collectionView.isScrollEnabled = true
//            }
//            else {
//                print("enable")
//                bottomCVCell.collectionView.isScrollEnabled = false
//            }

        }
        else if headerOrigin < 40 && isHeaderAnimated {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ClubCell
            let header = tableView.headerView(forSection: 1) as! ClubHeader
            
            UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.statusBarView.backgroundColor = .clear
                header.tabBarMenuView.backgroundColor = .clear
                cell.foregroundView.backgroundColor = .clear
                self.navigationController?.navigationBar.backgroundColor = .clear
            }, completion: nil)
            
            isHeaderAnimated = false
            
        }
    }
    
    internal func pushViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

}


