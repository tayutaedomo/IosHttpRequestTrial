//
//  GitHubApiTests.swift
//  HttpRequestTrial
//
//  Created by tayutaedomo on 2019/08/24.
//  Copyright © 2019 tayutaedomo.net. All rights reserved.
//

import XCTest
@testable import HttpRequestTrial

class GitHubApiTests: XCTestCase {

    func testZenFetch() {
        let expectation = self.expectation(description: "API")
        let input: Input = (
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )

        WebAPI.call(with: input) { output in
            switch output {
            case .noResponse:
                XCTFail("No response")

            case let .hasResponse(response):
                let errorOrZen = GitHubZen.from(response: response)
                XCTAssertNotNil(errorOrZen.right)
            }

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 10)
    }

    func testZenFetchTwice() {
        let expectation = self.expectation(description: "API")
        
        let input: Input = (
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        WebAPI.call(with: input) { output in
            switch output {
            case .noResponse:
                XCTFail("No response")
                
            case let .hasResponse(_):
                let nextInput: Input = (
                    url: URL(string: "https://api.github.com/zen")!,
                    queries: [],
                    headers: [:],
                    methodAndPayload: .get
                )
                
                WebAPI.call(with: nextInput) { nextOutput in
                    switch nextOutput {
                    case .noResponse:
                        XCTFail("No response")

                    case let .hasResponse(response):
                        let errorOrZen = GitHubZen.from(response: response)
                        XCTAssertNotNil(errorOrZen.right)
                    }

                    expectation.fulfill()
                }
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
    }
}
