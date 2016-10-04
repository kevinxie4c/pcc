#Copyright (c) 2016 Xie Kaixiang 123kevin321@163.com
#This program will parse the input from STDIN. It also generate assembly file and print it to STDOUT.

use strict;

my $is_full=0;
my $is_end=0;
my($type,$value,$source,$line);
my $local_offset;
my $lowest_offset;
my %local_var_offset;
my %local_var_type;
my %local_var_ptr;
my %local_array;
my %func_type_list; #parameter list
my %func_ptr_list; #parameter list
my %func_type;
my %func_ptr;
my %func_def;
my %global_var_type;
my %global_var_ptr;
my %global_array;

sub peek_token { #Peek next token
	return ($type,$value,$source,$line) if $is_full;
	return undef if($is_end);
	$_=<>;
	if(!$_) {
		$is_end=1;
		return undef;
	}
	$is_full=1;
	my @tmp=split;
	return ($type,$value,$source,$line)=@tmp unless $tmp[0] eq "string" || $tmp[0] eq "char";
	$type=shift @tmp;
	if($type eq "string") {
		die "Impossible!" unless /".*(\\\\)*"/;
		$value=$&;
	} else {
		die "Impossible!" unless /'.*(\\\\)*'/;
		$value=$&;
	}
	$line=pop @tmp;
	$source=pop @tmp;
	($type,$value,$source,$line);
}

sub get_token {
	if($is_full) {
		$is_full=0;
		return ($type,$value,$source,$line);
	}
	return undef if($is_end);
	$_=<>;
	if(!$_) {
		$is_end=1;
		return undef;
	}
	my @tmp=split;
	return ($type,$value,$source,$line)=@tmp unless $tmp[0] eq "string" || $tmp[0] eq "char";
	$type=shift @tmp;
	if($type eq "string") {
		die "Impossible!" unless /".*(\\\\)*"/;
		$value=$&;
	} else {
		die "Impossible!" unless /'.*(\\\\)*'/;
		$value=$&;
	}
	$line=pop @tmp;
	$source=pop @tmp;
	($type,$value,$source,$line);
}

sub match_token { #One arguement (type) or two arguements (type,value)
	my($type,$value,$source,$line)=&get_token;
	if(@_==1) {
		die "$source Line $line: Expected $_[0] but received $type\n" if $type ne $_[0];
	} else {
		die "$source Line $line: Expected $_[0] \"$_[1]\" but received $type \"$value\"\n" if $type ne $_[0] || $value ne $_[1];
	}
	return ($type,$value);
}

my @unary_ops=qw(+ - * & !);
my @binary_ops=qw(+ - * / & | ^ && ||);
my @code;
my @data;
my $label_num=0;
my $string_num=0;

#All expr term... save the result in the register eax
sub expr {
	my $ref_code=shift @_;
	my($base_type,$ptr_num,$writeable)=&log_expr($ref_code);
	my($type,$value,$source,$line)=&peek_token;
	if($type eq "operator" && $value eq "=") {
		die "$source Line $line: Left operand is not a variableA\n" unless $writeable;
		$writeable=0;
		if($$ref_code[-1]=~/mov eax,\[eax\]/) { #*p=expr
			$local_offset-=4;
			$lowest_offset=$local_offset if $lowest_offset>$local_offset;
			$$ref_code[-1]="mov [ebp$local_offset],eax\n";
			&get_token;
			&expr($ref_code);
			push @$ref_code,(
				"mov ebx,[ebp$local_offset]\n",
				"mov [ebx],eax\n"
			);
			$local_offset+=4
		} elsif($$ref_code[-1]=~/mov eax,\[.*\]/) { #[var]=expr
			die "$source Line $line: Left operand is not a variableB\n" unless $$ref_code[-1]=~/\[.*\]/;
			$local_offset-=4;
			$lowest_offset=$local_offset if $lowest_offset>$local_offset;
			$$ref_code[-1]="lea eax,$&\n";
			push @$ref_code,"mov [ebp$local_offset],eax\n";
			&get_token;
			&expr($ref_code);
			push @$ref_code,(
				"mov ebx,[ebp$local_offset]\n",
				"mov [ebx],eax\n"
			);
			$local_offset+=4;
		} else {
			die "$source Line $line: Left operand is not a variableC\n";
		}
	}
	($base_type,$ptr_num,$writeable);
}

