import Foundation

struct NetworkURLSessionProvider: URLSessionProvider {
    var baseURL = "http://localhost:8080/"
    var urlSession = URLSession.shared
}
