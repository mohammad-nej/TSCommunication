//
//  AnyServerRoute.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//


import Vapor
import TSShared


///Base protocol, that all Server  Http protocols will conform to.
///
///You don't need to conform to this protocol directly. This protocol is mainly used to create
///result builders or group all routes in a single array
public protocol AnyHttpRoute : OutputableRoute , VaporRespondable {}
