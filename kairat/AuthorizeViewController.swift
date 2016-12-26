//
//  AuthorizeViewController.swift
//  kairat
//
//  Created by Beka on 12/6/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

protocol AuthorizeDelegate {
    func scroll(point:CGPoint)
}
class AuthorizeViewController: UIViewController,AuthorizeDelegate {
    
    internal func scroll(point: CGPoint) {
        self.table.contentOffset.y=point.y
    }


    @IBOutlet weak var fon: UIImageView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
   
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
        l.isHidden=true
        return l
    }()
    var loadingViewHeght:NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingView)
        loadingViewHeght=NSLayoutConstraint(item: loadingView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)
        loadingView.addConstraint(loadingViewHeght!)
        loadingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        self.title="АВТОРИЗАЦИЯ"
        self.navigationController?.setBG()
        view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)

        table.rowHeight=UIScreen.main.bounds.height-fon.bounds.height
        table.estimatedRowHeight=UITableViewAutomaticDimension
        table.backgroundColor=UIColor.clear
        table.tableFooterView=UIView()
        table.translatesAutoresizingMaskIntoConstraints=false
        table.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20+(navigationController?.navigationBar.bounds.size.height)!, leftConstant: 0, bottomConstant: 20, rightConstant: 0)
        table.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AuthorizeViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AuthCell
        cell.parent=self
        cell.loading=loadingView
        return cell
    }
    
}

extension AuthorizeViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v=UIView()
        v.backgroundColor=UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height-fon.bounds.height+50
    }
}

class AuthCell: UITableViewCell {
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var collection: UICollectionView!
    
    var parent:AuthorizeViewController?
    var loading:UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collection.backgroundColor=UIColor.clear
        collection.showsVerticalScrollIndicator=false
        collection.showsHorizontalScrollIndicator=false
        if UserDefaults.standard.isLoggedIn()==false{
            setup()
        }
    }
    
    func setup(){
        logBtn.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        regBtn.addTarget(self, action: #selector(setSelected(sender:)), for: .touchUpInside)
        
        logBtn.isSelected=true
        regBtn.isSelected=true

        header.addSubview(logBtn)
        header.addSubview(regBtn)
        header.addSubview(indicator)
        
        indicator.anchorWithConstantsToTop(nil, left: header.leftAnchor, bottom: header.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        logBtn.anchorWithConstantsToTop(nil, left: header.leftAnchor, bottom: indicator.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
        regBtn.anchorWithConstantsToTop(nil, left: nil, bottom: indicator.topAnchor, right: header.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0)
    }
    
    func setSelected(sender:UIButton){
        if sender.tag==0{
            logBtn.isSelected=true
            regBtn.isSelected=false
            collection.setContentOffset(CGPoint.zero, animated: true)
        }else{
            logBtn.isSelected=false
            regBtn.isSelected=true
            collection.setContentOffset(CGPoint(x:UIScreen.main.bounds.width, y: 0), animated: true)
        }
    }
    
    var logBtn:UIButton={
        let b=UIButton()
        b.tag=0
        b.setTitle("ВОЙТИ", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor.red, for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var regBtn:UIButton={
        let b=UIButton()
        b.tag=1
        b.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x=scrollView.contentOffset.x
        indicator.frame.origin.x=x/2
        if x/2>indicator.frame.width/2{
            regBtn.isSelected=true
            logBtn.isSelected=false
        }else{
            logBtn.isSelected=true
            regBtn.isSelected=false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension AuthCell:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.clear
        logBtn.isSelected=true
        regBtn.isSelected=false
    }
    
}

extension AuthCell:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
}

extension AuthCell:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserDefaults.standard.isLoggedIn(){
            return 1
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if UserDefaults.standard.isLoggedIn(){
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "authCell", for: indexPath) as! AuthorizedCell
            cell.parent=parent
            cell.loading=loading
            return cell
        }else{
            switch indexPath.row {
            case 0:
                let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "loginCell", for: indexPath) as! LoginCell
                cell.parent=parent
                cell.loading=loading
                cell.delegate=parent
                return cell
            case 1:
                let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "registerCell", for: indexPath) as! RegisterCell
                cell.parent=parent
                cell.loading=loading
                cell.delegate=parent
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
}


class LoginCell: UICollectionViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var gBtn: UIButton!
    @IBOutlet weak var vBtn: UIButton!
    @IBOutlet weak var fBtn: UIButton!
    
    var delegate:AuthorizeDelegate?
    
    var parent:UIViewController?
    var loading:UIView?
    let toolBar:UIToolbar={
        let t=UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        return t
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        toolBar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissKeyboard))
        ]
        email.inputAccessoryView=toolBar
        email.attributedPlaceholder = NSAttributedString(string:"Ваш e-mail",attributes:[NSForegroundColorAttributeName: UIColor.gray])
        pass.inputAccessoryView=toolBar
        pass.attributedPlaceholder = NSAttributedString(string:"Пароль",attributes:[NSForegroundColorAttributeName: UIColor.gray])
        loginBtn.layer.borderColor=UIColor.white.cgColor
        loginBtn.layer.borderWidth=2
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        vBtn.addTarget(self, action: #selector(vkAuth(sender:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(loginEvent(sender:)), name: NSNotification.Name(rawValue: "loginEvent"), object: nil)
    }
    
    func dismissKeyboard() {
        parent?.view.endEditing(true)
        delegate?.scroll(point: CGPoint.zero)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let point=textField.frame.origin
        delegate?.scroll(point: point)
    }

    func vkAuth(sender:UIButton){
        
    }
    
    func loginEvent(sender:NSNotification){
        let l=(sender.object as! [String:String])["login"]
        let p=(sender.object as! [String:String])["pass"]
        CustomRequests.login(view:parent!, loading: loading!, login: l!, pass: p!){
            response in
            if response != nil{
                if response["status"].string=="ok"{
                    let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                        (result:UIAlertAction)->Void in
                        UserDefaults.standard.setIsLoggedIn(true)
                        var model=[String:String]()
                        if let id=response["id"].string{
                            model["id"]=id
                        }
                        if let login=response["login"].string{
                            model["login"]=login
                        }
                        if let token=response["token"].string{
                            model["token"]=token
                        }
                        UserDefaults.standard.setInfo(model)
                        self.parent?.navigationController?.popViewController(animated: true)
                    }
                    self.parent?.showAlert(msg: "Вы успешно авторизовались", actions: [cancel])
                }else{
                    let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                        (result:UIAlertAction)->Void in
                        
                    }
                    self.parent?.showAlert(msg: "Вы ввели неправильный пароль/логин", actions: [cancel])
                }
            }
        }
    }
    
    func login(){
        CustomRequests.login(view:parent!, loading: loading!, login: email.text!, pass: pass.text!){
            response in
            if response != nil{
                if response["status"].string=="ok"{
                    let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                        (result:UIAlertAction)->Void in
                        UserDefaults.standard.setIsLoggedIn(true)
                        var model=[String:String]()
                        if let id=response["id"].string{
                            model["id"]=id
                        }
                        if let login=response["login"].string{
                            model["login"]=login
                        }
                        if let token=response["token"].string{
                            model["token"]=token
                        }
                        UserDefaults.standard.setInfo(model)
                        self.parent?.navigationController?.popViewController(animated: true)
                    }
                    self.parent?.showAlert(msg: "Вы успешно авторизовались", actions: [cancel])
                }else{
                    let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                        (result:UIAlertAction)->Void in
                        
                    }
                    self.parent?.showAlert(msg: "Вы ввели неправильный пароль/логин", actions: [cancel])
                }
            }
        }
    }
}

