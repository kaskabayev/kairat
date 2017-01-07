//
//  StatisticViewController.swift
//  kairat
//
//  Created by Beka on 12/6/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import  Kingfisher

class Turnir{
    
    var id=""
    var name=""
    var country=""
    var logo=""
    var data=JSON.null
    var img=""
    var img_active=""
    init() {
        
    }
}
class StatisticViewController: UIViewController {
    
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var seasonBtn: UIButton!
    var picker=UIPickerView()
    
    let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: "", preferredStyle: .actionSheet)
    
    var turnir_model=[Turnir]()
    var turnirs=JSON.null
    var message=JSON.null
    var message_keys=[String]()
    var selected_turnir_id=0
    var turnir_id="233"
    var season="2017"
    
    var year=[String]()
    var refreshControl: UIRefreshControl!
    var loadingView:UIView={
        let l=UIView()
        l.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive=true
        l.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        l.translatesAutoresizingMaskIntoConstraints=false
        let activity=UIActivityIndicatorView()
        activity.startAnimating()
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.translatesAutoresizingMaskIntoConstraints=false
        l.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: l.centerXAnchor).isActive=true
        activity.centerYAnchor.constraint(equalTo: l.centerYAnchor).isActive=true
        l.isHidden=false
        return l
    }()
    var loadingViewHeght:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="ТАБЛИЦА"
        self.navigationController?.setBG()
        self.view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)
        fon.image=#imageLiteral(resourceName: "fon").imageByCroppingImage(size: CGSize(width: 1200, height: 1200))
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        seasonBtn.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        table.addSubview(refreshControl)
        table.translatesAutoresizingMaskIntoConstraints=false
        table.anchorWithConstantsToTop(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant:UIApplication.shared.statusBarFrame.height, leftConstant: 10, bottomConstant: 10, rightConstant: 10)
        table.contentInset=UIEdgeInsets(top: 20+(navigationController?.navigationBar.frame.height)!, left: 0, bottom: 0, right: 0)
        table.tableFooterView=UIView()
        table.backgroundColor=UIColor.clear
        table.estimatedRowHeight=100
        table.rowHeight=UITableViewAutomaticDimension
        collection.backgroundColor=UIColor.clear
        initializePicker()
        initializeYear()
        loadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y=scrollView.contentOffset.y
        if y>collection.frame.origin.y{
            self.navigationController?.setBG2()
        }else{
            self.navigationController?.setBG()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        CustomRequests.getAllTurnir(view: self,loading: loadingView){
            response in
            if response != nil{
                for item in response.array!{
                    let turnir=Turnir()
                    if let id=item["id"].string{
                        turnir.id=id
                    }
                    if let name=item["name"].string{
                        turnir.name=String(name).uppercased()
                    }
                    if let button=item["button"].string{
                        turnir.img=button
                    }
                    if let button_active=item["button_active"].string{
                        turnir.img_active=button_active
                    }
                    turnir.data=item["table"][0]["data"]
                    self.turnir_model.append(turnir)
                }
                self.get_turnir_data(id: self.selected_turnir_id)
            }
        }
    }
    func get_turnir_data(id:Int){
        self.message=JSON.null
        self.message_keys.removeAll()
        self.message=self.turnir_model[id].data
        let d=self.message.dictionaryValue
        for key in d.keys{
            self.message_keys.append(key)
        }
        self.collection.reloadData()
        self.table.reloadData()
    }
    func initializePicker(){
        view.addSubview(loadingView)
        loadingViewHeght=NSLayoutConstraint(item: loadingView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)
        loadingView.addConstraint(loadingViewHeght!)
        loadingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        picker.delegate=self
        picker.dataSource=self
        alertController.view.addSubview( picker)
        picker.anchorWithConstantsToTop(top: alertController.view.topAnchor, left: alertController.view.leftAnchor, bottom: nil, right: alertController.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler:  { void in
            
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler:  { void in
            self.setTile(title: self.season)
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
    }
    func initializeYear(){
        let date = NSDate()
        let calendar = NSCalendar.current
        let y = calendar.component(.year, from: date as Date)
        for item in y-10...y+1 {
            year.append(String(item))
        }
        season=String(y+1)
        setTile(title: season)
    }
    func setTile(title:String){
        seasonBtn.setAttributedTitle(NSAttributedString(string: title, attributes: [NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue,NSForegroundColorAttributeName:UIColor.white]), for: .normal)
    }
    func showPicker(){
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func open(_ sender: Any) {
        self.slideMenuController()?.toggleLeft()
    }
}

extension StatisticViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return year.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return year[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        season=year[row]
    }
}

extension StatisticViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.turnir_id=turnir_model[indexPath.row].id
        self.selected_turnir_id=indexPath.row
        get_turnir_data(id: selected_turnir_id)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.clear
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if turnir_model.isEmpty{
            return 0
        }
        return turnir_model.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TurnirCell
        let m=turnir_model[indexPath.row]
        if indexPath.row==selected_turnir_id{
            cell.turnirTitle.textColor=UIColor.red
            cell.turnirImg.kf.setImage(with: URL.init(string: m.img_active))
        }else{
            cell.turnirTitle.textColor=UIColor.white
            cell.turnirImg.kf.setImage(with: URL.init(string: m.img))
        }
        cell.turnirTitle.text=m.name
        return cell
    }
}

class TurnirCell:UICollectionViewCell{
    @IBOutlet weak var turnirImg: UIImageView!
    @IBOutlet weak var turnirTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        turnirImg.layer.cornerRadius=50
    }
}

extension StatisticViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if message_keys.isEmpty{
            return 1
        }
        return message_keys.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if message_keys.isEmpty{
            return 1
        }
        return message[message_keys[section]].array!.count+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message_keys.isEmpty{
            let cell=tableView.dequeueReusableCell(withIdentifier: "empty", for: indexPath)
            return cell
        }else{
            if indexPath.row==0{
                let cell=tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as! StatisticCell
                cell.title.text=message_keys[indexPath.section]
                return cell
                
            }else{
                let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatisticCell
                let m=message[message_keys[indexPath.section]][indexPath.row-1]
                if let title=m["title"].string{
                    cell.title.text=title
                }
                if let games=m["games"].string{
                    cell.games.text=games
                }
                if let win=m["win"].string{
                    cell.win.text=win
                }
                if let draw=m["draw"].string{
                    cell.draw.text=draw
                }
                if let lose=m["lose"].string{
                    cell.lose.text=lose
                }
                if let fgoal=m["fgoal"].string{
                    cell.fgoal.text=fgoal
                }
                if let agoal=m["agoal"].string{
                    cell.agoal.text=agoal
                }
                if let points=m["points"].string{
                    cell.points.text=points
                }
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let view=UIView()
        view.backgroundColor=UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.white
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if message.isEmpty{
            return 70
        }
        return UITableViewAutomaticDimension
    }
}

class StatisticCell:UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var games: UILabel!
    @IBOutlet weak var win: UILabel!
    @IBOutlet weak var draw: UILabel!
    @IBOutlet weak var lose: UILabel!
    @IBOutlet weak var fgoal: UILabel!
    @IBOutlet weak var agoal: UILabel!
    @IBOutlet weak var points: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

