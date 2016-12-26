//
//  SettingsViewController.swift
//  kairat
//
//  Created by Beka on 12/5/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="НАСТРОЙКИ"
        self.navigationController?.setBG()
        view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)
        table.alwaysBounceVertical=false
        table.backgroundColor=UIColor.clear
        table.tableFooterView=UIView()
        table.translatesAutoresizingMaskIntoConstraints=false
        table.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20+(navigationController?.navigationBar.bounds.size.height)!, leftConstant: 0, bottomConstant: 20, rightConstant: 0)
        table.separatorStyle = .none
        table.rowHeight=70
        table.estimatedRowHeight=UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func open(_ sender: Any) {
        self.slideMenuController()?.toggleLeft()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if segue.identifier=="showAuth"{
        }
    }
}

extension SettingsViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=SettingsCell(style: .subtitle, reuseIdentifier: "")
        let strelka=UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 14))
        strelka.image=#imageLiteral(resourceName: "strelkaa")
        strelka.transform=CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 180.0)
        cell.accessoryView=strelka
        switch indexPath.row {
        case 0:
            cell.imageView?.image=#imageLiteral(resourceName: "settings_user")
            cell.textLabel?.text="Профиль"
            cell.detailTextLabel?.text="Войдите или зарегистрируйтесь"
            break
        case 1:
            cell.imageView?.image=#imageLiteral(resourceName: "settings_star")
            cell.textLabel?.text="Оцените приложение"
            let fullString = NSMutableAttributedString(string: "")
            for _ in 1...5{
                let image1Attachment = NSTextAttachment()
                image1Attachment.image = #imageLiteral(resourceName: "favs")
                image1Attachment.bounds=CGRect(x: 0, y: -5, width: 15, height: 15)
                let image1String = NSAttributedString(attachment: image1Attachment)
                fullString.append(image1String)
            }
            cell.detailTextLabel?.attributedText=fullString
            break
        case 2:
            cell.selectionStyle = .none
            cell.accessoryView=UIView()
            cell.imageView?.image=#imageLiteral(resourceName: "settings_info")
            cell.textLabel?.text="О приложении"
            cell.detailTextLabel?.text="Официальное мобильное приложение футзал клуба Кайрат"
            cell.selectionStyle = .none
            cell.accessoryType = .none
            break
        default:
            break
        }
        return cell
    }
}

extension SettingsViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showAuth", sender: self)
            break
        case 1:
            UIApplication.shared.open(URL.init(string: "")!, options: [:], completionHandler: nil)
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v=UIView()
        v.backgroundColor=UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}

class SettingsCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
        self.tintColor=UIColor.white
        self.textLabel?.textColor=UIColor.white
        self.detailTextLabel?.textColor=UIColor.gray
        self.detailTextLabel?.numberOfLines=0
        self.detailTextLabel?.font=UIFont(name: "Century Gothic", size: 11)
        
        self.imageView?.frame=CGRect(x: 15, y: 15, width: 45, height: 45)
        self.textLabel?.frame.origin=CGPoint(x: 70, y: 15)
        self.detailTextLabel?.frame.origin=CGPoint(x: 70, y: 20+Int((self.textLabel?.bounds.height)!))
    }
}