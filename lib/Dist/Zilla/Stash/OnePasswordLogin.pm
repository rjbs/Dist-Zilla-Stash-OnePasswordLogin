package Dist::Zilla::Stash::OnePasswordLogin;
# ABSTRACT: get login credentials from 1Password

use Moose;
use Dist::Zilla::Pragmas;

use Password::OnePassword::OPCLI;

has item => (
  reader   => '_item_str',
  isa      => 'Str',
  required => 1,
);

has _item => (
  is => 'ro',
  init_arg => undef,
  lazy     => 1,
  default  => sub ($self) {
    my $pw = Password::OnePassword::OPCLI->new;
    $pw->get_item($self->_item_str);
  },
);

sub username ($self) { $self->_item->{username} }
sub password ($self) { $self->_item->{password} }

with 'Dist::Zilla::Role::Stash::Login';
__PACKAGE__->meta->make_immutable;
1;
