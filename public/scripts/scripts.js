String.prototype.capitalize = function() {
  var ary = this.split(' ')
  ary.forEach(function(word, idx){
    ary[idx] = word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  });
  return ary.join(' ')
}

function disableButtons(string, bad_guess){
  var letterArray = string.match(/[A-Z]/g)
  if (letterArray){
    letterArray.forEach(function(guess){
      var button = $(".letterbank:contains('"+ guess + "')")
      button.prop('disabled', true);
      if (bad_guess) {
        button.css("background-color", "#e37980")
      }
    });
  }
}

function parseServerData(data){
  var lat = parseFloat(data.latlng.split(', ')[0]);
  var lng = parseFloat(data.latlng.split(', ')[1]);
  var zoom = 1 + data.fail_count
  var guesses_left = 6 - data.fail_count

  disableButtons(data.bad_guesses, true)
  disableButtons(data.game_state, false)

  $('#guesses_left').empty().append(guesses_left)
  if (guesses_left < 3) {
    $('#guesses_left').css("color", "red")
  }
  
  $('#game_state').empty().append(data.game_state)
  console.log("game state:", data.game_state)
  console.log('bad guesses:', data.bad_guesses)

  if (data.victory || data.fail_count === 6){
    var mapOptions = {
      zoom: 7,
      center: new google.maps.LatLng(lat, lng),
      mapTypeId: google.maps.MapTypeId.HYBRID,
    };
    var map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);    
  }
  if (data.victory) {
    return victory();
  }
  if (data.fail_count === 6){   
    return failure();
  }

  var mapOptions = {
    zoom: zoom,
    center: new google.maps.LatLng(lat, lng),
    mapTypeId: google.maps.MapTypeId.SATELLITE,
    disableDefaultUI: true
  };
  var map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);
}

function victory() {
  $('#end_game').append('<h2>Great Job! You win!</h2>')
  endGame('true')
}
function failure() {
  $('#end_game').append('<h2>Too bad! Try again?</h2>')
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
  var locale = data.word.capitalize()
  var wiki = 'http://en.wikipedia.org/wiki/' + locale.split(', ')[0].replace(' ', '_')

  // var frame = '<object data=' + wiki + ' width="600" height="400"> <embed src=' + wiki.toLowerCase() + ' width="600" height="400"> </embed> Error: Embedded data could not be displayed. </object>'
  $('#end_game').append('<button id="play_again">Play Again</button>');
  $('#end_game').append('<a href="' + wiki + '" id="learn_more">Learn More About ' + locale + '!</a>')
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