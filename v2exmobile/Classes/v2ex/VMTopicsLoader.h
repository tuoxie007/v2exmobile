#import <Foundation/Foundation.h>
#import "VMLoader.h"

@protocol TopicsLoaderDalegate;
@interface VMTopicsLoader : VMLoader
{
    BOOL reloading;
    NSInteger _page;
    NSString *nodesFilePath;
    NSString *_node;
}

-(void)loadTopics:(NSInteger)page;
-(void)loadTopics:(NSInteger)page inNode:(NSString *)node;

@end


@protocol TopicsLoaderDalegate <LoaderDalegate>

- (void)didFinishedLoadingWithData:(id)data forPage:(NSInteger)page;

@end