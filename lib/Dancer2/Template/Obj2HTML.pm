package Dancer2::Template::Obj2HTML;
$Dancer2::Template::Obj2HTML::VERSION = '0.0';

use strict;
use warnings;

use Moo;
use JSON;
use HTML::Obj2HTML;
with 'Dancer2::Core::Role::Template';

has page_loc => (
    is      => 'rw',
    default => sub {'dofiles/pages'},
);

has component_loc => (
    is      => 'rw',
    default => sub {'dofiles/components'},
);

has template_loc => (
    is      => 'rw',
    default => sub {'dofiles/templates'},
);

sub BUILD {
  my $self     = shift;
  my $settings = $self->config;

  $settings->{$_} and $self->$_( $settings->{$_} )
    for qw/ page_loc component_loc template_loc /;

  HTML::Obj2HTML::import(components => $self->component_loc);
}

sub render {
  my ($self, $content, $tokens) = @_;

  if ($tokens->{content}) {
    HTML::Obj2HTML::set_snippet("content", [ raw => $tokens->{content} ]);
  }

  if (ref $content eq "ARRAY") {
    return HTML::Obj2HTML::gen($content);
  } elsif (!ref $content) {
    return HTML::Obj2HTML::gen(HTML::Obj2HTML::fetch($self->{settings}->{appdir} . $self->template_loc . "/" . $content . ".po"));
  }
}

sub view_pathname {
  my ( $self, $view ) = @_;
  return $view;
}
sub layout_pathname {
  my ( $self, $layout ) = @_;
  return $layout;
}

1;
