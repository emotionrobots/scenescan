//
//  WorldMapIO.swift
//  SceneScan
//
//  Created by Larry Li on 12/14/21.
//
import ARKit


extension ARWorldMap {
        
    ///  Save ARWorldMap
    func save(url: URL, completion: @escaping (String?)->Void ) {
        var err: String?
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            try data.write(to: url, options: [.atomic])
        }
        catch {
            err = "File writing error"
        }
        completion(err)
    }


    /// Load ARWorldMap and run it
    static func load(url: URL) -> ARWorldMap? {
        var worldMap: ARWorldMap?
        let data = try? Data(contentsOf: url)
        if let data = data {
            worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
        }
        return worldMap
    }
}
