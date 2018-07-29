//
//  CustomImageView.swift
//  Gazorpian
//
//  Created by Christopher Norman on 9/25/17.
//  Copyright © 2017 yakuza. All rights reserved.
//

import UIKit
import AVKit
import Alamofire

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
        Alamofire.download(url, to: destination).response { response in
            print(response.destinationURL!)
            
            if response.error != nil, let imagePath = response.destinationURL{
                let asset = AVURLAsset(url: imagePath)
                let _duration = asset.duration
                print(_duration)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                let time = CMTimeMake(1, 1)
                let imageRef = try! imageGenerator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage:imageRef)
                imageCache[url.absoluteString] = thumbnail
                
                DispatchQueue.main.async {
                    self.image = thumbnail
                }
            }
        }
    }
}
