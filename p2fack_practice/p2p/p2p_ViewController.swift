//
//  p2p_ViewController.swift
//  p2fack_practice
//
//  Created by 中村　朝陽 on 2019/02/16.
//  Copyright © 2019年 Fuuya Yamada. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation

class p2p_ViewController: UIViewController, MCBrowserViewControllerDelegate,
MCSessionDelegate,AVAudioPlayerDelegate{
    
    

    let serviceType = "LCOC-Chat"
    let kRecordedVoices = "RECORDED_VOICES"
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!

    var audioPlayer = AVAudioPlayer()
    
    var recordedVoices = [RecordedVoice]()
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func sendChat(_ sender: Any) {
        if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
            
            let filePath = dir.appendingPathComponent( "recording.m4a" )
            sendAudio2(url: filePath)
            print("ok")
        }
        //sendAudio(audioData: recordedVoices[0])
    }
    
    @IBAction func showBrowser(sender: UIButton) {
        // Show the browser view controller
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    @IBAction func join(_ sender: Any) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    @IBAction func openTable(_ sender: Any) {
        guard let rootViewController = rootViewController() else {
            return }
        rootViewController.presentMenuViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        loadVoice()
    }
    
    // 読み込み処理
    func loadVoice() {
        // Dictionary配列を読み込み
        let userDefaults = UserDefaults.standard
        if let loadArray = userDefaults.array(forKey: kRecordedVoices) as? [[String: Any]] {
            // Dictionary配列->ToDo配列に変換
            loadArray.forEach({ item in
                recordedVoices.append(RecordedVoice(dictionary: item))
            })
        }
    }
    //String送信
    func sendString(str: String){
        if mcSession.connectedPeers.count > 0 {
            if let msg = str.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do {
                    try mcSession.send(msg, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    //画像送信
    func sendImage(img: UIImage) {
        if mcSession.connectedPeers.count > 0 {
            if let imageData = img.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    //音声送信
    func sendAudio(audioData: RecordedVoice) {
        
        let url = URL(fileURLWithPath: audioData.path)
        if mcSession.connectedPeers.count > 0 {
                mcSession.sendResource(at: url, withName: audioData.name, toPeer: mcSession!.connectedPeers[0]) {(error) in
                    if error != nil{
                            let ac = UIAlertController(title: "Send error", message: error!.localizedDescription, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated: true)
                    }
            }
        }
    }
    
    // 保存処理
    func saveAudio() {
        var saveArray = [[String: Any]]()
        
        //VoiceRecorded配列->Dictionary配列に変換
        recordedVoices.forEach ({ item in
            saveArray.append(item.dictionaryFromVoice())
        })
        // Dictionary配列を保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(saveArray, forKey: kRecordedVoices)
        userDefaults.synchronize()
        
    }

    
    //音声送信
    func sendAudio2(url: URL) {
        
        if mcSession.connectedPeers.count > 0 {
            mcSession.sendResource(at: url, withName: "name", toPeer: mcSession!.connectedPeers[0]) {(error) in
                if error != nil{
                    let ac = UIAlertController(title: "Send error", message: error!.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }
   
    func updateChat(text : String, fromPeer peerID: MCPeerID) {
        // Appends some text to the chat view
        
        // If this peer ID is the local device's peer ID, then show the name
        // as "Me"
        var name : String
        
        switch peerID {
        case self.peerID:
            name = "Me"
        default:
            name = peerID.displayName
        }
        
        // Add the name to the message and display it
        let message = "\(name): \(text)\n"
      
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
         dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
         dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async { [unowned self] in
                // do something with the image
            }
        }
        
        if let msg = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
            DispatchQueue.main.async { [unowned self] in
                self.textField.text = msg as String
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("\(localURL?.lastPathComponent)" + ":" + "\(resourceName)")
        
        renameTmpFile(localURL: localURL!, resourceName: resourceName)
    }
    
    func renameTmpFile(localURL: URL, resourceName: String){
        let _: String = NSTemporaryDirectory()
        
        if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
            //let renamedPath = dir.path + "/" + resourceName + ".m4a"
            let renamedPath = dir.path + "/" + localURL.lastPathComponent + ".m4a"
            do {
                try FileManager.default.moveItem(atPath: localURL.path, toPath:renamedPath)
                recordedVoices.append(RecordedVoice(path: renamedPath, name: resourceName))
                
                saveAudio()
            } catch {
                print(localURL.path + ": " + renamedPath)
                print("error")
            }
        }
    }
    
    @IBAction func hide(_ sender: Any) {
        super.didReceiveMemoryWarning()
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