sub log_expr {
	my $ref_code=shift @_;
	my($base_type,$ptr_num,$writeable)=&cmp_expr($ref_code);
	my($type,$value)=&peek_token;
	my $changed=0;
	if($type eq "operator" && ($value eq "&&" || $value eq "||")) {
		$changed=1;
		$base_type="logic";
		$ptr_num=0;
		$writeable=0;
		$local_offset-=4;
		$lowest_offset=$local_offset if $lowest_offset>$local_offset;
		push @$ref_code,"mov [ebp$local_offset],eax\n";
	}
	while($type eq "operator" && ($value eq "&&" || $value eq "||")) {
		&get_token;
		my $op=$value eq "&&" ? "and":"or";
		if($value eq "&&") {
			push @$ref_code,"cmp eax,0\n";
			push @$ref_code,"mov eax,-1\n";
			push @$ref_code,"jnz LABEL$label_num\n";
			push @$ref_code,"xor eax,eax\n";
			push @$ref_code,"LABEL$label_num:\n";
			push @$ref_code,"mov [ebp$local_offset],eax\n";
			$label_num++;
		}
		&cmp_expr($ref_code);
		push @$ref_code,"$op [ebp$local_offset],eax\n";
		($type,$value)=&peek_token;
	}
	if($changed) {
		push @$ref_code,"mov eax,[ebp$local_offset]\n";
		$local_offset+=4;
	}
	($base_type,$ptr_num,$writeable);
}

sub cmp_expr {
	my $ref_code=shift @_;
	my($base_type,$ptr_num,$writeable)=&bit_expr($ref_code);
	my($type,$value)=&peek_token;
	my $changed=0;
	if($type eq "operator" && ($value eq ">" || $value eq "<" || $value eq "==" || $value eq "!=" || $value eq ">=" || $value eq "<=")) {
		$changed=1;
		$base_type="logic";
		$ptr_num=0;
		$writeable=0;
		$local_offset-=4;
		$lowest_offset=$local_offset if $lowest_offset>$local_offset;
		push @$ref_code,"mov [ebp$local_offset],eax\n";
	}
	while($type eq "operator" && ($value eq ">" || $value eq "<" || $value eq "==" || $value eq "!=" || $value eq ">=" || $value eq "<=")) {
		&get_token;
		my $op;
		if($value eq ">") {
			$op="jg";
		} elsif($value eq "<") {
			$op="jl";
		} elsif($value eq "==") {
			$op="je";
		} elsif($value eq "!=") {
			$op="jne";
		} elsif($value eq ">=") {
			$op="jge";
		} elsif($value eq "<=") {
			$op="jle";
		}
		&bit_expr($ref_code);
		push @$ref_code,"cmp [ebp$local_offset],eax\n";
		push @$ref_code,"mov eax,1\n";
		push @$ref_code,"$op LABEL$label_num\n";
		push @$ref_code,"xor eax,eax\n";
		push @$ref_code,"LABEL$label_num:\n";
		push @$ref_code,"mov [ebp$local_offset],eax\n";
		$label_num++;
		($type,$value)=&peek_token;
	}
	if($changed) {
		push @$ref_code,"mov eax,[ebp$local_offset]\n";
		$local_offset+=4;
	}
	($base_type,$ptr_num,$writeable);
}

sub bit_expr {
	my $ref_code=shift @_;
	my($base_type,$ptr_num,$writeable)=&ari_expr($ref_code);
	my($type,$value)=&peek_token;
	my $changed=0;
	if($type eq "operator" && ($value eq "&" || $value eq "|" || $value eq "^" || $value eq "<<" || $value eq ">>")) {
		$changed=1;
		$writeable=0;
		$local_offset-=4;
		$lowest_offset=$local_offset if $lowest_offset>$local_offset;
		push @$ref_code,"mov [ebp$local_offset],eax\n";
	}
	while($type eq "operator" && ($value eq "&" || $value eq "|" || $value eq "^" || $value eq "<<" || $value eq ">>")) {
		&get_token;
		&ari_expr($ref_code);
		if($value eq "<<" || $value eq ">>") {
			my $op=$value eq "<<" ? "shl":"shr";
			push @$ref_code,"mov cl,al\n";
			push @$ref_code,"$op DWORD PTR[ebp$local_offset],cl\n";
		} else {
			my $op=$value eq "&" ? "and":($value eq "|" ? "or":"xor");
			push @$ref_code,"$op [ebp$local_offset],eax\n";
		}
		($type,$value)=&peek_token;
	}
	if($changed) {
		push @$ref_code,"mov eax,[ebp$local_offset]\n";
		$local_offset+=4;
	}
	($base_type,$ptr_num,$writeable);
}

