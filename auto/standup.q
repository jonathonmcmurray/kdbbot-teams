\d .standup

// enable for different channels, configurable
channels:`devops`webdev!11b

tm:{[]
  // send standup reminder to all enabled channels
  .teams.msg\:[.teams.hooks where channels;"* What I did yesterday\n* What I'm going to do today\n* Any blockers?"]
 }

\d .

// set timer at 9:30, Mon-Fri
.timer.adddaily[`.standup.tm;`;09:30;"2-6"]
  
