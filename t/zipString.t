#!perl -T
#
# Test Archive::StringToZip as documented
#
# $Id: zipString.t 6 2006-05-20 11:33:28Z root $

use strict;

use Test::Exception;
use Test::More tests => 8;

my $class = 'Archive::StringToZip';
use_ok $class;

my $unzipped_text = <<'END';
Zip me baby
ONE MORE TIME!
END

# Use method calls advertised in the documentation
{
    my $stz     = $class->new();
    isa_ok      $stz, $class;
    throws_ok   { $stz->zipString() }
                    qr/\ACannot archive an undefined string/,
                    'zipString dies with no arguments';
}
{
    my $stz     = $class->new();
    my $zip     = $stz->zipString($unzipped_text, 'output.file_TEST');
    is          substr($zip, 0, 2), 'PK',
                    'Looks like a ZIP';
    like        $zip, qr/output\.file_TEST/,
                    'Specifying the filename probably works';

    # Check we can reuse an object
    throws_ok   { $stz->zipString() }
                    qr/\ACannot archive an undefined string/,
                    'zipString dies with no arguments';
    my $zip2    = $stz->zipString($unzipped_text);
    is          substr($zip2, 0, 2), 'PK',
                    'Looks like a ZIP when reusing an object';
    like        $zip2, qr/file\.txt/,
                    'Not specifying the filename probably works';
}
