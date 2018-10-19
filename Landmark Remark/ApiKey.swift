//
//  ApiKey.swift
//  Landmark Remark
//
//  Created by Jamie Astley on 19/10/18.
//  Copyright © 2018 jastley. All rights reserved.
//

import Foundation

//Google Maps API key is within a .gitignore file named "keys.plist" in project dir, this method retrieves it
func getApiKey(keyname:String) -> String {
	let filePath = Bundle.main.path(forResource: "keys", ofType: "plist")
	
	let keys = NSDictionary(contentsOfFile: filePath!)
	let value:String = keys?.object(forKey: keyname) as! String
	
	return value
}
