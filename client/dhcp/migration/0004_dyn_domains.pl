#!/usr/bin/perl

# Copyright (C) 2011 eBox Technologies S.L.
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


package EBox::Migration;
use base 'EBox::Migration::Base';

use strict;
use warnings;

use EBox;
use EBox::Global;
use Error qw(:try);

# Private methods

# Set the domain ID
sub _setDomainId
{
    my ($self, $dhcpMod, $domainModel, $key) = @_;

    my $dhcpDomain = $dhcpMod->get_string($key);
    if ( defined($dhcpDomain) ) {
        my $dnsDomain = $domainModel->find(domain => $dhcpDomain);
        if ( defined($dnsDomain) ) {
            $dhcpMod->set_string($key, $dnsDomain->id());
        }
    }

}

sub runGConf
{
    my ($self) = @_;

    try {
        my $dhcpMod = $self->{gconfmodule};
        my $dnsMod  = EBox::Global->modInstance('dns');
        my $domainModel = $dnsMod->model('DomainTable');

        $dhcpMod->models();
        foreach my $iface (keys %{$dhcpMod->{dynamicDNSModel}}) {
            my $model = $dhcpMod->{dynamicDNSModel}->{$iface};
            my $key = $model->{directory};
            $self->_setDomainId($dhcpMod, $domainModel, "$key/dynamic_domain");
            $self->_setDomainId($dhcpMod, $domainModel, "$key/custom");
        }
    } otherwise {};
}

EBox::init();

my $dhcpMod = EBox::Global->modInstance('dhcp');
my $migration =  __PACKAGE__->new(
    'gconfmodule' => $dhcpMod,
    'version' => 4
);
$migration->execute();