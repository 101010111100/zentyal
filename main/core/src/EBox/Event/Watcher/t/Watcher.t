#!/usr/bin/perl -w

# Copyright (C) 2008-2013 Zentyal S.L.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# A module to test EBox::Event::Watcher::DiskFreeSpace module

use Test::More tests => 3;
use Test::Exception;
use Test::Deep;
use Data::Dumper;

use EBox::Global::TestStub;

BEGIN {
    my $defaultWatcherName = 'State';

    $watcherName = $ARGV[0] || $defaultWatcherName;
    diag ( "Starting EBox::Event::Watcher::$watcherName test" );
    use_ok ( "EBox::Event::Watcher::$watcherName" )
      or die;
}

EBox::Global::TestStub::fake();

my $watcherClassName = "EBox::Event::Watcher::$watcherName";
my $watcher = new $watcherClassName();
isa_ok( $watcher, $watcherClassName );

lives_ok {
    $watcher->run();
} 'Running correctly';

1;
