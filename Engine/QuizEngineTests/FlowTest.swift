//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase  {
    
    let router = RouterSpy()
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(question: []).start()
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestions_routeToCollectQuestion() {
        makeSUT(question: ["Q1"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_routeToCorrectQuestion_2() {
        makeSUT(question: ["Q2"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routeToFirstQuestion() {
        makeSUT(question: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routeToFirstQuestionTwice() {
        let sut = makeSUT(question: ["Q1", "Q2"])//system under test
        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestion_routeToSecondAndThirdQuestion() {
        let sut = makeSUT(question: ["Q1", "Q2", "Q3"])//system under test
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion() {
        let sut = makeSUT(question: ["Q1"])//system under test
        sut.start()
        
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_doesNotRouteToResult() {
        makeSUT(question: []).start()
        
        XCTAssertEqual(router.routedResult!, [:])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_routesToResult() {
        let sut = makeSUT(question: ["Q1"])//system under test
        sut.start()
        
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedResult!, ["Q1": "A1"])
    }
    
    func test_start_withOneQuestion_routesToResult() {
        makeSUT(question: ["Q1"]).start()
        
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestion_routesToResult() {
        let sut = makeSUT(question: ["Q1", "Q2"])//system under test
        sut.start()
        
        router.answerCallback("A1")
       
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_doesNotrouteToResult() {
        let sut = makeSUT(question: ["Q1", "Q2"])//system under test
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult!, ["Q1": "A1", "Q2": "A2"])
    }
    
    // MARK: Helpers
    func makeSUT(question: [String]) -> Flow {
        return Flow(questions: question, router: router)
    }
    
    class RouterSpy: Router {
        
        var routedQuestions: [String] = []
        var routedResult: [String: String]? = nil
        var answerCallback: Router.AnswerCallback = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping Router.AnswerCallback) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: [String: String]) {
            routedResult = result
        }
    }
}
