//
//  HttpRequestTrialTests.swift
//  HttpRequestTrialTests
//
//  Created by tayutaedomo on 2019/08/24.
//  Copyright © 2019 tayutaedomo.net. All rights reserved.
//

import XCTest
@testable import HttpRequestTrial

class HttpRequestTrialTests: XCTestCase {

    func testRequest() {
        let input: Request = (
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )

        WebAPI.call(with: input)
    }

    func testResponse() {
        let response: Response = (
            statusCode: .ok,
            headers: [:],
            payload: "this is a response text".data(using: .utf8)!
        )
    }
}
