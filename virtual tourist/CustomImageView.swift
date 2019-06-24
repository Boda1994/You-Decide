//
//  CustomImageView.swift
//  virtualtourist
//
//  Created by Abdualrahman on 6/19/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit


protocol CustomImageViewDelegate {
    func imageDidDownload()
}

let imagesCache = NSCache<NSString, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageURL : URL!
    
    func setPhoto(_ newPhoto: Photo) {
        if photo != nil {
            return
        }
        photo = newPhoto
    }
    
    private var photo : Photo! {
        didSet {
            if let image = photo.getImage() {
                hideActivityIndiactorView()
                self.image = image
                return
            }
            
            guard let url = photo.imageURL else {
                return
            }
            loadImagesUsingCache(with: url)
        }
    }
    
    func loadImagesUsingCache(with url: URL) {
        imageURL = url
        image = nil
        showActivityIndiactorView()
        
        if let cachedImage = imagesCache.object(forKey: url.absoluteString as NSString) as?
            UIImage {
            image = cachedImage
            hideActivityIndiactorView()
            return
            }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
        }
            guard let DownloadedImage = UIImage(data: data!) else {return}
            imagesCache.setObject(DownloadedImage, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                self.image = DownloadedImage
                self.photo.set(image: DownloadedImage)
                try? self.photo.managedObjectContext?.save()
                self.hideActivityIndiactorView()
            }
            
        }.resume()
    }
    
    lazy var activityIndiactorView : UIActivityIndicatorView = {
        let activityIndiactorView = UIActivityIndicatorView(style: .whiteLarge)
        self.addSubview(activityIndiactorView)
        activityIndiactorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndiactorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndiactorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndiactorView.color = .black
        activityIndiactorView.hidesWhenStopped = true
        return activityIndiactorView
    } ()
    
    func showActivityIndiactorView() {
        DispatchQueue.main.async {
            self.activityIndiactorView.startAnimating()
        }
    }
    func hideActivityIndiactorView() {
        DispatchQueue.main.async {
            self.activityIndiactorView.stopAnimating()
        }
    }
}
