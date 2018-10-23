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
	
	var ref : DatabaseReference!
	var handle : DatabaseHandle!
	
	private let locationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		ref = Database.database().reference().child("remarks")
		
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		
		loadCoords()
	}

	
	func loadCoords() {
		ref.observe(.value, with: { (snapshot) in
			
			//prevent duplicate markers when Firebase live-updates
			self.mapView.clear()
			
			//Iterate over all Firebase objects, add remarks to mapView
			for child in snapshot.children {
				if let remarkSnapshot = child as? DataSnapshot,
					let remarkItem = RemarkItem(snapshot: remarkSnapshot) {
					
					let pos = CLLocationCoordinate2D(latitude: remarkItem.lat ,
													 longitude: remarkItem.lng)
					
					let marker = GMSMarker(position: pos)
					marker.title = remarkItem.user
					marker.snippet = remarkItem.remark
					marker.map = self.mapView
				}
			}
		}) { (Error) in
			print("Error")
		}
		
	}
	
	func saveRemark(user: String, remark: String, lat: Double, lng: Double) {
	
		let remarkItem = RemarkItem(user: user,
									remark: remark,
									lat: lat,
									lng: lng)
		
		//Generate unique node object name
		let remarkItemRef = self.ref.childByAutoId()
		
		remarkItemRef.setValue(remarkItem.toAnyObject())
	}

	@IBAction func addNoteAction(_ sender: UIBarButtonItem) {
		
		if mapView.isMyLocationEnabled {
			print("add note pressed")
			
			let alert = UIAlertController(title: "Leave Remark at your location...", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			
			alert.addTextField(configurationHandler: { nameField in
				nameField.placeholder = "Username..."
			})
			
			alert.addTextField(configurationHandler: { remarkField in
				remarkField.placeholder = "Your remark..."
			})
			
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
				
				let name = alert.textFields?.first?.text
				let remark = alert.textFields?.last?.text
				
				//Only save remark if input is not empty
				if !(name?.isEmpty)! && !(remark?.isEmpty)! {
					print("Your name: \(name!)")
					print("remark: \(remark!)")
					let pos = self.mapView.myLocation?.coordinate
					
					self.saveRemark(user: name!, remark: remark!, lat: (pos?.latitude)!, lng: (pos?.longitude)!)
				}

			}))
			
			self.present(alert, animated: true)
		}
			
		//Show error message if user denied initial location permission request
		else {
			let locationAlert = UIAlertController(title: "Location Access Denied", message: "Please enable location access for Landmark Remark" , preferredStyle: .alert)
			locationAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
			self.present(locationAlert, animated: true, completion: nil)
		}
		
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
		
		//TODO change zoom level
		mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 2, bearing: 0, viewingAngle: 0)
		
		locationManager.stopUpdatingLocation()
	}
}



