//
//  DetailViewController.swift
//  Pokemom Storyboard
//
//  Created by Alex Rhodes on 9/6/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var pokedexController = PokedexController()
    
    let ui = UIController()
    
    var pokemon: Pokemon?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var savePokemonButton: UIButton!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var types: UILabel!
    @IBOutlet weak var abilities: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        ui.viewConfiguration(view)
        ui.searchBarConfiguration(searchBar)
        
        nameLabel.isHidden = true
        idLabel.isHidden = true
        typesLabel.isHidden = true
        abilitiesLabel.isHidden = true
        savePokemonButton.isHidden = true
        id.isHidden = true
        types.isHidden = true
        abilities.isHidden = true
    }
    

    
    func setViews() {
        
        ui.viewConfiguration(view)
        ui.searchBarConfiguration(searchBar)
        
        if let pokemon = pokedexController.pokemon {
        
            nameLabel.isHidden = false
            idLabel.isHidden = false
            typesLabel.isHidden = false
            abilitiesLabel.isHidden = false
            savePokemonButton.isHidden = false
            id.isHidden = false
            types.isHidden = false
            abilities.isHidden = false
            
            savePokemonButton.setTitle("SAVE POKEMON", for: .normal)
            savePokemonButton.setTitleColor(.white, for: .normal)
            
            idLabel.text = String(pokemon.id)
            nameLabel.text = pokemon.name
            
            var types = ""
            let typeArray = pokemon.types
            
            for type in typeArray {
                types.append("\(type.type.name)")
                types.append("\n")
            }
            
            typesLabel.text = types
            
            var abilities = ""
            let abilityArray = pokemon.abilities
            
            for ability in abilityArray {
                abilities.append("\(ability.ability.name)")
                abilities.append("\n")
            }
            abilitiesLabel.text = abilities
            
            let url = URL(string: pokemon.sprites.frontDefault)!
            if let image = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: image)
            }
        } else  {

            let alert = UIAlertController(title: "Oops! We could not find that pokemon!", message: "Please try again.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)

            alert.addAction(action)

            self.present(alert, animated: true)
        }
//
        
    }
    
    @IBAction func savePokemonButton(_ sender: Any) {
      
        guard let pokemon = pokedexController.pokemon else {return}

        pokedexController.createPokemon(name: pokemon.name, sprites: pokemon.sprites, types: pokemon.types, abilities: pokemon.abilities, id: pokemon.id)
        pokedexController.saveToPersistentStore()
        navigationController?.popViewController(animated: true)
        }
    
    
}

extension DetailViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        guard let searchTerm = searchBar.text else {return}
        
        pokedexController.preformSearch(with: searchTerm) { (error) in
            DispatchQueue.main.async {
                self.setViews()
            }
        }
    }
}
