package Apache::HideFileExtension;
# PerlHeaderParserHandler Apache::HideFileExtension

use strict;
use warnings;

use Apache;
use Apache::Constants qw(OK DECLINED HTTP_MOVED_TEMPORARILY);
use Apache::Table;

our $VERSION = '0.01';

sub handler {
    my $r = shift;

    return DECLINED if !$r->is_initial_req;

    my $hide_ext = $r->dir_config->get('HideExtension') || '.html';
    my $schema   = 'http://'; # for internal redirect. TOOD: under SSL env?
    my $hostname = $r->hostname;
    my $uri      = $r->uri;
    my $filename = $r->filename;
    my $url      = $schema . $hostname . $uri;

    $hide_ext = '.' . $hide_ext if 0 != index $hide_ext, '.';

    if ( $filename =~ /\Q$hide_ext\E$/ ) {
        $url =~ s/\Q$hide_ext\E$//
            or return DECLINED;
        $r->headers_out->set( Location => $url );
        return HTTP_MOVED_TEMPORARILY;
    }
    elsif ( -f $filename . $hide_ext ) {
        $url .= $hide_ext;
        $r->internal_redirect($url);
        return OK;
    }

    return DECLINED;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Apache::HideFileExtension - Access "/path/to/SOMEONE.html" as "/path/to/SOMEONE"

=head1 SYNOPSIS

  # in Apache config file. in <VirtualHost> or <Location>.
  <Location /path/to/htmldir>
    PerlHeaderParserHandler Apache::HideFileExtension
    # ".html" is default.
    PerlSetVar HideExtension .html
  </Location>

=head1 DESCRIPTION

This modules hide your specify file extension on some context
(e.g. E<lt>DirectoryE<gt>, E<lt>LocationE<gt> and so on.).

=head1 MECHANISM

This module is recommended to hook at B<PerlHeaderPerserHandler>,
because we want to finished "URL Trans Phase" (PerlTransHandler) and
"Map to Storage Phase" (PerlMapToStorageHandler).
In this situation, finally URL and it's file path are determined.

This module searches either the file path is exists or not.
If it is exists, then the module send redirection url without extension.

Or the module gives request without the extension,
it causes Apache internal redirect with the extension.
Of course, this module ignores internal redirect's sub-request for
avoid infinite loop.

Apache internal redirect (Apache default-handler) handlings
some troublesome HTTP request processing,
e.g. HTTP 206 Partial Request, and so on.

If you understand mod_perl1 mechanism, and you run other rewrite process
at following native handler or Perl*Handler,
you can set this module at PerlFixupHandler.

Caution if you use mod_rewrite at E<lt>DirectoryE<gt> context,
then mod_rewrite may work something at fixup-handler.

=head1 SEE ALSO

L<Apache2::HideFileExtension>

This module is ported from Apache2::HideFileExtension for mod_perl1.

=head1 AUTHOR

OGATA Tetsuji, E<lt>ogata {at} gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by OGATA Tetsuji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
