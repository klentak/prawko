//
//  WatchRepository_Test.swift
//  prawko_Tests
//
//  Created by Jakub Klentak on 12/07/2023.
//

import XCTest
@testable import prawko

final class WatchRepository_Test: XCTestCase {
    var watchRepository: WatchlistRepository!

    override func setUp() {
        watchRepository = WatchlistRepository()
    }

    override func tearDown() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

    func test_getList_emptyArray() throws {
        XCTAssertEqual(
            watchRepository.getList(),
            []
        )
    }

    func test_addElement_oneElement() throws {
        let element = WatchlistElement(
            category: DrivingLicenceCategory(id: "1", name: "Test", icon: "test"),
            wordId: "1",
            type: ExamTypeEnum.practice,
            latestExam: nil
        )

        try watchRepository.addElement(element)

        XCTAssertEqual(
            watchRepository.getList(),
            [element]
        )
    }

    func test_addElement_twoElements() throws {
        let elementOne = WatchlistElement(
            category: DrivingLicenceCategory(id: "1", name: "Test", icon: "test"),
            wordId: "1",
            type: ExamTypeEnum.practice,
            latestExam: nil
        )

        let elementTwo = WatchlistElement(
            category: DrivingLicenceCategory(id: "2", name: "Test_2", icon: "test_2"),
            wordId: "2",
            type: ExamTypeEnum.practice,
            latestExam: nil
        )

        try watchRepository.addElement(elementOne)
        try watchRepository.addElement(elementTwo)

        XCTAssertEqual(
            watchRepository.getList(),
            [elementOne, elementTwo]
        )
    }

    func test_removeElement_removeOneElement() throws {
        let element = WatchlistElement(
            category: DrivingLicenceCategory(id: "1", name: "Test", icon: "test"),
            wordId: "1",
            type: ExamTypeEnum.practice,
            latestExam: nil
        )

        try watchRepository.addElement(element)

        watchRepository.removeElement(IndexSet(integer: 0))

        XCTAssertEqual(
            watchRepository.getList(),
            []
        )
    }

    func test_removeElement_removeTwoElements() throws {
        let elementOne = WatchlistElement(
            category: DrivingLicenceCategory(id: "1", name: "Test", icon: "test"),
            wordId: "1",
            type: ExamTypeEnum.practice,
            latestExam: nil
        )

        let elementTwo = WatchlistElement(
            category: DrivingLicenceCategory(id: "2", name: "Test_2", icon: "test_2"),
            wordId: "2",
            type: ExamTypeEnum.practice,
            latestExam: nil
        )

        try watchRepository.addElement(elementOne)
        try watchRepository.addElement(elementTwo)

        watchRepository.removeElement(IndexSet(integer: 0))
        watchRepository.removeElement(IndexSet(integer: 0))


        XCTAssertEqual(
            watchRepository.getList(),
            []
        )
    }

    func test_removeElement_removeFirstElementOfTwo() throws {
        let elementOne = WatchlistElement(
            category: DrivingLicenceCategory(id: "1", name: "Test", icon: "test"),
            wordId: "1",
            type: ExamTypeEnum.practice,
            latestExam: nil
        )

        let elementTwo = WatchlistElement(
            category: DrivingLicenceCategory(id: "2", name: "Test_2", icon: "test_2"),
            wordId: "2",
            type: ExamTypeEnum.practice,
            latestExam: nil
        )

        try watchRepository.addElement(elementOne)
        try watchRepository.addElement(elementTwo)

        watchRepository.removeElement(IndexSet(integer: 0))

        XCTAssertEqual(
            watchRepository.getList(),
            [elementTwo]
        )
    }

    func test_removeElement_removeSecondElementOfTwo() throws {
        let elementOne = WatchlistElement(
            category: DrivingLicenceCategory(id: "1", name: "Test", icon: "test"),
            wordId: "1",
            type: ExamTypeEnum.practice,
            latestExam: nil
        )

        let elementTwo = WatchlistElement(
            category: DrivingLicenceCategory(id: "2", name: "Test_2", icon: "test_2"),
            wordId: "2",
            type: ExamTypeEnum.practice,
            latestExam: nil
        )

        try watchRepository.addElement(elementOne)
        try watchRepository.addElement(elementTwo)

        watchRepository.removeElement(IndexSet(integer: 1))

        XCTAssertEqual(
            watchRepository.getList(),
            [elementOne]
        )
    }
}
