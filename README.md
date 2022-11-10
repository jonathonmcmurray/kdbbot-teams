# kdbbot-teams
A framework for a KDB back end to a MS Teams bot

kdbbot-teams is a plugin-based framework for interacting with MS Teams from KDB, adapted from [kdbslack](https://github.com/jonathonmcmurray/kdbslack). Functionality is added to the framework by way og [auto plugins](#auto-plugins). In addition, there is "worker" functionality that can be leveraged by plugins.

## Starting kdbbot

In order to start kdbbot, clone this repo & run `q kdbbot.q` from the root directory of this repo. (You will also need to update some config files). There are a number of command line options you can/should specify when running also:

## Plugins

### auto plugins

Auto plugins are timer based and are run periodically. These plugins are perfect for polling Web APIs on a given frequency, or running a periodic status report, for example.

Several examples of these are included, such as `feeds.q` which checks for new KDB+ related questions on public forums such as Google Groups & StackOverflow. Another included example is `hub.q` which checks for newly completed challenges & newly earnt badges on the [AquaQ Challenge Hub](http://challenges.aquaq.co.uk/).

These plugins (along with several other examples) are located within the `auto/` directory. In order to write an auto plugin, the only real requirement is to register with the timer, via `.timer.add` or `.timer.adddaily` functions, for example:

```rust
.timer.add[`.chlg.tm;`;00:05;1b]                    //call .chlg.tm function with null arg every 5 mins, repeat
.timer.adddaily[`.status.tm;`;09:00;"2-6"]          //call .status.tm function with null arg at 9am, Monday-Friday (i.e. where date mod 7 is in 2-6)
```

## workers/

Workers are scripts designed to be run in the background by the `auto.q` process.

For example, status.q builds a status report on the current host - this occurs in a background 
process so as to not hang the main process. The finished report is returned to the main process
via a callback function passed to the background script as a command line arg.

An example of the usage of workers is shown below:

```
q)-1 read0`:util/dummy_worker.q;
\l util/worker.q
system"sleep 10";
.worker.ret[1+1];
q).work.cb:{0N!x}
q).worker.create["util/dummy_worker.q";`.work.cb]
q)
q)
q)/not hung
q)2 /value returned from worker
```

For another example, see `auto/status.q` and it's companion `workers/status.q`

