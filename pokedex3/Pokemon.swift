//
//  Pokemon.swift
//  pokedex3
//
//  Created by Marc Cruz on 12/5/16.
//  Copyright © 2016 MarcBits. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: Int!
    private var _nextEvolutionLvl: Int!
    private var _pokemonURL: String!
    
    var name: String {
        if _name == nil {
            
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int {
        if _pokedexId == nil {
            
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            
            _nextEvolutionTxt = ""
        }
        
        if self.nextEvolutionName.characters.count == 0 {
            
            _nextEvolutionTxt = "No Evolutions"
        } else if self.nextEvolutionLvl == 0 {
            
            _nextEvolutionTxt = "Next Evolution: \(self.nextEvolutionName)"
        } else {
        
            _nextEvolutionTxt = "Next Evolution \(self.nextEvolutionName) LVL \(self.nextEvolutionLvl)"
        }
        
        return _nextEvolutionTxt
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: Int {
        if _nextEvolutionId == nil {
            
            _nextEvolutionId = 0
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: Int {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = 0
        }
        return _nextEvolutionLvl
    }
    
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        let requestURL = URL(string: self._pokemonURL)!
        
        Alamofire.request(requestURL).responseJSON { (response) in
            
//            print(self._pokemonURL)             // debug
//            print(response.result.value!)       // debug
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let name = dict["name"] as? String {
                    
                    self._name = name.capitalized
                    
                    print("Name: \(self._name!)")
                }
                
                if let pkdx_id = dict["pkdx_id"] as? Int {
                    
                    self._pokedexId = pkdx_id
                    
                    print("ID: \(self._pokedexId!)")
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    
                    // we're going to pull the first element in the array this time
                    if let url = descArr[0]["resource_uri"] {
                        
                        let descriptionURL = URL(string: "\(URL_BASE)\(url)")!
                        
                        print("Description URL: \(descriptionURL)")
                        
                        Alamofire.request(descriptionURL).responseJSON(completionHandler: { (response) in
                            
                            let descriptionResult = response.result
                            
                            if let descriptionDict = descriptionResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descriptionDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    self._description = newDescription
                                    
                                    print("Description: \(self._description!)")
                                }
                            }
                            
                            completed()
                        })
                    } else {
                        
                        self._description = ""
                    }
                    
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {

                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        
                        for i in 1..<types.count {
                            
                            if let name = types[i]["name"] {
                                
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
//                    print("Type: \(self._type!)")
                    
                } else {
                    
                    self._type = ""
                }
                
                if let defense = dict["defense"] as? Int {
                    
                    self._defense = "\(defense)"
                    
//                    print("Defense: \(self._defense!)")
                }
                
                if let height =  dict["height"] as? String {
                    
                    self._height = height
                    
//                    print("Height: \(self._height!)")
                }
                
                if let weight = dict["weight"] as? String {
                    
                    self._weight = weight
                    
//                    print("Weight: \(self._weight!)")
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                    
//                    print("Attack: \(self._attack!)")
                }
                
                //TODO: evolution
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextEvoName = evolutions[0]["to"] as? String {
                        
                        if nextEvoName.range(of: "mega") == nil {
                        
                            self._nextEvolutionName = nextEvoName
                            
                            print("Next evolution name: \(self._nextEvolutionName!)")
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                print("Next evolution uri: \(uri)")
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = Int(nextEvoId)
                                
                                print("Next evolution ID: \(self._nextEvolutionId!)")
                            }
                            
                            if evolutions[0]["level"] != nil {
                                
                                if let nextEvoLvl = evolutions[0]["level"] as? Int {
                                    
                                    self._nextEvolutionLvl = nextEvoLvl
                                    
                                    print("Next evolution level: \(self._nextEvolutionLvl!)")
                                }
                                
                            } else {
                                
                                self._nextEvolutionLvl = 0
                            }
                        }
                    }
                    
                } else {
                    
                    self._nextEvolutionLvl = 0
                    self._nextEvolutionName = ""
                    self._nextEvolutionId = 0
                    self._nextEvolutionTxt = ""
                }
                
            }
            
            completed()
            
        }
        
    }
    
}
