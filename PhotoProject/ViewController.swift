//
//  ViewController.swift
//  PhotoProject
//
//  Created by John Regner on 6/26/16.
//  Copyright © 2016 WigglingScholars. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var entries = [JournalEntry](){
        didSet {
            tableView.reloadData()
        }
    }

    var moc: NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }

    override func viewDidLoad() {
        fetchNewData()
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(ViewController.coreDataChanged(_:)),
                         name: NSManagedObjectContextObjectsDidChangeNotification, object: nil)
    }

    func coreDataChanged(note: NSNotification) {
        // Note This is not the ideal way to perform this action. 
        // should be examining the notification to find out what changed. Where 
        // items inserted, or deleted, or changed in some other way. 
        // we should be able to then perform more targeted changes on our table view
        // (Any time you are just calling `tableView.reloadData()` you are probably doing it wrong
        fetchNewData()
    }

    func fetchNewData(){
        let fetch = NSFetchRequest(entityName: "JournalEntry")
        fetch.sortDescriptors = []
        if let result = try? moc.executeFetchRequest(fetch),
            let results = result as? [JournalEntry] {
            entries = results
        }
    }

    @IBAction func addImage(sender: UIBarButtonItem) {
        let picker = UIImagePickerController()

        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            picker.sourceType = .Camera
        } else {
            picker.sourceType = .PhotoLibrary
        }
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = entries[indexPath.row].timeStamp?.description ?? "new"
        cell.imageView?.image = entries[indexPath.row].img
        return cell
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            let entry = NSEntityDescription.insertNewObjectForEntityForName("JournalEntry", inManagedObjectContext: moc) as! JournalEntry
            entry.image = image
            entry.timeStamp = NSDate()
            _ = try? moc.save() //in this tiny example project we don't really care if the save fails
        }
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        print("Canceled")
    }
}
