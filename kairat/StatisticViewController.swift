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
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var blur_top: NSLayoutConstraint!
    @IBOutlet weak var trans_top: NSLayoutConstraint!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var seasonView: UIView!
    @IBOutlet weak var seasonBtn: UIButton!
    var picker=UIPickerView()
    
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
    lazy var seasonButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 14).isActive = true
        button.titleLabel?.font = UIFont(name: "CenturyGothic", size: 16)
        button.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        button.setImage(UIImage(named: "strelkaa"), for: .normal)
        button.imageView!.transform = CGAffineTransform(rotationAngle: (270.0 * CGFloat(M_PI)) / 180.0)
        button.widthAnchor.constraint(equalToConstant: 94).isActive = true
        button.imageEdgeInsets = UIEdgeInsetsMake(4, 97, 4, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, -30)
        button.translatesAutoresizingMaskIntoConstraints=false
        return button
    }()
    let buttonBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    var trans_view:UIView={
        let v=UIView()
        v.backgroundColor=UIColor.white.withAlphaComponent(0.2)
        return v
    }()
    var lastContentOffset_x:CGFloat=0
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
        table.anchorWithConstantsToTop(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant:UIApplication.shared.statusBarFrame.height, leftConstant: 0, bottomConstant: 10, rightConstant: 0)
        table.contentInset=UIEdgeInsets(top: 20+(navigationController?.navigationBar.frame.height)!, left: 0, bottom: 0, right: 0)
        table.tableFooterView=UIView()
        table.backgroundColor=UIColor.clear
        table.estimatedRowHeight=100
        table.rowHeight=UITableViewAutomaticDimension
        collection.backgroundColor=UIColor.clear
        initializePicker()
        initializeYear()
        loadData()
        setup_menu()
    }
    
    let menuBtn=UIBarButtonItem()
    func open(_ sender: Any) {
        self.slideMenuController()?.toggleLeft()
    }
    func setup_menu(){
        let lBtn = UIButton()
        lBtn.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        lBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        lBtn.addTarget(self, action: #selector(open), for: .touchUpInside)
        menuBtn.customView=lBtn
        self.navigationItem.setLeftBarButtonItems([menuBtn], animated: false)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset_x==scrollView.contentOffset.x{
            let y=scrollView.contentOffset.y
            top.constant=0-(108+y)
            blur_top.constant=0-(64+y)
            trans_top.constant=0-(365+y)
        }else{
            lastContentOffset_x=scrollView.contentOffset.x
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
       
        seasonButton.addSubview(buttonBottomLine)
        buttonBottomLine.anchorWithConstantsToTop(top: nil, left: seasonButton.leftAnchor, bottom: seasonButton.bottomAnchor, right: seasonButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -2, rightConstant: 0)
        seasonView.addSubview(seasonButton)
        seasonButton.anchorToTop(seasonBtn.topAnchor, left: seasonBtn.leftAnchor, bottom: seasonBtn.bottomAnchor, right: seasonBtn.rightAnchor)
        seasonBtn.isHidden=true
        
    }
    func initializeYear(){
        let date = NSDate()
        let calendar = NSCalendar.current
        let y = calendar.component(.year, from: date as Date)
        for item in y-10...y+1 {
            year.append(String(item))
        }
        season=String(y)
        setTile(title: season)
        picker.reloadAllComponents()
    }
    func setTile(title:String){
        seasonButton.setTitle(title, for: .normal)
    }
    func showPicker(){
        if let index=year.index(where: {$0==season}){
              picker.selectRow(Int(index), inComponent: 0, animated: true)
        }
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: "", preferredStyle: .actionSheet)
        alertController.view.addSubview( picker)
        picker.anchorWithConstantsToTop(top: alertController.view.topAnchor, left: alertController.view.leftAnchor, bottom: nil, right: alertController.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler:  { void in
            
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler:  { void in
            self.setTile(title: self.season)
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
            cell.turnirTitle.textColor=UIColor(colorLiteralRed: 178/255, green: 28/255, blue: 31/255, alpha: 1)
            cell.turnirTitle.font=UIFont(name: "CenturyGothic-Bold", size: 14)
            cell.turnirImg.kf.setImage(with: URL.init(string: m.img_active))
        }else{
            cell.turnirTitle.textColor=UIColor.white
            cell.turnirTitle.font=UIFont(name: "CenturyGothic", size: 14)
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
        cell.backgroundColor=UIColor.clear
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

