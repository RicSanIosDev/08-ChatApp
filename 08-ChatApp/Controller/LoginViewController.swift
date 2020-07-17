//
//  LoginViewController.swift
//  08-ChatApp
//
//  Created by Ricardo Sanchez on 7/15/20.
//  Copyright © 2020 Ricardo Sanchez. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focusOutTextField))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc func focusOutTextField(){
           self.emailTextField.endEditing(true)
       self.passwordTextField.endEditing(true)
       
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
       guard let email = emailTextField.text else {
            let alert = UIAlertController(title: "Lo siento", message: "El email no ha sido escrito", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(okAction)
            present(alert,animated: true,completion: nil)
            return
        }
        
        guard let password = passwordTextField.text else {
            let alert = UIAlertController(title: "Lo siento", message: "La contraseña no ha sido escrita", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(okAction)
            present(alert,animated: true,completion: nil)
            return
        }
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        
        do {
            try Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Lo siento", message: "No se pudo ingresar, intentelo nuevamente", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    
                    alert.addAction(okAction)
                    self.present(alert,animated: true,completion: nil)
                    return
                } else {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "fromLoginToChat", sender: self)
                }
            })
            
        }catch {
            print("Error: No se pudo hacer el sign In")
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

}
