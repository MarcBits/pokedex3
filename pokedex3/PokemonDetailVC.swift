//
//  PokemonDetailVC.swift
//  pokedex3
//
//  Created by Marc Cruz on 12/9/16.
//  Copyright © 2016 MarcBits. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
    }

}
