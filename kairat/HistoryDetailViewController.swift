//
//  HistoryDetailViewController.swift
//  kairat
//
//  Created by Beka on 12/29/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class HistoryDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var table: UITableView!
    var message=JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setBG()
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "ИСТОРИЯ"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        navigationItem.titleView = titleLabel
        fon.image=#imageLiteral(resourceName: "fon").imageByCroppingImage(size: CGSize(width: 1200, height: 1200))
        table.backgroundColor=UIColor.clear
        table.estimatedRowHeight=140
        table.rowHeight=UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryDetaiViewlCell
        if message != nil{
            if let preview=message["preview"].string{
                cell.img.kf.setImage(with: URL.init(string: preview))
            }
            if let title=message["title"].string{
                cell.title.text=title
            }
            if let anons=message["anons"].string{
                cell.anons.text=anons
            }
            if let content=message["content"].string{
                cell.detail.text=content
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

class HistoryDetaiViewlCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var anons: UILabel!
    @IBOutlet weak var detail: UILabel!
    override func awakeFromNib() {
        
    }
    
}
