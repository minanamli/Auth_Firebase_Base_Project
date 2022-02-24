//
//  FirstViewController.swift
//  test
//
//  Created by Mina Namlı on 18.02.2022.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginPageClicked(_ sender: Any) {
    }
    
    @IBAction func signupPageClicked(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpViewController" {
            let destinationVC = segue.destination as! SignUpViewController}
        if segue.identifier == "logInViewController" {
            let destinationVC = segue.destination as! logInViewController}
      }
}
