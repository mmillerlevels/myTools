#!/usr/local/bin/perl -w

# cpanm Amazon::S3
use Amazon::S3;

my $access_key = 'Access Key';
my $secret_key = 'Secret Key';

my $conn = Amazon::S3->new(
		{
		aws_access_key_id     => $access_key,
		aws_secret_access_key => $secret_key,
		host                  => 'mybucket.s3-us-west-2.amazonaws.com',
		secure                => 1,
		retry                 => 1,
	}
);


sub listBuckets() {
	my @buckets = @{$conn->buckets->{buckets} || []};
	foreach my $bucket (@buckets) {
		print $bucket->bucket . "\t" . $bucket->creation_date . "\n";
	}
}

sub listObjects($) {
	my $bucket = @_;
	my @keys = @{$bucket->list_all->{keys} || []};
	foreach my $key (@keys) {
		print "$key->{key}\t$key->{size}\t$key->{last_modified}\n";
	}
}
