//
//  SocketViewController.swift
//  Demo
//
//  Created by phan.van.da on 4/8/19.
//  Copyright © 2019 phan.van.da. All rights reserved.
//

import UIKit
import SocketIO




let param = [
    "user_name": "admin",
    "pass": "admin"
]

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    lazy var manager: SocketManager = {
        let manager = SocketManager(socketURL: URL(string: "http://113.164.94.103:3000")!, config: [.log(true), .compress])
        //        manager.socket(forNamespace: "/socket.io")
        return manager
    }()
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func resultData() {
        socket.on("SERVER_SEND_RESULT_LOGIN") { (data, ack) in
            print("result: \(data)")
        }
    }
    
    func loginEMIT() {
        socket.on(clientEvent: .connect) { (data, act) in
            print("socket connected \(data)")
            self.socket.emit("CLIENT_REQUEST_AUTHENTICATE_LOGIN", "admin__admin")
        }
    }
    
}

class SocketViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loginByEmit()
        loginSussess()
    }
    
    func loginByEmit() {
        SocketIOManager.sharedInstance.loginEMIT()
    }
    
    func loginSussess() {
        SocketIOManager.sharedInstance.resultData()
    }
    
}
