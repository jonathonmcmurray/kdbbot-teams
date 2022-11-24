\d .feeds

.load.dir`:auto/feeds

// load feeds config
.feeds.cfg:update id:i from ("S**";enlist",")0:`:config/feeds.csv;
// set last dt for each feed to current dt
.feeds.ldt:.feeds.cfg[`id]!count[.feeds.cfg]#.z.z;
// load template for Teams msgs
/msgtemplate:.j.k read1`:config/samplemsg.json;
msgtemplate:"c"$read1`:config/samplemsg.json;
// get list of answer groups
ans:"," vs' read0`:config/ansgroups.txt;
//set the next group to get a notification to the first one
curgroup:0;

// format a single message
fmt:{[t;m;n] / t-feed type,m-message,n-feed name
  // extract username,link,title using type-specific funcs
  u:user[t]m; l:link[t]m`link; t:title[t]m`title;
  // put together string for message, include feed name n
  :u," asked a question on ",n," titled: ",t,"\n\nLink: [",l,"](",l,")";
 }

// build a single message
msg0:{[t;m;n] / t-feed type,m-message,n-feed name
  // instantiate with standard template
  msg:msgtemplate;
  // prepend question title/link to body text
  /msg[`attachments;`content;`body;0;`text]:fmt[t;m;n],msg[`attachments;`content;`body;0;`text];
  msg:ssr[msg;"MSG_PLACEHOLDER";fmt[t;m;n]];
  // get answerers & add details to message
  /msg[`attachments;`content;`msteams;`entities;0;0;`mentioned;`id]:ans[curgroup][0];
  /msg[`attachments;`content;`msteams;`entities;0;0;`mentioned;`name]:ans[curgroup][0];
  /msg[`attachments;`content;`msteams;`entities;0;1;`mentioned;`id]:ans[curgroup][1];
  /msg[`attachments;`content;`msteams;`entities;0;1;`mentioned;`name]:ans[curgroup][1];
  msg:ssr[msg;"USER_1_PLACEHOLDER";ans[curgroup][0]];
  msg:ssr[msg;"USER_2_PLACEHOLDER";ans[curgroup][1]];
  // increment group counter
  .feeds.curgroup:mod[curgroup+1;count ans];
  // return final message
  :msg;
 }
// projection to build list of messages
msg:{msg0[x;;z] each y}

// timer function for feeds checking
.feeds.tm:{[cfg]
  // download & check each feed in cfg
  nq:chk'[cfg`type;cfg`id;] dl'[cfg`type;cfg`url];
  // check for 0 being less than count of nq - FIX this check is wrong
  if[0<max count@'nq;
    .lg.a "New questions in feeds, sending to Teams";
    // format new messages & send to teams
    .teams.rawmsg[.teams.hooks`publicq]each raze msg'[cfg`type;nq;cfg`name];
    ];
 }

\d .

// add timer to check every 5 minutes
.timer.add[`.feeds.tm;enlist .feeds.cfg;00:05:00;1b];
