//
//  RemarkItem.swift
//  Landmark Remark
//
//  Created by Jamie Astley on 21/10/18.
//  Copyright © 2018 jastley. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct RemarkItem {
	
	let ref: DatabaseReference?
	
	let key: String
	let user: String
	let remark: String
	let lat: Double
	let lng: Double
	
	init(key: String = "", user: String, remark: String, lat: Double, lng: Double) {
		self.ref = nil
		self.key = key
		self.user = user
		self.remark = remark
		self.lat = lat
		self.lng = lng
	}
	
	init?(snapshot: DataSnapshot) {
		guard
			let value = snapshot.value as? [String: AnyObject],
			let user = value["user"] as? String,
			let remark = value["remark"] as? String,
			let lat = value["lat"] as? Double,
			let lng = value["lng"] as? Double else {
				return nil
		}
		
		self.ref = snapshot.ref
		self.key = snapshot.key
		self.user = user
		self.remark = remark
		self.lat = lat
		self.lng = lng
	}
	
	func toAnyObject() -> Any {
		return [
			"user": user,
			"remark": remark,
			"lat": lat,
			"lng": lng
		]
	}
}
