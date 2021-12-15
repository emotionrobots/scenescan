//
//  Globals.swift
//  SceneScan
//
//  Created by Larry Li on 12/14/21.
//

import ARKit

var defaultConfiguration: ARWorldTrackingConfiguration {
    let configuration = ARWorldTrackingConfiguration()
    configuration.sceneReconstruction = .mesh
    configuration.environmentTexturing = .automatic
    configuration.wantsHDREnvironmentTextures = true
    return configuration
}
