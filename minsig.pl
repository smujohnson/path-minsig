#!/usr/bin/perl

# This file is licensed under the Turkey License.
# Please see http://www.youtube.com/watch?v=epbCurj5XXo for more info.

use strict;
use warnings;

use File::Basename;

# -- start --

my $dir_separator = '/';

# as per osse's advice, get the path from the shell environment instead of Cwd core module,
# so that symbolic link directories are supported
my $cwd = $ENV{PWD};

# shorten home directory to ~ if possible
$cwd =~ s[^$ENV{HOME}][~];

my @dir_chunks = split /$dir_separator/, $cwd;
my @dir_chunks_shortened = @dir_chunks;

for (my $i = 0; $i < (@dir_chunks - 1); ++$i) {
  if (defined($dir_chunks[$i + 2])) {
    $dir_chunks_shortened[$i + 1] = transformMinimalSignificant(join ($dir_separator, @dir_chunks[ 0 .. $i ]), $dir_chunks[$i + 1]);
  } else {
    last;
  }
}

print (@dir_chunks_shortened ? (join $dir_separator, @dir_chunks_shortened) : $dir_separator);

# -- funcs --

sub transformMinimalSignificant {
  my $path_base = shift;
  my $path_to_shorten = shift;

  my @globbed_dirs = map { basename($_) } getGlobDirs($path_base);

  my $build = '';
  foreach (split //, $path_to_shorten) {
    $build .= $_;
    return $build if (grep { m[^$build] } @globbed_dirs) == 1;
  }

  return $build;

}

sub getGlobDirs { grep { -d $_ } glob("$_[0]$dir_separator*") }
