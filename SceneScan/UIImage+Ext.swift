//
//  UIImage+Ext.swift
//  SceneScan
//
//  Created by Larry Li on 12/13/21.
//

import UIKit

extension UIImage {
    
    /// Resize the image
    func resize(size: CGSize) -> UIImage? {
        let widthRatio  = size.width  / self.size.width
        let heightRatio = size.height / self.size.height
            
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: self.size.width * heightRatio, height: self.size.height * heightRatio)
        } else {
            newSize = CGSize(width: self.size.width * widthRatio, height: self.size.height * widthRatio)
        }
            
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
            
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
        return newImage
    }
}
