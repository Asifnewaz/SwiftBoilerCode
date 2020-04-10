//
//  EndpointsManager.swift
//  BoilerCode
//
//  Created by Asif Newaz on 10/4/20.
//  Copyright © 2020 Nasim Newaz. All rights reserved.
//

import Foundation
import Alamofire

enum EndPoint: EndPointCompatible {
    case login(parameters: [String: Any])
    case getPersonalInformation
    
    var method: HTTPMethod {
        switch self {
        case .getPersonalInformation:
            return .get
        default :
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return APIPath.basePath(path: EndPointSubURLs.loginPath.rawValue).url
        case .getPersonalInformation:
            return APIPath.basePath(path: EndPointSubURLs.changePassword.rawValue).url
        }
    }
    
    var query: [String: Any]  {
        var parameterQuery: [String: Any]?
        var parameterQueryLogin:[String: Any]?
        
        switch self {
        case .login(let queries):
            parameterQueryLogin = queries
        case .getPersonalInformation:
            return [:]
        default:
            return baseQuery
            
        }
        
        if let  parameterQuery = parameterQuery {
            return getCompleteParameters(parameters: parameterQuery)
        }
        
        if let  parameterQueryLogin = parameterQueryLogin {
            return getCompleteParametersForLogin(parameters: parameterQueryLogin)
        }
        
        return baseQuery
    }
}


