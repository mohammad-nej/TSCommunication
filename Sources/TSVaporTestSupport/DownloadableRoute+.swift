//
//  DownloadableRoute+.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Foundation
import TSVapor
import VaporTestUtils

public extension ServerFileDownloadable {
    
    ///returns the downloaded data from server
    static func output(from response: TestingHTTPResponse) -> Data {
        let data = Data(buffer: response.body)
        return data
    }
}
