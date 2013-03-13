//  TicTacToe
//
//  Created by Kevin & Bryan on 7/1/11.
//  Copyright 2011 WiBit.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicTacToe : NSObject {
@private
    NSInteger _tttGrid[3][3];
    NSInteger _moveCount;
    char _winner;
    char _how;
}

-(id) init;
-(void) reset;
-(char) whoseTurn;
-(char) getValueAtColumn: (NSInteger) col andRow: (NSInteger) row;
-(void) makeMoveAtColumn: (NSInteger) col andRow: (NSInteger) row;
-(char) whoIsWinner;
-(char) howwon;

@end