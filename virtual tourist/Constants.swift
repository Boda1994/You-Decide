//
//  Constants.swift
//  virtualtourist
//
//  Created by Abdualrahman on 6/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import MapKit

struct Constants {
    
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLateRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
        static let PerPage = "per_page"
    }
    
    struct FlickerParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        
        static let APIKey = "9d196ac678c1a087cfe3f244cd5e6c42"
        static let PerPage = 9
    }
}
