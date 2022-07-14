//
//  Profile.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/11/22.
//

import Foundation

struct Profile {
    
    var name: String
    var url: String
    
    init(_ dogString: String) {
        self.name = dogString
        self.url = "https://random.dog/" + dogString
    }
}