sub ari_expr {
	my $ref_code=shift @_;
	my($base_type,$ptr_num,$writeable)=&term($ref_code);
	my($type,$value)=&peek_token;
	my $changed=0;
	if($type eq "operator" && ($value eq "+" || $value eq "-")) {
		$changed=1;
		$writeable=0;
		$local_offset-=4;
		$lowest_offset=$local_offset if $lowest_offset>$local_offset;
		push @$ref_code,"mov [ebp$local_offset],eax\n";
	}
	while($type eq "operator" && ($value eq "+" || $value eq "-")) {
		&get_token;
		my $op=$value eq "+" ? "add":"sub";
		&term($ref_code);
		push @$ref_code,"$op [ebp$local_offset],eax\n";
		($type,$value)=&peek_token;
	}
	if($changed) {
		push @$ref_code,"mov eax,[ebp$local_offset]\n";
		$local_offset+=4;
	}
	($base_type,$ptr_num,$writeable);
}

sub term {
	my $ref_code=shift @_;
	my($base_type,$ptr_num,$writeable)=&factor($ref_code);
	my($type,$value)=&peek_token;
	my $changed=0;
	if($type eq "operator" && ($value eq "*" || $value eq "/" || $value eq "%")) {
		$changed=1;
		$ptr_num=0; # * and / will remove the pointer attribute
		$writeable=0;
		$local_offset-=4;
		$lowest_offset=$local_offset if $lowest_offset>$local_offset;
		push @$ref_code,"mov [ebp$local_offset],eax\n";
	}
	while($type eq "operator" && ($value eq "*" || $value eq "/" || $value eq "%")) {
		&get_token;
		&factor($ref_code);
		if($value eq "*") {
			push @$ref_code,"mov ebx,eax\n";
			push @$ref_code,"mov eax,[ebp$local_offset]\n";
			push @$ref_code,"imul eax,ebx\n";
			push @$ref_code,"mov [ebp$local_offset],eax\n";
		} elsif($value eq "/") {
			push @$ref_code,"mov ebx,eax\n";
			push @$ref_code,"xor edx,edx\n";
			push @$ref_code,"mov eax,[ebp$local_offset]\n";
			push @$ref_code,"idiv ebx\n";
			push @$ref_code,"mov [ebp$local_offset],eax\n";
		} else {
			push @$ref_code,"mov ebx,eax\n";
			push @$ref_code,"xor edx,edx\n";
			push @$ref_code,"mov eax,[ebp$local_offset]\n";
			push @$ref_code,"idiv ebx\n";
			push @$ref_code,"mov [ebp$local_offset],edx\n";
		}
		($type,$value)=&peek_token;
	}
	if($changed) {
		push @$ref_code,"mov eax,[ebp$local_offset]\n";
		$local_offset+=4;
	}
	($base_type,$ptr_num,$writeable);
}

