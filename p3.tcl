set ns [new Simulator]
set tf [open p3.tr w]
$ns trace-all $tf
set nf [open p3.nam w]
$ns namtrace-all $nf
set cwind [open wind3.tr w]
$ns color 1 Blue
$ns rtproto DV

for {set i 0} {$i<6} {incr i} {
set n$i [$ns node]
}

$ns duplex-link $n0 $n1 2Mb 2ms DropTail
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 2Mb 2ms DropTail
$ns duplex-link $n3 $n4 2Mb 2ms DropTail
$ns duplex-link $n4 $n5 2Mb 2ms DropTail
$ns duplex-link $n5 $n0 2Mb 2ms DropTail

$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n1 $n2 orient right 
$ns duplex-link-op $n2 $n3 orient right-down
$ns duplex-link-op $n3 $n4 orient left-down
$ns duplex-link-op $n4 $n5 orient left
$ns duplex-link-op $n5 $n0 orient left-up

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0
$ns connect $tcp0 $sink0
$tcp0 set fid_ 1

set ftp [new Application/FTP]
$ftp attach-agent $tcp0
$ns rtmodel-at 3.0 down $n1 $n2
$ns rtmodel-at 5.0 up $n1 $n2
$ns at 0.5 "$ftp start"
$ns at 10.0 finish

proc plotwindow {tcpsource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd0 [$tcpsource set cwnd_]
puts $file "$now $cwnd0"
$ns at [expr $now+$time ] "plotwindow $tcpsource $file"
}

$ns at 2.0 "plotwindow $tcp0 $cwind"

proc finish {} {
global ns tf nf cwind
$ns flush-trace
close $tf
close $nf
close $cwind
exec nam p3.nam &
exec xgraph win3.tr &
exit 0
}

$ns run


