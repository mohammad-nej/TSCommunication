//
//  PathPart+Regex.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//

import Foundation
import RegexBuilder




extension PathPart {
    
    ///Validator regex
    static var validation : some RegexComponent{
        Regex{
            let validWord = CharacterClass(
                .word,
                .digit,
                .anyOf("-_")
            )
            Optionally{
                ChoiceOf{
                    ":"
                    "/"
                }
            }
            OneOrMore(validWord)
        }
    }
    
    
}
