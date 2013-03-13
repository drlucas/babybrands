//  TicTacToe
//
//  Created by Kevin & Bryan on 7/1/11.
//  Copyright 2011 WiBit.Net. All rights reserved.
//

//#ifndef WIBIT_TIC_TAC_TOE
//#define WIBIT_TIC_TAC_TOE

#import "TicTacToe.h"

@implementation TicTacToe

-(id) init {
	if (!( self = [super init]) )
		return nil;
	//reset the board
	[self reset];
	return self;
}

-(void) reset {
	_moveCount = 0;
	_winner = ' ';
    _how = ' ';
	NSInteger i, j;
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			_tttGrid[i][j] = 32;
}

-(char) whoseTurn {
	if (_moveCount % 2)
		return 'O';
	return 'X';
}

-(char) getValueAtColumn: (NSInteger) col andRow: (NSInteger) row {
	if ( ( col > 2 || col < 0 ) || ( row > 2 || row < 0 ) )
		[ NSException raise: @"TicTacToeOutOfRangeException"
                     format: @"Cell is out of range" ];
	switch(_tttGrid[row][col])
	{
		case 88: return 'X';
		case 79: return 'O';
		default: return ' ';
	}
}

-(void) makeMoveAtColumn: (NSInteger) col andRow: (NSInteger) row {
    
	if ( [self whoIsWinner] != ' ' )
		[ NSException raise: @"TicTacToeSetException"
                     format: @"Game Over" ];
	else if ( [ self getValueAtColumn: col andRow: row ] != ' ')
		[ NSException raise: @"TicTacToeSetException"
                     format: @"Square is already used" ];
    
	_tttGrid[row][col] = [ self whoseTurn ];
 //   NSLog(@"Move count: %i", _moveCount);
	_moveCount++;
	[ self whoIsWinner ];
}

-(char) howwon {
//figure out how the sucker won....then we can draw a line through!
    if  (_tttGrid[0][0] == _tttGrid[1][1] && _tttGrid[0][0] == _tttGrid[2][2] && _tttGrid[0][0] != ' ')
    {  //left to right diagonal
        _how = 'A';
        return _how;
    }
    else if (_tttGrid[2][0] == _tttGrid[1][1] && _tttGrid[2][0] == _tttGrid[0][2] && _tttGrid[2][0] != ' ')
    { //right to left diagonal
        _how = 'B';
        return _how;
    }
    else if (_tttGrid[0][0] == _tttGrid[0][1] && _tttGrid[0][0] == _tttGrid[0][2] && _tttGrid[0][0] != ' ')
    { //right to left diagonal
        _how = 'C';
        return _how;
    }
    else if (_tttGrid[1][0] == _tttGrid[1][1] && _tttGrid[1][0] == _tttGrid[1][2] && _tttGrid[1][0] != ' ')
    { //right to left diagonal
        _how = 'D';
        return _how;
    }
    else if (_tttGrid[2][0] == _tttGrid[2][1] && _tttGrid[2][0] == _tttGrid[2][2] && _tttGrid[2][0] != ' ')
    { //right to left diagonal
        _how = 'E';
        return _how;
    }
    else if (_tttGrid[0][0] == _tttGrid[1][0] && _tttGrid[0][0] == _tttGrid[2][0] && _tttGrid[0][0] != ' ')
    { //right to left diagonal
        _how = 'F';
        return _how;
    }
    else if (_tttGrid[0][1] == _tttGrid[1][1] && _tttGrid[0][1] == _tttGrid[2][1] && _tttGrid[0][1] != ' ')
    { //right to left diagonal
        _how = 'G';
        return _how;
    }
    else // (_tttGrid[0][2] == _tttGrid[1][2] && _tttGrid[0][2] == _tttGrid[2][2] && _tttGrid[0][2] != ' ')
    { //right to left diagonal
        _how = 'H';
        return _how;
    }

}
-(char) whoIsWinner {
    
	//do we have a winner?
	if (_winner != ' ') return _winner;
	
	//other wise, is there a winning pattern?
	//Step 1: Check Diags
	if ( (_tttGrid[0][0] == _tttGrid[1][1] &&
		  _tttGrid[0][0] == _tttGrid[2][2] && _tttGrid[0][0] != ' ') ||
        (_tttGrid[2][0] == _tttGrid[1][1] &&
         _tttGrid[2][0] == _tttGrid[0][2] && _tttGrid[2][0] != ' ') )
	{
		_winner = _tttGrid[1][1];
		return _winner;
	}
	
	//Step 2: Check Castle Moves
	NSInteger i = 0, j = 0;
	for (i = 0; i < 3; i++)
	{
		if (_tttGrid[i][0] == _tttGrid[i][1] &&
			_tttGrid[i][0] == _tttGrid[i][2] && _tttGrid[i][0] != ' ')
		{
			_winner = _tttGrid[i][0];
			return _winner;
		}
		else if (_tttGrid[0][i] == _tttGrid[1][i] &&
                 _tttGrid[0][i] == _tttGrid[2][i] && _tttGrid[0][i] != ' ')
		{
			_winner = _tttGrid[0][i];
			return _winner;
		}
	}
	
	for(i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
		{
			if (_tttGrid[i][j] == ' ')
				return _winner;
		}
	return 'D';
    
}

@end

//#endif