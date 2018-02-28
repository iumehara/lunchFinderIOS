import Foundation

class MockSession: URLSession {
    var url: URL?
    var body: Data?
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    let urlSessionDataTaskSpy = URLSessionDataTaskSpy()

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = request.url
        self.body = request.httpBody
        self.completionHandler = completionHandler
        
        return urlSessionDataTaskSpy
    }
}

class URLSessionDataTaskSpy: URLSessionDataTask {
    var resumeWasCalled = false
    
    override func resume() {
        resumeWasCalled = true
    }
}
