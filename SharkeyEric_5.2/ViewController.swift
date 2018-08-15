//
//  ViewController.swift
//  SharkeyEric_5.2
//
//  Created by Eric Sharkey on 8/13/18.
//  Copyright © 2018 Eric Sharkey. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    // Creating outlet collections
    @IBOutlet var rpsImageViews: [UIImageView]!
    @IBOutlet var userChoiceImages: [UIImageView]!
    @IBOutlet var profileImages: [UIImageView]!
    @IBOutlet var wdlLables: [UILabel]!
    @IBOutlet var tallyCollection: [UILabel]!
    
    // Creating outlets
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var roShamBoLabel: UILabel!
    @IBOutlet weak var user2Label: UILabel!
    @IBOutlet weak var user1Label: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var playSelectedLabel: UILabel!
    
    // Creating variables.
    var session: MCSession!
    var peerId: MCPeerID!
    var advertisor: MCAdvertiserAssistant!
    var browser: MCBrowserViewController!
    var counter = 0
    var win = 0
    var draw = 0
    var loss = 0
    var selectedImage: Int!
    var timer = Timer()
    var timerCounter = 3
    var playCounter = 0
    
    let serviceId = "sharkeyEric-52"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        peerId = MCPeerID(displayName: UIDevice.current.name)
        
        session = MCSession(peer: peerId)
        session.delegate = self
        
        advertisor = MCAdvertiserAssistant(serviceType: serviceId, discoveryInfo: nil, session: session)
        advertisor.start()
        
        setup()
        
    }
    
    
    @IBAction func connectTap(_ sender: UIBarButtonItem) {
        browser = MCBrowserViewController(serviceType: serviceId, session: session)
        browser.delegate = self
        
        self.present(browser, animated: true, completion: nil)
    }
    
    
    
    //MARK - MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK - MCSessionDelegate callbacks
    
    // Remote peer changed state.
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState){
        
        DispatchQueue.main.async {
            switch state {
            // Maybe add activity indicator.
            case .connected:
                self.navItem.title = "Connected"
                self.user1Label.text = UIDevice.current.name
                self.user2Label.text = peerID.displayName
                self.playButton.setTitle("Play", for: .normal)
                self.roShamBoLabel.text = nil
            case .notConnected:
                self.navItem.title = "Disconnected"
                
            //MARK: Add alert notifying user of disconnection.
            case .connecting:
                self.navItem.title = "Connecting..."
            }
        }
    }
    
    
    // Received data from remote peer.
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID){
        
        //MARK: Start 3 second timer with selector function.
        
        if let data: String = String(data: data, encoding: String.Encoding.utf8){
            DispatchQueue.main.async {
                if data == "Play"{
                    self.playCounter += 1
                    self.playSelectedLabel.text = "\(peerID.displayName) is ready..."
                    if self.playCounter == 2 {
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkImage), userInfo: nil, repeats: true)
                        
                        self.playCounter = 0
                    }
                } else{
                    print(data)
                    self.userChoiceImages[1].image = self.rpsImageViews[Int(data)!].image
                }
            }
        }
    }
    
    
    // Received a byte stream from remote peer.
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
        
    }
    
    
    // Start receiving a resource from remote peer.
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress){
        
    }
    
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?){
        
    }
    
    func setup(){
        
        rpsImageViews[0].image = #imageLiteral(resourceName: "rock")
        rpsImageViews[1].image = #imageLiteral(resourceName: "paper")
        rpsImageViews[2].image = #imageLiteral(resourceName: "scissors")
        
        for imageView in rpsImageViews{
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.rpsTapped(sender:)))
            imageView.addGestureRecognizer(tap)
            imageView.isUserInteractionEnabled = true
            imageView.isHidden = true
        }
        
        for label in wdlLables{
            label.text = nil
        }
        
        resultLabel.text = nil
        user1Label.text = nil
        user2Label.text = nil
        vsLabel.text = nil
        counterLabel.text = nil
        playSelectedLabel.text = nil
        
        for label in tallyCollection{
            label.text = nil
        }
        
        topView.backgroundColor = UIColor.white
        playButton.setTitle("", for: .normal)
    }
    
   @objc func rpsTapped(sender: UITapGestureRecognizer){
        print("tapped")
   guard let selectedView = sender.view as? UIImageView else {return}
    
    switch selectedView.tag {
    case 0:
        userChoiceImages[0].image = #imageLiteral(resourceName: "rock")
        selectedImage = 0
    case 1:
        userChoiceImages[0].image = #imageLiteral(resourceName: "paper")
        selectedImage = 1
    case 2:
        userChoiceImages[0].image = #imageLiteral(resourceName: "scissors")
        selectedImage = 2
    default:
        print("Incorrect image tag")
    }
    
//    guard let index = selectedImage else {return}
//
//    if let text = Data.init(base64Encoded: String(index)) {
//
//        do{
//            try session.send(text, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
//        } catch{
//            print(error.localizedDescription)
//        }
//    }
    
    }
    @IBAction func playTapped(_ sender: UIButton) {
        playCounter += 1
        
        if playCounter == 2 {
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkImage), userInfo: nil, repeats: true)
            
            playCounter = 0
        }
            guard let buttonText = playButton.titleLabel?.text else {return}
        
            if let text = buttonText.data(using: String.Encoding.utf8) {
        
                do{
                    try session.send(text, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
                } catch{
                    print(error.localizedDescription)
                }
            }
    }
    
    @objc func checkImage (){
      
        if timerCounter > 0 {
            timerCounter -= 1
            counterLabel.text = "\(timerCounter)"
        } else {
            // MARK: When Timer hits 0 check the images and display.
            
            
            
            timerCounter = 3
            timer.invalidate()
            counterLabel.text = nil
        }
    }
}

