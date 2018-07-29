//
//  Post.swift
//  Gazorpian
//
//  Created by Christopher Norman on 9/25/17.
//  Copyright © 2017 yakuza. All rights reserved.
//

import Foundation

struct Post {
    
    var id: String?
    
    let user: User
    let videoUrl: String
    let benefits: String
    let Salary: String
    let jobType: String
    let jobDescrip: String
    let creationDate: Date
    
    var hasLiked = false
    
    init(user: User,dictionary: [String: Any]) {
        self.user = user
        self.videoUrl = dictionary["videoURL"] as? String ?? ""
        self.benefits = dictionary["Benefits"] as? String ?? ""
        self.Salary = dictionary["Salary"] as? String ?? ""
        self.jobType = dictionary["Type"] as? String ?? ""
        self.jobDescrip = dictionary["Job Description"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["CreationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
