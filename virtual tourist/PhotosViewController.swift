//
//  PhotosViewController.swift
//  virtual tourist
//
//  Created by Abdualrahman on 6/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttomLoading: UIBarButtonItem!
    @IBOutlet weak var messageNoImages: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var fetchedResultsController : NSFetchedResultsController<Photo>!
    var pin : Pin!
    var pageNumber = 1
    var isDeletingEverything = false
    
    var context : NSManagedObjectContext {
        return DataController.sharedInstance.viewContext
    }
    
    var doWeHavePhotos : Bool {
        return (fetchedResultsController.fetchedObjects?.count ?? 0) != 0
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
        let fetchRequest : NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            if doWeHavePhotos {
                updateUI(processing: false)
            } else {
            buttomNewPhotos(self)
            }
            
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    @IBAction func buttomNewPhotos(_ sender: Any) {
        updateUI(processing: true)
        
        if doWeHavePhotos {
            isDeletingEverything = true
            for photo in fetchedResultsController.fetchedObjects! {
                context.delete(photo)
            }
            try? context.save()
            isDeletingEverything = false
        }
        FlickrAPI.getPhotosUrls(with: pin.coordinate, pageNumber: pageNumber) { (urls, error, errorMessage) in
            DispatchQueue.main.async {
                
                self.updateUI(processing: false)
                
                guard (error == nil) && (errorMessage == nil) else {
                    self.alert(title: "Error", message: error?.localizedDescription ?? errorMessage)
                    return
                }
                
                guard let urls = urls, !urls.isEmpty else {
                    self.messageNoImages.isHidden = false
                    return
                }
                
                self.messageNoImages.isHidden = true

                for url in urls {
                    let photo = Photo(context: self.context)
                    photo.imageURL = url
                    photo.pin = self.pin
                }
                
            try? self.context.save()
                
            }
        
        }
        pageNumber += 1
    }
    func updateUI(processing: Bool) {
        collectionView.isUserInteractionEnabled = !processing
        if processing {
            buttomLoading.title = ""
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
            buttomLoading.title = "New Collection"
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
        let photo = fetchedResultsController.object(at: indexPath)
        cell.imageView.setPhoto(photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = fetchedResultsController.object(at: indexPath)
        context.delete(photo)
        try? context.save()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-20) / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let indexpath = indexPath, type == .delete && !isDeletingEverything {
            collectionView.deleteItems(at: [indexPath!])
            return
        }
        if let indexpath = indexPath, type == .insert {
            collectionView.insertItems(at: [indexPath!])
            return
        }
        if let newIndexPath = newIndexPath, let oldIndexPath = indexPath, type == .move {
            collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
            return
        }
        if type != .update {
            collectionView.reloadData()
        }
    }
}
