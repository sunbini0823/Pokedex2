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
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? infoViewCell else {
            print("error dequeuing cell at index path \(indexPath)")
            return UITableViewCell()
        }
        if let image = cachedImages[indexPath.row] {
            cell.pokemonImage.image = image
        } else {
            cell.pokemonImage.image = nil
            let url = URL(string: pokemonArray![indexPath.row].imageUrl)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                self.cachedImages[indexPath.row] = image
                                cell.pokemonImage.image = image // UIImage(data: imageData)
                            }
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
        cell.pokemonName.text = pokemonArray![indexPath.row].name
        cell.pokemonNumber.text = "\(pokemonArray![indexPath.row].number!)"
        cell.attack.text = "\(pokemonArray![indexPath.row].attack!)"
        cell.defense.text = "\(pokemonArray![indexPath.row].defense!)"
        cell.health.text = "\(pokemonArray![indexPath.row].health!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "toPokemonInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toPokemonInfo" {
                if let dest = segue.destination as? PokemonInfoViewController {
                    dest.pokemon = pokemonArray![selectedIndexPath!.row]
                    if cachedImages[selectedIndexPath!.row] != nil {
                        dest.image = cachedImages[selectedIndexPath!.row]
                    } else {
                        dest.image = nil
                    }
                }
            }
        }
    }


}
