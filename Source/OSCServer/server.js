var Voting = require('./lib/voting.js');
var Synchronization = require('./lib/synchronization.js');

var sync = new Synchronization();
var voting = new Voting();

var voteCount = 0;

sync.on('/getVote', function(msg) {
    if (msg[1] == 1) {
        var vote = voting.getVote();
        console.log('result of the vote: ' + vote);
        sync.clientBroadcast('/vote', vote);

        voteCount++;
        if (voteCount >= 2) {
            voteCount = 0;
            setTimeout(function() {
                voting.resetClients();
            }, 12000);
        }
    }
});