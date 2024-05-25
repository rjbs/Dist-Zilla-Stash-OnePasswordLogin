package Dist::Zilla::Stash::OnePasswordLogin;
# ABSTRACT: get login credentials from 1Password

=head1 OVERVIEW

This is a stash class, one of the less-often seen kinds of Dist::Zilla
components.  It's expected that you'll use it for things that expect a "Login"
stash credential, like the UploadToCPAN plugin.  Starting with a not-yet-made
mid-2024 release of Dist::Zilla, you can use any Login credential (not just a
PAUSE-specific) one for the UploadToCPAN plugin.  You need to configure the
stash in your home directory's dzil configuration, probably
C<~/.dzil/config.ini>, like this:

  [%OnePasswordLogin / %PAUSE]
  item = op://Vault Name/PAUSE Credential Name

If you've got a "username" and "password" field on that vault item, this should
just work!

This uses L<Password::OnePassword::OPCLI> under the hood.  You'll need to have
that installed, and you'll need to be able to authenticate with 1Password,
meaning that this stash isn't useful for automated build-and-release pipelines.

=cut

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
