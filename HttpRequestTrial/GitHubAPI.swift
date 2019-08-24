//
//  GitHubAPI.swift
//  HttpRequestTrial
//
//  Created by tayutaedomo on 2019/08/24.
//  Copyright © 2019 tayutaedomo.net. All rights reserved.
//

import Foundation


enum Either<Left, Right> {
    case left(Left)
    case right(Right)

    var left: Left? {
        switch self {
        case let .left(x):
            return x

        case .right:
            return nil
        }
    }

    var right: Right? {
        switch self {
        case .left:
            return nil

        case let .right(x):
            return x
        }
    }
}


struct GitHubZen {

    let text: String

    static func from(response: Response) -> Either<TransformError, GitHubZen> {
        switch response.statusCode {
        case .ok:
            guard let string = String(data: response.payload, encoding: .utf8) else {
                return .left(.malformedData(debugInfo: "not UTF-8 string"))
            }

            return .right(GitHubZen(text: string))

        default:
            return .left(.unexpectedStatusCode(debugInfo: "\(response.statusCode)"))
        }
    }

    enum TransformError {
        case unexpectedStatusCode(debugInfo: String)
        case malformedData(debugInfo: String)
    }
}


enum GitHubZenResponse {
    case success(GitHubZen)
    case failure(GitHubZen.TransformError)
}

