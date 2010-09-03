/*
 * Copyright 2010 Ullrich Schäfer, Gernot Poetsch for SoundCloud Ltd.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 *
 * For more information and documentation refer to
 * http://soundcloud.com/api
 * 
 */

#import "iPhoneTestAppSoundCloudController.h"


@implementation iPhoneTestAppSoundCloudController

#pragma mark Lifecycle

- (id)initWithAuthenticationDelegate:(NSObject<SCSoundCloudAPIAuthenticationDelegate> *)authDelegate configuration:(SCSoundCloudAPIConfiguration *)configuration;
{
	if (self = [super init]) {
		scAPI = [[SCSoundCloudAPI alloc] initWithAuthenticationDelegate:authDelegate
													   apiConfiguration:configuration];
		[scAPI setResponseFormat:SCResponseFormatJSON];
	}
	return self;
}

- (void)dealloc;
{
	[scAPI release];
	[super dealloc];
}


#pragma mark Accessors

@synthesize scAPI;


#pragma mark Public

- (void)requestAuthentication;
{
	[scAPI requestAuthentication];
}

#pragma mark API Helper

- (SCSoundCloudConnection *)meWithContext:(id)context
								 delegate:(NSObject<SCSoundCloudConnectionDelegate> *)delegate;
{
	return [scAPI performMethod:@"GET"
					 onResource:@"/me"
				 withParameters:nil
						context:context
			 connectionDelegate:delegate];
}

- (SCSoundCloudConnection *)postTrackWithTitle:(NSString *)title
									   fileURL:(NSURL *)fileURL
										public:(BOOL)public
									   context:(id)context
									  delegate:(NSObject<SCSoundCloudConnectionDelegate> *)delegate;
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:title forKey:@"track[title]"];
	[parameters setObject:(public ? @"public" : @"private") forKey:@"track[sharing]"];
	[parameters setObject:fileURL forKey:@"track[asset_data]"];
	
	return [scAPI performMethod:@"POST"
					 onResource:@"tracks"
				 withParameters:parameters
						context:context
			 connectionDelegate:delegate];
}

@end
