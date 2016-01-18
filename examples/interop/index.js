var TIMEOUT = 500;

var div = document.getElementById('elmEmbed');
var app = Elm.embed(Elm.Index, div, { addUser: null});
var addUser = app.ports.addUser.send;

app.ports.userCount.subscribe(function(c) {
  $("#counter").text(c);
});


$.get('./users.json')
  .success(function(data) {
    var users = data;

    function pushUser() {
      var next = users.shift();
      if (next) {
        setTimeout(function() {
          addUser(next);
          pushUser();
        }, TIMEOUT);
      }
    }
    pushUser();
  });