class RegisterCell: UICollectionViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var login: CustomTextField!
    @IBOutlet weak var name: CustomTextField!
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var pass: CustomTextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    var delegate:AuthorizeDelegate?
    
    var parent:UIViewController?
    var loading:UIView?
    let toolBar:UIToolbar={
        let t=UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        return t
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        toolBar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissKeyboard))
        ]
        login.inputAccessoryView=toolBar
        login.attributedPlaceholder = NSAttributedString(string:"Логин",attributes:[NSForegroundColorAttributeName: UIColor.gray])
        name.inputAccessoryView=toolBar
        name.attributedPlaceholder = NSAttributedString(string:"Имя",attributes:[NSForegroundColorAttributeName: UIColor.gray])
        email.inputAccessoryView=toolBar
        email.attributedPlaceholder = NSAttributedString(string:"Ваш e-mail",attributes:[NSForegroundColorAttributeName: UIColor.gray])
        pass.inputAccessoryView=toolBar
        pass.attributedPlaceholder = NSAttributedString(string:"Пароль",attributes:[NSForegroundColorAttributeName: UIColor.gray])
        registerBtn.layer.borderColor=UIColor.white.cgColor
        registerBtn.layer.borderWidth=2
        registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
    }
    
    func dismissKeyboard() {
        parent?.view.endEditing(true)
        delegate?.scroll(point: CGPoint.zero)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let point=textField.frame.origin
        delegate?.scroll(point: point)
    }
    
    func register(){
        CustomRequests.register(view:parent!, loading: loading!, login: login.text!, pass: pass.text!,email: email.text!){
            response in
            if response != nil{
                if response["status"].string=="ok"{
                    let cancel=UIAlertAction(title: "Войти", style: .destructive){
                        (result:UIAlertAction)->Void in
                        let msg=["login":self.login.text,"pass":self.pass.text]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginEvent"), object: msg, userInfo: nil)
                    }
                    self.parent?.showAlert(msg: "Вы успешно зарегистрировались", actions: [cancel])
                }else{
                    if let err=response["message"].string{
                        let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                            (result:UIAlertAction)->Void in
                        }
                        self.parent?.showAlert(msg: err, actions: [cancel])
                    }else{
                        let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                            (result:UIAlertAction)->Void in
                        }
                        self.parent?.showAlert(msg: "Повторите попытку", actions: [cancel])
                    }
                }
            }
        }
    }

}

class AuthorizedCell: UICollectionViewCell {
    
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var logutBtn: UIButton!
    var parent:UIViewController?
    var loading:UIView?
    override func layoutSubviews() {
        super.layoutSubviews()
        email.textAlignment = .center
        let info=UserDefaults.standard.getInfo()
        if info.isEmpty==false{
            email.attributedText = NSAttributedString(string:info["login"]!,attributes:[NSForegroundColorAttributeName: UIColor.white])
        }else{
            let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                (result:UIAlertAction)->Void in
                UserDefaults.standard.setIsLoggedIn(false)
                UserDefaults.standard.setInfo([:])
                self.parent?.navigationController?.popViewController(animated: true)
            }
            self.parent?.showAlert(msg: "Ошибка! Авторизуйтесь снова", actions: [cancel])
        }
        logutBtn.layer.borderColor=UIColor.white.cgColor
        logutBtn.layer.borderWidth=2
        logutBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    func logout(){
        UserDefaults.standard.setIsLoggedIn(false)
        UserDefaults.standard.setInfo([:])
        self.parent?.navigationController?.popViewController(animated: true)
    }
}
