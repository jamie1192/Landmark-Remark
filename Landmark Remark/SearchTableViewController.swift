//
//  SearchViewController.swift
//  Landmark Remark
//
//  Created by Jamie Astley on 24/10/18.
//  Copyright © 2018 jastley. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchTableViewController: UITableViewController {

	var ref : DatabaseReference!
	var remarks: [RemarkItem] = []

	
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference().child("remarks")
		tableView.estimatedRowHeight = 130
		tableView.rowHeight = UITableView.automaticDimension
		loadRemarks()
		self.searchRemarks(forQuery: "G")
    }
	
	func loadRemarks() {
		ref.observe(.value, with: { snapshot in
			
			var newRemarks: [RemarkItem] = []
			
			for child in snapshot.children {
				
				if let snapshot = child as? DataSnapshot,
					let remarkItem = RemarkItem(snapshot: snapshot) {
					newRemarks.append(remarkItem)
				}
			}
			
			self.remarks = newRemarks
			self.tableView.reloadData()
		})
	}
	
	func searchRemarks(forQuery query: String) {
		
		//"\u{f8ff}" represents "any" character in unicode, required for trailing of query
		ref.queryOrdered(byChild: "user").queryStarting(atValue: query).queryEnding(atValue: query + "\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
			
			print(snapshot.value!)
		}) { (err) in
			print(err)
		}
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return remarks.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "RemarkTableViewCell", for: indexPath) as! RemarkTableViewCell
		
		let remarkItem = remarks[indexPath.row]
		
		cell.userLabel?.text = remarkItem.user
		cell.remarkLabel?.text = remarkItem.remark
		
		return cell
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
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

// MARK: - Custom cell

class RemarkTableViewCell: UITableViewCell {
	
	@IBOutlet weak var userLabel: UILabel!
	@IBOutlet weak var remarkLabel: UILabel!
	
}
