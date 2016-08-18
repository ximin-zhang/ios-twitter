//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/17/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweet: Tweet?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        tableView.dataSource = self
        tableView.delegate = self

        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailCell", forIndexPath: indexPath) as! TweetDetailCell

            cell.nameLabel.text = (tweet?.user?.name as! String)
            cell.screennameLabel.text = (tweet?.user?.screenname as! String)
            cell.profileImageView.setImageWithURL((tweet?.user?.profileUrl)!)
            cell.tweetTextLabel.text = (tweet?.text as! String)
            cell.tweetTextLabel.sizeToFit()

            return cell

        } else if (indexPath.section == 1) {

            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailStatsCell", forIndexPath: indexPath) as! TweetDetailStatsCell

            return cell

        } else {

            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailFuncCell", forIndexPath: indexPath) as! TweetDetailFuncCell

            return cell
        }




    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }





    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
