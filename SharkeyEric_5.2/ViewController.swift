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
    
    // Creating variables.
    var session: MCSession!
    var peerId: MCPeerID!
    var advertisor: MCAdvertiserAssistant!
    var browser: MCBrowserViewController!
    var counter = 0
    var win = 0
    var draw = 0
    var loss = 0
    var selectedImage: UIImage!
    
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
        switch state {
            // Maybe add activity indicator.
        case .connected:
            navItem.title = "Connected"
            user1Label.text = UIDevice.current.name
            user2Label.text = peerID.displayName
        case .notConnected:
            navItem.title = "Disconnected"
            
        //MARK: Add alert notifying user of disconnection.
        case .connecting:
            navItem.title = "Connecting..."
        }
        
        
        
        
    }
    
    
    // Received data from remote peer.
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID){
        
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
            label.text = ""
        }
        
        resultLabel.text = ""
        user1Label.text = ""
        user2Label.text = ""
        vsLabel.text = ""
        
        for label in tallyCollection{
            label.text = ""
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
        selectedImage = #imageLiteral(resourceName: "rock")
    case 1:
        userChoiceImages[0].image = #imageLiteral(resourceName: "paper")
        selectedImage = #imageLiteral(resourceName: "paper")
    case 2:
        userChoiceImages[0].image = #imageLiteral(resourceName: "scissors")
        selectedImage = #imageLiteral(resourceName: "scissors")
    default:
        print("Incorrect image tag")
    }
    
    
    
    }
    @IBAction func playTapped(_ sender: UIButton) {
    }
    
}

