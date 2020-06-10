//
//  ACRouterTests.m
//  ACRouterTests
//
//  Created by creasyma on 06/26/2018.
//  Copyright (c) 2018 creasyma. All rights reserved.
//

@import XCTest;
#import "ACRouter.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    [ACRouter registerWithURLString:@"test://hasRegisterUrl" handler:^(NSDictionary * _Nullable paramsIn) {
        ACRouterCompletionBlock complete = paramsIn[ACRouterParameterCompletion];
        if (complete) {
            ACRouterOutModel *model = [[ACRouterOutModel alloc] init];
            model.data = @{@"result":@"result"};
            complete(model);
        }
        NSLog(@"paramsIn: %@",paramsIn);
    }];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOpenEmptyURL {
    NSString *emptyURL = @"";
    
    XCTAssertFalse([ACRouter openWithURLString:emptyURL]);
    
    emptyURL = @"    ";
    XCTAssertFalse([ACRouter openWithURLString:emptyURL]);
    
    emptyURL = nil;
    XCTAssertFalse([ACRouter openWithURLString:emptyURL]);
    
    emptyURL = (NSString *)[NSNull null];
    XCTAssertFalse([ACRouter openWithURLString:emptyURL]);
    
    emptyURL = (NSString *)[NSObject new];
    XCTAssertFalse([ACRouter openWithURLString:emptyURL]);
    
}

- (void)testNotRegisterUrl {
    NSString *notRegisterUrl = @"test://notRegisterUrl";
    XCTAssertFalse([ACRouter openWithURLString:notRegisterUrl]);
}

- (void)testOpenUrl {
    NSString *hasRegisterUrl = @"test://hasRegisterUrl";
    XCTAssertTrue([ACRouter openWithURLString:hasRegisterUrl]);
    
    hasRegisterUrl = @"test://hasRegisterUrl?a=a";
    XCTAssertTrue([ACRouter openWithURLString:hasRegisterUrl]);
    
    hasRegisterUrl = @"test://hasRegisterUrl?a=a&b=b";
    XCTAssertTrue([ACRouter openWithURLString:hasRegisterUrl]);
    
    hasRegisterUrl = @"test://hasRegisterUrl?a=a&b=中文";
    XCTAssertTrue([ACRouter openWithURLString:hasRegisterUrl]);
    
}

- (void)testOpenWithComplete {
    NSString *url = @"test://hasRegisterUrl";
    XCTestExpectation* expect = [self expectationWithDescription:@"testOpenWithComplete"];
    
    [ACRouter openWithURLString:url completion:^(ACRouterOutModel * _Nonnull outModel) {
        NSLog(@"testOpenWithComplete outModel: %@",outModel);
        [expect fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testOpenWithUserInfo {
    NSString *url = @"test://hasRegisterUrl";
    XCTestExpectation* expect = [self expectationWithDescription:@"testOpenWithUserInfo"];
    [ACRouter openWithURLString:url userInfo:@{@"userInfo":@"userInfo"} completion:^(ACRouterOutModel * _Nonnull outModel) {
        NSLog(@"testOpenWithUserInfo outModel: %@",outModel);
        [expect fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end

