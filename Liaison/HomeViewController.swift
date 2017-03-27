//
//  HomeViewController.swift
//  Liaison
//
//  Created by gabriel troia on 3/26/17.
//  Copyright © 2017 gabriel troia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var records = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadSampleRecords()
        
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as? RecordTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecordTableViewCell.");
        }
        
        let record = records[indexPath.row]
        
        cell.wordNameLabel.text = record.title
        
        return cell
        
    }
    
    private func loadSampleRecords() {
        guard let record1 = Record(title: "cat", audioURL: URL(string: "cat.m4a")!) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let record2 = Record(title: "dog", audioURL: URL(string: "cat.m4a")!) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let record3 = Record(title: "bird", audioURL: URL(string: "cat.m4a")!) else {
            fatalError("Unable to instantiate meal1")
        }
        
        records += [record1, record2, record3]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
