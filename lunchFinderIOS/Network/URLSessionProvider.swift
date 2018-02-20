import Foundation

protocol URLSessionProvider {
    var baseURL: String { get }
    var urlSession: URLSession { get }
}
