//
//  Extension.swift
//  ARKit-Measure
//
//  Created by Hubert Wang on 18/01/19.
//  Copyright © 2019 Hubert Wang. All rights reserved.
//

import Foundation
import UIKit
import ARKit

extension SCNNode {
    func distance(to destination: SCNNode) -> CGFloat {
        let dx = destination.position.x - position.x
        let dy = destination.position.y - position.y
        let dz = destination.position.z - position.z
        
        let meters = sqrt(dx*dx + dy*dy + dz*dz)
        
        return CGFloat(meters * 100)
    }
}