sub factor {
	my $ref_code=shift @_;
	my($type,$value,$source,$line)=&peek_token;
	my($base_type,$ptr_num,$writeable);
	if($type eq "operator") {
		if($value eq "(") {
			&get_token;
			($base_type,$ptr_num,$writeable)=&expr($ref_code);
			match_token("operator",")");
		} elsif($value eq "*") {
			&get_token;
			($base_type,$ptr_num,$writeable)=&factor($ref_code);
			die "$source Line $line: Operand is not a pointer\n" if ($ptr_num==0);
			$ptr_num--;
			$writeable=1;
			($type,$value)=&peek_token;
			if($type eq "operator" && ($value eq "++" || $value eq "--")) {
				&get_token;
				my $op=$value eq "++" ? "inc":"dec";
				push @$ref_code,(
					"mov ebx,[eax]\n",
					"$op DWORD PTR [eax]\n",
					"mov eax,ebx\n"
				);
			} else {
				push @$ref_code,"mov eax,[eax]\n";
			}
		} elsif($value eq "++" || $value eq "--") {
			&get_token;
			($base_type,$ptr_num,$writeable)=&factor($ref_code);
			my $op=$value eq "++" ? "inc":"dec";
			die "$source Line $line: Operand is not a variable\n" unless $writeable;
			$writeable=0;
			die "$source Line $line: Operand is not a variable\n" unless $$ref_code[-1]=~/\[.*\]/;
			$$ref_code[-1]="$op DWORD PTR $&\n";
			push @$ref_code,"mov eax,$&\n";
		} elsif($value eq "!") {
			&get_token;
			($base_type,$ptr_num,$writeable)=&factor($ref_code);
			$base_type="logic";
			$ptr_num=0;
			$writeable=0;
			push @$ref_code,(
				"cmp eax,0\n",
				"mov eax,1\n",
				"jz LABEL$label_num\n",
				"mov eax,0\n",
				"LABEL$label_num:\n"
			);
			$label_num++;
		} elsif($value eq "~") {
			&get_token;
			($base_type,$ptr_num,$writeable)=&factor($ref_code);
			$ptr_num=0;
			$writeable=0;
			push @$ref_code,"not eax\n";
		} elsif($value eq "&") {
			&get_token;
			($base_type,$ptr_num,$writeable)=&factor($ref_code);
			die "$source Line $line: Operand is not a variable\n" unless $writeable;
			$writeable=0;
			$ptr_num++;
			die "$source Line $line: Operand is not a variable\n" unless $$ref_code[-1]=~/\[.*\]/;
			$$ref_code[-1]="lea eax,DWORD PTR $&\n";
		} else {
			die "$source Line $line: Invalid operator \"$value\"\n";
		}
	} else {
		($base_type,$ptr_num,$writeable)=&atom($ref_code);
		($type,$value,$source,$line)=&peek_token;
		if($type eq "operator" && ($value eq "++" || $value eq "--")) {
			&get_token;
			my $op=$value eq "++" ? "inc":"dec";
			die "$source Line $line: Operand is not a variable\n" unless $writeable;
			$writeable=0;
			die "$source Line $line: Operand is not a variable\n" unless $$ref_code[-1]=~/\[.*\]/;
			push @$ref_code,"$op DWORD PTR $&\n";
		}
	}
	($base_type,$ptr_num,$writeable);
}

sub atom {
	my $ref_code=shift @_;
	my($type,$value,$source,$line)=&get_token;
	die "$source Line $line: Expected identifier or number but received operator \"$value\"\n" if $type eq "operator";
	if($type eq "identifier") {
		my($peek_type,$peek_value)=&peek_token;
		if($peek_type eq "operator" && $peek_value eq "(") { #Check weather it is a function call
			&get_token;
			die "$source Line $line: Undefined function \"$value\"\n" unless exists $func_type_list{$value};
			my $first_para=1;
			my @para_list;
			foreach(@{$func_type_list{$value}}) { #Notice that it is a C calling convention
				my $ref=[];
				if($first_para) {
					&expr($ref);
					$first_para=0;
				} else {
					&match_token("operator",",");
					&expr($ref);
				}
				push @$ref,"push eax\n";
				unshift @para_list,$ref;
			}
			foreach my $para(@para_list) {
				push @$ref_code,@$para;
			}
			match_token("operator",")");
			push @$ref_code,"call $value\n";
			push @$ref_code,"add esp,".4*@{$func_type_list{$value}}."\n" if @{$func_type_list{$value}};
		} elsif(exists $local_var_type{$value}) {
			if(exists $local_array{$value}) {
				$local_offset-=4;
				$lowest_offset=$local_offset if $lowest_offset>$local_offset;
				push @$ref_code,"mov DWORD PTR [ebp$local_offset],0\n";
				foreach my $index (@{$local_array{$value}}) {
					&match_token("operator","[");
					&expr($ref_code);
					push @$ref_code,"imul eax,$index\n";
					push @$ref_code,"add [ebp$local_offset],eax\n";
					&match_token("operator","]");
				}
				push @$ref_code,"mov esi,[ebp$local_offset]\n";
				push @$ref_code,"mov eax,[ebp+esi$local_var_offset{$value}]\n";
				$local_offset+=4;
			} else {
				push @$ref_code,"mov eax,[ebp$local_var_offset{$value}]\n";
			}
			return($local_var_type{$value},$local_var_ptr{$value},1);
		} elsif(exists $global_var_type{$value}) {
			if(exists $global_array{$value}) {
				$local_offset-=4;
				$lowest_offset=$local_offset if $lowest_offset>$local_offset;
				push @$ref_code,"mov DWORD PTR [ebp$local_offset],0\n";
				foreach my $index (@{$global_array{$value}}) {
					&match_token("operator","[");
					&expr($ref_code);
					push @$ref_code,"imul eax,$index\n";
					push @$ref_code,"add [ebp$local_offset],eax\n";
					&match_token("operator","]");
				}
				push @$ref_code,"mov esi,[ebp$local_offset]\n";
				push @$ref_code,"mov eax,[esi+_$value]\n";
				$local_offset+=4;
			} else {
				push @$ref_code,"mov eax,[_$value]\n";
			}
			return($global_var_type{$value},$global_var_ptr{$value},1);
		} else {
			die "$source Line $line: Undefined identifier \"$value\"\n";
		}
	} elsif($type eq "number" || $type eq "char") {
		push @$ref_code,"mov eax,$value\n";
		return($type,0,0);
	} elsif($type eq "string") {
		my @chars=split //,$value;
		shift @chars;
		pop @chars;
		push @data,"string$string_num DWORD '".join("','",@chars)."',0\n"; #Omitt this: string1 DWORD 'H','e','l','l','o',0
		push @$ref_code,"mov eax,offset string$string_num\n";
		$string_num++;
		return($type,1,0);
	} else {
		die "$source Line $line: Expected identifier or literal\n";
	}
}

