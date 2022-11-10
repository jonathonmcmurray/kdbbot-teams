/ have to load load.q manually, then can use loaddir function
\l util/load.q
//load util directory, auto directory
.load.dir`util;
.load.dir`auto;

//enable timer on 5 seconds
.timer.enable 00:00:05;

//make sure to open a port, if none specified on cmd line
if[not system"p";system"p 0W"];
.lg.a "Running on port :",string system"p";
