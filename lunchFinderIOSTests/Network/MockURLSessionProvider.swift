import Foundation
@testable import lunchFinderIOS

struct MockURLSessionProvider: URLSessionProvider {
    var baseURL = "http://testURL/"
    var urlSession = MockSession() as URLSession
}
