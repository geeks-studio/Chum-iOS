//
//  CHMRulesVC.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 15/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMRulesCell.h"
#import "CHMRulesVC.h"
#import "UIColor+CHMProjectsColor.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "CHMNotificationCenter.h"

NSString *const CHMRulesShowedKey = @"CHMRulesShowedKey";

@interface CHMRulesVC ()

@property (strong, nonatomic) NSArray *rulesArr;

@end

@implementation CHMRulesVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //    1. @"Пишите посты, находите новых друзей, отрывайтесь "
    //       @";) " 2. @"Помогайте окружающим и не стесняйтесь просить у них поддержки, ведь никто
    //       не "
    //                  @"узнает, что это вы." 3.
    //        @"Все мамы, папы и другие родственники других людей – хорошие, не стоит "
    //        @"играть." 4.
    //        @"Поделись улыбкою своей, и она не раз к тебе ещё "
    //        @"вернётся!" 5.
    //        @"Не давайте личные контакты первым встречным." 6.
    //        @"Не флудите и не распространяйте рекламу." 7.
    //        @"Чистите зубы с утра и перед сном!"

    

    self.rulesArr = @[
        @"Пишите посты, находите новых друзей, "
        @"отрывайтесь "
        @";) ",
        @"Помогайте окружающим и не стесняйтесь просить у них поддержки, ведь никто "
        @"не "
        @"узнает, "
        @"что это вы.",
        @"Все мамы, папы и другие родственники других людей – хорошие, "
        @"не "
        @"стоит "
        @"играть.",
        @"Поделись улыбкою своей, и она не раз к тебе ещё "
        @"вернётся!",
        @"Не давайте личные контакты первым встречным.",
        @"Не флудите и не распространяйте рекламу.",
        @"Чистите зубы с утра и перед сном!"
    ];

    self.tableView.backgroundColor = [UIColor lightBackgroundColor];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

//    UIButton *b = [self addRightButtonWithName:@"confirmIcon"];
//
//    [b addTarget:self action:@selector(dismisVC) forControlEvents:UIControlEventTouchUpInside];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CHMRulesShowedKey];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view
    // controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    

    [self.tableView registerNib:[CHMRulesCell nib]
         forCellReuseIdentifier:[CHMRulesCell identifier]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
//    UIFont *font = [UIFont fontWithName:@"Futura-Medium" size:26.];//UIFont(name: "Futura-Medium", size: 26.0)
//    CGRect r =  CGRectMake(0, 0, 100, 44);//CGRect(x: 0, y: 0, width: 200, height: 44)
//    UILabel *label = [[UILabel alloc] initWithFrame:r];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.font = font;
//    [label sizeToFit];
    //    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rulesIcon"]];
//    
//    self.navigationItem.titleView = label;
    
    self.title = @"Правила";
    
    [CHMNotificationCenter shared].canShow = NO;

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    self.tableView.contentSize =
    CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height);
    
    self.tableView.showsHorizontalScrollIndicator = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [CHMNotificationCenter shared].canShow = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rulesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMRulesCell *cell = [tableView dequeueReusableCellWithIdentifier:[CHMRulesCell identifier]
                                                         forIndexPath:indexPath];

    NSString *text = self.rulesArr[indexPath.row];

    [cell configureWithText:text number:indexPath.row + 1];
    // Configure the cell...

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath
*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new
row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
