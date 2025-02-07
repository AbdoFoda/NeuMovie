//
//  LatestMoviesViewModelTests.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//


import XCTest
@testable import NeuMovie
import Combine

final class LatestMoviesViewModelTests: XCTestCase {
    
    var viewModel: LatestMoviesViewModel!
    var mockNetworkService: MockNetworkService!
    var mockImagePrefetcher: MockImagePrefetcher!
    var cancellable: AnyCancellable?
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockImagePrefetcher = MockImagePrefetcher()
        viewModel = LatestMoviesViewModel(
            networkService: mockNetworkService,
            imagePrefetcher: mockImagePrefetcher
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockImagePrefetcher = nil
        super.tearDown()
    }
    
    func testLoadMoreMovies_Success() {
        let response = NowPlayingResponse(page: 1, results: MovieMockData.sampleMovies, totalPages: 1, totalResults: 50)
        mockNetworkService.mockResult = .success(response)
        
        let expectation = self.expectation(description: "Movies should be updated")
        
        cancellable = viewModel.$moviesToDisplay.sink { movies in
            if movies.count == MovieMockData.sampleMovies.count {
                expectation.fulfill()
                self.cancellable?.cancel() // Cancel subscription after expectation is fulfilled
            }
        }
        
        viewModel.loadMoreMovies { error in
            XCTAssertNil(error, "Expected no error")
        }
        
        waitForExpectations(timeout: 5)
        
        XCTAssertEqual(viewModel.moviesToDisplay.count, MovieMockData.sampleMovies.count, "Expected all movies")
        XCTAssertTrue(mockImagePrefetcher.didPrefetch, "Expected images to be prefetched")
        XCTAssertEqual(mockImagePrefetcher.prefetchCount, MovieMockData.sampleMovies.count, "Expected correct prefetch count")
    }
    func testLoadMoreMovies_Failure() {
        // Given: Mock a failed response
        mockNetworkService.mockResult = .failure(.invalidResponse)
        
        let expectation = self.expectation(description: "Loading movies should fail")
        
        // When: Calling `loadMoreMovies`
        viewModel.loadMoreMovies { error in
            XCTAssertNotNil(error, "Expected an error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
        
        // Then: Movies should NOT be added
        XCTAssertTrue(viewModel.moviesToDisplay.isEmpty, "Expected no movies")
        XCTAssertFalse(mockImagePrefetcher.didPrefetch, "Should not prefetch images on failure")
    }
    
    func testLoadMoreMovies_WhenAllMoviesLoaded() {
        // Given: No more pages left
        viewModel.canLoadMore = false
        
        let expectation = self.expectation(description: "Should not fetch more movies")
        
        // When: Trying to load more movies
        viewModel.loadMoreMovies { error in
            XCTAssertNil(error, "Expected no error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
        
        // Then: API should NOT be called
        XCTAssertTrue(viewModel.moviesToDisplay.isEmpty, "Expected no new movies")
        XCTAssertFalse(mockImagePrefetcher.didPrefetch, "Should not prefetch images")
    }
}
