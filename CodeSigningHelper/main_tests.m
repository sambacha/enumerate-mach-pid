#import <XCTest/XCTest.h>
#import "main.m"

@interface MainTests : XCTestCase
@end

@implementation MainTests

- (void)testXPCConnectionCreation {
    xpc_connection_t conn = xpc_connection_create_mach_service(service_name, NULL, 0);
    XCTAssertNotNil(conn, @"XPC connection should be created successfully");
}

- (void)testXPCMessageSendAndReply {
    xpc_connection_t conn = xpc_connection_create_mach_service(service_name, NULL, 0);
    xpc_connection_set_event_handler(conn, ^(xpc_object_t object) {
    });
    xpc_connection_resume(conn);

    XCTestExpectation *expectation = [self expectationWithDescription:@"XPC message send and reply"];

    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
    xpc_dictionary_set_string(message, "command", "fetchData");
    xpc_dictionary_set_int64(message, "pid", 1);

    xpc_connection_send_message_with_reply(conn, message, NULL, ^(xpc_object_t object) {
        size_t sz = 0;
        const void *data = xpc_dictionary_get_data(object, "bundleURL", &sz);
        XCTAssertNotEqual(sz, 0, @"Received data size should not be zero");
        XCTAssertNotNil(data, @"Received data should not be nil");
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testXPCMessageSendAndReplyWithInvalidPID {
    xpc_connection_t conn = xpc_connection_create_mach_service(service_name, NULL, 0);
    xpc_connection_set_event_handler(conn, ^(xpc_object_t object) {
    });
    xpc_connection_resume(conn);

    XCTestExpectation *expectation = [self expectationWithDescription:@"XPC message send and reply with invalid PID"];

    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
    xpc_dictionary_set_string(message, "command", "fetchData");
    xpc_dictionary_set_int64(message, "pid", -1);

    xpc_connection_send_message_with_reply(conn, message, NULL, ^(xpc_object_t object) {
        size_t sz = 0;
        const void *data = xpc_dictionary_get_data(object, "bundleURL", &sz);
        XCTAssertEqual(sz, 0, @"Received data size should be zero for invalid PID");
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
