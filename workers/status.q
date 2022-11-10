\l util/worker.q
\c 2000 2000
m:enlist "```";

/-- uptime --
m,:(1_raze system"uptime";"")

/-- external IP --
/m,:"External IP: ",.j.k[.Q.hg`:http://httpbin.org/ip]`origin;
m,:"External IP: ",@[{raze system"curl -s ipinfo.io/ip"};`;"Lookup Failed"];
m,:"";

/-- speedtest --
m,:"Speedtest Results:\n",@[{-1_.Q.s (!/)"SS"$flip ": "vs/:system"speedtest --simple"};`;"Speedtest Failed"];

/-- disk usage --
m,:("";"Disk Usage:");
m,:-1_.Q.s select from (.Q.id ("SSSSSS";enlist",")0:"," sv'{x where 0<count@'x}@'" " vs' system"df -h") where Mounted in `$("/home";"/data");

/-- TorQ stacks --
t:flip `n`user`stackid`stime!("ISIS";4#20)0:system"bash workers/gettorqs.sh"
t:select from t where not user in `devops1`fxcm`aquaq_surv`devops2`devmr`fxcmprod
jnq:{.j.j[x] except "\""}
t:`total xdesc select total:sum n,stacks:jnq sum each n group stackid,stime:jnq first each stime group stackid by user from t
if[0<count t;
   m,:("";"Running TorQ stacks");
   m,:-1_.Q.s t
  ];

m,:"```";
.worker.ret[m];

exit 0;
