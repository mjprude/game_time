console.log('<^+_+^>')
var $canvas = $('#board');
var context = $('#board')[0].getContext('2d');
var gameState = gameState || '         ';
var userSym = $('#userSym').text();
var currentSym;
var blockSize = 100;
var gameID = document.URL.split('/')[4];

// function makeBoard(){
//   var board = new Array(3);
//   for (var i=0; i < 3; i++) {
//     board[i] = new Array(3);
//   }
//   return board;
// } 

function getTTTData(){
  $.ajax({
    method: 'GET',
    url: '/api/ttt/' + gameID,
    dataType: 'JSON',
    data: {game_state: gameState},
    success: parseTTTData    
  });
}

function patchTTTData(){
  $.ajax({
    method: 'PATCH',
    url: '/api/ttt/' + gameID,
    dataType: 'JSON',
    data: {game_state: gameState},
    success: parseTTTData
  });
}

function parseTTTData(data){
  gameState = data.game_state;
  currentSym = data.turn;
  if (data.winner) {
    newGame(data.winner)
    // $canvas.on('click', disallowClick);
    $canvas.off();
  }
  if (userSym === currentSym){
    // debugger;
    $canvas.off();
    $canvas.on('click', clickBoard);
  } else {
    // debugger;
    // $canvas.on('click', disallowClick);
    $canvas.off();
  }
  drawBoard();
}

function clickBoard(e){
  var x = e.offsetX;
  var y = e.offsetY;
  var col = Math.floor(x/blockSize);
  var row = Math.floor(y/blockSize);
  var i = (row * 3 + col)
  gameState = gameState.substr(0, i) + currentSym + gameState.substr(i + 1);
  patchTTTData();
}

function disallowClick(e) {
  alert("It's not your turn!")
}

function drawHashes(){
  context.lineWidth = 4
  context.beginPath();
  context.moveTo(blockSize, 0);
  context.lineTo(blockSize, (blockSize * 3));
  context.moveTo((blockSize * 2), 0);
  context.lineTo((blockSize * 2), (blockSize * 3));
  context.moveTo(0, blockSize)
  context.lineTo((blockSize * 3), blockSize)
  context.moveTo(0, (blockSize * 2))
  context.lineTo((blockSize * 3), (blockSize * 2))
  context.stroke();
}

function drawBoard() {
  context.translate(0, 0); // This should not be needed... Andrew found it comforting to verify we are starting with a clean slate... which is should already do... given that we restore() on every draw...
  context.clearRect(0, 0, 3*blockSize, 3*blockSize); // Clear all pixels... we are about to draw the board fresh
  drawHashes();
  for (var row = 0; row < 3; row++) { // Iterate through all the row indexes
    for (var col = 0; col < 3; col++) {  // Iterate through all the column indexes
      var x = col * blockSize; // X: Starting location for the next block
      var y = row * blockSize; // Y: tarting location for the next block
      context.save(); // Save the state of the canvas
      context.translate(x, y);  // Set (0, 0) of the context to a new location
      context.font = blockSize + "px 'Courier New'"
      context.fillText(gameState[(row * 3 + col)], blockSize*.2, blockSize*.8);
      // context.fillStyle = worldState[row][col] ? aliveColor() : blockColor;  // Color based on living or not living
      // context.fillRect(0, 0, blockSize, blockSize);  // Draw a sqaure... It is at postion 0, 0 BECAUSE we translated before this
      context.restore(); // Apply the changes
    }
  }
}

function newGame(winner) {
  debugger;
  $canvas.append(winner + 'is the winner!')
  document.off();
}

$(function(){
  // $canvas.on('click', clickBoard);
  getTTTData();
  setInterval(getTTTData, 3000);
})