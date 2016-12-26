//
//  Models.swift
//  kairat
//
//  Created by dreamwings on 06.12.16.
//  Copyright © 2016 Beka. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Models: NSObject {
    
    static func fetchJSON(URL: String, completionHandler: @escaping (JSON) -> ()) {
        
        Alamofire.request(URL, method: .get).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    completionHandler(json)
                }
            case .failure(let error):
                print(error)
            }
        })
        
    }

}