sub same_array {
	my @a=@{$_[0]};
	my @b=@{$_[1]};
	return 0 if @a!=@b;
	while(@a) {
		return 0 if (shift @a) ne (shift @b);
	}
	1;
}

sub global_declaration {
	my $ref_code=shift @_;
	my($type,$value,$source,$line)=&get_token;
	if($type eq "keyword" && $value eq "int") {
		
	} elsif($type eq "keyword" && $value eq "char") {
	
	} else {
		die "$source Line $line: Unknown type \"$value\"\n";
	}
	my $base_type=$value;
	($type,$value,$source,$line)=&get_token;
	my $first_check=1;
	while($type ne "operator" || $value ne ";") {
		my $ptr_num=0;
		while($type eq "operator" && $value eq "*") {
			$ptr_num++;
			($type,$value)=&get_token;
		}
		die "$source Line $line: Expected identifier but received $type \"$value\"\n" if $type ne "identifier";
		my $identifier= $value;
		($type,$value,$source,$line)=&get_token;
		if($first_check && $value eq "(") { #That means Function declaration or definition
			my $declaration=0;
			%local_var_offset=%local_var_type=%local_var_ptr=%local_array=(); #Remember to clear these
			die "$source Line $line: Conflicted function declaration \"$identifier\"\n" if 
				exists $func_type{$identifier} 
				&& ($func_type{$identifier} ne $base_type || $func_ptr{$identifier} ne $ptr_num);
			$func_type{$identifier}=$base_type;
			$func_ptr{$identifier}=$ptr_num;
			($type,$value,$source,$line)=&get_token;
			my @type_list;
			my @ptr_list;
			my $para_offset=4;
			while($type ne "operator" || $value ne ")") { #Deal with the paremeter list
				die "$source Line $line: Expected keyword \"int\" or \"char\" but received $type \"$value\"\n" if $type ne "keyword" || ($value ne "int" && $value ne "char");
				push @type_list,$value;
				$ptr_num=0;
				($type,$value,$source,$line)=&get_token;
				while($type eq "operator" && $value eq "*") {
					$ptr_num++;
					($type,$value,$source,$line)=&get_token;
				}
				push @ptr_list,$ptr_num;
				if($type eq "identifier") {
					die "$source Line $line: Duplicate define var \"$value\"\n" if exists $local_var_type{$value};
					$local_var_type{$value}=$type_list[-1];
					$local_var_ptr{$value}=$ptr_num;
					$local_var_offset{$value}="+".($para_offset+=4); #All the parameters contains 4 bytes
					($type,$value,$source,$line)=&get_token;
				} else {
					$declaration=1;
				}
				if($type eq "operator" && $value eq ",") {
					($type,$value,$source,$line)=&get_token;
				} else {
					die "$source Line $line: Expected \",\" or \")\" but received $type \"$value\"\n" if $type ne "operator" || $value ne ")";
				}
			}
			if(exists $func_type_list{$identifier}) {
				die "$source Line $line: Conflicted function declaration \"$identifier\"\n" unless same_array($func_type_list{$identifier},\@type_list) && same_array($func_ptr_list{$identifier},\@ptr_list);
			} else {
				$func_type_list{$identifier}=[@type_list];
				$func_ptr_list{$identifier}=[@ptr_list];
			}
			if($declaration) {
				&match_token("operator",";");
				last; #function have done, break
			}
			($type,$value,$source,$line)=&get_token; 
			last if $type eq "operator" && $value eq ";";
			die "$source Line $line: Duplicate define function \"$identifier\"\n" if $func_def{$identifier};
			$func_def{$identifier}=1;
			die "$source Line $line: Expected \"{\" but received $type \"$value\"\n" unless $type eq "operator" && $value eq "{";
			&func_definition($identifier,$ref_code);
			last; #function have done, break
		}
		$first_check=0; #Deal with the var declaration
		die "$source Line $line: Duplicate define var \"$identifier\"\n" if exists $global_var_type{$identifier};
		$global_var_type{$identifier}=$base_type;
		$global_var_ptr{$identifier}=$ptr_num;
		if($type eq "operator" && $value eq "[") {
			my @array;
			my @tmp;
			while($type eq "operator" && $value eq "[") {
				($type,$value,$source,$line)=&match_token("number");
				push @tmp,$value;
				&match_token("operator","]");
				($type,$value,$source,$line)=&get_token;
			}
			unshift @array,4; #To simplify
			while(@tmp) {
				unshift @array,$array[0]*(pop @tmp);
			}
			push @data,"_$identifier DWORD ".(shift @array)." DUP(0)\n";
			$global_array{$identifier}=[@array];
		} else {
			push @data,"_$identifier DWORD 0\n"
		}
		if($type eq "operator" && $value eq ",") {
			($type,$value,$source,$line)=&get_token;
		} else {
			die "$source Line $line: Expected \",\" or \";\" but received $type \"$value\"\n" if $type ne "operator" || $value ne ";";
		}
	}
}

