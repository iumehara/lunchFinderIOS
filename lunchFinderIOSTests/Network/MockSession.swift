import Foundation

class MockSession: URLSession {
    var url: URL?
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    let urlSessionDataTaskSpy = URLSessionDataTaskSpy()

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
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
