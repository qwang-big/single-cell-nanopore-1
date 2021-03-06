$illu=shift;
$nano=shift;
$n=shift; #file prefix
$L=shift; #umi length
$l=$L-3;  #max 3 mismatches allowed
$dir=shift;
$dir='.' unless defined $dir;

open(F,"<$illu");
while(<F>){chomp;
@t=split(/\t/);
$h{"$t[2]\t$t[0]"}.=">$t[1]\n$t[1]\n"
}
close F;

open(F,"<$nano");
while(<F>){chomp;
@t = split(/\t/);
$r = $t[3];
$s = reverse $t[3];
$s =~ tr/ATGCatgc/TACGtacg/;
$d = 0.5 * (length($s)-$L);
$h1{"$t[2]\t$t[1]"}.=">$t[0]\n".substr($r,0,$L+4)."\n" if substr($r,$L)=~tr/T/n/ >=$d;
$h1{"$t[2]\t$t[1]"}.=">$t[0]\n".substr($s,0,$L+4)."\n" if substr($s,$L)=~tr/T/n/ >=$d;
}
close F;

foreach $g(keys %h1){
next unless defined $h{$g};
$r='';
open(F,">$dir/s$n.fa")||die "$!";
print F $h1{$g};
close F;
open(F,">$dir/q$n.fa")||die "$!";
print F $h{$g};
close F;
system("mummer $dir/q$n.fa $dir/s$n.fa -maxmatch -b -c -l $l -F > $dir/mm$n");
open(F,"<$dir/mm$n");
while(<F>){
$b=/^>/;
$_=substr($_,2);
$_=substr($_,0,index($_,' '));
$r.="$g\t$_\t$s\n" unless $b;
$s=$_ if $b
}
close F;
print $r
}
