
import Foundation

public struct PhotoModel {
  var url: URL
  var photoID: String
  var uploadDateString: String
  var descriptionText: String
  var likesCount: Int
  var location: String
  var ownerUserProfile: UserModel
  var width: Int
  var height: Int
}

extension PhotoModel: Equatable {
  public static func == (lhs: PhotoModel, rhs: PhotoModel) -> Bool {
    return lhs.photoID == rhs.photoID
  }
}
