#Copyright (c) 2016 Xie Kaixiang 123kevin321@163.com
#Usage: lexer.pl filename
#This is a lexer using regular expression.
#This program will generate tuples (type, value, filename, linenumber) and print them to STDOUT.

@items=(
	[qr/\G(int|char|if|else|while|return)((?=\W)|\z)/,"keyword"],
	[qr/\G(\+\+|--|>>|<<|==|>=|<=|!=|&&|\|\|)/,"operator"],
	[qr/\G(\+|-|\*|\/|%|>|<|=|&|\||!|\^|~|\{|\}|\[|\]|\(|\)|,|;)/,"operator"],
	[qr/\G([A-Za-z_]\w*)/,"identifier"],
	[qr/\G(".*(\\\\)*")/,"string"],
	[qr/\G('.')/,"char"],
	[qr/\G(\d+)((?=\W)|\z)/,"number"],
	[qr/\G(\n)/,"newline"],
	[qr/\G(\s+)/,"whitespace"]
);

open FILE,"<$ARGV[0]";
while(<FILE>) {
	$line++;
	if(/include\s+<(.+)>/) {#Preprocess the include file
		system("$0 $1");
	} elsif(/include\s+<(.+)>/) {
		system("$0 $1");
	} else {
	
LOOP: #Lexical analysis
		while(1) {
			foreach my $item (@items) {
				my($regex,$description)=@$item;
				next unless /$regex/gc;
				if($description eq "whitespace") {
					last LOOP if pos==length;
					next LOOP;
				}
				last LOOP if $description eq "newline";
				print "$description $1 $ARGV[0] $line\n";
				last LOOP if pos==length;
				next LOOP;
			}
			die "$ARGV[0] Line $line: Unexpected char.\n";
			last;
		}
	}
}