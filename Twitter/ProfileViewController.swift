//
//  ProfileViewController.swift
//  Twitter
//
//  Created by John Zoldos on 7/5/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    /*@IBOutlet weak var tweetCellProfilePictureView: UIButton!
    @IBOutlet weak var tweetCellUsernameLabel: UILabel!
    @IBOutlet weak var tweetCellHandleLabel: UILabel!
    @IBOutlet weak var tweetCellTweetAgeLabel: UILabel!*/
    
    
    @IBAction func backButton(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    @IBAction func composeTweetButton(_ sender: UIButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
