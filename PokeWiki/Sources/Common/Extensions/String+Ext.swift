//
//  String+Ext.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 12/01/22.
//

import Foundation

extension String {
    func parseToIntOrZero() -> Int {
        guard let int = Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else { return 0 }
        return int
    }
    
    func getId() -> String {
        guard let range = self.range(of: "pokemon") else { return "" }
        
        let str: String = String(self[range.upperBound...])
        return  str
    }
    
}
