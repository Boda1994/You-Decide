//
//  MapViewController.swift
//  virtual tourist
//
//  Created by Abdualrahman on 6/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    
    var context : NSManagedObjectContext {
        return DataController.sharedInstance.viewContext
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            updateMapView()
        } catch {
            fatalError("The fetch could not be performd: \(error.localizedDescription)")
        }
    }
    
    @IBAction func loguot(_ sender: Any) {
        UdacityAPI.deleteSession { (error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    @IBAction func handleLongPeess(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began {return}
        let touchPoint = sender.location(in: mapView)
        let pin = Pin(context: context)
        pin.coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        try? context.save()
    }
    
    
    func updateMapView() {
        guard let pins = fetchedResultsController.fetchedObjects else {return}
        for pin in pins {
            if mapView.annotations.contains(where: { pin.compare(to: $0.coordinate) } ) {continue}
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotos" {
            let photosVC = segue.destination as! PhotosViewController
            photosVC.pin = sender as? Pin
         }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = fetchedResultsController.fetchedObjects?.filter { $0.compare(to: view.annotation!.coordinate) } .first!
            performSegue(withIdentifier: "ShowPhotos", sender: pin)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMapView()
    }

}
