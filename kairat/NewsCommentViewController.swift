//
//  NewsCommentViewController.swift
//  kairat
//
//  Created by Beka on 12/5/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class NewsCommentViewController: UIViewController,UITextFieldDelegate {
    
    var message=JSON.null
    var id=""
    @IBOutlet weak var fon: UIImageView!
    var blur:UIBlurEffect?
    let blurView = UIVisualEffectView()
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var addComm: UIView!
    var loadingView:UIView={
        let l=UIView()
        l.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive=true
        l.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive=true
        l.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        l.translatesAutoresizingMaskIntoConstraints=false
        let activity=UIActivityIndicatorView()
        activity.startAnimating()
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.translatesAutoresizingMaskIntoConstraints=false
        l.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: l.centerXAnchor).isActive=true
        activity.centerYAnchor.constraint(equalTo: l.centerYAnchor).isActive=true
        l.isHidden=true
        return l
    }()
    
    let textField:UITextField={
        let t=UITextField()
        t.placeholder="Напишите комментарий"
        t.backgroundColor=UIColor.white
        t.borderStyle = .roundedRect
        t.returnKeyType = .send
        t.translatesAutoresizingMaskIntoConstraints=false
        return t
    }()
    let toolBar:UIToolbar={
        let t=UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        return t
    }()
    @IBOutlet weak var bottomAnchor: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="КОММЕНТАРИИ"
        self.navigationController?.setBG()
        self.view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)
        blur=UIBlurEffect(style: .light)
        blurView.effect=blur
        self.blurView.frame = fon.bounds
        self.blurView.alpha=0.8
        self.blurView.translatesAutoresizingMaskIntoConstraints=false
        self.view.insertSubview(blurView, belowSubview: commentTable)
        blurView.anchorWithConstantsToTop(top: self.fon.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor , topConstant: (self.navigationController?.navigationBar.frame.height)!, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        commentTable.translatesAutoresizingMaskIntoConstraints=false
        commentTable.anchorWithConstantsToTop(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 30+(navigationController?.navigationBar.bounds.size.height)!, leftConstant: 10, bottomConstant: 60, rightConstant: 10)
        commentTable.tableFooterView=UIView()
        commentTable.backgroundColor=UIColor.clear
        commentTable.estimatedRowHeight=100
        commentTable.rowHeight=UITableViewAutomaticDimension
        setupTextField()
    }
    
    func addLove(){
        if UserDefaults.standard.isLoggedIn(){
            
        }else{
            let data=message.rawString(.utf8, options: .prettyPrinted)!
            if let id=message["id"].string{
                UserDefaults.standard.setNewFav(data, key: id)
            }
        }
    }
    
    func removeLove(){
        if UserDefaults.standard.isLoggedIn(){
            
        }else{
            let data=message.rawString(.utf8, options: .prettyPrinted)!
            if let id=message["id"].string{
                UserDefaults.standard.setNewFav(data, key: id)
            }
        }
    }
    
    func setupTextField(){
        view.addSubview(loadingView)
        loadingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        toolBar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissKeyboard))
        ]
        textField.inputAccessoryView=toolBar
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addComm.addSubview(textField)
        textField.centerYAnchor.constraint(equalTo: addComm.centerYAnchor).isActive=true
        textField.leftAnchor.constraint(equalTo: addComm.leftAnchor, constant: 10).isActive=true
        textField.rightAnchor.constraint(equalTo: addComm.rightAnchor, constant: -10).isActive=true
        textField.delegate=self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if UserDefaults.standard.isLoggedIn() != true{
            let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                (result:UIAlertAction)->Void in
                
            }
            self.showAlert(msg: "Вы не авторизованы", actions: [cancel])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if UserDefaults.standard.isLoggedIn(){
            textField.resignFirstResponder()
            if let text=textField.text{
                textField.text=""
                CustomRequests.sendComment(view: self, loading: loadingView, id: id, body: text){
                    response in
                    if response["status"].string == "ok"{
                        CustomRequests.getComment(view: self, loading: self.loadingView, id: self.id){
                            response2 in
                            if response != nil{
                                self.message=response2
                                self.commentTable.reloadData()
                            }
                        }
                    }else{
                        let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                            (result:UIAlertAction)->Void in
                            
                        }
                        self.showAlert(msg: "Произошла ошибка. Повторите попытку", actions: [cancel])
                    }
                }
            }
            return true
        }
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(aNotification: NSNotification) {
        var info = aNotification.userInfo!
        let kbSize = info[UIKeyboardFrameBeginUserInfoKey] as! CGRect
        let rate = info[UIKeyboardAnimationDurationUserInfoKey] as! CFloat
        UIView.animate(withDuration: TimeInterval(rate), animations: {() -> Void in
            self.bottomAnchor.constant=kbSize.height
            self.loadViewIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: TimeInterval(1), animations: {() -> Void in
            self.bottomAnchor.constant=0
            self.loadViewIfNeeded()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NewsCommentViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (message.array?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCommentCell
        
        let m=message[indexPath.row]
        if let url=m["author"]["thumb"].string{
            cell.avatar.kf.setImage(with: URL.init(string:url))
            
        }
        if let dtime=m["dtime"].string{
            let date=Date(timeIntervalSince1970: TimeInterval.init(dtime)!)
            let dateFormat=DateFormatter()
            dateFormat.locale=Locale(identifier: "ru")
            dateFormat.dateFormat="d MMMM,HH:mm"
            cell.dateTxt.text=dateFormat.string(from: date)
        }
        if let author=m["author"]["name"].string{
            cell.author.text=author
        }
        if let body=m["body"].string{
            cell.content.text=body
        }
        if let rate=m["author"]["rate"].string{
            cell.rate.text=rate
        }
        return cell
    }
    
}

extension NewsCommentViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

class NewsCommentCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var dateTxt: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var minus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
