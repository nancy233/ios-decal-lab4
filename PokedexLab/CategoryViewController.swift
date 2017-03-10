//
//  CategoryViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemonArray: [Pokemon]?
    var cachedImages: [Int:UIImage] = [:]
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = pokemonArray {
            return array.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        cell.name.text = pokemonArray?[indexPath.row].name
        cell.number.text = String(describing: (pokemonArray?[indexPath.row].number)!)
        cell.stats.text = String(describing: (pokemonArray?[indexPath.row].attack)!)+"/"+String(describing: (pokemonArray?[indexPath.row].defense)!)+"/"+String(describing: (pokemonArray?[indexPath.row].health)!)
        if let image = cachedImages[indexPath.row] {
            cell.tableImage.image = image // may need to change this!
        } else {
            let url = URL(string: (pokemonArray?[indexPath.row].imageUrl)!)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.cachedImages[indexPath.row] = image
                            cell.tableImage.image = UIImage(data: imageData) // may need to change this!
                            
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code")
                    }
                }
            }
            downloadPicTask.resume()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedIndexPath = indexPath

        performSegue(withIdentifier: "CategoryToInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryToInfo" {
            if let dest = segue.destination as? PokemonInfoViewController {
                if let array = pokemonArray {
                    dest.pokemon = array[(selectedIndexPath?.row)!]
                    dest.image = cachedImages[(selectedIndexPath?.row)!]
                }
                
            }
        }
    }

}
