//
//  ViewController.swift
//  LoktraFlickerTask
//
//  Created by Tuhin Samui on 08/05/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var flickerImageFeedCollectionView: UICollectionView!
    
    fileprivate lazy var flickrImageDetailsData: [[String: Any]] = []
    fileprivate lazy var layoutManagedProperly: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flickerImageFeedCollectionView.delegate = self
        flickerImageFeedCollectionView.dataSource = self
        DataHandlingModelClass.singletonForDataHandlingModelClass.flickrImageFeedResponseDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MakeAndCallApiStruct.makeAndHitApiForFlickerFeed()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layoutManagedProperly != true{ //This method can be called by the system several times. This bool will ensure update layout will run only once in the lifecycle.
            makeEqualSizeOfCells(cellCountValue: 2)
            
        }
    }
    
    fileprivate func makeEqualSizeOfCells(cellCountValue cellCount: Int) {
        let mainScreenWidth = UIScreen.main.bounds.width
        let flickrImageCollectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flickrImageCollectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flickrImageCollectionLayout.itemSize = CGSize(width: mainScreenWidth/CGFloat(cellCount), height: mainScreenWidth/CGFloat(cellCount))
        flickrImageCollectionLayout.minimumInteritemSpacing = 0
        flickrImageCollectionLayout.minimumLineSpacing = 0
        flickerImageFeedCollectionView.collectionViewLayout = flickrImageCollectionLayout
    }
    
    
}


extension ViewController: UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//        return (UIScreen.main.bounds.width / CGFloat(2.0))
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentCell = collectionView.cellForItem(at: indexPath) as? FlickrFeedCollectionViewCell{
            if currentCell.cellAlreadyFlipped == false{
                currentCell.cellAlreadyFlipped = true
                currentCell.flipViewWithAnimation(currentCell.flickrMainFeedImageSuperView, secondView: currentCell.flickrMainFeedImageDetailsSuperView, flipForward: true, flipDuration: 0.4)

                
            }else{
                currentCell.cellAlreadyFlipped = false
                currentCell.flipViewWithAnimation(currentCell.flickrMainFeedImageSuperView, secondView: currentCell.flickrMainFeedImageDetailsSuperView, flipForward: false, flipDuration: 0.4)

            }
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let currentCell = collectionView.cellForItem(at: indexPath) as? FlickrFeedCollectionViewCell{
            
            if currentCell.cellAlreadyFlipped == true{
                currentCell.cellAlreadyFlipped = false
                currentCell.flipViewWithAnimation(currentCell.flickrMainFeedImageSuperView, secondView: currentCell.flickrMainFeedImageDetailsSuperView, flipForward: false, flipDuration: 0.4)
            }
        }
    }
}


extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrImageDetailsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cellOfCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "flickrFeedCollectionViewCellId", for: indexPath) as? FlickrFeedCollectionViewCell{
            cellOfCollection.flickrMainFeedImageDetailsSuperView.backgroundColor = UIColor.white
            cellOfCollection.flickrMainFeedImageSuperView.backgroundColor = UIColor.white
            cellOfCollection.backgroundColor = UIColor.clear
            if let whichImageToLoadInCollectionView = flickrImageDetailsData[indexPath.item]["imageUrl"] as? String,
                !whichImageToLoadInCollectionView.isEmpty{
            
            cellOfCollection.flickrMainFeedImageView.kf.indicatorType = .activity
            let urlToLoad = URL(string: whichImageToLoadInCollectionView)
            cellOfCollection.flickrMainFeedImageView.kf.setImage(with: urlToLoad, placeholder: nil, options: [.transition(ImageTransition.fade(0.5))], progressBlock: nil, completionHandler: nil)
            }else{
                debugPrint("Image Not Found for this cell. Try showing some placeholder image here")
                cellOfCollection.flickrMainFeedImageView.image = nil
            }
            
            if let imageDetailsToLoadInCollectionView = flickrImageDetailsData[indexPath.item]["imageDetails"] as? String,
                !imageDetailsToLoadInCollectionView.isEmpty{
                cellOfCollection.flickrMainFeedImageDetailsLbl.text = imageDetailsToLoadInCollectionView
            }else{
                cellOfCollection.flickrMainFeedImageDetailsLbl.text = GenericMessagesForApp.imageDetailsNotFoundMessage
            }
            return cellOfCollection
        }else{
            return UICollectionViewCell()
        }
    }
}

extension ViewController: DataHandlingModelClassResponseDelegate{
    func notifySubClassThatDataSavedAndGoodToGo(responseCode statusCode: Int, imageResponseData responseData: [[String : Any]]?, imageResponseStatus isError: Bool) {
        switch isError{
        case true:
            debugPrint("Error found during data fetch")
            
            switch statusCode{
            case _ where statusCode == ApiResponseStatusCode.failureApiStatusCode:
                debugPrint("Flickr image details failure response from server")
                
            case _ where statusCode == ApiResponseStatusCode.failureFromSystemStatusCode:
                debugPrint("Flickr image details failure response from System")
                
                
            default:
                break
            }
            
        case false:
            debugPrint("Data found From server")
            switch statusCode{
            case _ where statusCode == ApiResponseStatusCode.successApiStatusCode:
                debugPrint("Flickr image details success response from server")
                if let responseDataDetailsCheck = responseData{ //Cross checking response data from server to prevent unwanted crash!
                    debugPrint(responseDataDetailsCheck)
                    DispatchQueue.main.async (execute: { [unowned self] in //Updating the details on main thread asynchronously! Making self as "unwoned" to ensure no strong reference cycle occures in memory!
                        self.flickrImageDetailsData = responseDataDetailsCheck
                        self.flickerImageFeedCollectionView.reloadData()
                    })
                }
                
            default:
                break
            }
        }
    }
}
