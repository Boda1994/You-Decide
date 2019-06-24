//
//  PhotoExtension.swift
//  virtualtourist
//
//  Created by Abdualrahman on 6/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

extension Photo {

    func set(image: UIImage) {
        self.image = image.pngData()
    }
    
    func getImage() -> UIImage? {
        return (image == nil) ? nil : UIImage(data: image!)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
}
