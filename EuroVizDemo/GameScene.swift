//
//  GameScene.swift
//  EuroVizDemo
//
//  Created by Michael Forrest on 23/01/2019.
//  Copyright © 2019 GoodToHear. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreBluetooth

let FRIENDS = ["🐿", "🦔", "🍂", "🌰", "🥜", "🍃", "🌱", "☘️", "🍀", "🌿"]

class GameScene: SKScene {
    private var mushroom: SKLabelNode!
    private var bluetooth: BluetoothSerial!
    private var centralManager: CBCentralManager!
    
      func addFriend(){
        let friendElement = SKLabelNode(text: FRIENDS.randomElement())
        friendElement.position = CGPoint(x:130,y:0)
        
        let friend = SKNode()
        friend.addChild(friendElement)
        
        self.addChild(friend)
        let duration: TimeInterval = 6
        friendElement.run(SKAction.rotate(byAngle:  .pi * -4, duration: duration))
        friend.run(SKAction.group([
            SKAction.rotate(byAngle: .pi * 4, duration: duration),
            SKAction.sequence([
                SKAction.wait(forDuration: duration - 1),
                SKAction.fadeOut(withDuration: 1),
                SKAction.removeFromParent()
                ])
            ]))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pulseMushroom()
        self.addFriend()
    }
    
    override func didMove(to view: SKView) {
        self.mushroom = (self.childNode(withName: "//mushroom") as! SKLabelNode)
        self.bluetooth = BluetoothSerial(delegate: self)
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func pulseMushroom(){
        self.mushroom.run(SKAction(named: "Pulse")!)
    }
    
    

}

extension GameScene: BluetoothSerialDelegate{
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        bluetooth.connectToPeripheral(peripheral)
    }
    
    func serialDidReceiveString(_ message: String) {
        if message == "trigger_1"{
            self.pulseMushroom()
            self.addFriend()
        }
    }
    
    func serialDidChangeState() {
        
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        
    }
 
}

extension GameScene: CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn){
            bluetooth.startScan()
        }
    }
}
