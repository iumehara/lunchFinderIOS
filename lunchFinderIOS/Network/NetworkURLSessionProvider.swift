import UIKit

struct NetworkURLSessionProvider: URLSessionProvider {
    let baseURL = AppDelegate.baseURL

    var urlSession = URLSession.shared
    
    func getRequest(path: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    func postRequest(path: String, body: Data) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        return request
    }

    func putRequest(path: String, body: Data) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        return request
    }

    func deleteRequest(path: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
