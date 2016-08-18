//
//  TwitterClient.swift
//  Twitter
//
//  Created by ximin_zhang on 8/16/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "eb2cC3UOQPgJbe5hTFb2n7ioV", consumerSecret: "Wiwo0mNJtfd5cSHfdQqT46whXt0kNpXtIxnxbAcrNCukpEKxbj")

    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?

    // Login Part I
    func login(success: () -> (), failure: (NSError) -> ()) {

        loginSuccess = success
        loginFailure = failure

        deauthorize()

        //  NSURL(string: "twitter://oauth")!
        fetchRequestTokenWithPath("oauth/request_token", method:
            "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
                print("I got a token")

                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(url)

        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure!(error)
        }

    }

    func logout() {
        User.currentUser = nil
        deauthorize()

        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)

    }

    // Login part II
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in

            self.currentAccount({ (user: User) in

                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })

            self.loginSuccess?() // envoke

            //            print("I got the access token!")
            //            self.homeTimeline({ (tweets: [Tweet]) in
            //                for tweet in tweets {
            //                    print(tweet.text)
            //                }
            //                }, failure: { (error: NSError) in
            //                    print("error: \(error.localizedDescription)")
            //            })
            //
            //            self.currentAccount()

        }) { (error: NSError!) in
            //            print(error.localizedDescription)
            self.loginFailure?(error)
        }
    }

    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

            //                    print("account: \(response)")
            //                    let user = response as! NSDictionary
            //                    print("name: \(user["name"])")

            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)


            success(user)
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile url: \(user.profileUrl)")
            print("description: \(user.description)")

            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in

                print(error.localizedDescription)
                failure(error)
        })
    }

    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

//            print(response)

            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            //            for tweet in tweets {
            //                print("\(tweet.text)")
            //            }
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            //            print("error: \(error.localizedDescription)")
            failure(error)
        }
    }

}



