//
//  CodeSigningHelper.h
//  CodeSigningHelper
//
//  Created by janitor on 7/21/24.
//

#import <Foundation/Foundation.h>
#import "CodeSigningHelperProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface CodeSigningHelper : NSObject <CodeSigningHelperProtocol>
@end
