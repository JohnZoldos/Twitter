//
//  User.swift
//  Twitter
//
//  Created by John Zoldos on 6/9/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import AlamofireImage

class User: NSObject {
    static let userDidLogoutNotification = "UserDidLogout"
    
    var name: String?
    var screenName: String?
    var profileUrl: NSURL?
    var tagline: NSString?
    var profileImage: UIImageView?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? NSString
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString as String)
            profileImage?.af_setImage(withURL: profileUrl! as URL)
        }
        tagline = dictionary["description"] as? NSString
        self.dictionary = dictionary
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as? NSDictionary
                    if let dictionary = dictionary{
                        _currentUser = User(dictionary: dictionary!)
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary as Any, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
    
}
