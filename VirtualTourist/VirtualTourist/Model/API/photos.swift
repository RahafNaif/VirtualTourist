//
//  photos.swift
//  VirtualTourist
//
//  Created by Rahaf Naif on 13/11/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import Foundation

struct photos : Codable {
    let photos : photosDetails
}

struct photosDetails : Codable{
  
    let page : Int
    let pages : Int
    let perpage : Int
    let total : Int
    let photo : [photoInfo]
    let stat : String
    
}

struct photoInfo : Codable{
    
    let id : String
    let owner : String
    let secret : String
    let server : String
    let farm : Int
    let title : String
    
    var imageUrl: URL {
       return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
    
}
