
//
//  MakeServerApiCallStructFile.swift
//  LoktraFlickerTask
//
//  Created by Tuhin Samui on 08/05/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import Foundation

struct MakeAndCallApiStruct{
    static func makeAndHitApiForFlickerFeed(){
        let flickerApiForImages: String = ApiRelatedStruct.flickerImageResponseApi
        
        let parametersForFlickerApi: [String: Any] = [ApiRelatedParameters.flickerApiMethodParam: ApiRelatedParameters.flickerApiMethodType, ApiRelatedParameters.flickerApiKeyParam: ApiRelatedStruct.flickerApiClientId, ApiRelatedParameters.flickerApiPerPageParam: ApiRelatedParameters.flickerApiPerPageCount, ApiRelatedParameters.flickerApiFormatParam:ApiRelatedParameters.flickerApiResponseFormat, ApiRelatedParameters.flickerApiNoCallbackParam: 1]
        
        ServerApiCallHandlingClass.singletonForServerApiCallClass.getFlickerImageDetails(finalApiString: flickerApiForImages, parameters: parametersForFlickerApi)
    }
}


