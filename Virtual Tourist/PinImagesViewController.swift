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
    @IBOutlet weak var newCollButton: UIButton!
    
    //var managedContext: NSManagedObjectContext!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    var currentPin:Pin!
    var photoArray:[Photo] = [Photo]()
    var selectedCells:[IndexPath] = [IndexPath]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //collectionView.allowsMultipleSelection = true
        
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
    //downloading images from Flickr
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
    @IBAction func buttonClicked(_ sender: UIButton) {
        if sender.titleLabel?.text == "New Collection"{
            print("new collection")
        }else{
            print("delete photos")
            deleteImages()
            collectionView.reloadData()
            newCollButton.setTitle("New Collection", for: .normal)
            
        }
        
    }
    
    func deleteImages(){
        
        let managedContext = self.appDelegate.getContext()
        for indexPath in selectedCells{
            let photo = photoArray[indexPath.row]
            managedContext.delete(photo)
            photoArray.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }
        //save the changes
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Save error: \(error),description: \(error.userInfo)")
        }
        //update the array with indices
        selectedCells = [IndexPath]()
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
                cell?.imageView.image = UIImage(data:photo.photoData as! Data)
                cell?.activityIndicator.stopAnimating()
                cell?.activityIndicator.hidesWhenStopped = true
            }
            
        }else{
            FlickrRequest.sharedInstance.fromDataToUrl(photo.photoUrl!, { (returnedData, error) in
                if let photoData = returnedData{
                    performUIUpdatesOnMain {
                        photo.photoData = photoData as NSData?
                        cell?.imageView.image = UIImage(data: photo.photoData as! Data)
                        cell?.activityIndicator.stopAnimating()
                        cell?.activityIndicator.hidesWhenStopped = true
                    }
                }else{
                    print("Data error: \(error)")
                }
            })
        }
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //add implementation
        
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        
        //check if it has already been selected
        if let index = selectedCells.index(of: indexPath){

            selectedCells.remove(at: index)
            cell.imageView.alpha = 1.0

            print("Not new:\(selectedCells.count)")
            
        }else{
            selectedCells.append(indexPath)
            //selectedCells.sorted(by: <#T##(NSIndexPath, NSIndexPath) -> Bool#>)
             print("new:\(selectedCells.count)")
             cell.imageView.alpha = 0.4
        }
        
        if selectedCells.count > 0{
            print("more")
            newCollButton.setTitle("Remove Selected Pictures", for: .normal)
            
        
        }else{
            print("less")
            newCollButton.setTitle("New Collection", for: .normal)
        }
        
    }

   

}
