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
    var isEditingMode = true
    var pins = [Pin]()
   
    
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
        
        
        if isEditingMode{
            
            editBtn.title = "Done"
            editLabel.isHidden = false
            isEditingMode = false
            
        }else{
            editBtn.title = "Edit"
            editLabel.isHidden = true
            isEditingMode = true
            
        }
    }

    

    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.began{
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            
            let pin = Pin(coordinate.latitude, coordinate.longitude, context: managedContext)
            pins.append(pin)
            mapView.addAnnotation(pin.annotation)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Save error: \(error),description: \(error.userInfo)")
            }
            
            
        }
        
    }

    
    func fetchPins(){
        //let managedContext = self.appDelegate.getContext()
        let pinFetch:NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do{
            let results = try managedContext.fetch(pinFetch)
            
            if results.count > 0{
            print("found results")
            for result in results{
                pins.append(result)
                mapView.addAnnotation(result.annotation)
                
            }
            }else{
                print("no pins located yet")
            }
            
        }catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.animatesDrop = true
        
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
       
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        
       let lat = view.annotation?.coordinate.latitude
       let lon = view.annotation?.coordinate.longitude
       print("selected pin's lat:\(lat!), lon:\(lon!)")
        
        
       //let selectedPin = Pin(lat!, lon!, context: managedContext)
        
        if !isEditingMode{
            
            for pin in pins{
                
                if pin.latitude == lat && pin.longitude == lon{
                    managedContext.delete(pin)
                    do {
                        try self.managedContext.save()
                    } catch let error as NSError {
                        print("Save error: \(error),description: \(error.userInfo)")
                    }
                    
                    let index = pins.index(of: pin)
                    pins.remove(at: index!)
                    
                    
                    mapView.removeAnnotation(view.annotation!)
                    print("the pin was deleted")
                    print(pins.count)
                    
                }
                
            }
            
        }else{
        print("segue to the photo album.")
            for pin in pins{
                
                if pin.latitude == lat && pin.longitude == lon{
                    performSegue(withIdentifier: "PhotoAlbumView", sender: pin)
                }
                
            }
        
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
        
        




