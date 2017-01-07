//
//  CenterMatchViewController.swift
//  kairat
//
//  Created by Beka on 1/2/17.
//  Copyright © 2017 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class MatchModel{
    var country=""
    var info=JSON.null
    init() {
        
    }
}
protocol CenterMatchDelegate {
    func set(tag:Int)
}
class CenterMatchViewController: UIViewController,CenterMatchDelegate {

    var message=JSON.null
    var past=[MatchModel]()
    var future=[MatchModel]()
    
    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var seasonView: UIView!
    @IBOutlet weak var seasonBtn: UIButton!
    
    var index=0
    var selected_turnir_id=0
    var match_id=""
    let formatter = DateFormatter()
    var currentDate = Date()
    var loadingView:UIView={
        let l=UIView()
        l.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive=true
        l.backgroundColor=UIColor.black.withAlphaComponent(0.4)
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
        self.title="МАТЧ-ЦЕНТР"
        navigationController?.setBG()
        fon.image=#imageLiteral(resourceName: "fon").imageByCroppingImage(size: CGSize(width: 1200, height: 1200))
        table.backgroundColor=UIColor.clear
        collection.backgroundColor=UIColor.clear
        collection.isUserInteractionEnabled=true
        btn1.isSelected=true
        btn2.isSelected=true
        setup()
        formatter.dateFormat = "yyyy.MM.dd"
        loadData(date: formatter.string(from: currentDate))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func open(_ sender: Any) {
        self.toggleLeft()
    }
    func loadData(date:String){
        CustomRequests.getGames(view: self,loading: loadingView,data: date){
            response in
            if response != nil{
                self.seasonButton.setTitle(date, for: .normal)
                self.message=response
                self.get_turnir_match(id: 0)
            }
        }
    }
    func get_turnir_match(id:Int){
        if message != nil{
            self.collection.reloadData()
            self.past.removeAll()
            self.future.removeAll()
            for item2 in message[id]["games"].array!{
                let m=MatchModel()
                if let c=message[id]["name"].string{
                    m.country=c
                }
                m.info=item2
                if item2["status"].string=="finished"{
                    self.past.append(m)
                }else{
                    self.future.append(m)
                }
            }
//            self.past=JSON(message[id]["games"].array!.filter({$0["status"].string == "finished"}))
//            self.future=JSON(message[id]["games"].array!.filter({$0["status"].string == "wait"}))
            self.table.reloadData()
        }
    }
    var btn1:UIButton={
        let b=UIButton()
        b.tag=0
        b.setTitle("БУДУЩИЕ МАТЧИ", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor.red, for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var btn2:UIButton={
        let b=UIButton()
        b.tag=1
        b.setTitle("ПРОШЕДШИЕ МАТЧИ", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor.red, for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var indicator:UIView={
        let v=UIView()
        v.backgroundColor=UIColor.red
        v.heightAnchor.constraint(equalToConstant: 4).isActive=true
        v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    lazy var seasonButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 14).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(chooseDate), for: .touchUpInside)
        button.setImage(UIImage(named: "strelkaa"), for: .normal)
        button.imageView!.transform = CGAffineTransform(rotationAngle: (270.0 * CGFloat(M_PI)) / 180.0)
        button.widthAnchor.constraint(equalToConstant: 94).isActive = true
        button.imageEdgeInsets = UIEdgeInsetsMake(3, 97, 3, 0)
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
    func setup(){
        view.addSubview(loadingView)
        loadingViewHeght=NSLayoutConstraint(item: loadingView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)
        loadingView.addConstraint(loadingViewHeght!)
        loadingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        btn1.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        
        btn1.isSelected=true
        btn2.isSelected=false
        
        header.addSubview(btn1)
        header.addSubview(btn2)
        header.addSubview(indicator)
        
        indicator.anchorWithConstantsToTop(nil, left: header.leftAnchor, bottom: header.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        btn1.anchorWithConstantsToTop(nil, left: header.leftAnchor, bottom: indicator.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
        btn2.anchorWithConstantsToTop(nil, left: btn1.rightAnchor, bottom: indicator.topAnchor, right: header.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
        
        seasonButton.addSubview(buttonBottomLine)
        buttonBottomLine.anchorWithConstantsToTop(top: nil, left: seasonButton.leftAnchor, bottom: seasonButton.bottomAnchor, right: seasonButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -2, rightConstant: 0)
        seasonView.addSubview(seasonButton)
        seasonButton.anchorToTop(seasonBtn.topAnchor, left: seasonBtn.leftAnchor, bottom: seasonBtn.bottomAnchor, right: seasonBtn.rightAnchor)
        seasonBtn.isHidden=true
    }
    
    func chooseDate() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: "", preferredStyle: .actionSheet)
        
        alertController.view.addSubview(datePicker)
        
        datePicker.anchorWithConstantsToTop(top: alertController.view.topAnchor, left: alertController.view.leftAnchor, bottom: nil, right: alertController.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler:  { void in
            
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler:  { void in
            self.loadData(date: self.formatter.string(from: self.currentDate))
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        currentDate=sender.date
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y=scrollView.contentOffset.y
        if y>195{
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.navigationController?.setBG2()
            }, completion: nil)
            self.header.frame.origin.y=y+50
        }else{
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.navigationController?.setBG()
            }, completion: nil)
        }
    }
    internal func set(tag: Int) {
        index=tag
        setXPosition(tag: tag)
    }
    func setSelected(sender:UIButton){
       index=sender.tag
       setXPosition(tag: sender.tag)
    }
    func setXPosition(tag:Int){
        switch tag {
        case 0:
            btn1.isSelected=true
            btn2.isSelected=false
            indicator.frame.origin.x=0
            table.reloadData()
            break
        case 1:
            btn1.isSelected=false
            btn2.isSelected=true
            indicator.frame.origin.x=UIScreen.main.bounds.width*1/2
            table.reloadData()
            break
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier=="detail"{
            let dc=segue.destination as! MatchDetailViewController
            dc.match_id=match_id
        }
    }
}
extension CenterMatchViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected_turnir_id=indexPath.row
        get_turnir_match(id: selected_turnir_id)
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
        if message.isEmpty{
            return 0
        }
        return message.array!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MatchTurnirCell
        let m=message[indexPath.row]
        cell.turnirImg.image=#imageLiteral(resourceName: "k3")
        cell.turnirImg.layer.cornerRadius=50
        if indexPath.row==selected_turnir_id{
            cell.turnirTitle.textColor=UIColor.red
        }else{
            cell.turnirTitle.textColor=UIColor.white
        }
        if let name=m["name"].string{
            cell.turnirTitle.text=String(name)?.uppercased()
        }
        
        return cell
    }
}
class MatchTurnirCell:UICollectionViewCell{
    @IBOutlet weak var turnirImg: UIImageView!
    @IBOutlet weak var turnirTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        turnirImg.layer.cornerRadius=50
    }
}
extension CenterMatchViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if message != nil{
            if index==0{
                return future.count
            }
            return past.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CenterMatchCell
        
        cell.delegate=self
        cell.index=index
        
        var m:MatchModel
        if index==0{
            m=future[indexPath.row]
        }else{
            m=past[indexPath.row]
        }
        if let dtime=m.info["dtime"].string{
            let date=Date(timeIntervalSince1970: TimeInterval.init(dtime)!)
            let dateFormat=DateFormatter()
            dateFormat.locale=Locale(identifier: "ru")
            dateFormat.dateFormat="d MMMM,HH:mm"
            cell.data.text=dateFormat.string(from: date)
        }
        
        if let score=m.info["info"]["score"].string{
           cell.score.text=String(score)?.replacingOccurrences(of: "-", with: ":")
        }
        
        cell.turnir.text=m.country
        
        if let name=m.info["home"]["name"].string{
            cell.name1.text=name
        }
        if let logo=m.info["home"]["logo"].string{
            cell.img1.kf.indicatorType = .activity
            UIImageView().kf.setImage(with: URL.init(string: logo),completionHandler: {
                (image, error, cacheType, imageUrl) in
                if image != nil{
                    cell.img1.image=image?.imageByCroppingImage(size: CGSize(width: 140, height: 140))
                }
            })
        }
        
        if let name=m.info["guest"]["name"].string{
            cell.name2.text=name
        }
        if let logo=m.info["guest"]["logo"].string{
            cell.img2.kf.indicatorType = .activity
            UIImageView().kf.setImage(with: URL.init(string: logo),completionHandler: {
                (image, error, cacheType, imageUrl) in
                if image != nil{
                    cell.img2.image=image?.imageByCroppingImage(size: CGSize(width: 140, height: 140))
                }
            })
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var m:MatchModel
        if index==0{
            m=future[indexPath.row]
        }else{
            m=past[indexPath.row]
        }
        if let id=m.info["id"].string{
            match_id=id
            performSegue(withIdentifier: "detail", sender: self)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.clear
    }
}
class CenterMatchCell:UITableViewCell{
    
    var index=0
    var delegate:CenterMatchDelegate?
    
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var turnir: UILabel!
    
    override func awakeFromNib() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeLeft)
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if index>0{
                    index-=1
                }
                delegate?.set(tag: index)
                break
            case UISwipeGestureRecognizerDirection.left:
                if index<1{
                    index+=1
                }
                delegate?.set(tag: index)
                break
            default:
                break
            }
        }
    }
}
