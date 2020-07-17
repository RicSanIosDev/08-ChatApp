//
//  RegisterViewController.swift
//  08-ChatApp
//
//  Created by Ricardo Sanchez on 7/15/20.
//  Copyright © 2020 Ricardo Sanchez. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var switchConditions: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.password2TextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focusOutTextField))
             
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
   @objc func focusOutTextField(){
        self.emailTextField.endEditing(true)
    self.passwordTextField.endEditing(true)
    self.password2TextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard switchConditions.isOn else {
            
            let alert = UIAlertController(title: "Lo siento", message: "necesita aceptar las politicas de privacidad para poder usar la App", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(okAction)
            present(alert,animated: true,completion: nil)
            return
        }
        
        guard passwordTextField.text == password2TextField.text else {
            let alert = UIAlertController(title: "Lo siento", message: "Las constraseñas no coinciden", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            
             alert.addAction(okAction)
            present(alert,animated: true,completion: nil)
            return
        }
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
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Lo siento", message: "\(error!)", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(okAction)
                self.present(alert,animated: true,completion: nil)
                return
            }else {
                let alert = UIAlertController(title: "Felicidades", message: "Se ha registrado correctamente", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    SVProgressHUD.dismiss(withDelay: 0.5)
                    self.performSegue(withIdentifier: "fromRegistryToChat", sender: self)
                }
                
                alert.addAction(okAction)
                self.present(alert,animated: true,completion: nil)
                SVProgressHUD.dismiss()
                return
            }
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
