#!/usr/bin/perl -w

#Just messing with Parse::DMIDecode
#This isn't just for memory, the following groups can be used for data colletion
#bios, system, baseboard, chassis, processor, >memory, cache, connector, slot

use Parse::DMIDecode ();
use Parse::DMIDecode::Constants qw(@TYPES);

memCheck();

sub memCheck
{
	my $decoder = new Parse::DMIDecode;
	$decoder->probe; 

	printf("System: %s, %s",
		$decoder->keyword("system-manufacturer"),
		$decoder->keyword("system-product-name"),
		);
	
	print "\n";
	for my $handle ($decoder->get_handles(group => "memory")) {
		printf("Found handle at %s (%s):\n%s\n",
			$handle->address,
			$TYPES[$handle->dmitype],
			$handle->raw
			);
	}
}