my @tail_modified;
sub func_definition {
	#do not need to call &match_token("operator","{");
	my($func_name,$ref_code)=@_;
	$local_offset=$lowest_offset=0;
	push @$ref_code,"$func_name PROC C\n";
	push @$ref_code,"push ebp\n";
	push @$ref_code,"mov ebp,esp\n";
	push @$ref_code,"";
	my $head_modified=\$$ref_code[-1];
	@tail_modified=(); #Must be clear;
	my($type,$value,$source,$line)=&peek_token;
	while($type eq "keyword" && ($value eq "int" || $value eq "char")) {
		&local_declaration($ref_code);
		($type,$value,$source,$line)=&peek_token;
	}
	
	foreach(sort keys %local_var_type) {
		print LOG "$_ $local_var_offset{$_} $local_var_type{$_} $local_var_ptr{$_}\n";
		print LOG "@{$local_array{$_}}\n" if exists $local_array{$_};
	}
	($type,$value,$source,$line)=&peek_token;
	while(defined($type) && defined($value) && ($type ne "operator" || $value ne "}")) {
		&statement($ref_code);
		($type,$value,$source,$line)=&peek_token;
	}
	&match_token("operator","}");
	if($lowest_offset) 	{
		$$head_modified="sub esp,".-$lowest_offset."\n";
		foreach(@tail_modified) {
			$$_="mov esp,ebp\n";
		}
	}
	push @$ref_code,"$func_name ENDP\n";
}

