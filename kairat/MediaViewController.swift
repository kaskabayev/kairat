//
//  MediaViewController.swift
//  kairat
//
//  Created by Beka on 12/9/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import INSPhotoGallery

class MediaViewController: UIViewController {

    var image_message=JSON.null
    var video_message=JSON.null
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var fon: UIImageView!
    var blur:UIBlurEffect?
    let blurView = UIVisualEffectView()
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var collection: UICollectionView!
    
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
        l.isHidden=true
        return l
    }()
    var loadingViewHeght:NSLayoutConstraint?
    var logBtn:UIButton={
        let b=UIButton()
        b.tag=0
        b.setTitle("ФОТО", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic Bold", size: 12)
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
        b.setTitle("ВИДЕО", for: .normal)
        b.titleLabel?.font=UIFont(name: "Century Gothic Bold", size: 12)
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
        v.heightAnchor.constraint(equalToConstant: 3).isActive=true
        v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title="МЕДИА"
        self.navigationController?.setBG()
        view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)
        
        blur=UIBlurEffect(style: .light)
        blurView.effect=blur
        self.blurView.frame = fon.bounds
        self.blurView.alpha=0.8
        self.blurView.translatesAutoresizingMaskIntoConstraints=false
        self.view.insertSubview(blurView, belowSubview: header)
        blurView.anchorWithConstantsToTop(top: self.fon.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor , topConstant: (self.navigationController?.navigationBar.frame.height)!+header.frame.height, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        header.translatesAutoresizingMaskIntoConstraints=false
        header.anchorWithConstantsToTop(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20+(navigationController?.navigationBar.bounds.size.height)!, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        header.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        collection.translatesAutoresizingMaskIntoConstraints=false
        collection.anchorWithConstantsToTop(header.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        collection.backgroundColor=UIColor.clear
        setup()
        load()
    }

    func load(){
        CustomRequests.getPhoto(view: self, loading: loadingView){
            response in
            if response != nil{
                CustomRequests.getVideo(view: self, loading: self.loadingView){
                    response2 in
                    self.image_message=response
                    self.video_message=response2
                    self.collection.reloadData()
                }
            }
        }
    }
    
    func setup(){
        view.addSubview(loadingView)
        loadingViewHeght=NSLayoutConstraint(item: loadingView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height)
        loadingView.addConstraint(loadingViewHeght!)
        loadingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func open(_ sender: Any) {
        self.slideMenuController()?.toggleLeft()
    }
}

extension MediaViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collection.bounds.size
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor=UIColor.clear
        logBtn.isSelected=true
        regBtn.isSelected=false
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
            cell.message=self.image_message
            cell.parent=self
            cell.loading=loadingView
            cell.table.reloadData()
            return cell
        case 1:
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
            cell.message=self.video_message
            cell.parent=self
            cell.loading=loadingView
            cell.table.reloadData()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

class PhotoCell:UICollectionViewCell,UITableViewDelegate,UITableViewDataSource{
    
    var message=JSON.null
    var parent:UIViewController?
    var loading:UIView?
    @IBOutlet weak var table: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        table.backgroundColor=UIColor.clear
        table.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if message == nil{
            return 1
        }
        return (message.array?.count)!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if message == nil{
            cell.backgroundColor=UIColor.white
        }else{
            cell.backgroundColor=UIColor.clear
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if message == nil{
            return 70
        }
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let id=message[indexPath.section]["id"].string{
            CustomRequests.getAlbum(view: parent!, loading: loading!, id: id){
                response in
                if response != nil{
                    let galery=response["items"].arrayValue.map{
                        (item)->INSPhoto in
                        var output=""
                        if let thumb=item["src"].string{
                            output=thumb
                        }
                        return INSPhoto(imageURL: URL.init(string: output), thumbnailImageURL: URL.init(string: output))
                    }
                    if (galery.count)>0{
                        let galleryPreview = INSPhotosViewController(photos: galery, initialPhoto: galery[0], referenceView: self)
                        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
                            if (galery.index(where: {$0 === photo})) != nil {
                                return self
                            }
                            return nil
                        }
                        self.parent?.present(galleryPreview, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message == nil{
            let cell=tableView.dequeueReusableCell(withIdentifier: "empty", for: indexPath)
            return cell
        }
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MediaCell
        cell.video_img.isHidden=true
        
        let m=message[indexPath.section]
        if let thumb=m["thumb"].string{
            cell.img.kf.indicatorType = .activity
            UIImageView().kf.setImage(with: URL.init(string: thumb),options: [], completionHandler: {
                (image, error, cacheType, imageUrl) in
                let size=image?.size
                let w=200*(size?.width)!/(size?.height)!
                let processor = ResizingImageProcessor(targetSize: CGSize(width: w, height: 200))
                cell.img.kf.setImage(with: imageUrl,options: [.processor(processor)])
            })
        }
        if let count=m["count"].string{
            let fullString = NSMutableAttributedString(string: "")
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = #imageLiteral(resourceName: "foto")
            image1Attachment.bounds=CGRect(x: 0, y: 0, width: 15, height: 12)
            let image1String = NSAttributedString(attachment: image1Attachment)
            fullString.append(image1String)
            fullString.append(NSAttributedString(string: " \(count)"))
            cell.count.attributedText=fullString
        }
        if let name=m["name"].string{
            cell.title.text=name
        }
        
        return cell
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

class VideoCell:UICollectionViewCell,UITableViewDelegate,UITableViewDataSource{
    
    var message=JSON.null
    var parent:UIViewController?
    var loading:UIView?
    @IBOutlet weak var table: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        table.backgroundColor=UIColor.clear
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if message == nil{
            return 1
        }
        return (message.array?.count)!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if message == nil{
            cell.backgroundColor=UIColor.white
        }else{
            cell.backgroundColor=UIColor.clear
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if message == nil{
            return 70
        }
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let id=message[indexPath.row]["id"].string{
            CustomRequests.getAlbum(view: parent!, loading: loading!, id: id){
                response in
                if response != nil{
                    if let url=response["items"][0]["src"].string{
                        UIApplication.shared.open(URL.init(string: url)!, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message == nil{
            let cell=tableView.dequeueReusableCell(withIdentifier: "empty", for: indexPath)
            return cell
        }
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MediaCell
        cell.video_img.isHidden=false
        cell.count.isHidden=true
        let m=message[indexPath.row]
        if let thumb=m["thumb"].string{
            cell.img.kf.setImage(with: URL.init(string: thumb))
        }
        if let name=m["name"].string{
            cell.title.text=name
        }
        
        return cell
    }
}

class MediaCell:UITableViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var video_img: UIImageView!
    
}
