//
//  DataHandlingModelClass.swift
//  LoktraFlickerTask
//
//  Created by Tuhin Samui on 08/05/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataHandlingModelClass: NSObject {
    
    static let singletonForDataHandlingModelClass = DataHandlingModelClass() //Making This class a singleton to ensure only one instance in memory.
    weak var flickrImageFeedResponseDelegate: DataHandlingModelClassResponseDelegate? //Making this object "weak" ensures no memory leak due to this!

    
    func handleFlickerImageDataResponse(dataToParse rawData: Any?, stautsCode codeValue: Int){ //On this function we can pass next api which can be called after Successfull data parsing.
        
        
        switch codeValue{
        case _ where codeValue == ApiResponseStatusCode.successApiStatusCode: //Its a successful response.
            if let rawDataObjectCheck = rawData{ //Cross Checking the response data for optional values.
                let convertedData = JSON(rawDataObjectCheck) //Converting the response to JSON object using SwiftyJson!
                print(convertedData)
                var flickrImageDetailsData: [[String: Any]] = []
                let photosDataArray = convertedData["photos"]["photo"].arrayValue

                for photosObject in photosDataArray{
                    let imageFarmId = photosObject["farm"].stringValue
                    let imageServerId = photosObject["server"].stringValue
                    let imageId = photosObject["id"].stringValue
                    let imageSecret = photosObject["secret"].stringValue
                    let imageTitle = photosObject["title"].stringValue
                    
                    let finalImageUrlToDownload: String = "\(ApiRelatedStruct.flickerImageDownloadUrl)\(imageFarmId).\(ApiRelatedParameters.flickerImageDownloadUrlParam)/\(imageServerId)/\(imageId)_\(imageSecret).jpg"
                    let imageDataToAppend: [String: String] = ["imageUrl": finalImageUrlToDownload, "imageDetails": imageTitle]
                    flickrImageDetailsData.append(imageDataToAppend)
                }
                
//                debugPrint(flickrImageDetailsData)
                
                flickrImageFeedResponseDelegate?.notifySubClassThatDataSavedAndGoodToGo?(responseCode: codeValue, imageResponseData: flickrImageDetailsData, imageResponseStatus: false)
                
            
            }else{
                flickrImageFeedResponseDelegate?.notifySubClassThatDataSavedAndGoodToGo?(responseCode: codeValue, imageResponseData: nil, imageResponseStatus: false)
            }
        case _ where codeValue == ApiResponseStatusCode.failureApiStatusCode: //Its a failure response from server.
            flickrImageFeedResponseDelegate?.notifySubClassThatDataSavedAndGoodToGo?(responseCode: codeValue, imageResponseData: nil, imageResponseStatus: true)

            
        case _ where codeValue == ApiResponseStatusCode.failureFromSystemStatusCode: //Its a Failure response from system itself.

            flickrImageFeedResponseDelegate?.notifySubClassThatDataSavedAndGoodToGo?(responseCode: codeValue, imageResponseData: nil, imageResponseStatus: true)

            
        default:
            break
            
        }
    }
}

@objc protocol DataHandlingModelClassResponseDelegate: class{ //Custom Deelgate for to send back data to viewcontroller for any further task or UI update.
    @objc optional func notifySubClassThatDataSavedAndGoodToGo(responseCode statusCode: Int, imageResponseData responseData: [[String: Any]]?,imageResponseStatus isError: Bool) //Making this optional wil ensure unexpected initialization syntax error!
}



