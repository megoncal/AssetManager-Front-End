//
//  InventoryManagementFirstViewController.m
//  InventoryManagement
//
//  Created by Marcos Vilela on 06/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "InventoryManagementFirstViewController.h"

@interface InventoryManagementFirstViewController ()

@end

@implementation InventoryManagementFirstViewController

@synthesize inventoryListArray = _inventoryListArray;
@synthesize tableView = _tableView;


- (void) loadView{
    [super loadView];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


- (NSMutableArray*)inventoryListArray
{
 
    if(_inventoryListArray==nil) {
        
        //getting data from the plist file
        /*
        _inventoryListArray = [[NSMutableArray alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"asset.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]){
            NSMutableArray *inventoryListDataArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
            for (id object in inventoryListDataArray) {
                InventoryData *assetData = [NSKeyedUnarchiver unarchiveObjectWithData:object];
                [_inventoryListArray addObject:assetData];
            }
        }
        else{
            _inventoryListArray = [[NSMutableArray alloc] init];
        }
         */
        
        
        //getting data from parse.com
        
        self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:self.HUD];
        
        self.HUD.delegate = self;
        self.HUD.labelText = @"Loading";
        self.HUD.detailsLabelText = @"assets from server";
        self.HUD.square = YES;
       
        [self.HUD show:YES];
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
        
        _inventoryListArray = [[NSMutableArray alloc]init];
        PFQuery *query = [PFQuery queryWithClassName:@"Asset"];
        [query whereKey:@"objectId" notEqualTo:@""];
        NSError *error;
        NSArray *returnedAssets = [query findObjects:&error];
        if (!error) {
            for (id object in returnedAssets){
                AssetData *inventoryData = [[AssetData alloc] init];
                [inventoryData createInventoryDataWithParserObject:(PFObject *)object];
                [_inventoryListArray addObject:inventoryData];
            }
            [self.HUD hide:YES];
        }else{
            NSString *errorString;
            errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [self.HUD hide:YES];
            [self performSegueWithIdentifier:@"logInApplication" sender:self];
        }
        
                     
        
    }
    return _inventoryListArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(enteredBackground)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
}

- (void) viewDidAppear:(BOOL)animated{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if([InternetConnection reachable]){
            
            [self synchWaitingListObjects];
            
        }
    });

}

- (void) synchWaitingListObjects {
    for (id object in self.inventoryListArray) {
        AssetData *asset = (AssetData*)object;
        if (![asset assetDataSynced]) {
            [asset synchronizeAssetWithServer];
        }
    }
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [self.searchResults count];
    }else{
       return [self.inventoryListArray count]; 
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *inventoryTableIdentifier = @"InventoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inventoryTableIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inventoryTableIdentifier];
    }
    
    
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        AssetData *invData = (AssetData*)[self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = invData.shortDescription;
        if ([invData assetDataSynced]) {
            cell.detailTextLabel.text = @"Synced";
        }
        else{
            cell.detailTextLabel.text = @"Not Synced";
        }
        //cell.detailTextLabel.text = invData.manufacturer;
    }else{
        AssetData *invData = (AssetData*)[self.inventoryListArray objectAtIndex:indexPath.row];
        cell.textLabel.text = invData.shortDescription;
        if ([invData assetDataSynced]) {
            cell.detailTextLabel.text = @"Synced";
        }
        else{
            cell.detailTextLabel.text = @"Not Synced";
        }
        //cell.detailTextLabel.text = invData.manufacturer;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        [self performSegueWithIdentifier:@"showDetailedInventory" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    if([segue.identifier isEqualToString:@"showDetailedInventory"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        InventoryManagementThirdViewController *destViewController = segue.destinationViewController;
        
       if([self.searchDisplayController isActive]){
            destViewController.inventoryData = [self.searchResults objectAtIndex:indexPath.row];
        }else{
            destViewController.inventoryData = [self.inventoryListArray objectAtIndex:indexPath.row];
        }
        
        destViewController.sender = sender;
        destViewController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"addNewItem"]){
        InventoryManagementThirdViewController *destViewControler = segue.destinationViewController;
        destViewControler.sender = sender;
        destViewControler.inventoryListArray = self.inventoryListArray;
        destViewControler.delegate = self;
        
    }else if([segue.identifier isEqualToString:@"logInApplication"]){
        [PFUser logOut];
        PFUser *currentUser;
        currentUser = [PFUser currentUser]; // this will now be nil
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetailedInventory" sender:self];
}

- (void) enteredBackground{
    
    NSMutableArray *inventoryListArrayData = [[NSMutableArray alloc] init];
    
    for (id object in self.inventoryListArray){
        NSData *encodedAsset = [NSKeyedArchiver archivedDataWithRootObject:object];
        [inventoryListArrayData addObject:encodedAsset];
    }
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"asset.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"asset" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    [inventoryListArrayData writeToFile:path atomically:YES];
    
}

- (void)filterContentForSearchText: (NSString*)searchText scope:(NSString*) scope{
    
    self.searchResults = [[NSMutableArray alloc] init];
    
    for(id object in self.inventoryListArray){
        AssetData *data =  object;
        NSString *shortDescriptionUpperCase = [data.shortDescription uppercaseString];
        NSString *searhTextUpperCase = [searchText uppercaseString];
        if([shortDescriptionUpperCase rangeOfString:searhTextUpperCase].location != NSNotFound){
            [self.searchResults addObject:object];
        }
    }
    
}

- (BOOL) searchDisplayController: (UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
    
}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
    if(editing){
        self.addButton.enabled = NO;
    }else{
        self.addButton.enabled = YES;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        AssetData *invData = [self.inventoryListArray objectAtIndex:indexPath.row];
        
        NSString *imagePath = invData.picture.imagePath;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            [fileManager removeItemAtPath:imagePath error:NULL];
            
        });

        [self.inventoryListArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        //Delete drom Parse
        
        [invData.pfObject deleteEventually];
        
        
    }
}

- (void) inventoryManagementThirdViewControllerHasDone:(InventoryManagementThirdViewController *)viewController{
    [self.navigationController popViewControllerAnimated:YES];
}

    
    
   
@end
