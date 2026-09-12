#!/usr/bin/env perl
# probe-sna.pl - inspect a 48K ZX Spectrum .SNA snapshot.
#
#   probe-sna.pl FILE.sna            decode the register header + entry point
#   probe-sna.pl FILE.sna ADDR [LEN] also hexdump + disassemble LEN bytes @ ADDR
#
# ADDR/LEN accept 0x.., $.., ..h or decimal.  Disassembly shells out to z80dasm.
use strict; use warnings;

sub num { my $s = shift; $s =~ s/h$//i;
          return hex($s) if $s =~ /^(0x|\$)/i || $s =~ /[a-f]/i && $s !~ /^\d+$/;
          return $s + 0; }

my ($file, $addr, $len) = @ARGV;
die "usage: $0 FILE.sna [ADDR [LEN]]\n" unless defined $file;
open my $fh, '<:raw', $file or die "open $file: $!\n";
my $data = do { local $/; <$fh> };
my $size = length $data;
die "not a 48K .sna (got $size bytes, expected 49179)\n" unless $size == 49179;

# 27-byte header, little-endian 16-bit fields.
my ($I,$HLp,$DEp,$BCp,$AFp,$HL,$DE,$BC,$IY,$IX,$IFF,$R,$AF,$SP,$IM,$BORDER)
  = unpack 'C v v v v v v v v v C C v v C C', substr($data, 0, 27);

# 48K .sna: PC lives on the stack; loading effectively RETs into it.
my $pc_off = 27 + ($SP - 0x4000);
my $PC = ($SP >= 0x4000 && $SP <= 0xFFFE)
       ? unpack('v', substr($data, $pc_off, 2)) : undef;

printf "== %s (48K snapshot) ==\n", $file;
printf "AF  %04X   BC  %04X   DE  %04X   HL  %04X\n", $AF,$BC,$DE,$HL;
printf "AF' %04X   BC' %04X   DE' %04X   HL' %04X\n", $AFp,$BCp,$DEp,$HLp;
printf "IX  %04X   IY  %04X   SP  %04X   I %02X  R %02X\n", $IX,$IY,$SP,$I,$R;
printf "IM  %d      IFF2 %s   border %d\n",
       $IM, ($IFF & 0x04 ? "on (EI)" : "off (DI)"), $BORDER;
printf "PC  %s   (popped from stack top at SP=%04X)\n",
       defined $PC ? sprintf("%04X", $PC) : "??", $SP;

exit 0 unless defined $addr;

$addr = num($addr);
$len  = defined $len ? num($len) : 24;
die "addr $addr out of RAM range \$4000-\$FFFF\n" if $addr < 0x4000 || $addr > 0xFFFF;
$len = 0x10000 - $addr if $addr + $len > 0x10000;
my $slice = substr($data, 27 + ($addr - 0x4000), $len);

printf "\n== hexdump \$%04X (%d bytes) ==\n", $addr, $len;
for (my $i = 0; $i < length $slice; $i += 16) {
    my $row = substr($slice, $i, 16);
    printf "%04X  %-48s%s\n", $addr + $i,
        join(' ', map { sprintf '%02x', $_ } unpack 'C*', $row),
        join('',  map { $_ >= 0x20 && $_ < 0x7f ? chr : '.' } unpack 'C*', $row);
}

if (my $z80 = `command -v z80dasm 2>/dev/null`) {
    chomp $z80;
    my $tmp = "/tmp/probe-sna.$$";
    open my $t, '>:raw', $tmp or die; print $t $slice; close $t;
    printf "\n== disassembly \$%04X ==\n", $addr;
    system($z80, '-a', '-t', '-g', sprintf('0x%X', $addr), $tmp);
    unlink $tmp;
} else {
    print "\n(z80dasm not found - skipping disassembly)\n";
}
