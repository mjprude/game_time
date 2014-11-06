function disableButtons(string){
  var letterArray = string.match(/[A-Z]/g)
  if (letterArray){
    letterArray.forEach(function(guess){
      $(".letterbank:contains('"+ guess + "')").prop('disabled', true);
    });
  }
}

function parseServerData(data){
  disableButtons(data.bad_guesses)
  disableButtons(data.game_state)
  
  $('#game_state').empty().append(data.game_state)
  console.log("game state:", data.game_state)
  console.log('bad guesses:', data.bad_guesses)

  if (data.victory){
    return victory();
  }
  if (data.fail_count === 6){
    return failure();
  }
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

function playAgain(data){
  wiki = 'http://en.wikipedia.org/wiki/' + data.word.split(', ')[0].replace(' ', '_')
  $('body').append('The location was ' + data.word)
  $('body').append('<a href="' + wiki.toLowerCase() + '">Learn More!</a>')
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


function getChar(event) {
  return String.fromCharCode(event.keyCode || event.charCode).toUpperCase();
}

function allowTyping() {
  $('body').keypress(function(e){
    var buttonID = '#' + getChar(e)
    $(buttonID).click();
  });
}


// // // document ready \\ \\ \\
$(function(){

  getState();
  clickGuess();
  allowTyping();

});