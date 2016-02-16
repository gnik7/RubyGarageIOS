//
//  SearchViewController.m
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 09.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "SearchViewController.h"
#import "NGServerManager.h"
#import "NGCategory.h"
#import "NGProductsCollection.h"
#import "NGProgress.h"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *categoryPickerView;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *productSearch;



@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *categoryNameArray;

@property (assign, nonatomic) NSInteger categoryId;
@property (strong, nonatomic) NSString *categorySearch;

@property (strong, nonatomic) NGProgress *progress;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.progress = [[NGProgress alloc] init];
    
    self.categoryArray = [NSMutableArray array];
    self.categoryNameArray = [NSMutableArray array];
    
    self.categoryPickerView.dataSource = self;
    self.categoryPickerView.delegate = self;
    self.productSearch.delegate = self;
    
    self.categoryPickerView.showsSelectionIndicator = false;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    
    if ([NGServerManager isConnectedToNetwork]) {
        [self.progress createProgressHUD];
        [self getCategory];
    } else {
        [NGServerManager alertMessage:@"No internet connection or service ton avalible"];
    }
    
}



#pragma mark - Action

- (IBAction)submitAction:(UIButton *)sender {
    
    if (self.productSearch.text.length > 0 && ![self.productSearch.text isEqualToString:@"Search Product"]) {
        [self moveToCollection];
    } else {
        [NGServerManager alertMessage:@"Enter word for search"];
    }
    
}

- (void) moveToCollection {
    NGProductsCollection *controler = [self.storyboard instantiateViewControllerWithIdentifier:@"NGProductsCollection"];
    
    NGCategory *category = [[NGCategory alloc] init];
    category.category_id = [NSNumber numberWithInteger:self.categoryId];
    category.category_name = self.categorySearch;
    category.long_name = self.categoryTitleLabel.text;
    controler.searchProducts = self.productSearch.text;
    controler.category = category;
    
    [controler setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:controler animated:YES completion:nil];
}


#pragma mark - API

- (void) getCategory {
    [[NGServerManager sharedManager] getCategoriesOnSuccess:^(NSArray *category) {
        
        [self.categoryArray addObjectsFromArray:category];
        
        for (NGCategory *cat in category) {
            [self.categoryNameArray addObject:cat.long_name];
        }
        [self.categoryPickerView reloadAllComponents];
        [self.progress hideProgressHUD];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        [self.progress hideProgressHUD];
        NSLog(@"error = %@, code = %lu",[error localizedDescription], statusCode);
    }];
}


#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.categoryArray count];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.categoryNameArray[row] ;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@" %ld", (long)row);
    NGCategory *category = [self.categoryArray objectAtIndex:row];
    self.categoryTitleLabel.text =category.long_name;
    
    self.categoryId = [category.category_id integerValue];
    self.categorySearch = category.category_name;
}


#pragma mark - UISearchBarDelegate  

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.productSearch.text = @"";
    
    return  true;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.productSearch setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.productSearch resignFirstResponder];
    [self.productSearch setShowsCancelButton:YES animated:YES];
    self.productSearch.text = @"Search Product";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@", searchText);
   
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.productSearch resignFirstResponder];
    
    if (self.productSearch.text.length > 0) {
        [self moveToCollection];
    } else {
        [NGServerManager alertMessage:@"Enter word for search"];
    }
}

-(void)dismissKeyboard {
    [self.productSearch resignFirstResponder];
}

@end
