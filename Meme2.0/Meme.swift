//
//  Meme.swift
//  ImagePicker
//
//  Created by Christine Chao on 5/9/17.
//  Copyright © 2017 Christine Chao. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topText:String
    let bottomText:String
    let originalImage:UIImage
    let memedImage:UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    init(fromImageWithDefaultValues image: UIImage) {
        topText = "TOP"
        bottomText = "BOTTOM"
        originalImage = image
        memedImage = image
    }
}
