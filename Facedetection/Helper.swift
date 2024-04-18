//
//  Helper.swift
//  Facedetection
//
//  Created by Ajin on 18/04/24.
//

import UIKit

extension UIViewController{
    public func convertUnitToPoint(orginalImageRect: CGRect, targetRect: CGRect)-> CGRect{
        
        var pointRect = targetRect
        
        pointRect.origin.x = orginalImageRect.origin.x + (targetRect.origin.x * orginalImageRect.size.width)
        pointRect.origin.y = orginalImageRect.origin.y + (1 - targetRect.origin.y - targetRect.height) * orginalImageRect.size.height
        pointRect.size.width *= orginalImageRect.size.width
        pointRect.size.height *= orginalImageRect.size.height
        
        return pointRect
    }
    
    public func determineScale(cgImage: CGImage, imageViewFrame: CGRect)-> CGRect{
        let originalWidth = CGFloat(cgImage.width)
        let originalHeight = CGFloat(cgImage.height)
        
        let imageFrame = imageViewFrame
        let widthRatio = originalWidth / imageFrame.width
        let heightRatio = originalHeight / imageFrame.height
        
        let scaleRatio = max(widthRatio, heightRatio)
        
        let scaledImageWidth = originalWidth / scaleRatio
        let scaledImageHeight = originalHeight / scaleRatio
        
        let scaledImageX = (imageFrame.width - scaledImageWidth) / 2
        let scaledImageY = (imageFrame.height - scaledImageHeight) / 2
        
        return CGRect(x: scaledImageX, y: scaledImageY, width: scaledImageWidth, height: scaledImageHeight)
    }
}

extension CGImagePropertyOrientation{
    init(_ orientation: UIImage.Orientation){
        switch orientation {
        case .up:
            self = .up
        case .down:
            self = .down
        case .left:
            self = .left
        case .right:
            self = .right
        case .upMirrored:
            self = .upMirrored
        case .downMirrored:
            self = .downMirrored
        case .leftMirrored:
            self = .leftMirrored
        case .rightMirrored:
            self = .rightMirrored
        default:
            self = .up
        }
    }
}
