//
//  ImageProcessor.swift
//  SeeFood
//
//  Created by Joseph Toronto on 1/15/21.
//

import Foundation
import UIKit
import CoreML
import Vision

protocol ImageProcessorDelegate {
    func imageProcessorDidReturnResults(results: [String])
}

class ImageProcessor {
    var delegate:ImageProcessorDelegate?
    
    func detectAndClassifyImage(image: CIImage){
        
        DispatchQueue.background(delay: 0) {
            var resultsArray: [String] = []
            
            guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
                fatalError("Loading CoreML model failed")
            }
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else{
                    fatalError("VN Core ML Request failed")
                }
               // print(results)
                
                
                let firstTen = results.prefix(10)
                
                for result in firstTen {
                    resultsArray.append(result.identifier)
                }
            }
            let handler = VNImageRequestHandler(ciImage: image)
            do{
                try handler.perform([request])
            } catch{
                print(error)
            }
            self.delegate?.imageProcessorDidReturnResults(results: resultsArray)
        } completion: {
            
        }
        
    }
    
    
}

extension DispatchQueue { // Found here https://stackoverflow.com/questions/24056205/how-to-use-background-thread-in-swift

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
