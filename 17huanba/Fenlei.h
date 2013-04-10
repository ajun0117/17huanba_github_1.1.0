//
//  Fenlei.h
//  17huanba
//
//  Created by Chen Hao on 13-1-25.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Fenlei : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *fenleiArray;
}

@property(retain,nonatomic)UITableView *fenleiTableView;
@property(retain,nonatomic)UISearchBar *mySearchBar;
@property(retain,nonatomic)UISearchDisplayController *searchDis;
@property(retain,nonatomic) NSMutableArray *fenleiArray;

@end
