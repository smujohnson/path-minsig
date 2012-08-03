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
    my $path_base = join ($dir_separator, @dir_chunks[ 0 .. $i ]);
    my $path_to_shorten = $dir_chunks[$i + 1];

    $dir_chunks_shortened[$i + 1] = transformMinimalSignificant($path_base, $path_to_shorten);
  } else {
    last;
  }
}

print (@dir_chunks_shortened ? (join $dir_separator, @dir_chunks_shortened) : $dir_separator);

# -- funcs --

sub transformMinimalSignificant {
  my $path_base = shift;
  my $path_to_shorten = shift;

  my @tmp_dirs = map { basename($_) } getGlobDirs($path_base);

  my $build = '';
  foreach (split //, $path_to_shorten) {
    $build .= $_;
    @tmp_dirs = grep { m[^$build] } @tmp_dirs;
    return $build if @tmp_dirs == 1;
  }

  return $build;

}

sub getGlobDirs { grep { -d $_ } glob("$_[0]$dir_separator*") }
