//
//  FirstScreenViewController.swift
//  MusicMatch
//
//  Created by James Wo on 9/4/19.
//  Copyright © 2019 James Wo. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 234/255, green: 199/255, blue: 215/255, alpha: 1.0) /* #eac7d7 */
        setUpElements()

        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        Utilities.styleHollowButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        
    }
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


