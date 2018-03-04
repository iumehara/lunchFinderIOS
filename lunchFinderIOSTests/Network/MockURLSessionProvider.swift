import Foundation
@testable import lunchFinderIOS

class MockURLSessionProvider: URLSessionProvider {
    var baseURL = "http://testURL/"
    var urlSession = MockSession() as URLSession

    var getRequest_wasCalled = false
    func getRequest(path: String) -> URLRequest? {
        getRequest_wasCalled = true
        var request = URLRequest(url: URL(string: "\(baseURL)\(path)")!)
        request.httpMethod = "GET"
        return request
    }

    var postRequest_wasCalled = false
    func postRequest(path: String, body: Data) -> URLRequest? {
        postRequest_wasCalled = true
        var request = URLRequest(url: URL(string: "\(baseURL)\(path)")!)
        request.httpMethod = "POST"
        request.httpBody = body
        return request
    }

    var putRequest_wasCalled = false
    func putRequest(path: String, body: Data) -> URLRequest? {
        putRequest_wasCalled = true
        var request = URLRequest(url: URL(string: "\(baseURL)\(path)")!)
        request.httpMethod = "PUT"
        request.httpBody = body
        return request
    }

    var deleteRequest_wasCalled = false
    func deleteRequest(path: String) -> URLRequest? {
        deleteRequest_wasCalled = true
        var request = URLRequest(url: URL(string: "\(baseURL)\(path)")!)
        request.httpMethod = "DELETE"
        return request
    }
}
