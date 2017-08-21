//
//  PinImagesViewController.swift
//  Virtual Tourist
//
//  Created by Polina Fiksson on 17/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PinImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    //var managedContext: NSManagedObjectContext!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    var currentPin:Pin!
    var photoArray:[Photo] = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //add pin to a small map
        addPinToMap(currentPin.latitude, currentPin.longitude)
        
        fetchImages()

        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func addPinToMap(_ latitude: Double,_ longitude: Double){
        
        let annotation = MKPointAnnotation()
        let lat = CLLocationDegrees(latitude)
        let lon = CLLocationDegrees(longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.coordinate = coordinate
       
        //zoom into an appropriate region
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
        
        performUIUpdatesOnMain {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
        }
    }
    /* try fetching images from the core data. Check if images for the current location were downloaded before, if not - load photos from flickr*/
    func fetchImages(){
        let managedContext = self.appDelegate.getContext()
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        print("finished fetching")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "location = %@", currentPin!)
    
       do{
            let results = try managedContext.fetch(fetchRequest)
        //always prints the number of results = 0
            print("Number of results:\(results.count)")
            if results.count > 0{
                photoArray = results
                self.collectionView.reloadData()
                
            }else{
                loadPhotosFromFlickr()
            }
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
            
        }

        
    }
    
    func loadPhotosFromFlickr(){
        
        FlickrRequest.sharedInstance.getFlickrImages(currentPin) { (results, error) in
            
            if error == nil {
                
                performUIUpdatesOnMain {
                    
                    if results != nil{
                        self.photoArray = results!
                        print("\(self.photoArray.count) photos from flickr fetched")
                        self.collectionView.reloadData()
                    }
                }
                
            }else{
                
                print("couldn't get photos from flickr")
            }
        }
        
    
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
       //return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? ImageCollectionViewCell
        //cell?.imageView.image = UIImage(named:"temp")
        //cell?.activityIndicator.startAnimating()
        let photo = photoArray[indexPath.row]
        cell?.imageView.image = UIImage(named: "temp")
        cell?.activityIndicator.startAnimating()
        
        if photo.photoData != nil{
            performUIUpdatesOnMain {
                cell?.activityIndicator.stopAnimating()
            }
            cell?.imageView.image = UIImage(data:photo.photoData as! Data)
        }else{
            print("no info")
        }
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

   

}
