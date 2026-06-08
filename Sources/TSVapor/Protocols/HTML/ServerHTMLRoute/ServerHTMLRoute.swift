//
//  ServerHTMLRoute.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/29/26.
//

import TSShared
import Foundation
import Vapor


///A route that can send HTML back to the client
public protocol ServerHTMLRoute : ServerHttpRoute where ClosureResponse == HTML {}


