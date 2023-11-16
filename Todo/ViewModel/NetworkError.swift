//
//  NetworkError.swift
//  Todo
//
//  Created by Yves Dukuze on 15/11/2023.
//

import Foundation

enum NetworkError:Error{
    case parsingError
    case apiError
    case dataNotFound
    case invalidURL
}

extension NetworkError: LocalizedError{
    
    var errorDescription :String?{
        switch self{
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .parsingError:
            return NSLocalizedString("parsing Error", comment: "parsingError")
        case .dataNotFound:
            return NSLocalizedString("Failed to get data from API", comment: "dataNotFound")
        case .apiError:
            return NSLocalizedString("apiError", comment: "apiError")

        }
    }
}
