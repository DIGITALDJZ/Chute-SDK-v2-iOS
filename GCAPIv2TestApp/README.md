#Creating Tutorial Application

We will create a simple tutorial application that will show the use of the Chute SDK library. It's step by step tutorial so it should be more extensive, don't worry about it.

#Dependency

No external dependancies beyond Chute SDK which you can also find here:

https://github.com/chute/Chute-SDK-v2-iOS

#Setting up your project

First if you don't have a Chute developer account or an app created on chute for this project then create a Chute developer account and make a new app in Chute at http://apps.getchute.com/
	*  For the URL you can enter http://getchute.com/ if you don't have a site for your app
	*  For the Callback URL you can use http://getchute.com/oauth/callback if you don't need callbacks for another purpose.

Create a new single view project and called it whatever you like. Make it universal and make sure to have checked "Use StoryBoards" and "Use ARC".

In the next step copy Chute-SDK-v2-iOS library to your project.

Also copy the contents of Resources directory in your project's resources folder because you will need them later.

#Setting up ViewControllers


##LoginViewController

First, delete the default ViewController and then create a new one, called LoginViewController. This one it will be the one which will handle the login and the authentication.
Open `MainStoryBoard-iPhone.storyboard` and on default view controller go to Identity Inspector and set its class to LoginViewController.
Add a couple of buttons named by the service that will be used to log in into the application and create IBActions for each of them. 

Do the same for the iPad version in `MainStoryBoard-iPad.storyboard`.

In `LoginViewController.m` add `#import <Chute-SDK/GetChute.h>` to be able to use the methods provided by Chute library.

