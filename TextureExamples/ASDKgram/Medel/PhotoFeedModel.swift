
import Foundation
import CoreGraphics

public class PhotoFeedModel: NSObject {
  public enum PhotoFeedModelType {
    case popular
    case location
    case userPhotos
  }
  
  // array of PhotoModel objects
  private(set) var photos: [PhotoModel] = []
  private var feedType: PhotoFeedModelType = .userPhotos
  private var ids: [String] = []
  private var imageSize: CGSize
  private var urlString: String
  private var currentPage: Int = 0
  private var totalPage: Int = 0
  private var totalItems: Int = 0
  private var fetchPageInProgress: Bool = false
  private var refreshFeedInProgress: Bool = false
  private var task: URLSessionTask?
  private var userID: UInt?
  
  public init(type: PhotoFeedModelType, size: CGSize) {
    feedType = type
    imageSize = size
    
    var apiEndpointString = ""
    switch feedType {
    case .popular: apiEndpointString = Unsplash.Endpoint.popular
    case .location: apiEndpointString = Unsplash.Endpoint.search
    case .userPhotos: apiEndpointString = Unsplash.Endpoint.user
    }
    
    urlString = Unsplash.Endpoint.host
      + apiEndpointString
      + Unsplash.consumerKey
  }
}

public extension PhotoFeedModel {
  var totalNumberOfPhotos: Int { return totalItems }
  
  var numberOfItemsInFeed: Int { return photos.count }
  
  func object(at index: Int) -> PhotoModel {
    return photos[index]
  }
  
  func index(of photoModel: PhotoModel) -> Int? {
    return photos.firstIndex { $0 == photoModel }
  }
  
  func updatePhotoFeedModel(of userID: UInt) {
    self.userID = userID
    
    urlString = Unsplash.Endpoint.host
      + "\(userID)"
      + Unsplash.Endpoint.list
      + Unsplash.consumerKey
  }
  
  func clearFeed() {
    photos.removeAll()
    ids.removeAll()
    currentPage = 0
    fetchPageInProgress = false
    refreshFeedInProgress = false
    task?.cancel()
    task = nil
  }
  
  func requestPage(completion: @escaping ([PhotoModel]) -> Void, itemCount: Int) {
    guard fetchPageInProgress == false else { return }
    
    fetchPageInProgress = true
    
    fetchPage(completion: completion, itemCount: itemCount)
  }
  
  func refreshFeed(completion: @escaping ([PhotoModel]) -> Void, itemCount: Int) {
    guard refreshFeedInProgress == false else { return }
    
    refreshFeedInProgress = true
    currentPage = 0
    
    // FIXME: blow away any other requests in progress
    fetchPage(completion: { [self] (newPhotos) in
      completion(newPhotos)
      
      self.refreshFeedInProgress = false
    },
              itemCount: itemCount,
              isReplace: true)
  }
}

private extension PhotoFeedModel {
  enum Unsplash {
    enum Endpoint {
      static let host = "https://api.unsplash.com/"
      static let popular = "photos?order_by=popular"
      static let search = "photos/search?geo=" // latitude,longitude,radius<units>
      static let user = "photos?user_id="
      static let list = "&sort=created_at&image_size=3&include_store=store_download&include_states=voted"
    }
    
    static let consumerKey = "&client_id=y57IzJhk0hPv7DLclBsTP4OJRKLtdv1qML7UBAAmZ3U" // PLEASE REQUEST YOUR OWN UNSPLASH CONSUMER KEY
    static let imagesPerPage = 30
  }
  
  func fetchPage(completion: @escaping ([PhotoModel]) -> Void, itemCount: Int) {
    fetchPage(completion: completion, itemCount: itemCount, isReplace: false)
  }
  
  func fetchPage(completion: @escaping ([PhotoModel]) -> Void, itemCount: Int, isReplace: Bool) {
    guard
      !(totalPage == 0 && currentPage == totalPage)
      else {
        DispatchQueue.main.async {
          completion([])
        }
        return
    }
    
    let requestItemCount = min(itemCount, Unsplash.imagesPerPage)
    let qosClass = DispatchQoS(qosClass: .default, relativePriority: 0).qosClass
    DispatchQueue.global(qos: qosClass).async {
      var newPhoto: [PhotoModel] = []
      var newIDs: [String] = []
      
      objc_sync_enter(self)
      defer { objc_sync_exit(self) }
      
      let nextPage = self.currentPage + 1
      let imageSizeParam = ImageURLModel.imageParameter(forClosestImage: self.imageSize)
      let urlAdditions = "&page=\(nextPage)&per_page=\(requestItemCount)\(imageSizeParam)"
      
      let url = URL(string: self.urlString + urlAdditions)!
      let sessions = URLSession(configuration: URLSessionConfiguration())
      self.task = sessions.dataTask(with: url,
                                    completionHandler: { (data, response, error) in
                                      objc_sync_enter(self)
                                      defer { objc_sync_exit(self) }
                                      
                                      var httpResponse: HTTPURLResponse?
                                      guard
                                        let data = data,
                                        response is HTTPURLResponse
                                        else { return }
      })
    }
  }
}
