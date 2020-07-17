//
//  Message.swift
//  08-ChatApp
//
//  Created by Ricardo Sanchez on 7/16/20.
//  Copyright © 2020 Ricardo Sanchez. All rights reserved.
//

class Message {
    
    var sender : String = ""
    var body : String = ""
 
    init(sender : String, body: String){
        self.sender = sender
        self.body = body
        
    }
    
    init(){
        sender = "Automatic"
        body = "Este es un mensaje de prueba para la aplicacion del curso de ios"
        
    }
    
}
