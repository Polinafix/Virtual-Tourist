//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Polina Fiksson on 17/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

// MARK: - Constants

struct Constants {
    
    // MARK: Flickr
    struct Flickr {
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest" 
    }

    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Bbox = "bbox"
        static let SafeSearch = "safe_search"
        static let Page = "page"
        static let Extras = "extras"
        static let Format = "format"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let PerPage = "per_page"
        static let Radius = "radius"
        static let RadiusUnits = "radius_units"
        static let NoJSONCallback = "nojsoncallback"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let APIKey = "bccd2636da81691d1cd4dc2df88f907e"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" 
        static let MediumURL = "url_m"
        static let SearchMethod = "flickr.photos.search"
        static let UseSafeSearch = "1"
        static let Radius = "5"
        static let RadiusUnits = "mi"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}
