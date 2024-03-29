//
//  VisionObjectRecognitionViewController.swift
//  artlookup
//
//  Created by Дмитрий Лисин on 05.12.2019.
//  Copyright © 2019 Дмитрий Лисин. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

protocol VisionObjectRecognitionViewControllerDelegate: AnyObject {
    func mostLikelyObject(object: VNClassificationObservation?)
}

class VisionObjectRecognitionViewController: ViewController {
    private var requests = [VNRequest]()
    
    weak var delegate: VisionObjectRecognitionViewControllerDelegate?
    
    @discardableResult
    func setupVision() -> NSError? {
        let error: NSError! = nil
        
        do {
            let visionModel = try VNCoreMLModel(for: Resnet50().model)
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                self.delegate?.mostLikelyObject(object: request.results?.first as? VNClassificationObservation)
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
                
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    override func setupAVCapture() {
        super.setupAVCapture()
        
        setupVision()
        startCaptureSession()
    }
}
