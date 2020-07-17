//
//  ChatViewController.swift
//  08-ChatApp
//
//  Created by Ricardo Sanchez on 7/15/20.
//  Copyright © 2020 Ricardo Sanchez. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButtom: UIButton!
    @IBOutlet weak var textBoxHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        self.messageTextField.delegate = self
        self.messagesTableView.tableFooterView = UIView()
        self.messagesTableView.separatorStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideMessageZone))
        self.messagesTableView.addGestureRecognizer(tapGesture)
        self.messagesTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCellID")
        
        configureTableViewCell()
        retrieveMessagesFromFirebase() //nos suscribimos a la DB para estar atento a los cambios

        // Do any additional setup after loading the view.
    }
    
    func configureTableViewCell(){
        self.messagesTableView.rowHeight = UITableView.automaticDimension
        self.messagesTableView.estimatedRowHeight = 120
    }
    
    // Mark: - Firebase Methods
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
       
        do {
            try Auth.auth().signOut()

        }catch {
            print("Error: no se ha podido hacer un sign out")
        }
        
        guard navigationController?.popToRootViewController(animated: true) != nil else {
            print("No hay view controllers que eliminar de la stack")
            return
        }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        guard let message = self.messageTextField.text , message != "" else {
            return
        }
        
        messageTextField.isEnabled = false
        sendButtom.isEnabled = false
        
        self.messageTextField.endEditing(true)
        
        let messagesDB = Database.database().reference().child("Messages")
        
        let messageDic = ["sender": Auth.auth().currentUser?.email,
                          "body" : message]
        
        messagesDB.childByAutoId().setValue(messageDic) { (error, ref) in
            if error != nil {
                print(error!)
            } else {
                print("Mensaje guardado correctamente")
                self.messageTextField.isEnabled = true
                self.sendButtom.isEnabled = true
                self.messageTextField.text = ""
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
    
    //Establecemos un observador del evento .childAdded de la DB Messages de Firebase para saber cuando se a;ade un nuevo
    //mensaje a dicha table del server
    func retrieveMessagesFromFirebase() {
        let messagesDB = Database.database().reference().child("Messages")
        messagesDB.observe(.childAdded) { (snapshot) in
            let snpValue = snapshot.value as! Dictionary<String, String>
            
            guard let sender = snpValue["sender"], let body = snpValue["body"] else {
                return
            }
            let message = Message(sender: sender, body: body)
            self.messageArray.append(message)
            
            self.configureTableViewCell()// recalcula el tamaño de la celda para ajustarla al tama;o del mensaje
            self.messagesTableView.reloadData()
        }
    }
    
    
    //Mark: - UITableViewDataSource
    var messageArray : [Message] = [Message]()

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCellID", for: indexPath) as! MessageCell
        
        cell.usernameLabel.text = messageArray[indexPath.row].sender
        cell.messageLabel.text = messageArray[indexPath.row].body
        cell.messageImageView.image = UIImage(named: "perfil-default")
        
        if cell.usernameLabel.text == Auth.auth().currentUser?.email {
            cell.messageImageView.backgroundColor = UIColor.flatLime()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }else {
            cell.messageImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    // Mark: - UITextFieldDelegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        UIView.animate(withDuration: 0.5) {
            self.textBoxHeight.constant = 80 + 258 + 80
            self.view.layoutIfNeeded()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideMessageZone()
    }
    
   
    @objc func hideMessageZone() {
        self.messageTextField.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.textBoxHeight.constant = 80
            self.view.layoutIfNeeded()
                      }
    }
}
