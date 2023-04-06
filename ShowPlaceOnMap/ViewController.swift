//
//  ViewController.swift
//  ShowPlaceOnMap
//
//  Created by Sakshi Yelmame on 04/04/23.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        // Ignoring User
        UIApplication.shared.beginIgnoringInteractionEvents()
        // Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        // Hide Search Bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        // Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (responce, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if responce == nil
            {
                print("ERROR")
            }
            else
            {
                // Remove Annotations
                let annotation = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotation)
                // Getting Data
                let latitude = responce?.boundingRegion.center.latitude
                let longitude = responce?.boundingRegion.center.longitude
                // Creating Annotation
                let annotations = MKPointAnnotation()
                annotations.title = searchBar.text
                annotations.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
               self.myMapView.addAnnotation(annotations)
                // Zooming in on annotaion
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.myMapView.setRegion(region, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

