//
//  SearchViewController.swift
//  Landmark Remark
//
//  Created by Jamie Astley on 24/10/18.
//  Copyright © 2018 jastley. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController {

	var ref : DatabaseReference!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference().child("remarks")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
