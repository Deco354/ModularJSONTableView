//
//  ImageRequestTests.swift
//  ModularJSONTableViewTests
//
//  Created by Declan McKenna on 23/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import XCTest
@testable import ModularJSONTableView

class ImageRequestTests: XCTestCase {

    let stubbedNetworkSession = StubbedNetworkSession()
    let stubURL = URL(string: "test.com")!
    var loadedImageData: Data?
    
    func testLoadValidImage() {
        let expectedImage = UIImage(named: "Card", in: Bundle(for: Self.self), compatibleWith: nil)
        let expectedData = expectedImage?.pngData()
        stubbedNetworkSession.data = expectedImage?.pngData()
        
        let localImageURL = Bundle(for: ImageRequestTests.self).url(forResource: "Card", withExtension: ".png")!
        let imageRequest = ImageRequest(url: localImageURL, session: stubbedNetworkSession)
        imageRequest.load(withCompletion: saveImageData)
        XCTAssertEqual(loadedImageData, expectedData)
    }
    
    func testLoadURLWithNoData() {
        let imageRequest = ImageRequest(url: stubURL, session: stubbedNetworkSession)
        imageRequest.load(withCompletion: saveImageData)
        XCTAssertNil(loadedImageData)
    }
    
    func testLoadURLWithInvalidData() {
        stubbedNetworkSession.data = Data()
        let imageRequest = ImageRequest(url: stubURL, session: stubbedNetworkSession)
        imageRequest.load(withCompletion: saveImageData)
        XCTAssertNil(loadedImageData)
    }
    
    private func saveImageData(from image: UIImage?) {
        loadedImageData = image?.pngData()
    }

}

class StubbedNetworkSession: NetworkSession {
    var data: Data?
    var error: Error?
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(self.data, self.error)
    }
}
