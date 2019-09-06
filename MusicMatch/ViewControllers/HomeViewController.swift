//
//  HomeViewController.swift
//  MusicMatch
//
//  Created by James Wo on 9/4/19.
//  Copyright © 2019 James Wo. All rights reserved.
//

import UIKit
import Firebase
import Geofirestore
import CoreLocation

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    var currentLocation: CLLocation = CLLocation(latitude: 37.7853889, longitude: -122.4056973)
    var userLocation: CLLocation = CLLocation(latitude: 37.7853889, longitude: -122.4056973)
    let geoFirestoreRef = Firestore.firestore().collection("users")
    
    var artists = [String]() // <-- If this is made an array literal, everything works
    var db: Firestore!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        table.dataSource = self
        table.delegate = self
        artistTextField.delegate=self
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            print("Hello")
            locationManager.delegate=self
            locationManager.desiredAccuracy=kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        loadData()
        table.tableFooterView = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor(red: 234/255, green: 199/255, blue: 215/255, alpha: 1.0)
        table.backgroundView?.backgroundColor = UIColor(red: 234/255, green: 199/255, blue: 215/255, alpha: 1.0)
        addButton.backgroundColor = UIColor(red: 234/255, green: 199/255, blue: 215/255, alpha: 1.0)
        addButton.setTitleColor(.white, for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
    }
    
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if(artists.isEmpty){
            return
        }
        startSearching()
    }
    
    func startSearching(){
        
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)
        let queryCircle = geoFirestore.query(withCenter: currentLocation, radius: 0.6)
        let queryHandle = queryCircle.observe(.documentEntered) { (key, location) in
            
        }
        
    }
    
    func transitionToHome(){
        let ViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ChatController)
        view.endEditing(true)
        view.window?.rootViewController = ViewController
        view.window?.makeKeyAndVisible()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        currentLocation = userLocation
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)
        geoFirestore.setLocation(location: userLocation, forDocumentWithID: Auth.auth().currentUser!.uid)
        print(userLocation)
    }
    func loadData() {
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
            if let document = document {
                self.artists = document["artists"] as! [String]
                self.table.reloadData()
                print(self.artists)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if(artistTextField.text == ""){
            return
        }
        else{
            insertNewArtist()
        }
    }
    
    func insertNewArtist(){
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData(["artists": FieldValue.arrayUnion([artistTextField.text!])])
        artists.append(artistTextField.text!)
        let indexPath = IndexPath(row: artists.count - 1, section:0)
        table.beginUpdates()
        table.insertRows(at: [indexPath], with: .automatic)
        table.endUpdates()
        artistTextField.text = ""
        view.endEditing(true)
        
    }
    //Tableview setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Tableview setup \(artists.count)")
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let artist = artists[indexPath.row]
        cell.textLabel?.text = artist
        print("Array is populated \(artist)")
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData(["artists": FieldValue.arrayRemove([artists[indexPath.row]])])
            //when delete is pressed
            artists.remove(at: indexPath.row)
            table.beginUpdates()
            table.deleteRows(at: [indexPath], with: .automatic)
            table.endUpdates()
        }
    }
}
