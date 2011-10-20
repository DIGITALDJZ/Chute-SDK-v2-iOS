Setup
====

First copy the SDK files into your project.  Find the GCConstants.h file located at GetChute/Classes/Core and enter your OAuth information.  You can also adjust which service your users will use to sign in from this file.  At this point your application will be ready to use the Chute SDK.  Simply include GetChute.h in any classes that will be accessing the SDK.

You can also find prebuilt customizable drop in components [here](https://github.com/chute/chute-ios-components).  You can pick and choose which components you want to use and they are a simple way to get working with chute quickly and to see the SDK in action.

Key Concepts
========

## Client
All Chute applications use OAuth and are referred to as 'Clients'

## Asset
Any photo or video managed by Chute

## Chute
A container for assets.  Chutes can be nested inside of each other.

## Parcel
A named collection of assets.  Whenever you upload assets, they are grouped into parcels.

## Bundle
An unnamed collection of assets.


Basic Tasks
=========

## Uploading Assets
You upload tasks using a parcel.  You can use it in conjunction with the GCUploader class to queue uploads in the background, or you can upload directly from the parcel.

The following code will queue an array of assets to upload to an array of chutes in the background.

'''
    GCParcel *parcel = [GCParcel objectWithAssets:_assets andChutes:_chutes];
    [[GCUploader sharedUploader] addParcel:parcel];
'''

If you want to perform the upload now or with a custom completion block you can use the following code.

'''
    GCParcel *parcel = [GCParcel objectWithAssets:_assets andChutes:_chutes];
    [parcel startUploadWithTarget:self andSelector:@selector(parcelCompleted)];
'''

You may also set these to to nil if you don't wish have any completion behavior.

## Displaying Assets

There are two convenience methods for displaying assets.  Each asset has a method to retrieve a thumbnail as well as one for a custom sized image.  You can access the thumbnail by simply calling [_asset thumbnail], which returns a UIImage that is formatted for 75x75 pixels.  To retrieve a custom sized image you can call [_asset imageForWidth:(NSUInteger)width andHeight:(NSUInteger)height] which returns an image formatted to the given dimensions.  This method runs in the foreground so it may be somewhat slow.  You can also call [_asset imageForWidth:(NSUInteger)width andHeight:(NSUInteger)height inBackgroundWithCompletion:(void (^)(UIImage *))aResponseBlock] to get the image in the background and run a response block on completion.  For example

'''
UIImageView *v = [[[UIImageView alloc] init] autorelease];
[_asset imageForWidth:320 andHeight:480 inBackgroundWithCompletion:^(UIImage *temp){
        [v setImage:temp];
    }];
'''

## Organizing Assets

## Associating Your Data with Assets

Many chute components can have metadata associated with them.  This metadata is specific to your application.  There are several methods for setting the metadata.  They are

'''
- (BOOL) setMetaData:(NSDictionary *) metaData;
- (void) setMetaData:(NSDictionary *) metaData inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

- (BOOL) setMetaData:(NSString *) data forKey:(NSString *) key;
- (void) setMetaData:(NSString *) data forKey:(NSString *) key inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;
'''

The first two methods can set multiple values by using a dictionary.  The second two are for setting a single value for a key.

There are also several methods for retrieving metadata.  There are two methods for retrieving all your metadata and two for simply getting a value for a single key.  These methods are

'''
- (GCResponse *) getMetaData;
- (void) getMetaDataInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (id) getMetaDataForKey:(NSString *) key;
- (void) getMetaDataForKey:(NSString *) key inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;
'''

There are also methods for retrieving all objects that have a specific key/value pair.  These are

'''
+ (GCResponse *) searchMetaDataForKey:(NSString *) key andValue:(NSString *) value;
+ (void) searchMetaDataForKey:(NSString *) key andValue:(NSString *) value inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;
'''

Finally you can also delete your metadata for an object.  You do this using one of the following methods

'''
- (BOOL) deleteMetaData;
- (void) deleteMetaDataInBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

- (BOOL) deleteMetaDataForKey:(NSString *) key;
- (void) deleteMetaDataForKey:(NSString *) key inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;
'''

The first set delete all metadata and the second set deletes meta data for a specific key.

## Bundling Assets


Social Tasks
==========

## Hearting Assets

Hearting and unhearting an asset is simple.  You just call one of the following methods

'''
- (GCResponse *) heart;
- (void) heartInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolErrorBlock;

- (GCResponse *) unheart;
- (void) unheartInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolErrorBlock;
'''

You can also check if an asset is hearted by calling [_asset isHearted].  This method checks against your hearted assets which must be loaded by calling [[GCAccount sharedManager] loadHeartedAssets].  To get a correct response when checking if an asset is hearted it is recommended that you call this function once when your app loads and any time you heart or unhurt an asset.

## Commenting on Assets

You can retrieve all comments for an asset by calling one of two methods

'''
- (GCResponse *) comments;
- (void) commentsInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;
'''

There are also two methods for posting a comment to an asset

'''
- (GCResponse *) addComment:(NSString *) _comment;
- (void) addComment:(NSString *) _comment inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;
'''

Both of these rely on the asset's parentID to be set.  If the asset is retrieved from a chute then this as already set, however if you are retrieving the asset from a parcel you need to set it manually since there could be multiple chutes that the asset was uploaded to.  You can set it by calling [_asset setParentID:[_chute objectID]].
