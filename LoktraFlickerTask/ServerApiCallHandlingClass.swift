//
//  ServerApiCallHandlingClass.swift
//  LoktraFlickerTask
//
//  Created by Tuhin Samui on 08/05/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit
import Alamofire

class ServerApiCallHandlingClass: NSObject {

    static let singletonForServerApiCallClass = ServerApiCallHandlingClass() //Making This class a singleton
    
    func getFlickerImageDetails(finalApiString apiToHit: String, parameters paramObject: [String: Any]){
        debugPrint(apiToHit)
        debugPrint(paramObject)
        
        Alamofire.request(apiToHit, parameters: paramObject).responseJSON { response in switch response.result{
            
        case .success(_):
            if let receivedData: Any = response.result.value,
                let responseStatusCodeCheck = response.response?.statusCode{ //response.response?.statusCode for status code check
                DataHandlingModelClass.singletonForDataHandlingModelClass.handleFlickerImageDataResponse(dataToParse: receivedData, stautsCode: responseStatusCodeCheck)
                
            }else{ //Handling Error Here for response data is not proper.
                DataHandlingModelClass.singletonForDataHandlingModelClass.handleFlickerImageDataResponse(dataToParse: nil, stautsCode: ApiResponseStatusCode.failureFromSystemStatusCode)

            }
        case .failure(_):
            DataHandlingModelClass.singletonForDataHandlingModelClass.handleFlickerImageDataResponse(dataToParse: nil, stautsCode: ApiResponseStatusCode.failureFromSystemStatusCode)

            }
        }
    }
}
