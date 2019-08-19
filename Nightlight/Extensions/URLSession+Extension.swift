import Foundation

extension URLSession {
    /**
     A wrapper around a data task with a result callback.
     
     - parameter url: the URL to be retrieved.
     - parameter result: the result of the load request.
     */
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse?, Data?), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                return result(.failure(error))
            }
            
            result(.success((response, data)))
        }
    }
    
    /**
     A wrapper around a data task with a result callback.
     
     - parameter urlRequest: a URL request object that provides the URL, cache policy, request type, body data or body stream, and so on.
     - parameter result: the result of the load request.
     */
    func dataTask(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse?, Data?), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return result(.failure(error))
            }
            
            result(.success((response, data)))
        }
    
    }
}
