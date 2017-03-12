//
//  PMNetworkManager.m
//  Poems
//
//  Created by Dzionis Brek on 2/25/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMNetworkManager.h"

// Managers
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"

// Constants
#import "PMConstants.h"

NSString *const kTimeoutErrorString = @"You are not connected to the internet";
NSString *const kDefaultErrorString =
    @"Sorry, something went wrong. Please, try again later";
NSString *const kRequestErrorString = @"Request was failed";

@interface PMNetworkManager ()

@property(strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation PMNetworkManager

#pragma mark -

+ (instancetype)sharedManager {
  static PMNetworkManager *_sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedManager = [[PMNetworkManager alloc] init];
  });

  return _sharedManager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    _sessionManager = [[AFHTTPSessionManager alloc]
        initWithBaseURL:[NSURL URLWithString:kPMBaseUrl]];

    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
  }
  return self;
}

#pragma mark - Public

- (void)allPoemsWithSuccess:(PMNetworkSuccessBlock)success
                    failure:(PMNetworkFailedBlock)failure {
  NSString *requestPath = [PMNetworkManager requestWithPath:kPMAPIKolasPath];
  NSDictionary *params = @{kPMAPIAuthorKey : kPMAPIAuthorNameKey};
  [self getRequestWithService:requestPath
                   parameters:params
                      success:success
                      failure:failure];
}

- (void)checkUpdatesWithLastUpdate:(NSUInteger)lastUpdate
                           success:(PMNetworkSuccessBlock)success
                           failure:(PMNetworkFailedBlock)failure {
  NSString *requestPath = [PMNetworkManager requestWithPath:kPMAPIUpdatesPath];
  NSDictionary *params = @{
    kPMAPIAuthorKey : kPMAPIAuthorNameKey,
    kPMAPILastUpdateKey : @(lastUpdate)
  };
  [self getRequestWithService:requestPath
                   parameters:params
                      success:success
                      failure:failure];
}

#pragma mark - Private

+ (NSString *)requestWithPath:(NSString *)path {
  return [NSString stringWithFormat:@"%@%@", kPMBaseUrl, path];
}

+ (BOOL)checkInternetConnection {
  if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <
      0) {
    return YES;
  }

  if ([AFNetworkReachabilityManager sharedManager].reachable) {
    return YES;
  } else {
    return NO;
  }
}

+ (NSString *)jsonMessageStatusError:(NSError *)error {
  NSData *errorData =
      error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];

  if (errorData) {
    NSDictionary *errorDictionary =
        [NSJSONSerialization JSONObjectWithData:errorData
                                        options:kNilOptions
                                          error:nil];

    NSString *errorMessage = errorDictionary[kPMAPIMessageKey];
    return errorMessage;
  }
  if ([PMNetworkManager checkInternetConnection]) {
    return kDefaultErrorString;
  } else {
    return kTimeoutErrorString;
  }
}

- (NSError *)createErrorWithCode:(NSInteger)errorCode {
  return [self createErrorWithCode:errorCode
              localizedDescription:kRequestErrorString];
}

- (NSError *)createErrorWithCode:(NSInteger)errorCode
            localizedDescription:(NSString *)localizedDescription {
  NSError *error = [NSError
      errorWithDomain:kPMBaseUrl
                 code:errorCode
             userInfo:@{NSLocalizedDescriptionKey : localizedDescription}];
  return error;
}

#pragma mark - Basic Requests

- (void)getRequestWithService:(NSString *)service
                   parameters:(NSDictionary *)parameters
                      success:(PMNetworkSuccessBlock)success
                      failure:(PMNetworkFailedBlock)failure {
  if (![PMNetworkManager checkInternetConnection]) {
    NSError *error =
        [self createErrorWithCode:408 localizedDescription:kTimeoutErrorString];
    if (failure) {
      failure(error);
    }
    return;
  }

  [self.sessionManager GET:service
      parameters:parameters
      progress:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {

        // Update token after each get request.
        if (success) {
          success(responseObject);
        }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
        // Check Unauthorized error.
        [self checkUnauthorizedError:&error];

        if (failure) {
          failure(error);
        }
      }];
}

- (void)deleteRequestWithService:(NSString *)service
                      parameters:(NSDictionary *)parameters
                         success:(PMNetworkSuccessBlock)success
                         failure:(PMNetworkFailedBlock)failure {
  if (![PMNetworkManager checkInternetConnection]) {
    NSError *error =
        [self createErrorWithCode:408 localizedDescription:kTimeoutErrorString];
    if (failure) {
      failure(error);
    }
    return;
  }

  [self.sessionManager DELETE:service
      parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {

        if (success) {
          success(responseObject);
        }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {

        // Check Unauthorized error.
        [self checkUnauthorizedError:&error];

        if (failure) {
          failure(error);
        }
      }];
}

- (void)postRequestWithService:(NSString *)service
                    parameters:(NSDictionary *)params
                       success:(PMNetworkSuccessBlock)success
                       failure:(PMNetworkFailedBlock)failure {
  if (![PMNetworkManager checkInternetConnection]) {
    NSError *error =
        [self createErrorWithCode:408 localizedDescription:kTimeoutErrorString];
    if (failure) {
      failure(error);
    }
    return;
  }

  [self.sessionManager POST:service
      parameters:params
      progress:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
          success(responseObject);
        }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
        // Check Unauthorized error.
        [self checkUnauthorizedError:&error];

        if (failure) {
          failure(error);
        }
      }];
}

- (void)patchRequestWithService:(NSString *)service
                     parameters:(NSDictionary *)parameters
                        success:(PMNetworkSuccessBlock)success
                        failure:(PMNetworkFailedBlock)failure {
  if (![PMNetworkManager checkInternetConnection]) {
    NSError *error =
        [self createErrorWithCode:408 localizedDescription:kTimeoutErrorString];
    if (failure) {
      failure(error);
    }
    return;
  }

  [self.sessionManager PATCH:service
      parameters:parameters
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nullable responseObject) {

        if (success) {
          success(responseObject);
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        // Check Unauthorized error.
        [self checkUnauthorizedError:&error];

        if (failure) {
          failure(error);
        }
      }];
}

- (void)putRequestWithService:(NSString *)service
                   parameters:(NSDictionary *)parameters
                      success:(PMNetworkSuccessBlock)success
                      failure:(PMNetworkFailedBlock)failure {
  if (![PMNetworkManager checkInternetConnection]) {
    NSError *error =
        [self createErrorWithCode:408 localizedDescription:kTimeoutErrorString];
    if (failure) {
      failure(error);
    }
    return;
  }

  [self.sessionManager PUT:service
      parameters:parameters
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nullable responseObject) {

        if (success) {
          success(responseObject);
        }
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        // Check Unauthorized error.
        [self checkUnauthorizedError:&error];

        if (failure) {
          failure(error);
        }
      }];
}

- (void)checkUnauthorizedError:(NSError **)outError {
  NSError *error = *outError;
  NSInteger statusCode = [[[error userInfo]
      objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];

  // If status code is |401| unauthorized, just set token to nil.
  if (statusCode == 401) {
  }
}

@end
