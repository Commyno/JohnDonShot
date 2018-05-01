//
//  GameViewController.swift
//  John Don Shot
//
//  Created by Giovanni on 13/04/18.
//  Copyright © 2018 Giovanni Tirico. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

// Notification
let startGameplayNotificationName = Notification.Name("startGameplayNotificationName")

// Preload
let preloadNotificationName = Notification.Name("PreloadNotificationName")
let progressNotificationName = Notification.Name("ProgressNotificationName")


class GameViewController: UIViewController {
    
    enum LoadStatus{
        case Normal
        case Warning
        case Critical
        case Reset
        case Backup
    }

    let skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bview:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()

    let loadLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 25)
        label.text = "Loading:"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let progressNumber:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 25)
        label.text = "0%"
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    private var defaultPlist = NSMutableDictionary()
    private var clientData = NSMutableDictionary()

    //
    // DidLoad
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("--Start--")
        
        // Notification
        addNotificationObservers()  // Setta tutte le notification
        JDSManager.shared.launch()  //
        loadingScene()              // Progress Scene
        load()                      // Carica l'account utente

    }
    
    func addNotificationObservers() {
       
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.preloadDone(_:)),
                                               name: preloadNotificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.progressTrack(_:)),
                                               name: progressNotificationName,
                                               object: nil)

    }
    
    private func loadingScene(){
        
        // Set Scene e View
        view.addSubview(skView)
        view.addSubview(bview)
        bview.addSubview(loadLabel)
        loadLabel.addSubview(progressNumber)

        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        skView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true

        bview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        bview.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        bview.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/2).isActive = true
        
        loadLabel.centerXAnchor.constraint(equalTo: bview.centerXAnchor, constant: -50).isActive = true
        loadLabel.topAnchor.constraint(equalTo: bview.bottomAnchor, constant: 50).isActive = true
        loadLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        progressNumber.leftAnchor.constraint(equalTo: loadLabel.rightAnchor).isActive = true
        progressNumber.centerYAnchor.constraint(equalTo: loadLabel.centerYAnchor).isActive = true
        progressNumber.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4).isActive = true
        progressNumber.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    private func load(){
        
        //Carica el info dal file accountinfo
        let LoadAccountInfoStatus = loadAccountInfo()
        if LoadAccountInfoStatus.0 != .Normal {
            redirect(status: LoadAccountInfoStatus.0, message: LoadAccountInfoStatus.1)
        }
            
        // Se tutto ok
        redirect(status: .Normal, message: "Success")

    }
    
    private func loadAccountInfo() -> (LoadStatus, String) {

        let loadStatus:(LoadStatus, String) = (.Normal, "No errors")

        // Caricamento del file originale di userinfo.plist
        let fullPathName = documentDir.appendingPathComponent("userinfo.plist")
        
        guard let sourceFilePath = Bundle.main.path(forResource: "userinfo", ofType: "plist") else{
            return (.Critical, "Critical001:: userinfo.plist is missing. Please, add it to the main path")
        }
        
        guard let originalPlist = NSMutableDictionary(contentsOfFile:sourceFilePath) else{
            return (.Critical, "Critical002: Error loading contents of  \(fullPathName)")
        }
        
        defaultPlist = originalPlist
        
        // Caricamento del file originale di userinfo.plist
        guard let virtualPList = NSMutableDictionary(contentsOfFile: fullPathName) else{
            
            // Se il caricamento non è andato a buon fine provo a ricrearlo
            let fileManager = FileManager.default
            
            if !fileManager.fileExists(atPath: fullPathName){
                // Il file non esiste lo creo quindi sulla base dell'originale
                if !originalPlist.write(toFile: fullPathName, atomically: false){
                    return (.Critical, "FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN ViewController")
                }
            }
            clientData = originalPlist
            return (.Warning, "[Notice]: OriginalPlist being used.")
        }
        
        clientData = virtualPList
        
        return loadStatus
    }
    
    private func redirect(status st:LoadStatus, message msg:String){
        
        switch st {
        case .Normal:
            print("Load Status: Normal")
            print(msg)
            global.prioirityLoad()
        case .Warning:
            print("Load Status: Warning")
            print(msg)
            global.prioirityLoad()
        case .Critical:
            print("Load Status: Critical")
            print(msg)
        case .Backup:
            print("Load Status: Backup")
            print(msg)
            //backup(filepath: documentDir.appendingPathComponent("userinfo.plist"))
            global.prioirityLoad()
        case .Reset:
            print("Load Status: Reset") //Virtual List exists, but needs update
            hardReset(filepath: documentDir.appendingPathComponent("userinfo.plist"))
            global.prioirityLoad()
        }
        
    }
 
    private func hardReset(filepath: String){
        if !defaultPlist.write(toFile: filepath, atomically: false){
            redirect(status: .Critical, message: "FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN ViewController.hardReset")
        }
        clientData = defaultPlist
    }

    // Preload

    @objc func preloadDone(_ info:Notification) {
        print("Preload ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            self.bview.removeFromSuperview()

            let scene = MainMenu(size: CGSize(width: ScreenSize.width, height: ScreenSize.heigth))
            self.skView.presentScene(scene)
            self.skView.ignoresSiblingOrder = true
            self.skView.isMultipleTouchEnabled = false
            self.skView.showsNodeCount = true
            scene.scaleMode = .aspectFill

        }
        
    }
    
    @objc func progressTrack(_ info:Notification) {
        let percentage = info.userInfo?["Left"]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            print(String(percentage as! Int) + "%")
            self.progressNumber.text =  String(percentage as! Int) + "%"
        }
    }

    // Standard
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
