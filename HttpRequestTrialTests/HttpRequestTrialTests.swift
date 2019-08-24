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

        let errorOrZen = GitHubZen.from(response: response)

        switch errorOrZen {
        case let .left(error):
            XCTFail("\(error)")

        case let .right(zen):
            XCTAssertEqual(zen.text, "this is a response text")
        }
    }

    func testRequestAndResponse() {
        let expectation = self.expectation(description: "Wait for API")

//        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
//            expectation.fulfill()
//        }

        let input: Request = (
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )

        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                XCTFail("\(connectionError)")

            case let .hasResponse(response):
                let errorOrZen = GitHubZen.from(response: response)
                XCTAssertNotNil(errorOrZen.right)
            }

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 10)
    }
}
