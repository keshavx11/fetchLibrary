//
//  Fetch.swift
//  Universal Fetch Library
//
//  Created by Keshav Bansal on 26/07/17.
//  Copyright © 2017 Keshav. All rights reserved.
//


import Foundation
import UIKit

class Fetch{
    
    //MARK: Properties
    var type: FetchType
    var content: Any!
    var image: UIImage?
    
    class func getURLData(urlString: String, completion: @escaping (Fetch) -> Swift.Void){
        
        let url = URL.init(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error == nil {
                let json = try! JSONSerialization.jsonObject(with: data!, options: [])
                let dictArray = json as! Array<[String: Any]>
                for var i in 0..<dictArray.count{
                let dict = dictArray[i] 
                let urlDict = dict["urls"] as! [String: Any]
                let content = urlDict["regular"] as! String
                let type = FetchType.photo
                let item = Fetch.init(type: type, content: content)
                completion(item)
                }
            }
        }).resume()
    }

    
    func downloadImage(indexpathRow: Int, completion: @escaping (Bool,Int) -> Swift.Void)  {
            let imageLink = self.content as! String
            let imageURL = URL.init(string: imageLink)
            URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, response, error) in
                if error == nil {
                    self.image = UIImage.init(data: data!)
                    completion(true, indexpathRow)
                }
            }).resume()
    }
    

    enum FetchType {
        case photo
        case text
    }
    
    //MARK: Inits
    init(type: FetchType, content: Any) {
        self.type = type
        self.content = content
    }
}

