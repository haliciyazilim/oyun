//
//  ArrowGameLayer.h
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#import "cocos2d.h"
#import "ArrowGame.h"
#import "ArrowBase.h"
#import "Util.h"

//@class Stopwatch;

@interface ArrowGameLayer : CCLayer

+(CCScene *) sceneWithFile:(NSString*)fileName;
- (void) initializeGameWithFile:(NSString*)fileName;

@property ArrowGame *arrowGame;
//@property Stopwatch *gameTimer;

- (void) restartGame;
- (void) inGameMenuWillClose;
- (void) returnToMainMenu;
- (void) gameEnded;
- (void) showInGameMenu;

+(ArrowGameLayer*)lastInstance;
+(void)cleanLastInstance;

@end
