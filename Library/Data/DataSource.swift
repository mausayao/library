//
//  DataSource.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 22/10/20.
//

import Foundation

class DataSource {
    
    static let shared = DataSource()
    
    var tutorials: [TutorialCollection]
    private let decoder = PropertyListDecoder()
    
   private init() {
        guard let url = Bundle.main.url(forResource: "Tutorials", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let tutorials = try? decoder.decode([TutorialCollection].self, from: data)
        else {
            self.tutorials = []
            return
        }
        
        self.tutorials = tutorials
    }
    
    
}


