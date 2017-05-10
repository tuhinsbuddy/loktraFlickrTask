//
//  AllStructRelatedFile.swift
//  GithubTask
//
//  Created by Tuhin Samui on 05/05/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import Foundation

struct ApiRelatedStruct{
    static let flickerApiClientId: String = "e7de0f50f541b0345a8c2db9fa01365b"
    static let flickerApiClientSecret: String = "fa718dd326ddcb54"
    static let flickerImageResponseApi: String = "https://api.flickr.com/services/rest/"
    static let flickerImageDownloadUrl: String = "https://farm"
}

struct GenericMessagesForApp{
    static let imageDetailsNotFoundMessage: String = "Image Details Not Found!"
}

struct ApiRelatedParameters{
    static let flickerApiPerPageCount: Int = 40
    static let flickerApiMethodType: String = "flickr.photos.getRecent"//getRecent"
    static let flickerApiMethodParam: String = "method"
    static let flickerApiKeyParam: String = "api_key"
    static let flickerApiPerPageParam: String = "per_page"
    static let flickerApiFormatParam: String = "format"
    static let flickerApiResponseFormat: String = "json"
    static let flickerApiNoCallbackParam: String = "nojsoncallback"
    static let flickerImageDownloadUrlParam: String = "staticflickr.com"
}


struct ApiResponseStatusCode{
    static let successApiStatusCode: Int = 200 //Successful Call
    static let failureApiStatusCode: Int = 400 //Unsuccessful Call
    static let failureFromSystemStatusCode: Int = 900 //Custom Code for system error
}
