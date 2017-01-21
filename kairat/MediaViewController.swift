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
        b.titleLabel?.font=UIFont(name: "CenturyGothic-Bold", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor(colorLiteralRed: 178/255, green: 28/255, blue: 31/255, alpha: 1), for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var regBtn:UIButton={
        let b=UIButton()
        b.tag=1
        b.setTitle("ВИДЕО", for: .normal)
        b.titleLabel?.font=UIFont(name: "CenturyGothic-Bold", size: 12)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitleColor(UIColor(colorLiteralRed: 178/255, green: 28/255, blue: 31/255, alpha: 1), for: .selected)
        b.heightAnchor.constraint(equalToConstant: 40).isActive=true
        b.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive=true
        b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    var indicator:UIView={
        let v=UIView()
        v.backgroundColor=UIColor(colorLiteralRed: 178/255, green: 28/255, blue: 31/255, alpha: 1)
        v.heightAnchor.constraint(equalToConstant: 4).isActive=true
        v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title="МЕДИА"
        self.navigationController?.setBG()
        view.backgroundColor=UIColor(colorLiteralRed: 0, green: 0, blue: 19/255, alpha: 1)
        fon.image=#imageLiteral(resourceName: "fon").imageByCroppingImage(size: CGSize(width: 1200, height: 1200))
        header.translatesAutoresizingMaskIntoConstraints=false
        header.anchorWithConstantsToTop(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20+(navigationController?.navigationBar.bounds.size.height)!, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        header.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        collection.translatesAutoresizingMaskIntoConstraints=false
        collection.anchorWithConstantsToTop(header.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        collection.backgroundColor=UIColor.clear
        collection.isPagingEnabled=true
        setup()
        load()
        setup_menu()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setBG()
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
            UIView.animate(withDuration: 4.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                 self.regBtn.isSelected=false
            }, completion: nil)
            collection.setContentOffset(CGPoint.zero, animated: true)
        }else{
            regBtn.isSelected=true
            UIView.animate(withDuration: 4.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.logBtn.isSelected=false
            }, completion: nil)
            collection.setContentOffset(CGPoint(x:UIScreen.main.bounds.width+10, y: 0), animated: true)
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
            UIView.animate(withDuration: 4.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.regBtn.isSelected=false
            }, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if segue.identifier=="detail"{
            let dc=segue.destination as! MediaDetailViewController
            dc.message=sender as! JSON
        }
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
        if message.count==0{
            return 1
        }
        return (message.array?.count)!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
                        UIApplication.shared.isStatusBarHidden=true
                        let galleryPreview = INSPhotosViewController(photos: galery, initialPhoto: galery[0], referenceView: self)
                        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
                            UIApplication.shared.isStatusBarHidden=false
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
        if message.count==0{
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
                if image != nil{
                    let size=image?.size
                    let w=200*(size?.width)!/(size?.height)!
                    let processor = ResizingImageProcessor(targetSize: CGSize(width: w, height: 200))
                    cell.img.image=image
                    //cell.img.kf.setImage(with: imageUrl,options: [.processor(processor)])
                }
            })
        }
        if let count=m["count"].string{
            cell.count.text=count
        }
        if let name=m["name"].string{
            cell.title.text=name.uppercased()
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
        if message.count==0{
            return 1
        }
        return (message.array?.count)!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let id=message[indexPath.row]["id"].string{
            CustomRequests.getAlbum(view: parent!, loading: loading!, id: id){
                response in
                if response != nil{
                    self.parent?.performSegue(withIdentifier: "detail", sender: response)
//                    let galery=response["items"].arrayValue.filter({$0["type"].stringValue=="2"}).map{
//                        (item)->CustomVideoModel in
//                        var output=""
//                        if let thumb=item["thumb"].string{
//                            output=thumb
//                        }
//                        var src=""
//                        if let s=item["src"].string{
//                            src=s
//                        }
//                        return CustomVideoModel(imageURL: URL.init(string: output), thumbnailImageURL: URL.init(string: output),videoURL:src)
//                    }
//                    if (galery.count)>0{
//                        UIApplication.shared.isStatusBarHidden=true
//                        let galleryPreview = INSPhotosViewController(photos: galery, initialPhoto: galery[0], referenceView: self)
//                        galleryPreview.overlayView=CustomOverlay(frame: CGRect.zero)
//                        (galleryPreview.overlayView as? CustomOverlay)?.currentPhoto=galery[0]
//                        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
//                            UIApplication.shared.isStatusBarHidden=false
//                            if (galery.index(where: {$0 === photo})) != nil {
//                                return self
//                            }
//                            return nil
//                        }
//                        self.parent?.present(galleryPreview, animated: true, completion: nil)
//                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message.count==0{
            let cell=tableView.dequeueReusableCell(withIdentifier: "empty", for: indexPath)
            return cell
        }
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MediaCell
        cell.video_img.isHidden=false
        let m=message[indexPath.section]
        if let thumb=m["thumb"].string{
            cell.img.kf.indicatorType = .activity
            UIImageView().kf.setImage(with: URL.init(string: thumb),options: [], completionHandler: {
                (image, error, cacheType, imageUrl) in
                if image != nil{
                    let size=image?.size
                    let w=200*(size?.width)!/(size?.height)!
                    let processor = ResizingImageProcessor(targetSize: CGSize(width: w, height: 200))
                    cell.img.image=image
                    //cell.img.kf.setImage(with: imageUrl,options: [.processor(processor)])
                }
            })
        }
        if let name=m["name"].string{
            cell.title.text=name.uppercased()
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

class MediaCell:UITableViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var video_img: UIImageView!
    
}
