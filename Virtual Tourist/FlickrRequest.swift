//
//  FlickrRequest.swift
//  Virtual Tourist
//
//  Created by Polina Fiksson on 17/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation
import UIKit

class FlickrRequest: NSObject{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let sharedInstance = FlickrRequest()
    
    
    func getFlickrImages(_ selectedPin: Pin,_ completionHandler: @escaping(_ result:[Photo]?,_ error:NSError?) -> Void) {
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.Bbox: bboxString(selectedPin.latitude, selectedPin.longitude),
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.PerPage: "20",
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch
        ] as [String : Any]
        
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url: urlFromParameters(methodParameters))
        
        /* 4. Make the request */
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //if an error occurs, print it and re-enable the UI
            func displayError(_ error: String){
                print(error)
                performUIUpdatesOnMain {
                    print("Error")
                }
            }
            
            //was there an error?
            guard (error == nil) else{
                displayError("There was an error with your request: \(error)")
                return
            }
            //Did we get a successful 2xx response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            //was there any data returned?
            guard let data = data else{
                displayError("No data was returned by the request")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult:[String:AnyObject]
            do{
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            }catch{
                displayError("Unable to parse the data as JSON")
               
                return
            }
            
            //get the photos Dictionary at the "photos" key
            if let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject],
                //in the photos dictionary, get the array of photo dictionaries at the 'photo' key
                let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]]{
                
                
                /* 6. Use the data! */
                performUIUpdatesOnMain {
                    
                   // print("number of photosArray:\(photosArray.count)")
                    
                    let context = self.appDelegate.getContext()
                    var images = [Photo]()
                    
                    for photo in photosArray {
                        
                        guard let urlString = photo[Constants.FlickrResponseKeys.MediumURL] as? String else {
                            print("Cannot find key '\(Constants.FlickrResponseKeys.MediumURL)' in \(photosArray)")
                            return
                        }
                            
                            if let url  = URL(string: urlString){
                                let data = NSData(contentsOf: url)
                                let photo = Photo(photoData: data as! Data , location: selectedPin, insertInto: context)
                                images.append(photo)
                                do {
                                    try context.save()
                                } catch let error as NSError {
                                    print("Save error: \(error),description: \(error.userInfo)")
                                }
                            }
                            
                        
                    }
                
                    completionHandler(images,nil)
                
                    
                    
                    
                }
            }
        
    }
        // start the task!
        task.resume()
      
}
    func urlFromParameters(_ parameters: [String:Any]) -> URL {
        var components = URLComponents()
        components.scheme = Constants.Flickr.ApiScheme
        components.host = Constants.Flickr.ApiHost
        components.path = Constants.Flickr.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    func bboxString(_ longitude:Double,_ latitude:Double) -> String {
        let minimumLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let minimumLat = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
        let maximumLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let maximumLat = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
}

