//
//  LogInViewController.swift
//  MusicMatch
//
//  Created by James Wo on 9/4/19.
//  Copyright © 2019 James Wo. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        view.backgroundColor = UIColor(red: 234/255, green: 199/255, blue: 215/255, alpha: 1.0) /* #eac7d7 */
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        errorLabel.alpha=0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleHollowButton(loginButton)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        //validate, which means al fields are just filled
        
        
        //cleaned version of textfield
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                //couldnt sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ViewController)
                self.view.endEditing(true)
                self.view.window?.rootViewController = viewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
        

}
}
