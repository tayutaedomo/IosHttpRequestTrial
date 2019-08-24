//
//  WebAPI.swift
//  HttpRequestTrial
//
//  Created by tayutaedomo on 2019/08/24.
//  Copyright © 2019 tayutaedomo.net. All rights reserved.
//

import Foundation


//
// Refer: https://qiita.com/Kuniwak/items/a972ff2ade643799d1fe
//

typealias Input = Request


enum WebAPI {

    static func call(with input: Input) {
        self.call(with: input) { _ in
            // TODO
        }
    }

    static func call(with input: Input, _ block: @escaping (Output) -> Void) {
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
//            let response: Response = (
//                statusCode: .ok,
//                headers: [:],
//                payload: "this is a response text".data(using: .utf8)!
//            )
//
//            block(.hasResponse(response))
//        }

        let urlRequest = self.createUrlRequest(by: input)

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in

            let output = self.createOutput(
                data: data,
                urlResponse: urlResponse as? HTTPURLResponse,
                error: error)

            block(output)
        }
        task.resume()
    }

    static private func createUrlRequest(by input: Input) -> URLRequest {
        var request = URLRequest(url: input.url)

        request.httpMethod = input.methodAndPayload.method
        request.httpBody = input.methodAndPayload.body
        request.allHTTPHeaderFields = input.headers

        return request
    }

    static private func createOutput(data: Data?, urlResponse: HTTPURLResponse?, error: Error?) -> Output {
        guard let data = data, let response = urlResponse else {
            return .noResponse(.noDataOrNoResponse(debugInfo: error.debugDescription))
        }

        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields.enumerated() {
            headers[key.description] = String(describing: value)
        }

        return .hasResponse((
            statusCode: .from(code: response.statusCode),
            headers: headers,
            payload: data
        ))
    }
}


enum Output {

    case hasResponse(Response)
    
    case noResponse(ConnectionError)
}


typealias Request = (

    url: URL,

    queries: [URLQueryItem],

    headers: [String: String],

    methodAndPayload: HTTPMethodAndPayload
)


enum ConnectionError {

    case noDataOrNoResponse(debugInfo: String)
}


typealias Response = (

    statusCode: HTTPStatus,

    headers: [String: String],

    payload: Data
)


enum HTTPMethodAndPayload {

    case get

    var method: String {
        switch self {
        case .get:
            return "GET"
        }
    }

    var body: Data? {
        switch self {
        case .get:
            return nil
        }
    }
}


enum HTTPStatus {

    case ok

    case notFound

    case unsupported(code: Int)

    static func from(code: Int) -> HTTPStatus {
        switch code {
        case 200:
            return .ok

        case 400:
            return .notFound

        default:
            return .unsupported(code: code)
        }
    }
}
