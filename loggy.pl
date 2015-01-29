#!/usr/bin/perl

%hashdata = ();

while(<>) {
    chomp();
    @arr = split(/\t/);
    ($date,$time,$fn,$ip) = @arr;
#    print "$date\t$time\t$fn\t$ip\n";
    if(!defined($hashdata{$fn}{$date}{$ip})) {
       $hashdata{$fn}{$date}{$ip}{"start"} = $time;
       $hashdata{$fn}{$date}{$ip}{"end"} = $time;
    } else {
      if($hashdata{$fn}{$date}{$ip}{"start"} gt $time) {
        $hashdata{$fn}{$date}{$ip}{"start"} = $time;
      }
      if($hashdata{$fn}{$date}{$ip}{"end"} lt $time) {
        $hashdata{$fn}{$date}{$ip}{"end"} = $time;
      }
   }
 }

# use Data::Dumper;
# Dumper(%hashdata);

 foreach my $file (keys(%hashdata)) {
   foreach my $date (keys(%{$hashdata{$file}})) {
     foreach my $ip (keys(%{$hashdata{$file}{$date}})) {
         print "$file\t$date\t$ip\t".$hashdata{$file}{$date}{$ip}{"start"}."\t".$hashdata{$file}{$date}{$ip}{"end"}."\n";
        }
      }
    }

