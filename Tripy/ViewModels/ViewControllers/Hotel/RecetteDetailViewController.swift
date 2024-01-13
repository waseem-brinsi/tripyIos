//
//  FoodDetailViewController.swift
//  Tripy
//
//
//

import UIKit
import JWTDecode

class RecetteDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    
    
    
    @IBAction func reportAction(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        print("clicked")
        
        let userId = defaults.object(forKey: "userId") as! String
        
        // Set the URL for the POST request
        let url = URL(string: "http://172.18.21.85:3000/api/reports")!

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set the request body
        let params = ["userId": userId, "recetteId": recetteDetail?._id, "recetteName":recetteDetail?.name]
                    
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a URLSession instance
        let session = URLSession.shared
        
    
        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from server")
                return
            }
            
            do {

                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    DispatchQueue.main.async {
                        self.showReportAlert()
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        // Start the data task
        task.resume()
    }
    
    func showReportAlert() {
            let alertController = UIAlertController(title: "Report Recipe", message: "Are you sure you want to report this recipe?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let reportAction = UIAlertAction(title: "Report", style: .destructive) { _ in
                self.showAlert(title: "Success", message: "report submited successfully")
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(reportAction)
            
            present(alertController, animated: true, completion: nil)
        }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientMeasureCell", for: indexPath) as! IngredientsMeasuresTableViewCell
           
        let data = ingredients[indexPath.row]
        let data1 = measures[indexPath.row]
        print(data1+" "+"Of" + " " + data)
           
        // Configure the cell with the extracted data
        cell.ingredientMeasureLabel.text = data1+" "+"of" + " " + data

        return cell
    }
    
    
    var ingredients : [String] = []
    var measures:[String] = []
    
    @IBOutlet weak var durationView: UIView!
    
    @IBOutlet weak var personView: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    var recetteDetail: Hotel? = nil
    @IBOutlet weak var descriptionScrollView: UITextView!
    @IBOutlet weak var ingredientsMesuresTableView: UITableView!
    
    @IBOutlet weak var foodDetailIV: UIImageView!
    
    @IBOutlet weak var difficultyView: UIView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsListLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var dislikeButton: UIButton!
    
    
    var total:Int = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        
        let userId = defaults.object(forKey: "userId") as! String
        
        let usersLikedArray = recetteDetail!.usersLiked
        let usersDislikedArray = recetteDetail!.usersDisliked

        
        for userLiked in usersLikedArray!{
            print(userLiked)
            print(userId)
            
            if (userLiked == userId){
                likeButton.tintColor = UIColor(named: "orangeKitchen")
            }
        }
        for usersDisliked in usersDislikedArray!{
            print(usersDisliked)
            print(userId)
            if (usersDisliked == userId){
                dislikeButton.tintColor = UIColor(named: "orangeKitchen")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(ingredients.count)
        print(measures.count)
        
        // '2 kilos'+' '+ 'of' + 'meat'
        
       foodDetailIV.kf.setImage(with: URL(string: recetteDetail!.image!))
        ingredientsListLabel.text = recetteDetail?.name
        descriptionScrollView.text = recetteDetail?.description
        userLabel.text = recetteDetail?.username
       
        
        durationView.layer.cornerRadius = 10.0
        
        // Set the shadow properties of the view's layer
        durationView.layer.shadowColor = UIColor.black.cgColor
        durationView.layer.shadowOpacity = 0.3
        durationView.layer.shadowOffset = CGSize(width: 0, height: 2)
        durationView.layer.shadowRadius = 2
        personView.layer.cornerRadius = 10.0
        // Set the shadow properties of the view's layer
        personView.layer.shadowColor = UIColor.black.cgColor
        personView.layer.shadowOpacity = 0.3
        personView.layer.shadowOffset = CGSize(width: 0, height: 2)
        personView.layer.shadowRadius = 2
        difficultyView.layer.cornerRadius = 10.0
        // Set the shadow properties of the view's layer
        difficultyView.layer.shadowColor = UIColor.black.cgColor
        difficultyView.layer.shadowOpacity = 0.3
        difficultyView.layer.shadowOffset = CGSize(width: 0, height: 2)
        difficultyView.layer.shadowRadius = 2
        
        let duration = recetteDetail!.duration
        if (duration!<59){
            durationLabel.text = "\(duration) minutes"
        }else if(duration == 60){
            durationLabel.text = "\(duration) Hour"

        }else if ( duration! > 60){
            let hours = duration! / 60
            let minutes = duration! % 60
            if hours == 1 {
                durationLabel.text = "\(hours) hour \(minutes) minutes"
            } else {
                durationLabel.text = "\(hours) hours \(minutes) minutes"
            }
        }
        personLabel.text = "\(recetteDetail!.person) persons"
        difficultyLabel.text = "\(recetteDetail!.difficulty)"
    }
    
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        let userId = defaults.object(forKey: "userId") as! String
        
        // Set the URL for the POST request
        let url = URL(string: "http://172.18.21.85:3000/api/recettes/\(recetteDetail!._id)/like")!

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set the request body
        let params = ["userId": userId]
                    
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a URLSession instance
        let session = URLSession.shared
        
    
        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from server")
                return
            }
            
            do {

                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    DispatchQueue.main.async {
                        self.showAlert(title: "Success", message: "The recipe has been liked!")
                        print(json)
                        let message = json["message"] as! String
                        if (message == "Recette like +1"){
                            self.likeButton.tintColor = UIColor(named: "orangeKitchen")
                            self.total += 1
                            self.likeCountLabel.text = "\(self.total)"
                            self.dislikeButton.tintColor = UIColor.lightGray
                        }else if (message=="Recette dislike +1"){
                            self.dislikeButton.tintColor = UIColor(named: "orangeKitchen")
                            self.total -= 1
                            self.likeCountLabel.text = "\(self.total)"
                            self.likeButton.tintColor = UIColor.lightGray
                        }else if (message=="Recette like +1 dislike -1"){
                            self.likeButton.tintColor = UIColor(named: "orangeKitchen")
                            self.total += 2
                            self.likeCountLabel.text = "\(self.total)"
                            self.dislikeButton.tintColor = UIColor.lightGray
                        }else if (message == "Recette dislike +1 like -1"){
                            self.dislikeButton.tintColor = UIColor(named: "orangeKitchen")
                            self.total -= 2
                            self.likeCountLabel.text = "\(self.total)"
                            self.likeButton.tintColor = UIColor.lightGray
                        }else if (message == "Recette dislike -1"){
                            self.dislikeButton.tintColor = UIColor.lightGray
                            self.total += 1
                            self.likeCountLabel.text = "\(self.total)"
                            self.likeButton.tintColor = UIColor.lightGray
                        }else if (message == "Recette like -1"){
                            self.dislikeButton.tintColor = UIColor.lightGray
                            self.total -= 1
                            self.likeCountLabel.text = "\(self.total)"
                            self.likeButton.tintColor = UIColor.lightGray
                        }

                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        // Start the data task
        task.resume()
    }
    
    
    @IBAction func dislikeButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        let userId = defaults.object(forKey: "userId") as! String
        
        // Set the URL for the POST request
        let url = URL(string: "http://172.18.21.85:3000/api/recettes/\(recetteDetail!._id)/dislike")!

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set the request body
        let params = ["userId": userId]
                    
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a URLSession instance
        let session = URLSession.shared
        
    
        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from server")
                return
            }
            
            do {

                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    DispatchQueue.main.async {
                        self.showAlert(title: "Success", message: "The recipe has been disliked!")
                        print(json)
                        let message = json["message"] as! String
                        if (message == "Recette like +1"){
                            self.likeButton.tintColor = UIColor(named: "orangeKitchen")
                            self.total += 1
                            self.likeCountLabel.text = "\(self.total)"
                            self.dislikeButton.tintColor = UIColor.lightGray
                        }else if (message=="Recette dislike +1"){
                            self.dislikeButton.tintColor = UIColor(named: "orangeKitchen")
                            self.total -= 1
                            self.likeCountLabel.text = "\(self.total)"
                            self.likeButton.tintColor = UIColor.lightGray
                        }else if (message=="Recette like +1 dislike -1"){
                            self.likeButton.tintColor = UIColor(named: "orangeKitchen")
                            self.total += 2
                            self.likeCountLabel.text = "\(self.total)"
                            self.dislikeButton.tintColor = UIColor.lightGray
                        }else if (message == "Recette dislike +1 like -1"){
                            self.dislikeButton.tintColor = UIColor(named: "orangeKitchen")
                            self.total -= 2
                            self.likeCountLabel.text = "\(self.total)"
                            self.likeButton.tintColor = UIColor.lightGray
                        }else if (message == "Recette dislike -1"){
                            self.dislikeButton.tintColor = UIColor.lightGray
                            self.total += 1
                            self.likeCountLabel.text = "\(self.total)"
                            self.likeButton.tintColor = UIColor.lightGray
                        }else if (message == "Recette like -1"){
                            self.dislikeButton.tintColor = UIColor.lightGray
                            self.total -= 1
                            self.likeCountLabel.text = "\(self.total)"
                            self.likeButton.tintColor = UIColor.lightGray
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        // Start the data task
        task.resume()
    }
    
 
    func showAlert(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        

        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in

            completion?()

        }

        

        alert.addAction(action)

        

        if let topViewController = UIApplication.shared.windows.first?.rootViewController {

            topViewController.present(alert, animated: true, completion: nil)

        }

    }
}
