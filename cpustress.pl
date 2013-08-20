#!/usr/bin/perl

use threads;
use Crypt::CBC;

my $cores = `cat /proc/cpuinfo | grep processor | wc -l`;

my @threads;
for(my $i = 0; $i < $cores; $i++){
  push @threads, threads->create('bowfishStress');
}
foreach my $thread (@threads){
  $thread->join();
}
exit;

sub bowfishStress{
  my $plaintext;
  my $key;
  my $decrypted_plaintext;
  my $cipher = Crypt::CBC->new( -key => 'dummy', -cipher => 'Blowfish' );
  while(1){
    $plaintext = '';
    for(my $i = 0; $i < 58; $i++){ $plaintext .= sprintf("%x%x",int(rand(16)),int(rand(16))); }
    $key = '';
    for(my $i = 0; $i < 58; $i++){ $key .= sprintf("%x%x",int(rand(16)),int(rand(16))); }
    $cipher->key($key);
    $decrypted_plaintext = $cipher->decrypt($cipher->encrypt($plaintext));
    if($plaintext ne $decrypted_plaintext){
      print STDERR "ERROR: Mismatch in decode\n       input: $plaintext\n      output: $decrypted_plaintext\n";
    }
  }
}

