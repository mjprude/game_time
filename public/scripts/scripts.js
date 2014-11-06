function disableButtons(string){
  var letterArray = string.match(/[A-Z]/g)
  if (letterArray){
    letterArray.forEach(function(guess){
      $("#" + guess).prop('disabled', true);
    });
  }
}

function parseServerData(data){
  if (data.victory){
    victory();
    return;
  }
  if (data.fail_count === 6){
    failure();
    return;
  }
  
  disableButtons(data.bad_guesses)
  disableButtons(data.game_state)
  
  $('#game_state').empty().append(data.game_state)
  console.log("game state:", data.game_state)
  console.log('bad guesses:', data.bad_guesses)
}

function victory() {
  $('body').append('<h2>Great Job! You win!</h2>')
  endGame('true')
}
function failure() {
  $('body').append('<h2>Too bad! Try again?</h2>')
  endGame('false')
}

function endGame(result) {
  $.ajax({
    method: 'POST',
    url: '/api/hangman',
    dataType: 'JSON',
    data: {user_won: result},
    success: playAgain
  });
}

function playAgain(){
  debugger;
  $('body').append('<button id="play_again">Play Again</button>');
  $('#play_again').click(function(){
    location.reload();
  });
}

function clickGuess(){
  $('button.letterbank').click(function() {
    makeGuess($(this).text())
    $(this).prop('disabled', true);
  });
}

function getState(){
  $.ajax({
    url: '/api/hangman',
    dataType: 'JSON',
    success: parseServerData
  });

}

function makeGuess(guess){
  $.ajax({
    url: '/api/hangman',
    dataType: 'JSON',
    data: {guess: guess},
    success: parseServerData
  });
}

// // // document ready \\ \\ \\
$(function(){

  getState();
  clickGuess();

});