Create private  method called something like : `- (void)showLoginForLoginType:(GCLoginType)loginType fromStartPoint:(CGPoint)point`. This  method will show a webView with the login method you provide with parameter `loginType, and this animation will start from the start point that you will define in second parameter `point`.
In this method you will have to create a oauth2Client with chute application information and then use it for calling one of GCLoginView methods to display a webView. This look something like this:

```Objective-C
	- (void)showLoginForLoginType:(GCLoginType)loginType fromStartPoint:(CGPoint)point {
	
		GCOAuth2Client *oauth2Client = [GCOAuth2Client clientWithClientID:@"YOUR_APP_ID"  clientSecret:@"YOUR_APP_SECRET"];

		[GCLoginView showInView:self.view fromStartPoint:point oauth2Client:oauth2Client withLoginType:loginType success:^{
			NSLog(@"Success");
			[self dismissViewControllerAnimated:YES completion:^{}];
		} failure:^(NSError *error) {
			NSLog(@"Failed: %@", [error localizedDescription]);
			[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Login Not Successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
		}];
	}
```

Now in your IBActions call this  method like this:

```Objective-C
	- (IBAction)chute:(id)sender {
		[self showLoginForLoginType:GCLoginTypeChute fromStartPoint:[sender layer].position];
	}
```

with that difference that you will change the login type to corresponding service. There is an enumeration in GCOAuth2Client.h for the login types that you can use. Some of them are: GCLoginTypeFacebook, GCLoginTypeSkydrive, GCLoginTypeGoogle etc.

##AlbumViewController

This controller will actually be your initial view controller. So create new view controller as subclass of class UICollectionViewController and name it AlbumViewController.
Create another class but as subclass of type UICollectionViewCell, which will actually represent the view for cell in collection view. Name it AlbumViewCell. In it, create a property `@property (nonatomic, strong) UILabel *albumTitleLabel`, which will be used to display the name of the album later.

In `MainStoryBoard-iPhone.storyboard` bring up Collection View Controller from the object library. While selected go to Editor submenu of XCode and select Embed In -> Navigation Controller. As initial view controller we will need some control for navigating back and forth.
In Identity Inspector for this controller set its class to AdminViewController.
For the cell in Identity Inspector set its class to AlbumViewCell and in Attribute Inspector set its identifier to AlbumCell. This attribute will be used for reusing the same cell in representing cells in collection view.

While you are here you might want to connect AlbumViewController with LoginViewController. Select AlbumViewController then press ctrl and drag from there to LoginViewController. It will create a segue. In Attributes Inspector set its identifier to "Login", its style "Modal" and its transition "Cross Dissolve".

Do the same for the iPad version in `MainStoryBoard-iPad.storyboard`.

At first add `#import <Chute-SDK/GetChute.h>` in `AlbumViewController.m` to be able to use the methods provided by Chute library.

Then create a couple of properties like:
	* `@property (nonatomic) BOOL isManagingAlbumEnabled` - Property of type BOOL which will indicate if the user want to manage representing albums or not. By managing we mean selecting and removing them.
	* `@property (nonatomic, strong) NSMutableArray *selectedAlbums` - Array containing selected albums that we want to delete.
	* `@property (nonatomic, strong) UIBarButtonItem *manageButton` - Button of UIBarButtonItem type which is representing a button with multiple functions: Managing, which enables the multi selection of albums and cancel, to cancel the selection of albums. 
	* `@property (nonatomic, strong) UIBArButtonItem *deleteButton` - Button of UIBarButtonItem type which is visible only when managing is enabled.
	* `@property (nonatomic, strong) NSMutableArray *albums` - Array which holds the albums for the logged user.

First thing is first. We need to check if user is logged in or not, so based on that to decide what is our next action. Your `viewDidAppear` should look like this:

```Objective-C
	-(void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
	
		GCClient *apiClient = [GCClient sharedClient];

		if ([apiClient isLoggedIn] == NO)
			[self performSegueWithIdentifier:@"Login" sender:self.view];
		else
			[self getAlbums];
	}
```

What we do here is obvious. First we create a singleton object from GCClient and then using its method `isLoggedIn` we check if the user is logged in. If NO, then we perform the segue that we've setup before, called "Login" which actually present LoginViewController. If YES on the other hand, we are calling an private method called `getAlbums`.

Your `viewDidLoad` should look similar to this:

```Objective-C
	- (void)viewDidLoad	{
		[super viewDidLoad];
		self.isManagingAlbumsEnabled = NO;
		[self setNavBarWithItems];
		[self setToolbarWithItems];
		self.selectedAlbums = [@[] mutableCopy];
	}
```
Note: The methods `setNavBarWithItems` and `setToolbarWithItems` are defined below.

####Custom Methods

In this section we will define all the private methods that we use in this controller. The defining will go as some methods are mentioned, just to keep the picture.

First the one that we have already mentioned it. The `getAlbums` method. In this method we call a GCAlbum method which has a success and failure blocks. On success it returns an array of albums of type GCAlbum which we use to set our array albums, on failure it presents an alert:

```Objective-C
	-(void)getAlbums {
		[GCAlbum getAllAlbumsWithSuccess:^(GCResponseStatus *responseStatus, NSArray *_albums, GCPagination *pagination) {
			self.albums = [[NSMutableArray alloc] initWithArray:_albums];
			[self.collectionView reloadData];
		} failure:^(NSError *error) {
			[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot fetch albums!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
		}];
	}
```

Next is `manageAlbums`. This one is more used to setup properties of collection view and other objects defined before.

```Objective-C
	- (void)manageAlbums {
		if(!self.isManagingAlbumsEnabled) {
			self.isManagingAlbumsEnabled = YES;
			[self.manageButton setTitle:@"Cancel"];
			[self.collectionView setAllowsMultipleSelection:YES];
			[self.navigationController setToolbarHidden:NO];
			[self setToolbarWithItems];
		}
		else {
			[self.navigationController setToolbarHidden:YES];
			self.isManagingAlbumsEnabled = NO;
			[self.manageButton setTitle:@"Manage"];
			[self.collectionView setAllowsMultipleSelection:NO];
			[self.collectionView reloadData];
			[self.selectedAlbums removeAllObjects];
		}
	}
```

The following two methods are more used for defining the UI. As you will see there are some selectors attached to the bar buttons which we will describe in time.

```Objective-C
	- (void)setToolbarWithItems	{
		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		self.deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteSelectedAlbum)];
		[self.deleteButton setEnabled:NO];
	
		NSArray *toolbarItemsToBeAdd = [NSArray arrayWithObjects:flexibleSpace,self.deleteButton,flexibleSpace, nil];
		self.toolbarItems = toolbarItemsToBeAdd;
	}

	- (void)setNavBarWithItems	{
		UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
	
		self.manageButton = [[UIBarButtonItem alloc] initWithTitle:@"Manage" style:UIBarButtonItemStyleBordered target:self action:@selector(manageAlbums)];
		UIBarButtonItem *addAlbumsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createAlbum)];
		NSArray *rightBarButtons = [NSArray arrayWithObjects:addAlbumsButton,self.manageButton, nil];
	
		self.navigationItem.leftBarButtonItem = logout;
		self.navigationItem.rightBarButtonItems = rightBarButtons;
	}
```

Next method is `deleteSelectedAlbum`. In this method we iterate through the selected albums and delete them one by one.

```Objective-C
	- (void)deleteSelectedAlbum	{
		for (GCAlbum *album in self.selectedAlbums) {
			[album deleteAlbumWithSuccess:^(GCResponseStatus *responseStatus) {

			} failure:^(NSError *error) {
				[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot delete album!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
			}];
		}
			
		[self getAlbums];
		[self manageAlbums];
	}
```

Next method is `createAlbum`. This one differs from the others. It's actually an alertView which presents a keyboard and a text field in which you give desired album name. The creation of album is done in alert view delegate method when user selects "Create".
Note: Don't forget to add `<UIAlertViewDelegate>` in `AlbumViewController.h>.

```Objective-C
	- (void)createAlbum	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Create New Album With Name:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
		alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
		UITextField *inputField = [alertView textFieldAtIndex:0];
		inputField.keyboardType = UIKeyboardTypeDefault;
		[alertView show];
	}
	
	-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
		if(buttonIndex)	{
			UITextField *inputField = [alertView textFieldAtIndex:0];

			[GCAlbum createAlbumWithName:inputField.text moderateMedia:NO moderateComments:NO success:^(GCResponseStatus *responseStatus, GCAlbum *album) {
				[self getAlbums];
			} failure:^(NSError *error) {
				[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Unable to create new album!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
			}];
		}
	}
```

The last one is `logout`. It deletes the token for the given account and performs a segue to the Login Page:

```Objective-C
	- (void)logout {
		GCClient *apiClient = [GCClient sharedClient];
		[apiClient clearAuthorizationHeader];
		[self performSegueWithIdentifier:@"Login" sender:self.view];
	}
```

####Setting the Collection View

Now we should be able to put some data in collection view. We have already set the `albums` so now we know the number of items:
```Objective-C
	-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section	{
		return [self.albums count];
	}
```

And for the data in cells:
```Objective-C
	-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
	{
		AlbumViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
		GCAlbum *album = (GCAlbum *)self.albums[indexPath.item];
		cell.albumTitleLabel.text = [album name]; 		// just for initial version a simple label representing album name.

		if (cell.selected)
			cell.backgroundColor = [UIColor blueColor]; // highlight selection
		else
			cell.backgroundColor = [UIColor whiteColor]; // Default color
	
		return cell;
	}
```

The delegate methods for the collection view, `didSelectItemAtIndexPath` and `didDeselectItemAtIndexPath`, in our case will be used only when managing of the albums is enabled. For presenting the content of the selected album we will use segue. So they should look like this:
```Objective-C
	-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath	{
		if(self.isManagingAlbumsEnabled) {
			AlbumViewCell *cell = (AlbumViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
			cell.backgroundColor = [UIColor blueColor];
			GCAlbum *album = [self.albums objectAtIndex:indexPath.row];
			[self.selectedAlbums addObject:album];
			if([self.selectedAlbums count] > 0)
			   [self.deleteButton setEnabled:YES];
		}
	}
	
	-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
		if(self.isManagingAlbumsEnabled) {
			AlbumViewCell *cell = (AlbumViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
			cell.backgroundColor = [UIColor whiteColor];
			GCAlbum *album = [self.albums objectAtIndex:indexPath.row];
			[self.selectedAlbums removeObject:album];
			if([self.selectedAlbums count] == 0)
				[self.deleteButton setEnabled:NO];
		}
	}
```

####Performing the segue

Although `prepareForSegue` method will have forward declaration of the following view controller (ImagesViewController), don't worry, we'll get there in a moment.
So don't forget to add `#import "ImagesViewController"`, although it doesn't exist at the moment.

```objective-C
	-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender	{
		if([segue.identifier isEqualToString:@"ShowAssets"]) {
			ImagesViewController *ivc = segue.destinationViewController;
			
			NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];

			GCAlbum *album = [albums objectAtIndex:indexPath.item];
			[ivc setAlbum:album];
			[self.collectionView deselectItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] objectAtIndex:0] animated:YES];
		}
	}

	- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
	{
		if(self.isManagingAlbumsEnabled)
			return NO;
		else
			return YES;
	}
```
The `shouldPerformSegueWithIdentifier` method must be defined because on contrary when user clicks on album it will perform the segue, although the user wants to manage the albums.

##ImagesViewController

The logic behind this view controller does not differ much from the one in AlbumViewController, so most of the code is the same.

Create new view controller as subclass of class UICollectionViewController and name it ImagesViewController.
Create another class but as subclass of type UICollectionViewCell, which will actually represent the view for cell in collection view. Name it ImageViewCell. In it, create a property `@property (nonatomic, strong) UIImageView *imageView`, which will be used to display the image thumbnail later.

In `MainStoryBoard-iPhone.storyboard` bring up Collection View Controller from the object library. In Identity Inspector for this controller set its class to ImagesViewController.
For the cell in Identity Inspector set its class to ImagesViewCell and in Attribute Inspector set its identifier to AssetCell. This attribute will be used for reusing the same cell in representing cells in collection view.

While in storyboard, click on cell from the AlbumViewController and then with ctrl pressed drag to ImagesViewController and create a push segue called "ShowAssets". 

Repeat the procedure for the iPad version in `MainStoryBoard-iPad.storyboard`.

In ImagesViewController.h add the following lines:

```objective-c
	//right after the imports add
	@class GCAlbum;

	//add delegate methods that we're going to be need, in the interface declaration.
	@interface ImagesViewController : UICollectionViewController <UIImagePickerControllerDelegate>

	//and the following properties
	@property (strong, nonatomic) NSMutableArray *assets; // A MuttableArray which holds assets for a certain album.
	@property (strong, nonatomic) GCAlbum *album; // GCAlbum used to get the assets for it.
	@property (strong, nonatomic) UIPopoverController *popOver; // A popover control used to represent image picker on iPad version.
```

In ImagesViewController.m add `#import <Chute-SDK/GetChute.h>` to be able to use the methods provided by Chute library. Also add `#import <AFNetworking/UIImageView+AFNetworking.h` because we will need it when setting the thumbnail in the cell. And after all that add this properties:
	* `@property(nonatomic) BOOL isManagingAssetsEnabled;` - Property of type BOOL which will indicate if the user want to manage representing assets or not. By managing we mean selecting and removing them.
	* `@property (strong, nonatomic) NSMutableArray *selectedAssets;` - Array containing selected albums that we want to delete.
	* `@property (strong, nonatomic) UIBarButtonItem *manageButton;` - Button of UIBarButtonItem type which is representing a button with multiple functions: Managing, which enables the multi selection of assets and cancel, to cancel the selection of assets. 
	* `@property (strong, nonatomic) UIBarButtonItem *deleteButton;` - Button of UIBarButtonItem type which is visible only when managing is enabled.

The `viewDidLoad` method is the same, with only change in this line:
`self.selectedAssets = [@[] mutableCopy];` instead of `self.selectedAlbums = [@[] mutableCopy];`
Note: Method `[self setToolbarWithItems]` stays exactly the same, and in `[self setNavBarWithItems]` there are some changes, which will be presented with a code snippet.

In our `viewDidAppear` method we just get the assets that we are going to display. So in `viewDidAppear` call this method: `[self getAssets];`. We will define it in a moment.

####Custom Methods

In this section we will define all the private methods that we use in this controller. The defining will go as some methods are mentioned, just to keep the picture.

First the one that we have already mentioned it. The `getAssets` method. In this method we call a GCAlbum method which has a success and failure blocks. On success it returns an array of assets of type GCAsset which we use to set our array assets, on failure it presents an alert:

```Objective-C
	- (void)getAssets {
		[self.album getAllAssetsWithSuccess:^(GCResponseStatus *responseStatus, NSArray *_assets, GCPagination *pagination) {
			self.assets = [[NSMutableArray alloc] initWithArray:_assets];
			[self.collectionView reloadData];
		} failure:^(NSError *error) {
			[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot fetch assets!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
		}];
	}
```

Next is `manageAssets`. This method has same logic as in AlbumViewController. The only differences are the name of the properties for the corresponding controller. 
e.g. Instead `self.isManagingAlbums` you use `self.isManagingAssets` and so on. You got the picture.

Next on the list is `deleteSelectedAssets`. We call GCAlbum method which takes an array of assets that are supposed to be deleted.

```Objective-C
	- (void)deleteSelectedAssets {
		[self.album removeAssets:self.selectedAssets success:^(GCResponseStatus *responseStatus) {
			[self getAssets];
			[self manageAssets];
		} failure:^(NSError *error) {
			[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot delete assets!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
		}];
	}
```

As noted before method `setToolbarWithItems` stays the same, and `setNavBarWithItems` should look something like this:

```Objective-C
	- (void)setNavBarWithItems {
		self.manageButton = [[UIBarButtonItem alloc] initWithTitle:@"Manage" style:UIBarButtonItemStyleBordered target:self action:@selector(manageAssets)];
		UIBarButtonItem *addAssetsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAsset:)];
		NSArray *navBarItems = [NSArray arrayWithObjects:addAssetsButton,self.manageButton, nil];
	
		self.navigationItem.rightBarButtonItems = navBarItems;
	}
```

There is only one IBAction in this controller and it's used to present an UIImagePickerController. This is where we will use the popOver that we defined earlier.

```Objective-C
	- (IBAction)addAsset:(id)sender {
		UIImagePickerController *picker = [UIImagePickerController new];
		[picker setDelegate:self];
	
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
			if (![[self popOver] isPopoverVisible]) {
				UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
				[popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
				self.popOver = popover;
			}
			else
				[[self popOver] dismissPopoverAnimated:NO];
		}
		else
			[self presentViewController:picker animated:YES completion:nil];
	}
```
Note that you will need to implement the delegate methods for the image picker. Well, in `didFinishPickingMediaWithInfo` we will make an upload request in current album using the one step uploader method. On success we call again `getAssets` method, on failure we present alert view.

```Objective-C
	- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
		if (self.popOver)
			[self.popOver dismissPopoverAnimated:YES];
		else
			[self dismissViewControllerAnimated:YES completion:nil];
	
		GCUploader *uploader = [GCUploader sharedUploader];
		[uploader uploadImages:@[[info objectForKey:UIImagePickerControllerOriginalImage]] inAlbumWithID:self.album.id progress:^(CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads) {
			 NSLog(@"Progress: %f", currentUploadProgress);
		} success:^(NSArray *assets) {
			[self getAssets];
		} failure:^(NSError *error) {
			[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Unable to upload images.Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
		}];
	}
	
	- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    	[self dismissViewControllerAnimated:YES completion:nil];
	}
```

####Setting the Collection View

As we have already set `assets` we know the number of cells that we are going to be need, just as in AlbumViewController in `collectionView:numberOfItemsInSection:` we return `return [assets count];`

The `collectionView:cellForItemAtIndexPath:` is basically the same with the one in AlbumViewController, but with logic from this controller:

```Objective-C
	- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
		ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell" forIndexPath:indexPath];
		cell.backgroundColor = [UIColor whiteColor];
		GCAsset *asset = (GCAsset *)assets[indexPath.item];
		[cell.imageView setImageWithURL:[NSURL URLWithString:asset.thumbnail]];
	
		if (cell.selected)
			cell.backgroundColor = [UIColor blueColor]; // highlight selection
		else
			cell.backgroundColor = [UIColor whiteColor]; // Default color
	
		return cell;
	}
```

The purpose of delegate methods for the collection view, `didSelectItemAtIndexPath` and `didDeselectItemAtIndexPath` is the same as in AlbumViewController:

```Objective-C
	- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath	{
		if(self.isManagingAssetsEnabled) {
			ImageViewCell *cell = (ImageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
			cell.backgroundColor = [UIColor blueColor];
			GCAsset *asset = [self.assets objectAtIndex:indexPath.row];
			[self.selectedAssets addObject:asset];
			if([self.selectedAssets count]>0)
				[self.deleteButton setEnabled:YES];
		}
	}

	- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
			ImageViewCell *cell = (ImageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
			cell.backgroundColor = [UIColor whiteColor];
			GCAsset *asset = [self.assets objectAtIndex:indexPath.row];
			[self.selectedAssets removeObject:asset];
			if([self.selectedAssets count] == 0)
				[self.deleteButton setEnabled:NO];
	}
```

####Performing the segue

Although `prepareForSegue` method will have forward declaration of the following view controller (ImageDetailsViewController), don't worry, we'll get there in a moment.
So don't forget to add `#import "ImageDetailsViewController"`, although it doesn't exist at the moment.

```Objective-C
	- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
		if ([segue.identifier isEqualToString:@"PushAssetDetails"]) {
		
			ImageDetailsViewController *vc;
		
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
				vc = [[segue.destinationViewController viewControllers] objectAtIndex:0];
			else
				vc = segue.destinationViewController;
			NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
			GCAsset *asset = [assets objectAtIndex:indexPath.item];
			[vc setAsset:asset];
			[vc setAlbum:self.album];
			[self.collectionView deselectItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] objectAtIndex:0] animated:YES];
		}
	}
	
	- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
		if(self.isManagingAssetsEnabled)
			return NO;
		else
			return YES;
	}
```

The `shouldPerformSegueWithIdentifier` method must be defined because on contrary when user clicks on asset it will perform the segue, although the user wants to manage the assets.

##ImageDetailsViewController  
  
This is the last controller we will make in this tutorial. In this controller we will show the asset in full resolution, we will be able to heart, vote, flag and comment on an asset and show their count. We will also present the comments for the asset.

So, create new controller as subclass of class UIViewController and name it ImageDetailsViewController.  
Create another class as subclass of type UITableViewCell, which will represent the view for cell in comments table. Name it CommentCell. In it, create a property `@property (nonatomic, strong) UILabel *commentLabel;` which will display the comment text.

####Setting the StoryBoard

In `MainStoryBoard-iPhone.storyboard` bring up View Controller from the object library. In Identity Inspector for this controller set its class to ImageDetailController.  
There are a couple of steps you need to do to setup the storyboard:  
    * Take an Scroll View from the object library and place it inside the controllers's view.  
	* Take an Image View from the object library and place it in the Scroll View and align it in the top corners. Set it's height as you like.  
	* Take a View from the object library and place it below the Image View. Set it's height around 44pix. Inside place three buttons and three labels. Set their dimensions to fit them all inside the view. For the first button set Background with "unheart.png", for the second "unvote.png" and for the third "unflag.png", images that are located in Resources directory which you've already downloaded and inserted into the project. Labels text should be empty because they will be used to represent the count of each button.  
	* Take a Table View from the object library and place it below the View. Align it with side and bottom of its superview. Select the cell and in Identity Inspector set its class to CommentCell. In Attribute Inspector set its identifier to commentCell. 
	* There is just one specific thing. The height of the table should be dynamic, as one asset can have from none to a lot of comments. What you need to do here is select the Table View, go to the Pin section, and select "Height". That will create a constraint for the height. Find that constraint in the Size Inspector for table view, and select "Select and Edit". It will open a section where you can change the attributes for that constraint. Change the relation to "Greater Than or Equal" and for priority set 750. Like this you can change the height of the table.  

For each of the objects pulled out from the object library create an IBOutlet. For buttons create, also, an IBActions.  
You create outlets and actions by selecting the object and then with ctrl you drag into your .h file.

While in storyboard click on cell from the ImagesViewController and then with ctrl pressed, drag to ImageDetailViewController and create a push segue called "PushAssetsDetails".

The procedure is almost the same for the iPad version, in `MainStoryBoard-iPad.storyboard`, with only difference in segue style. Here it should be Modal, with presentation style - Form Sheet and transition style - Flip Horizontal. Of course, you can set it whatever you like.

#### Setting properties and basic controller methods

In ImageDetailViewController.h add the following lines:

```objective-C
	//right after the imports add 
	@class GCAsset;
	@class GCAlbum;
	
	//add delegate methods that we are going to be need, in the interface declaration.
	@interface ImageDetailsViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
	
	//add this properties
	@property (strong, nonatomic) GCAlbum *album; // GCAlbum needed for all API methods for selected asset
	@property (strong, nonatomic) GCAsset *asset; // The asset that should be presented and interacted with.
	@property (strong, nonatomic) NSMutableArray *comments; // MutableArray used to store the comments for the asset.
	
	//below are listed all the IBOutlets and IBActions that should be created. Add some if you've forgotten to create.
	@property (strong, nonatomic) IBOutlet UIImageView *imageView;
	@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
	@property (strong, nonatomic) IBOutlet UIView *socialView;

	@property (strong, nonatomic) IBOutlet UIButton *heartButton;
	@property (strong, nonatomic) IBOutlet UIButton *voteButton;
	@property (strong, nonatomic) IBOutlet UIButton *flagButton;

	@property (strong, nonatomic) IBOutlet UILabel *heartsLabel;
	@property (strong, nonatomic) IBOutlet UILabel *votesLabel;
	@property (strong, nonatomic) IBOutlet UILabel *flagLabel;

	@property (strong, nonatomic) IBOutlet UITableView *commentsTable;
	@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint; // This outlet is defined from the specific height constraint that we discussed earlier.

	- (IBAction)heartUnheart:(UIButton *)sender;
	- (IBAction)voteUnvote:(UIButton *)sender;
	- (IBAction)flagUnflag:(UIButton *)sender;
```

In ImageDetailsViewController.m add `#import <Chute-SDK/GetChute.h>` to be able to use the methods provided by Chute library.  
Also add `#import <AFNetworking/AFImageRequestOperation.h>` because we will need to send an request to get the image from an url. Then add the following lines just under `@interface ImageDetailsViewController ()`:

```objective-c
	@property (nonatomic, strong) UITextField *commentTextField;
	@property (nonatomic, strong) NSArray *toolbarItemsToBeAdd;
	@property (nonatomic) BOOL isItHearted;
	@property (nonatomic) BOOL isItVoted;
	@property (nonatomic) BOOL isItFlagged;
```

In next methods there is forward declaration of some custom methods, but don't worry, we'll be there in no time. First to cover the basic ones.  
The `viewDidLoad` should look like:

```objective-c
	- (void)viewDidLoad	{
		[super viewDidLoad];
		[self.navigationController setToolbarHidden:NO];
		[self setToolbarWithItems];
	
		[self updateFlagLabelCount];
		[self updateHeartLabelCount];
		[self updateVoteLabelCount];
	
		[self populateComments];
	}
```

In `viewDidAppear` we will take the original full resolution image from the asset. That look something like this:

```Objective-C
	- (void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
	
		AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.asset url]]] success:^(UIImage *image) {
			[self.imageView setImage:image];
		}];
		[operation start];
	
		[self adjustHeightOfTableview];
		[self setScrollViewContentSize];
	}
```

Then there is `viewWillAppear` in which we set default image for image view and we are registering two observers for keyboard.

```objective-c
	- (void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	
		[self setTitle:[self.asset caption]];
		[self.imageView setImage:[UIImage imageNamed:@"chute.png"]];
	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

	}
```

And the last two, `viewDidLayoutSubviews`, to layout all the objects when the screen is rotated and `viewWillDisappear` to hide the toolbar.

```objective-c
	-(void)viewDidLayoutSubviews {
		[super viewDidLayoutSubviews];
		[self setToolbarWithItems];
	}
	
	-(void)viewWillDisappear:(BOOL)animated	{
		[self.navigationController setToolbarHidden:YES];
	}
```

####Custom Methods

In this section we will define all the private methods that we use in this controller. The defining will go as some methods are mentioned, just to keep the picture. We'll start with the ones already mentioned.

The `setToolbarWithItems` method. In this method we will create a toolbar with text field and a button, which we will use for commenting on a asset. So:

```objective-c
	-(void)setToolbarWithItems {
		if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
			if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft)
				commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 400, 25)];
			else
				commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 235, 30)];
		else
			commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 450, 30)];
		commentTextField.borderStyle = UITextBorderStyleRoundedRect;
		commentTextField.font = [UIFont systemFontOfSize:15];
		commentTextField.placeholder = @"Write your comment..";
		commentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		commentTextField.keyboardType = UIKeyboardTypeDefault;
		commentTextField.returnKeyType = UIReturnKeyDone;
		commentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
		commentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		commentTextField.delegate = self;

		UIBarButtonItem *commentField = [[UIBarButtonItem alloc] initWithCustomView:commentTextField];
		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(postComment)];
		toolbarItemsToBeAdd = [NSArray arrayWithObjects:flexibleSpace,commentField,flexibleSpace,postButton,flexibleSpace, nil];
	
		self.toolbarItems = toolbarItemsToBeAdd;
	}
```

The `updateHeartLabelCount`, `updateFlagLabelCount`, `updateVoteLabelCount` methods are basically the same, the only difference is the name of the GCAsset method that they call. So we'll present only one:

```objective-c
	-(void)updateHeartLabelCount {
		[self.asset getHeartCountForAssetInAlbumWithID:self.album.id success:^(GCResponseStatus *responseStatus, GCHeartCount *heartCount) {
			self.heartsLabel.text = [heartCount.count stringValue];
		} failure:^(NSError *error) {
			NSLog(@"Failed to obtain heart count!");
		}];
	}
```

The `adjustHeightOfTableView` method sets the constraint that we've defined before. It's needed because we want the whole table to be shown. But for that to be possible we also need to set the content size of the scroll view.

```Objective-c
	- (void)adjustHeightOfTableview {
		CGFloat height =self.commentsTable.contentSize.height;
		self.tableViewHeightConstraint.constant = height;
		[self.commentsTable needsUpdateConstraints];
	}

	-(void)setScrollViewContentSize	{
   		CGFloat scrollViewContentSize = 0.0f;
	
		if([self.comments count] >0)
			scrollViewContentSize = self.imageView.frame.size.height+self.socialView.frame.size.height+self.commentsTable.contentSize.height;
		else
			scrollViewContentSize = self.imageView.frame.size.height+self.socialView.frame.size.height;
   
		[self.scrollView setContentSize:(CGSizeMake(self.scrollView.frame.size.width, scrollViewContentSize))];
	}

```

The `populateComments` is a method that sets the mutable array comments that we've already defined. By the way it reloads and sets table height and scroll view content size.

```objective-c
	-(void)populateComments	{
		[self.asset getCommentsForAssetInAlbumWithID:self.album.id success:^(GCResponseStatus *responseStatus, NSArray *comments, GCPagination *pagination) {
			[self setComments:[NSMutableArray arrayWithArray:comments]];
			[self.commentsTable reloadData];
			[self adjustHeightOfTableview];
			[self setScrollViewContentSize];
		} failure:^(NSError *error) {
			[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Comments can't be retrieved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
		}];
	}
```

The `postComment` is a custom method that is add as a action to the "Post" button on the toolbar. It sends a request to attach this comment to the presented asset and then it show in the comments table. It also sets the toolbar properties to the default.

```objective-c
	-(void)postComment	{
		[self.asset createComment:commentTextField.text forAlbumWithID:self.album.id fromUserWithName:@"Me" andEmail:@"mine-email@someemail.com" success:^(GCResponseStatus *responseStatus, GCComment *comment) {
			[self.comments addObject:comment];
			[commentTextField resignFirstResponder];
			[commentTextField setText:@""];
			[commentTextField setPlaceholder:@"Write your comment..."];
			[self populateComments];
		} failure:^(NSError *error) {
			[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Comment text can't be blank." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
		}];
	}
```

The following two methods are actually a notification methods, but they are also custom methods so we will put them in this section.  
This methods work is to move the toolbar along with the showing/hiding keyboard. In them, based if iPhone or iPad, we do some simple math, to get it right. It's a little hackie but that's the only way.

```objective-c
	- (void)keyboardWillShow:(NSNotification *)notification	{
		[self.navigationController.toolbar setItems:toolbarItemsToBeAdd animated:YES];
		/* Move the toolbar to above the keyboard */
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		CGRect frame = self.navigationController.toolbar.frame;
		if([[UIDevice currentDevice] orientation] != UIInterfaceOrientationLandscapeLeft && [[UIDevice currentDevice] orientation] != UIInterfaceOrientationLandscapeRight)	{
			if(UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPhone)
				frame.origin.y = self.view.frame.size.height - 150.0;
			else
				frame.origin.y = self.view.frame.size.height - 27.0;
		}
		else {
			if(UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPhone)
				frame.origin.y = self.view.frame.size.height - 110.0;
			else
				frame.origin.y = self.view.frame.size.height - 180.0;
		}
		self.navigationController.toolbar.frame = frame;
		[UIView commitAnimations];
	}

	- (void)keyboardWillHide:(NSNotification *)notification	{
		[self.navigationController.toolbar setItems:toolbarItemsToBeAdd animated:YES];
		/* Move the toolbar back to bottom of the screen */
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		CGRect frame = self.navigationController.toolbar.frame;
		if([[UIDevice currentDevice] orientation] != UIInterfaceOrientationLandscapeLeft && [[UIDevice currentDevice] orientation] != UIInterfaceOrientationLandscapeRight)	{
			if(UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPhone)
				frame.origin.y = self.view.frame.size.height+62.0;
			else
				frame.origin.y = self.view.frame.size.height+45.0;
		}
		else {
			if(UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPhone)
				frame.origin.y = self.view.frame.size.height+50.0;
			else
				frame.origin.y = self.view.frame.size.height+45.0;
		}
		self.navigationController.toolbar.frame = frame;
		[UIView commitAnimations];
	}

```

In combination with these notifications comes this UITextField delegate method, which actually dismiss the keyboard:

```objective-c
	-(BOOL)textFieldShouldReturn:(UITextField *)textField {
		[textField resignFirstResponder];
		return YES;
	}
``` 

####Setting the Table View

As we already have obtained the comments we know their number and we can set the number of rows in a section.

```objective-c
	-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section	{
		return [self.comments count];
	}
``` 
And the data:

```objective-c
	-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
		static NSString *cellIdentifier = @"commentCell";
	
		CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
		if (cell == nil){
			cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		}
		GCComment *comment = [self.comments objectAtIndex:indexPath.row];
		cell.commentLabel.text = [comment commentText];
		return cell;	
	}
```
So far we have the table set it with the comments, but what if some comment is too long to be shown in that tiny cell? That's way you need to set the following table view delegate method:

```objective-c
	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath	{
		GCComment *comment = [self.comments objectAtIndex:indexPath.row];
		int heightForRow;
		if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
			 heightForRow = [comment.commentText sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize: CGSizeMake(500, CGFLOAT_MAX) lineBreakMode: NSLineBreakByWordWrapping].height;
		else
			heightForRow = [comment.commentText sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize: CGSizeMake(280, CGFLOAT_MAX) lineBreakMode: NSLineBreakByWordWrapping].height;
		return heightForRow + 21;
	}
```
What we do here is a simple approximation, where the main thing specified, is how big is actually the label in that cell and based on its font we find the needed height. The last addition of +21 are just the margins of the label according to the cell.

If some comment is inappropriate or you've post it by mistake, there must be a way to delete it, so you need to define the following delegate methods:

```Objective-c
	-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
		return YES;
	}

	-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		if (editingStyle == UITableViewCellEditingStyleDelete)	{
			GCComment *comment = [self.comments objectAtIndex:indexPath.row];
			[comment deleteCommentWithSuccess:^(GCResponseStatus *responseStatus, GCComment *comment) {
				[self populateComments];
				[self adjustHeightOfTableview];
				[self setScrollViewContentSize];
			} failure:^(NSError *error) {
				[[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Unable to delete comment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
			}];
		}
	}
```

##Conclusion

