//
//  MapSelectionCollectionViewController.m
//  OkParcalari
//
//  Created by Yunus Eren Guzel on 12/25/12.
//
//

#import "MapSelectionCollectionViewController.h"

@interface MapSelectionCollectionViewController ()

@end



@implementation MapSelectionCollectionViewController

- (id)init
{
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(150, 150)];
        [flowLayout setMinimumInteritemSpacing:4];
        [flowLayout setMinimumLineSpacing:4];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0) collectionViewLayout:flowLayout];
        [collectionView setBackgroundColor:[UIColor redColor]];
        [collectionView setDelegate: self];
        [self setCollectionView:collectionView];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MapCell"];
        [self.collectionView setFrame:CGRectMake(self.collectionView.frame.origin.x+35, self.collectionView.frame.origin.y+200, self.collectionView.frame.size.width-70.0, self.collectionView.frame.size.height-300	)];
        NSLog(@"%f,%f,%f,%f",self.collectionView.frame.origin.x,self.collectionView.frame.origin.y,self.collectionView.frame.size.width,self.collectionView.frame.size.height);
        [self.collectionView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MapCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UICollectionViewCell alloc] init];
    }
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
//    [label setBackgroundColor:[UIColor blackColor]];
    [label setText:@"deneme label"];
    [cell addSubview:label];
    
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
