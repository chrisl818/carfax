//
//  CodeError.swift
//  CarfaxList
//
//  Created by Chris Lin on 9/18/19.
//  Copyright © 2019 Chris Lin. All rights reserved.
//

import Foundation

struct CodeError: Error {
    
    let code: Int?
    let message: String
    
    init(code: Int? = nil, message: String) {
        self.code = code
        self.message = message
    }
    
    init(error: Error?) {
        if let nsError = error as NSError? {
            self.code = nsError.code
            self.message = nsError.localizedDescription
        } else {
            self.code = nil
            self.message = error?.localizedDescription ?? "Unknown Error"
        }
    }
}

extension CodeError {
    
    static var unknown: CodeError {
        return CodeError(message: "An unknown error occurred.")
    }
        
    static var dataUnavailable: CodeError {
        return CodeError(code: -11, message: "Please try again later.")
    }
}
