//
//  RecetteViewController.swift
//  Tripy
//
//  
//

import UIKit
import SwiftUI
import Toast
class RecetteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {

    
    var Hotels:[Hotel] = []
    var filteredData:[Hotel] = []
    let searchController = UISearchController(searchResultsController: nil)
    let floatingButton = UIButton(type: .system)
    var userId :String = ""

    @IBOutlet weak var recetteNavigationItem: UINavigationItem!
    
    @IBOutlet weak var recetteCollectionView: UICollectionView!
    
    @IBOutlet weak var loadingIndecator: UIActivityIndicatorView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"recetteCell",for:indexPath) as! RecetteCollectionViewCell
        

        let recette = filteredData[indexPath.row]

        cell.recetteImageView.kf.setImage(with: URL(string: recette.image!))
            cell.recetteLabel.text = recette.name
            cell.recetteImageView.layer.cornerRadius = 20.0
            cell.recetteImageView.contentMode = .scaleAspectFill
            cell.recetteImageView.clipsToBounds = true
            cell.blackScreen.layer.cornerRadius = 20.0



        return cell
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
            
            
            // Get the product that was selected
            let recetteDetail = self.filteredData[indexPath.item]
            // Create a new view controller to display the product details
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let recetteDetailViewController = storyboard.instantiateViewController(withIdentifier: "recetteDetailVC") as! RecetteDetailViewController
        recetteDetailViewController.recetteDetail = recetteDetail
            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(recetteDetailViewController, animated: true)
            
   
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = Hotels
        } else {
            filteredData = Hotels.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
        }
        recetteCollectionView.reloadData()
    }
    
    @IBOutlet weak var emptyRecettesIV: UIImageView!
    @IBOutlet weak var emptyRecettes: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.Hotels.count < 1 || self.filteredData .count < 1){
            self.emptyRecettes.isHidden = false
            self.emptyRecettesIV.isHidden = false
        }else{
            self.emptyRecettes.isHidden = true
            self.emptyRecettesIV.isHidden = true
        }
        
        loadingIndecator.isHidden = false
        loadingIndecator.startAnimating()
        
        recetteCollectionView.showsVerticalScrollIndicator = false
        

        if let navigationBar = self.navigationController?.navigationBar {
            let searchBar = UISearchBar()
            searchBar.placeholder = "Search"
            searchBar.sizeToFit()
            searchBar.delegate = self
            let leftBarButtonItemsWidth = recetteNavigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let rightBarButtonItemsWidth = recetteNavigationItem.rightBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let searchBarWidth = navigationBar.frame.width - leftBarButtonItemsWidth - rightBarButtonItemsWidth - 32
            searchBar.frame.size.width = searchBarWidth - 42
            searchBar.frame.size.height = 44
            
            let searchContainer = UIView(frame: searchBar.frame)
            searchContainer.addSubview(searchBar)
            recetteNavigationItem.titleView = searchContainer
            

        }
        guard let urlRecette = URL(string: "http://172.18.21.85:3000/api/recettes") else { return }
        let sessionFood = URLSession.shared
        let taskFood = sessionFood.dataTask(with: urlRecette) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: invalid response")
                return
            }

            guard let data = data else {
                print("Error: missing data")
                return
            }
            do {
                let decoder = JSONDecoder()
                print("level1")
                self.Hotels = try decoder.decode([Hotel].self, from: data)
                print("level2")
                print(self.Hotels.first)
                self.Hotels.sort { (recette1, recette2) -> Bool in
                    let total1 = recette1.likes! - recette1.dislikes!
                    let total2 = recette2.likes! - recette2.dislikes!
                    return total1 > total2
                }
                
                print("foods array: \(self.Hotels.count)")
                
                self.filteredData = try decoder.decode([Hotel].self,from:data)
                self.filteredData.sort { (recette1, recette2) -> Bool in
                    let total1 = recette1.likes! - recette1.dislikes!
                    let total2 = recette2.likes! - recette2.dislikes!
                    return total1 > total2
                }
                print("filteredData array: \(self.filteredData.count)")
                DispatchQueue.main.async {
                    if (self.Hotels.count < 1 || self.filteredData .count < 1){
                        self.emptyRecettes.isHidden = false
                        self.emptyRecettesIV.isHidden = false
                    }else{
                        self.emptyRecettes.isHidden = true
                        self.emptyRecettesIV.isHidden = true
                    }
                    self.stoploadingIndicator()

                    self.recetteCollectionView.reloadData()
                    
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }

            // Process the data here

        }

        taskFood.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!Hotels.isEmpty) {
            self.stoploadingIndicator()
        }
        // Set the frame and position of the button
        floatingButton.frame = CGRect(x: view.bounds.width - 68, y: view.bounds.height   - tabBarController!.tabBar.frame.height - 60 , width: 48, height: 48)

        // Set the button's appearance
        floatingButton.backgroundColor = UIColor(named: "orangeKitchen")
        floatingButton.layer.cornerRadius = 24
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        floatingButton.layer.shadowOpacity = 0.5
        floatingButton.layer.shadowRadius = 2
        
        // Set the button's image or title
        let image = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .regular))
            .withRenderingMode(.alwaysTemplate)
        floatingButton.setImage(image, for: .normal)
        floatingButton.tintColor = .white
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)

        // Add the button to the view hierarchy
        view.addSubview(floatingButton)
    }
    
    @objc func didTapFloatingButton() {
        let vc = UIHostingController(rootView: RecetteView())
        present(vc, animated: true)
    }

         @objc func dismissSwiftUIView() {
                 dismiss(animated: true, completion: nil)

             }

    
    func stoploadingIndicator () {
        loadingIndecator.isHidden = true
        loadingIndecator.stopAnimating()
    }

}
