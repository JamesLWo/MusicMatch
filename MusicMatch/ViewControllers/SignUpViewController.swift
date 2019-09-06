//
//  SignUpViewController.swift
//  MusicMatch
//
//  Created by James Wo on 9/4/19.
//  Copyright © 2019 James Wo. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate=self
        self.passwordTextField.delegate=self
        self.firstNameTextField.delegate=self
        self.lastNameTextField.delegate=self
        setUpElements()
        view.backgroundColor = UIColor(red: 234/255, green: 199/255, blue: 215/255, alpha: 1.0) /* #eac7d7 */

        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        
        //hiding error label
        errorLabel.alpha=0
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleHollowButton(signUpButton)
    }
    func validateFields() -> String? {
        //check all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        //check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false{
            return "Please make password at least 8 characters and contains a special character"
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil{
            showError(error!)
        }
        else{
            
            //create cleaned versions of data
            let firstName=firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName=lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil{
                    self.showError("Error")
                }
                else{
                    //user created successfully
                    let db = Firestore.firestore()
                    let uid = result!.user.uid
                    db.collection("users").document(uid).setData(["firstname":firstName, "lastname":lastName, "uid":result!.user.uid, "artists":[]]){ (error) in
                        if error != nil{
                            self.showError("Error saving user data")
                        }
                    }
                    //successful! transition
                    self.transitionToHome()
                    
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
   

    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        let ViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ViewController)
        view.endEditing(true)
        view.window?.rootViewController = ViewController
        view.window?.makeKeyAndVisible()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
