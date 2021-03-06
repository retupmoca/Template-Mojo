use v6;
use Test;
use Template::Mojo;


my @cases = (
	{
		name    => 'template',
	},
	{
		name   => 'param',
		params => 5,
	},
	{
		name   => 'hash',
		params => {
			fname => 'Foo',
			lname => 'Bar',
		},
		save => 0,
	},
);

plan @cases.elems;

for @cases -> $c {
	my $fh = open "eg/$c<name>.tm", :r;
	my $tmpl = $fh.slurp;
	#diag $tmpl;
	my $output;
	if $c<params> {
		$output = Template::Mojo.new($tmpl).render($c<params>);
	} else {
		$output = Template::Mojo.new($tmpl).render();
	}
	#diag $output;
	
	# After changing the template one can save it with this code,
	# examine it, and if found correct, keep it as the new expected data
	if $c<save> {
		my $out = open "eg/$c<name>.out", :w;
		$out.print($output);
		$out.close;
	}
	
	my $fh2 = open "eg/$c<name>.out", :r;
	my $expected = $fh2.slurp;
	is $output, $expected, $c<name>;
}

