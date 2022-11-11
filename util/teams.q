\d .teams

hooks:exec channel!hook from ("S*";enlist",")0:`:config/teamschannels.csv
template:(`$("@context";"@type"))!("https://schema.org/extensions";"MessageCard");
msg0:{[url;title;msg].req.post[url;enlist["Content-Type"]!enlist .h.ty`json] .j.j template,`title`text!(title;msg)}
msg:msg0[;"";]
