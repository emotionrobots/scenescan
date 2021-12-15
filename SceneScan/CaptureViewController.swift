//
//  CaptureViewController.swift
//  SceneScan
//
//  Created by Larry Li on 12/13/21.
//
import UIKit
import SceneKit
import ARKit
import RealityKit


class CaptureViewController: UIViewController, ARSessionDelegate {
   
    @IBOutlet var arView: ARView!
       
    @IBOutlet var captureBtn: UIButton!
    
    @IBOutlet var navigationItems: UINavigationItem!
    
    ///  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView.session.delegate = self
        
        arView.environment.sceneUnderstanding.options = []
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        arView.environment.sceneUnderstanding.options.insert(.physics)
        
        arView.debugOptions.insert(.showSceneUnderstanding)
        
        arView.renderOptions = [.disablePersonOcclusion, .disableDepthOfField, .disableMotionBlur]
        
        arView.automaticallyConfigureSession = false
        
        let stopRecordingBtn = UIImage(named: "stopRecordingBtn_173x173")!.resize(size: CGSize(width:80, height:80))
        let recordingBtn = UIImage(named: "recordingBtn_173x173")!.resize(size: CGSize(width:80, height:80))
        captureBtn.setImage(stopRecordingBtn, for: .selected)
        captureBtn.setImage(recordingBtn, for: .normal)

        // Create Render title bar button
        let renderItem = UIBarButtonItem(title: "Render 〉", style: .plain, target: self, action: #selector(segToRender))
        navigationItems.rightBarButtonItem = renderItem
        
        /*
        let configuration = defaultConfiguration
        arView.session.run(configuration)
        sleep(1)
        arView.session.pause()
        */
        
    }
    
    
    ///  viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent screen from dimming
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    
    ///  viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Re-enable screen dimming
        UIApplication.shared.isIdleTimerDisabled = false
        
        // Pause the view's session
        arView.session.pause()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    /// Segue to RenderViewController
    @objc func segToRender() {
        performSegue(withIdentifier: "segToRenderVC", sender: self)
    }
    
    
    /// Return map saving URL based on file selector
    lazy var mapSaveURL: URL = {
        do {
            return try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("map.arexperience")
        } catch {
            self.showAlert(title: "Error", message: "Can't get file save URL: \(error.localizedDescription)")
            exit(-1)
        }
    }()
    
    
    // Called opportunistically to verify that map data can be loaded from filesystem.
    /*
    var mapDataFromFile: Data? {
        var data: Data?
        
        data = try? Data(contentsOf: mapSaveURL)
        if data == nil {
            print("data is nil")
        }
        return data
    }
    */
    
    /*
    ///  Save ARWorldMap
    func saveWorldMap ( completion: @escaping (Bool)->Void ) {
        arView.session.getCurrentWorldMap { worldMap, error in
            var success = false
            
            guard let map = worldMap
            else {
                self.showAlert(title: "Warning", message: error!.localizedDescription)
                return
            }
                        
            do {
                let url = self.mapSaveURL
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: url, options: [.atomic])
                    
                // Show the saved file
                /*
                let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityController.popoverPresentationController?.sourceView = self.arView
                self.present(activityController, animated: true, completion: nil)
                */
                success = true
            }
            catch {
                print("Had a catch")
            }
            completion(success)
        }
    }
    
    
    /// Load ARWorldMap and run it
    func loadWorldMap() -> ARWorldMap? {
        var worldMap: ARWorldMap?
        let data = try? Data(contentsOf: mapSaveURL)
        if let data = data {
            worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
        }
        return worldMap
    }
    */
    
    /// Toggle the Scan button to start/stop capture
    @IBAction func onCaptureBtn(_ sender: UIButton) {
        if sender.isSelected {
            arView.session.getCurrentWorldMap { worldMap, error in
                if let map = worldMap {
                    map.save(url: self.mapSaveURL, completion: { err in
                        if let err = err {
                            self.showAlert(title: "Error", message: err)
                        }
                    })
                }
                else {
                    self.showAlert(title: "Warning", message: error!.localizedDescription)
                }
                self.arView.session.pause()
                sender.isSelected = false
            }
        }
        else {
            let configuration = defaultConfiguration
            if let worldMap = ARWorldMap.load(url: self.mapSaveURL) {
                configuration.initialWorldMap = worldMap
                arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            }
            else {
                arView.session.run(configuration)
            }
            sender.isSelected = true
        }
    }
    
    
    /// Render button press will cause navigation to RenderViewController
    @IBAction func onRenderBtn(_ sender: UIButton) {
       segToRender()
    }
    
    
    // MARK: - ARSessionDelegate
    
    /// This is called when a new frame has been updated.
    ///    @param session The session being run.
    ///    @param frame The frame that has been updated.
    ///
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
    }
    
    
    /// This is called when new anchors are added to the session.
    ///    @param session The session being run.
    ///    @param anchors An array of added anchors.
    ///
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
    }

    
    /// This is called when anchors are updated.
    ///    @param session The session being run.
    ///    @param anchors An array of updated anchors.
    ///
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
    }

    
    /// This is called when anchors are removed from the session.
    ///    @param session The session being run.
    ///    @param anchors An array of removed anchors.
    ///
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        
    }
}