sub local_declaration { #Before call this function, $local_offset must be set 0
	my $ref_code=shift @_;;
	my($type,$value,$source,$line)=&get_token;
	die "$source Line $line: Expected int or char but received $type \"$value\"\n" unless $type eq "keyword" && ($value eq "int" || $value eq "char");
	my $base_type=$value;
	while(1) {
		my $ptr_num=0;
		($type,$value,$source,$line)=&get_token;
		while($type eq "operator" && $value eq "*") {
			$ptr_num++;
			($type,$value,$source,$line)=&get_token;
		}
		die "$source Line $line: Expected identifier but received $type \"$value\"\n" if $type ne "identifier";
		my $identifier=$value;
		die "$source Line $line: Duplicate define var \"$identifier\"\n" if exists $local_var_type{$identifier};
		$local_var_type{$identifier}=$base_type;
		$local_var_ptr{$identifier}=$ptr_num;
		($type,$value,$source,$line)=&get_token;
		if($type eq "operator" && $value eq "[") {
			my @array;
			my @tmp;
			while($type eq "operator" && $value eq "[") {
				($type,$value,$source,$line)=&match_token("number");
				push @tmp,$value;
				&match_token("operator","]");
				($type,$value,$source,$line)=&get_token;
			}
			unshift @array,4; #To simplify
			while(@tmp) {
				unshift @array,$array[0]*(pop @tmp);
			}
			$local_offset-=(shift @array);
			$local_array{$identifier}=[@array];
		} else {
			$local_offset-=4; #To simplify
		}
		$local_var_offset{$identifier}=$local_offset;
		last if $type eq "operator" && $value eq ";";
		die unless $type eq "operator" && $value eq ",";
	}
}

sub statement {
	my $ref_code=shift @_;
	my($type,$value,$source,$line)=&peek_token;
	if($type eq "operator" && $value eq "{") {
		&get_token;
		($type,$value,$source,$line)=&peek_token;
		while(defined($type) && defined($value) && ($type ne "operator" || $value ne "}")) {
			&statement($ref_code);
			($type,$value,$source,$line)=&peek_token;
		}
		&match_token("operator","}");
	} elsif($type eq "keyword") {
		if($value eq "if") {
			&get_token;
			&match_token("operator","(");
			&expr($ref_code);
			&match_token("operator",")");
			my $label_a=$label_num; #Reserve 2 label here
			my $label_b=$label_num+1;
			$label_num+=2;
			push @$ref_code,"test eax,eax\n";
			push @$ref_code,"jz LABEL$label_a\n";
			&statement($ref_code);
			($type,$value,$source,$line)=&peek_token;
			if($type eq "keyword" && $value eq "else") {
				&get_token;
				push @$ref_code,"jmp LABEL$label_b\n";
				push @$ref_code,"LABEL$label_a:\n";
				&statement($ref_code);
				push @$ref_code,"LABEL$label_b:\n";
			} else {
				push @$ref_code,"LABEL$label_a:\n";
			}
		} elsif($value eq "while") {
			&get_token;
			&match_token("operator","(");
			my $label_a=$label_num; #Reserve 2 label here
			my $label_b=$label_num+1;
			$label_num+=2;
			push @$ref_code,"LABEL".($label_b).":\n";
			&expr($ref_code);
			&match_token("operator",")");
			push @$ref_code,"test eax,eax\n";
			push @$ref_code,"jz LABEL$label_a\n";
			&statement($ref_code);
			push @$ref_code,"jmp LABEL$label_b\n";
			push @$ref_code,"LABEL".($label_a).":\n";
		} elsif($value eq "return") {
			&get_token;
			&expr($ref_code);
			push @$ref_code,"";
			push @tail_modified,\$$ref_code[-1];
			push @$ref_code,"pop ebp\n";
			push @$ref_code,"ret\n";
			&match_token("operator",";");
		}else {
			die "$source Line $line: Expected if, while or return but received $type \"$value\"\n";
		}
	} else {
		&expr($ref_code);
		&match_token("operator",";");
	}
}

open LOG,">log.txt";
while(&peek_token) {
	&global_declaration(\@code);
}
print ".386
.model flat,C\n";
foreach(sort keys %func_type) {
	print "$_ PROTO C\n";
}
print ".data\n";
print @data;
print ".code\n";
print @code;
print "END main";

foreach(sort keys %global_var_type) {
	print LOG "$_ $global_var_type{$_} $global_var_ptr{$_}\n";
	print LOG "@{$global_array{$_}}\n" if exists $global_array{$_};
}
foreach(keys %func_type) {
	print LOG "$_ $func_type{$_} $func_ptr{$_}\n";
	print LOG "@{$func_type_list{$_}} @{$func_ptr_list{$_}}\n";
}