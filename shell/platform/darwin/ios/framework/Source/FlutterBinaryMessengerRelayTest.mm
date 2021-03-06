// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "flutter/shell/platform/darwin/ios/framework/Source/FlutterBinaryMessengerRelay.h"

#ifndef __has_feature
#define __has_feature(x) 0 /* for non-clang compilers */
#endif

#if !__has_feature(objc_arc)
#error ARC must be enabled!
#endif

@interface FlutterBinaryMessengerRelayTest : XCTestCase
@end

@implementation FlutterBinaryMessengerRelayTest

- (void)setUp {
}

- (void)tearDown {
}

- (void)testCreate {
  id messenger = OCMProtocolMock(@protocol(FlutterBinaryMessenger));
  FlutterBinaryMessengerRelay* relay =
      [[FlutterBinaryMessengerRelay alloc] initWithParent:messenger];
  XCTAssertNotNil(relay);
  XCTAssertEqual(messenger, relay.parent);
}

- (void)testPassesCallOn {
  id messenger = OCMProtocolMock(@protocol(FlutterBinaryMessenger));
  FlutterBinaryMessengerRelay* relay =
      [[FlutterBinaryMessengerRelay alloc] initWithParent:messenger];
  char messageData[] = {'a', 'a', 'r', 'o', 'n'};
  NSData* message = [NSData dataWithBytes:messageData length:sizeof(messageData)];
  NSString* channel = @"foobar";
  [relay sendOnChannel:channel message:message binaryReply:nil];
  OCMVerify([messenger sendOnChannel:channel message:message binaryReply:nil]);
}

- (void)testDoesntPassCallOn {
  id messenger = OCMStrictProtocolMock(@protocol(FlutterBinaryMessenger));
  FlutterBinaryMessengerRelay* relay =
      [[FlutterBinaryMessengerRelay alloc] initWithParent:messenger];
  char messageData[] = {'a', 'a', 'r', 'o', 'n'};
  NSData* message = [NSData dataWithBytes:messageData length:sizeof(messageData)];
  NSString* channel = @"foobar";
  relay.parent = nil;
  [relay sendOnChannel:channel message:message binaryReply:nil];
}

@end
