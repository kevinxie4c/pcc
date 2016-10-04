#Copyright (c) 2016 Xie Kaixiang 123kevin321@163.com
#Usage: pcc.pl [driver:][path]filename
#This program will Generate assembly file filename.asm. 
#Then use ml to generate object file(coff format) filename.obj and link to generate executable file(PE format) filename.exe.

$file=$ARGV[0];
$file=~/.*\./;
$asm=$&."asm";
$obj=$&."obj";
print "lexer.pl $file|parser.pl>$asm\n";
system("lexer.pl $file|parser.pl>$asm");
print "ml /c /coff $asm\n";
system("ml /c /coff $asm");
print "link  $obj io.obj";
system("link  $obj io.obj");