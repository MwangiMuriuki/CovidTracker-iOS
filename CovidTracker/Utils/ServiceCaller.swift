//
//  ServiceCaller.swift
//  CovidTracker
//
//  Created by ERNEST MURIUKI on 10/09/2021.
//

import Foundation
import Alamofire


class ServiceCaller{
    
    //MARK :- Properties
    var delegate: ServiceCallerDelegate?
    //MARK :- Methods
    
    func makeRequest(url : String, requestBody: [String : String]?, method: HTTPMethod = .post, addHeaders : Bool = false, progresslabel: String = "", showProgress: Bool = true) {
        
        var headersValue : HTTPHeaders = HTTPHeaders()
        
        if showProgress {
            
        }
        
        AF.request(url,
                   method: method,
                   parameters: requestBody,
                   headers: headersValue
        ).responseData { response in
           
            if showProgress {
                
            }
            switch response.result {
                case .success(let value):
                    print(value)
                    self.delegate?.successResponse(response: value)
                
                case .failure(let error):
                    print(error)
                    self.delegate?.errorResponse(error: error.localizedDescription)
                
            }
        }
    }
}

public protocol ServiceCallerDelegate{
    func successResponse(response: Data)
    func errorResponse(error: String)
}
