//
//  Tweet.swift
//  Twitter
//
//  Created by ximin_zhang on 8/16/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?

    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String

        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0

        let timestampString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM HH:mm:ss Z y"

        if let timestampString = timestampString {
            timestamp =  formatter.dateFromString(timestampString)
        }

        let _user = dictionary["user"] as! NSDictionary
        user = User(dictionary: _user)

    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()

        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)


            tweets.append(tweet)
        }

        return tweets
    }

}


