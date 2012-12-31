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
{
    NSArray* maps;
    NSArray* completedMaps;	
}
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

        maps = [ArrowGameMap loadMapsFromFile:@"haydn"];

        
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 700.0, 1024.0, 68.0)];
        [myView setBackgroundColor:[UIColor blueColor]];
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [myButton addTarget:self
                     action:@selector(openStore)
         forControlEvents:UIControlEventTouchUpInside];
        [myButton setFrame:CGRectMake(800.0, 12.0, 200.0, 44.0)];
        [myButton setTitle:@"Game Unlock" forState:UIControlStateNormal];
        [myButton setTitle:@"highligted" forState:UIControlStateHighlighted];
        [myView addSubview:myButton];
        [self.view addSubview:myView];
        
    }
    return self;
}
-(void)openStore{
    NSLog(@"store will open here");
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
    return [maps count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MapCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UICollectionViewCell alloc] init];
    }
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    
    [label setText:[maps objectAtIndex:indexPath.row]];
    [cell addSubview:label];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ArrowGameLayer sceneWithFile:[NSString stringWithFormat:@"haydn/%@",[maps objectAtIndex:indexPath.row]]] withColor:ccWHITE]];
    [[[CCDirector sharedDirector] navigationController] popViewControllerAnimated:YES];
    
}

@end
