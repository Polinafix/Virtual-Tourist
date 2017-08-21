//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Polina Fiksson on 15/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editLabel: UILabel!
    var editBtn:UIBarButtonItem!
     //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        editLabel.isHidden = true
        mapView.delegate = self
        
        editBtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editPins))
        navigationItem.rightBarButtonItem = editBtn
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPressGesture)
        fetchPins()
    }
    
    func editPins(){
        print("hello")
        editLabel.isHidden = false
        if isEditing{
            print("is editing")
            editLabel.isHidden = true
            self.setEditing(false, animated: true)
        }else{
            editBtn.title = "Done"
            editLabel.isHidden = false
            self.setEditing(true, animated: true)
            
        }
    }

    

    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            print(coordinate)
            //Now use this coordinate to add annotation on map.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
           savePin(lat: annotation.coordinate.latitude, lon: annotation.coordinate.longitude)
            performUIUpdatesOnMain {
                self.fetchPins()
            }
        }
    }
    
    func savePin(lat:Double, lon: Double){
        //let managedContext = self.appDelegate.getContext()
        _ = Pin(lat, lon, context: managedContext)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Save error: \(error),description: \(error.userInfo)")
        }
    }
    
    func fetchPins(){
        //let managedContext = self.appDelegate.getContext()
        let pinFetch:NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do{
            let results = try managedContext.fetch(pinFetch)
            var annotations = [MKPointAnnotation]()
            if results.count > 0{
                
                for result in results{
                    let lat = CLLocationDegrees(result.latitude)
                    let lon  = CLLocationDegrees(result.longitude)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotations.append(annotation)
                    
                }
                performUIUpdatesOnMain {
                    self.mapView.addAnnotations(annotations)
                    print("annotations added to the map view.")
                }
                
            }else{
                print("no pins located yet")
            }
        }catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //let managedContext = self.appDelegate.getContext()
        mapView.deselectAnnotation(view.annotation, animated: true)
        let lat = view.annotation?.coordinate.latitude
        let lon = view.annotation?.coordinate.longitude
        print("selected pin's lat:\(lat), lon:\(lon)")
        let selectedPin = Pin(lat!, lon!, context: managedContext)
             //Perform segue to the photo album
        print("Perform segue to the photo album.")
        performUIUpdatesOnMain {
        self.performSegue(withIdentifier: "PhotoAlbumView", sender: selectedPin)
        }
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoAlbumView" {
            let controller = segue.destination as! PinImagesViewController
            let selectedPin = sender as! Pin
            controller.currentPin = selectedPin
        }
    }
}
        
        




