//
//  ViewController.swift
//  PhotosExample
//
//  Created by 한수빈 on 2022/11/22.
//
import Photos
import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    var fetchResult: PHFetchResult<PHAsset>!    // 사진을 최신순으로 정리한 걸 가져옴
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier: String = "cell"
    
    func requestCollection() {
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        // 사진 찍으면 저장되는 cameraRoll
        
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]   // 사진 최신순으로 sort -> fetchResult 라는 프로퍼티로 가져옴
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {   // 뷰가 로드되면 사용자가 사진을 허가했는지 확인
        case .authorized :
            print("접근 허가됨")         // 허가된 상태
            self.requestCollection()    // Collection을 불러옴
            self.tableView.reloadData()     // 모든 게 끝난 다음 테이블 뷰에 데이터를 다시 불러옴.
        case .denied :                  // 허가되지 않은 상태
            print("접근 불허")            // 어쩔 수 없음 -> Alert를 띄워주든 다시 허가해달라 요청
        case .notDetermined :
            print("아직 응답하지 않음")     // 아직 선택 전 상태
            PHPhotoLibrary.requestAuthorization({ (status) in    // 사용자에게 요청
                switch status {
                case .authorized :
                    print("사용자가 허용함")
                    self.requestCollection()
                    // self.tableView.reloadData()     // 모든 게 끝난 다음 테이블 뷰에 데이터를 다시 불러옴.
                        // reloadData()는 메인스레드에서 실행되어야 함
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                case .denied :
                    print("사용자가 불허함")
                default : break
                }
            })
        case .restricted :
            print("접근 제한")
        default :
            print("default")
        }
        

    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 테이블 뷰에서 셀에다가 이미지들을을 하나씩 꽂아줌.
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        // Asset은 fetchresult에서 인덱스에 해당
        let asset: PHAsset = fetchResult.object(at: indexPath.row)
        
        // 실질적인 이미지 요청, 셀에 들어갈 이미지 사이즈 : (30,30)
        imageManager.requestImage(for: asset,
                                  targetSize: CGSize(width: 30, height: 30), contentMode: .aspectFill, options: nil, resultHandler: {image, _ in cell.imageView?.image = image
        // 셀에 가져온 이후에, 셀의 이미지 뷰에다 이미지를 넣음.
            
        })
        
        // 셀을 돌려줌.
        return cell
    }
}

