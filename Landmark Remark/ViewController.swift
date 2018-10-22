//
//  ViewController.swift
//  Landmark Remark
//
//  Created by Jamie Astley on 19/10/18.
//  Copyright © 2018 jastley. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import FirebaseDatabase

class ViewController: UIViewController {

	@IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var saveNote: UIBarButtonItem!
	
	var ref : DatabaseReference!
	var handle : DatabaseHandle!
	
	private let locationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		ref = Database.database().reference().child("remarks")
			
//			.childByAutoId().setValue(["username": "test", "note": "blah blah"])
		
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		
		loadCoords()
//		ref.childByAutoId().setValue(["username": "test", "note": "blah blah"])
	}
	
//	func dataTest(user: String, note: String, lat: Double, lng: Double) {
//		ref.childByAutoId().setValue(["username": user,
//									  "note": note,
//									  "lat": lat,
//									  "lng": lng])
//	}
	
	func loadCoords() {
		ref.observe(.value, with: { (snapshot) in
			
			for child in snapshot.children {
				print(child)
				
				for notes in snapshot.children.allObjects as! [DataSnapshot] {
					let noteObj = notes.value as? [String: AnyObject]
					let lat = noteObj?["lat"]
					let lng = noteObj?["lng"]
					let username = noteObj?["username"]
					let remark = noteObj?["note"]
					
					let pos = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees)
					let marker = GMSMarker(position: pos)
					marker.title = username as? String
					marker.map = self.mapView
					marker.snippet = remark as? String
				}
				
			}
		}) { (Error) in
			print("Error")
		}
		
//		ref.observeSingleEvent(of: .value, with: { (snapshot) in
//			let value = snapshot.value as? NSDictionary
//
//		})
	}


}

extension ViewController: CLLocationManagerDelegate {
	
	//initialise user location
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		guard status == .authorizedWhenInUse else {
			return
		}
		
		locationManager.startUpdatingLocation()
		
		mapView.isMyLocationEnabled = true
		mapView.settings.myLocationButton = true
		mapView.accessibilityElementsHidden = false
	}
	
	//Re-center map on location update
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.first else {
			return
		}
		
		mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 2, bearing: 0, viewingAngle: 0)
		
//		dataTest(user: "someone", note: "blahcgf", lat: location.coordinate.latitude, lng: location.coordinate.longitude)
//		ref.childByAutoId().setValue(["username": "test",
//									  "note": "blah blah",
//									  "coords": location.coordinate])
		
		locationManager.stopUpdatingLocation()
	}
}



