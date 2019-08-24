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
        // TODO
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
