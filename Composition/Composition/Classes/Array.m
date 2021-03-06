//
//  Array.m
//  Composition
//
//  Created by Dave Meehan on 21/05/2013.
//  Copyright (c) 2013 Dave Meehan. All rights reserved.
//

#import "Array.h"
#import "ArrayImpl.h"
#import "LoggingProxy.h"
#import "RecursiveLockingProxy.h"

@interface Array () <IArrayDelegate>

@property (strong) NSArray *storage;

@end

@implementation Array

@synthesize storage = _storage;

-(id)init {
	
	return [self initWithArray: @[]];
	
}

-(id)initWithArray: (NSArray *)array {
	
	NSParameterAssert(array);
	NSParameterAssert([array isKindOfClass: [NSArray class]]);
	
	id arrayImpl = [[ArrayImpl alloc] initWithDelegate: self];
	id locker = [[RecursiveLockingProxy alloc] initWithProxiedObject:arrayImpl];
	id logger = [[LoggingProxy alloc] initWithProxiedObject:locker];
	
	if (self = [super initWithProxiedObject:logger]) {
		
		_storage = [array copy];

	}
	
	return self;
	
}

-(void)forwardInvocation: (NSInvocation *) anInvocation {
	[super forwardInvocation:anInvocation];
}


@end
