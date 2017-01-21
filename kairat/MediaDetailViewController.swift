//
//  MediaDetailViewController.swift
//  kairat
//
//  Created by beka on 1/20/17.
//  Copyright © 2017 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON

class MediaDetailViewController: UIViewController {

    var message=JSON.null
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var blur: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="МЕДИА"
        
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
        view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)
        fon.image=#imageLiteral(resourceName: "fon").imageByCroppingImage(size: CGSize(width: 1200, height: 1200))
        table.backgroundColor=UIColor.clear
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MediaDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if message["items"].count>0{
            return message.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message.count==0{
            let cell=tableView.dequeueReusableCell(withIdentifier: "empty", for: indexPath)
            return cell
        }
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MediaCell
        
        let m=message["items"][indexPath.section]
        
        if let thumb=m["thumb"].string{
            cell.img.kf.setImage(with: URL.init(string: thumb))
        }
        if let title=m["title"].string{
            cell.title.text=title
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m=message["items"][indexPath.section]
        if let src=m["src"].string{
            UIApplication.shared.openURL(URL.init(string: src)!)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if message.count==0{
            cell.backgroundColor=UIColor.white
        }else{
            cell.backgroundColor=UIColor.clear
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if message.count==0{
            return 70
        }
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view=UIView()
        view.backgroundColor=UIColor.clear
        return view
    }
}
