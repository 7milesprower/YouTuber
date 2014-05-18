//
//  YTDownloadsViewController.m
//  YouTuber
//
//  Created by Majd Alfhaily on 5/16/14.
//
//

#import "YTDownloadsViewController.h"

@interface YTDownloadsViewController ()

@end

@implementation YTDownloadsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    baseOfDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    baseOfYouTube = ([baseOfDirectories count] > 0) ? [baseOfDirectories objectAtIndex:0] : nil;
    filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[baseOfYouTube stringByAppendingPathComponent:@"YouTuber"] error:nil];
    [self setTitle:@"Downloads"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = filesArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	NSString *newPath = [[baseOfYouTube stringByAppendingPathComponent:@"YouTuber"] stringByAppendingPathComponent:filesArray[indexPath.row]];
    
	BOOL fileExists = [[NSFileManager defaultManager ] fileExistsAtPath:newPath isDirectory:nil];
    
	if (fileExists)
	{
        QLPreviewController *preview = [[QLPreviewController alloc] init];
        preview.dataSource = self;
        UINavigationController *previewController = [[UINavigationController alloc] initWithRootViewController:preview];
        previewController.modalPresentationStyle = UIModalPresentationFormSheet;
        preview.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModalViewControllerAnimated:)];
        [self presentModalViewController:previewController animated:YES];
	}
}

#pragma mark - QuickLook

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item {
    return YES;
}

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller {
    
    return 1;
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index {
    
	NSString *newPath = [[baseOfYouTube stringByAppendingPathComponent:@"YouTuber"] stringByAppendingPathComponent:filesArray[self.tableView.indexPathForSelectedRow.row]];
    
    return [NSURL fileURLWithPath:newPath];
}

@end
