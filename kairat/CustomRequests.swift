import UIKit
import Foundation
import Alamofire
import SwiftyJSON

let host="http://api.kairat.com/"

class CustomRequests {
    
    static func getGames(view:UIViewController,loading:UIView,id:String,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)game/\(id)").validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getClub(view: view,loading: loading,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
        
    }
    static func getGames(view:UIViewController,loading:UIView,data:String?,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        var url="\(host)games"
        if let d=data{
            url+="?date=\(d)"
        }
        Alamofire.request(url).validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getClub(view: view,loading: loading,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }

    }
    static func getTeam(view:UIViewController,loading:UIView,id:Int,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)club/team/\(id)").validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getClub(view: view,loading: loading,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    static func getTeam(view:UIViewController,loading:UIView,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)club/team").validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getClub(view: view,loading: loading,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    static func getClub(view:UIViewController,loading:UIView,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)club").validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getClub(view: view,loading: loading,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    static func getNews(view:UIViewController,loading:UIView,page:Int,limit:Int,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)feeds?offset=\(page)&limit=\(limit)").validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getNews(view: view,loading: loading,page: page,limit: limit, completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func getNewsDetail(view:UIViewController,loading:UIView,id:String,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)feeds/"+id).validate().responseJSON{
            response in
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getNewsDetail(view: view, loading: loading, id: id, completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func sendComment(view:UIViewController,loading:UIView,id:String,body:String,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        let model=UserDefaults.standard.getInfo()
        let params="body=\(body)"
        let url = URL(string: "\(host)feeds/\(id)/comments")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let token=model["token"]{
            request.setValue(token, forHTTPHeaderField: "token")
        }
        request.httpBody=params.data(using: .utf8)
        Alamofire.request(request).validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getAllTurnir(view: view, loading: loading,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func getComment(view:UIViewController,loading:UIView,id:String,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)feeds/\(id)/comments").validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getComment(view: view, loading: loading, id: id, completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func getAllTurnir(view:UIViewController,loading:UIView,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)club/turnir").validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getAllTurnir(view: view, loading: loading,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func getStats(view:UIViewController,loading:UIView,turnir_id:String,season:String?,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        var url="\(host)turnir/\(turnir_id)/table"
        if let s=season{
            url+="?season=\(s)"
        }
        Alamofire.request(url).validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getStats(view: view, loading: loading, turnir_id: turnir_id, season: season, completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func login(view:UIViewController,loading:UIView,login:String,pass:String,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        let params=["login":login,"password":pass]
        Alamofire.request("\(host)auth", method: .post, parameters: params, encoding: URLEncoding.default).validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.login(view: view, loading: loading, login: login, pass: pass, completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func register(view:UIViewController,loading:UIView,login:String,pass:String,email:String,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        let params=["login":login,"password":pass,"email":email]
        Alamofire.request("\(host)register", method: .post, parameters: params, encoding: URLEncoding.default).validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.register(view: view, loading: loading, login: login, pass: pass,email: email,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func google(view:UIViewController,loading:UIView,id:String,completionHandler: @escaping (JSON) -> ()){
        
    }
    
    static func getFav(view:UIViewController,loading:UIView,page:Int,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        let model=UserDefaults.standard.getInfo()
        let url = URL(string: "\(host)favorites/feeds?offset=\(page)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token=model["token"]{
            request.setValue(token, forHTTPHeaderField: "token")
        }
        Alamofire.request(request).validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getAllTurnir(view: view, loading: loading,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func addFav(view:UIViewController,loading:UIView,id:String,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        let model=UserDefaults.standard.getInfo()
        let params="id=\(id)"
        let url = URL(string: "\(host)favorites/feeds")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let token=model["token"]{
            request.setValue(token, forHTTPHeaderField: "token")
        }
        request.httpBody=params.data(using: .utf8)
        Alamofire.request(request).validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getAllTurnir(view: view, loading: loading,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func removeFav(view:UIViewController,loading:UIView,id:String,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        let model=UserDefaults.standard.getInfo()
        let url = URL(string: "\(host)favorites/feeds/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        if let token=model["token"]{
            request.setValue(token, forHTTPHeaderField: "token")
        }
        Alamofire.request(request).validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getAllTurnir(view: view, loading: loading,completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func getPhoto(view:UIViewController,loading:UIView,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)media/photos").validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getPhoto(view: view, loading: loading, completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func getVideo(view:UIViewController,loading:UIView,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)media/videos").validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getVideo(view: view, loading: loading, completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
    
    static func getAlbum(view:UIViewController,loading:UIView,id:String,completionHandler: @escaping (JSON) -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loading.isHidden=false
        Alamofire.request("\(host)media/album/\(id)").validate().responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            loading.isHidden=true
            if response.result.error==nil{
                completionHandler(JSON(response.result.value!))
            }else{
                let okAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.getAlbum(view: view, loading: loading, id: id, completionHandler: completionHandler)
                }
                let cancel=UIAlertAction(title: "Закрыть", style: .destructive){
                    (result:UIAlertAction)->Void in
                    
                }
                view.showAlert(msg: (response.result.error?.localizedDescription)!, actions: [okAction,cancel])
            }
        }
    }
}
