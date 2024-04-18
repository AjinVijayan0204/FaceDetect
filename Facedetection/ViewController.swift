//
//  ViewController.swift
//  Facedetection
//
//  Created by Ajin on 18/04/24.
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageOrientation = CGImagePropertyOrientation(.up)
    
    override func viewDidLoad() {

        if let image = UIImage(named: "people"){
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageOrientation = CGImagePropertyOrientation(image.imageOrientation)
            
            guard let cgImage = image.cgImage else { return }
            
            setupVision(image: cgImage)
        }
    }

    private func setupVision(image: CGImage){

        let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaceDetectionRequest)
#if targetEnvironment(simulator)
    faceDetectionRequest.usesCPUOnly = true
#endif
        let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: imageOrientation, options: [:])
        
        do{
            try imageRequestHandler.perform([faceDetectionRequest])
        }catch let error as NSError{
            print(error)
            return
        }
        
    }
    
    private func handleFaceDetectionRequest(request: VNRequest?, error: Error?){
        if let requestError = error as NSError?{
            print(requestError)
            return
        }
        DispatchQueue.main.async {
            guard let image = self.imageView.image else { return }
            guard let cgImage = image.cgImage else { return }
            
            let imageRect = self.determineScale(cgImage: cgImage, imageViewFrame: self.imageView.frame)
            
            self.imageView.layer.sublayers = nil
            if let results = request?.results as? [VNFaceObservation] {
                for observation in results{
                    let faceRect = self.convertUnitToPoint(orginalImageRect: imageRect, targetRect: observation.boundingBox)
                    let emojiRect = CGRect(x: faceRect.origin.x,
                                           y: faceRect.origin.y - 5,
                                           width: faceRect.size.width + 5,
                                           height: faceRect.size.height + 5)
                    let textLayer = CATextLayer()
                    textLayer.string = "⚽️"
                    textLayer.fontSize = faceRect.width
                    textLayer.frame = emojiRect
                    textLayer.contentsScale = UIScreen.main.scale
                    
                    self.imageView.layer.addSublayer(textLayer)
                }
            }
        }
        
        
    }
}

