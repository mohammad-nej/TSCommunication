//
//  FileName+Regex.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/30/26.
//

import Foundation
import RegexBuilder




extension FileName {
    
    static var validation : some RegexComponent{
        // name part
        Regex{
            let lower = "a"..."z"
            let upper = "A"..."Z"
            let number = "0"..."9"
            let validClass = CharacterClass(
                lower,
                upper,
                number,
                .anyOf("_-")
            )
            OneOrMore {
                validClass
            }

            // optional middle parts like .tar in archive.tar.gz
            ZeroOrMore {
                "."
                OneOrMore {
                    validClass
                }
            }
            
            // extension (required)
            "."
            OneOrMore {
                validClass
            }
        }
        
    }
}
