//
//  MenuViewController.swift
//  kairat
//
//  Created by Beka on 12/25/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

var selectedIndex = 0
class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let menuItems=["НОВОСТИ","МАТЧ-ЦЕНТР","ТАБЛИЦА","МЕДИА","О КЛУБЕ","ИЗБРАННОЕ","НАСТРОЙКИ"]
    let menuIcons=["news","match","stats","media","kairat","favs","setting"]
    
    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView=UIView()
        self.tableView.backgroundColor=UIColor.clear
        self.tableView.separatorStyle = .none
        self.tableView.alwaysBounceVertical=false
        fon.image=#imageLiteral(resourceName: "kairatt").imageByCroppingImage(size: CGSize(width: 1000, height: 1000))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        
        if selectedIndex==indexPath.row{
            cell.isSelectedRow=true
            cell.icon.image=UIImage(named: menuIcons[indexPath.row]+"_active")
        }else{
            cell.isSelectedRow=false
            cell.icon.image=UIImage(named: menuIcons[indexPath.row])
        }
        cell.title.text=menuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view=UIView()
        view.backgroundColor=UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        switch indexPath.row {
        case 0:
            tableView.reloadData()
            if let controller=self.storyboard?.instantiateViewController(withIdentifier: "News"){
                self.slideMenuController()?.changeMainViewController(controller, close: true)
            }
            break
        case 1:
            tableView.reloadData()
            if let controller=self.storyboard?.instantiateViewController(withIdentifier: "Match"){
                self.slideMenuController()?.changeMainViewController(controller, close: true)
            }
            break
        case 2:
            tableView.reloadData()
            if let controller=self.storyboard?.instantiateViewController(withIdentifier: "Statistic"){
                self.slideMenuController()?.changeMainViewController(controller, close: true)
            }
            break
        case 3:
            tableView.reloadData()
            if let controller=self.storyboard?.instantiateViewController(withIdentifier: "Media"){
                self.slideMenuController()?.changeMainViewController(controller, close: true)
            }
            break
        case 4:
            tableView.reloadData()
            if let controller=self.storyboard?.instantiateViewController(withIdentifier: "Club"){
                self.slideMenuController()?.changeMainViewController(controller, close: true)
            }
            break
        case 5:
            tableView.reloadData()
            if let controller=self.storyboard?.instantiateViewController(withIdentifier: "News"){
                self.slideMenuController()?.changeMainViewController(controller, close: true)
            }
            break
        case 6:
            tableView.reloadData()
            if let controller=self.storyboard?.instantiateViewController(withIdentifier: "Settings"){
                self.slideMenuController()?.changeMainViewController(controller, close: true)
            }
            break
        default:
            break
        }
    }
}

class MenuCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    var isSelectedRow:Bool?{
        didSet{
            title.textColor = isSelectedRow! ? UIColor(colorLiteralRed: 178/255, green: 28/255, blue: 31/255, alpha: 1) : UIColor(colorLiteralRed: 232/255, green: 232/255, blue: 230/255, alpha: 1)
            setupViews()
        }
    }
    
    var icon:UIImageView={
        let i=UIImageView()
        i.contentMode = .scaleAspectFit
        i.clipsToBounds = true
        i.widthAnchor.constraint(equalToConstant: 13).isActive=true
        i.heightAnchor.constraint(equalToConstant: 15).isActive=true
        i.translatesAutoresizingMaskIntoConstraints=false
        return i
    }()
    
    var title:UILabel={
        let l=UILabel()
        l.font=UIFont(name: "CenturyGothic-Bold", size: 16)
        l.translatesAutoresizingMaskIntoConstraints=false
        return l
    }()
    
    func setupViews() {
        addSubview(icon)
        addSubview(title)
        
        icon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 27).isActive=true
        icon.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive=true
        title.anchorWithConstantsToTop(nil, left: icon.rightAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 5, rightConstant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
