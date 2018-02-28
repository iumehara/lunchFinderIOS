import Foundation

protocol URLSessionProvider {
    var baseURL: String { get }
    var urlSession: URLSession { get }
    func getRequest(path: String) -> URLRequest?
    func postRequest(path: String, body: Data) -> URLRequest?
    func putRequest(path: String, body: Data) -> URLRequest?
}
