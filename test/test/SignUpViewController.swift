//
//  ViewController.swift
//  test
//
//  Created by Mina Namlı on 16.02.2022.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import FirebaseDatabase



class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordVerifyText: UITextField!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    @IBAction func sigUpClicked(_ sender: Any) {
        
        //already sign
        // facebook apple
        //database
        
        if (userNameText.text != "" && passwordText.text == passwordVerifyText.text && emailText.text != "" && passwordText.text != "" && isValidEmail(email: emailText.text!) && isValidPassword(password: passwordText.text!)) {
            self.register(name: userNameText.text!, email: emailText.text!, password: passwordText.text!)
        }else{
            self.makeAlert(titleInput: "Error!", messageInput: "Try Again.")}}
    
    
    public func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)}
    
    public func isValidPassword(password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[A-Z])(?=.*[$@$#!%*?&]).{8,}$")
        return passwordTest.evaluate(with: password)}
    
    public func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput , message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)}
 
    public func register(name: String, email: String, password: String){
  
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                self.makeAlert(titleInput: "Error!", messageInput: err.localizedDescription)
            }else{
//               result?.user.uid
//               result?.user.email
//               result?.user.displayName
                
                self.uploadData(username: name, email: email, password: password)
    
            }}}

    public func uploadData(username: String, email: String, password: String){
        let db = FirebaseFirestore.Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).setData(["name" : userNameText.text! ,
                                                       "email" : emailText.text!,
                                                       "count" : 0]){ err in
            if let err = err {
                self.makeAlert(titleInput: "Error!", messageInput: err.localizedDescription)
            }}}

}
