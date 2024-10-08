#!/usr/bin/perl -w

#USAGE:
#
# assembler.pl <infile> [ > <outfile> ]
#NOTES:
# -All labels MUST start with L
# -Shift amounts must be in decimal
# -Immediate may be in hex or decimal.  If in hex, precede with "0x"
# -Comments may be specified with either "#" or "//".
# -No multiline comments
#
# MEM <ADDR> and DATA <VALUE> may be used to specify memory
#
#################################################################

use strict;

if ( @ARGV < 1 ) {
    print "Usage: assembler.pl <input assembly file> > outputFile\n";
    exit;
}
my %regs = (
    "R0"  => "0000",
    "R1"  => "0001",
    "R2"  => "0010",
    "R3"  => "0011",
    "R4"  => "0100",
    "R5"  => "0101",
    "R6"  => "0110",
    "R7"  => "0111",
    "R8"  => "1000",
    "R9"  => "1001",
    "R10" => "1010",
    "R11" => "1011",
    "R12" => "1100",
    "R13" => "1101",
    "R14" => "1110",
    "R15" => "1111"
);
my %numArgs = (
    qw/ADD 3 SUB 3 PADDSB 3 XOR 3 SLL 3 SRA 3 ROR 3 RED 3 LW 3 SW 3 LLB 2 LHB 2 B 2 BR 2 PCS 1 HLT 0/
);
my %opcode = (
    qw/ADD 0000 SUB 0001 XOR 0010 RED 0011 SLL 0100 SRA 0101 ROR 0110 PADDSB 0111 LW 1000 SW 1001 LLB 1010 LHB 1011 B 1100 BR 1101 PCS 1110 HLT 1111/
);
my %rlookup = (
    "1111", "F", "1110", "E", "1101", "D", "1100", "C",
    "1011", "B", "1010", "A", "1001", "9", "1000", "8",
    "0111", "7", "0110", "6", "0101", "5", "0100", "4",
    "0011", "3", "0010", "2", "0001", "1", "0000", "0"
);

open( IN, "$ARGV[0]" ) or die("Can't open $ARGV[0]: $!");

my %labels = ();
my @mem;
my @code;
my $addr = 0;

while (<IN>) {
    my $bits = "";

    s/\#(.*)$//;          #remove  (#) comments
    s#//(.*)$##;          #remove (//) comments
    next if (/^\s*$/);    #skip blank lines

    if (/MEM\s+(\S*)/) {
        $addr = hex($1);
        next;
    }

    if (/DATA\s+(.*)/) {
        my $data = $1;
        $data =~ s/\s*(\S+)\s*/$1/;
        while ( length($data) < 4 ) { $data = "0" . $data }
        $mem[ $addr++ ] = hexToBin( $data, 16 );
        next;
    }

    $_ = uc($_);

    if (s/(.*)://) {    #capture labels
        my $label = $1;
        $label =~ s/\s*(\S+)\s*/$1/;    #strip white space
        $labels{$label} = $addr;
    }

    if (/^\s*(\S+)\s*(.*)/) {
        my $instr = $1;
        my @args  = split( ",", $2 );
        if ( !exists( $numArgs{$instr} ) ) { die("Unknown instruction\n$_") }
        if ( $numArgs{$instr} != @args ) {
            die(
"Error:\n$_\nWrong number of arguments (need $numArgs{$instr} args)\n"
            );
        }

        $bits = "$opcode{$instr}";

        #strip whitespace from arguments
        for ( my $c = 0 ; $c < @args ; $c++ ) {
            $args[$c] =~ s/^\s*(\S+)\s*$/$1/;
        }

        if ( $instr =~ /^(RED|XOR|PADDSB|ADD|SUB)$/ ) {
            foreach my $reg ( $args[0], $args[1], $args[2] ) {
                if ( !$regs{$reg} ) { die("Bad register ($reg)\n$_") }
                $bits .= $regs{$reg};
            }
        }

        elsif ( $instr =~ /^(SRA|SLL|ROR|LW|SW)$/ ) {
            foreach my $reg ( $args[0], $args[1] ) {
                if ( !$regs{$reg} ) { die("Bad register ($reg)\n$_") }
                $bits .= $regs{$reg};
            }
            $bits .= decToBin( $args[2], 4 );
        }

        elsif ( $instr =~ /^(LLB|LHB)$/ ) {
            foreach my $reg ( $args[0] ) {
                if ( !$regs{$reg} ) { die("Bad register ($reg)\n$_") }
                $bits .= $regs{$reg};
            }
            $bits .= parseImmediate( $args[1], 8 );
        }

        elsif ( $instr =~ /^(BR)$/ ) {
            if ( $args[0] =~ /[a-zA-Z]/ ) {
                print STDERR "Warning: control letters not yet supported\n";
            }
            else { $bits .= $args[0] . "0"; }

            foreach my $reg ( $args[1] ) {
                if ( !$regs{$reg} ) { die("Bad register ($reg)\n$_") }
                $bits .= $regs{$reg};
            }
            $bits .= "0000";
        }

        elsif ( $instr =~ /^(B)$/ ) {
            if ( $args[0] =~ /[a-zA-Z]/ ) {
                print STDERR "Warning: control letters not yet supported\n";
            }
            else { $bits .= $args[0]; }
            if ( $args[1] !~ /[a-zA-Z]/ ) {
                print STDERR "Error: Invalid label name: \"$args[1]\"";
                exit;
            }
            $bits .= "|" . $args[1] . "|9|B|";
        }

        elsif ( $instr =~ /^(PCS)$/ ) {
            foreach my $reg ( $args[0] ) {
                if ( !$regs{$reg} ) { die("Bad register ($reg)\n$_") }
                $bits .= $regs{$reg};
            }
            $bits .= "00000000";
        }
        elsif ( $instr =~ /^(HLT)$/ ) {
            $bits .= "000000000000";
        }

        $mem[$addr]  = $bits;
        $code[$addr] = $_;
        $addr += 1;
    }
}

close(IN);

for ( my $i = 0 ; $i < scalar(@mem) ; $i++ ) {
    $addr = $mem[$i];
    next if ( !$addr );
    if ( $addr =~ /\|(.+)\|(\d+)\|(\w)\|/ ) {
        if ( !$labels{$1} ) {
            die("Error:\nLabel referenced, but doesnt exist ($1)\n");
        }
        my $disp = $labels{$1} - $i - 1;
        $disp = decToBin( $disp, $2 );
        $addr =~ s/\|(.+)\|(\d+)\|(\w)\|/$disp/;
    }
    print binToHex($addr) . "\n";
}

sub parseImmediate {
    my $imm = $_[0];
    my $hex = ( $imm =~ /^0x/i ) ? 1 : 0;
    $imm =~ s/^0x//i if ($hex);
    return $hex ? hexToBin( $imm, $_[1] ) : decToBin( $imm, $_[1] );
}

sub hexToBin {
    return decToBin( hex( $_[0] ), $_[1] );
}

sub decToBin {
    my $ret = sprintf( "%b", $_[0] );
    while ( length($ret) < $_[1] ) { $ret = "0" . $ret }
    if ( length($ret) > $_[1] ) { $ret = substr( $ret, length($ret) - $_[1] ) }
    return $ret;
}

sub decToHex {
    my $ret = sprintf( "%x", $_[0] );
    while ( length($ret) < 4 ) { $ret = "0" . $ret }
    return $ret;
}

sub binToHex {
    $_[0] =~ /(\d{4})(\d{4})(\d{4})(\d{4})/;
    return $rlookup{$1} . $rlookup{$2} . $rlookup{$3} . $rlookup{$4};
}
