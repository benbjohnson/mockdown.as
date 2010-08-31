mockdown -- A Markdown-inspired mockup tool
=============================================

### THIS PROJECT IS IN PLANNING RIGHT NOW. ###


## DESCRIPTION

Mockdown is a language for quickly creating mockups using a text editor.
Mockups can be exported to a variety of formats and mockdown definition files
are plain text so they work well with version control systems.

Mockdown follows the rules of [Semantic Versioning](http://semver.org/) and uses
[TomDoc](http://tomdoc.org) for inline documentation.


## GETTING STARTED

To install mockdown, simply install the gem:

	[sudo] gem install mockdown

This will install the command line tool, `mockdown`, which you can use to
export your mockups into a visual format such as HTML or PNG.


## LANGAUGE

The mockdown language is a cross between (HAML)[http://haml-lang.com] and
(Markdown)[http://daringfireball.net/projects/markdown]. These two langauges
were used because they're known for their ease of use and readability.

Mockdown files (*.mkd) are structured hierarchically using tags. Tags are
created using the `%` sign.

### Container Tags

These tags can hold other tags inside of them. They are used for laying out
your mockup.

* `vbox` - A box that contains elements that are vertically aligned.
* `hbox` - A box that contains elements that are horizontally aligned.
* `canvas` - An area that allows for elements to be positioned using `x` and
  `y` positioning.

### Drawing Tags

These tags are drawing primitives designed to perform basic styling of your
mockup.

* `line`
* `circle`
* `rect`

### Tag Libraries

### Links


## COMMAND LINE

...

## API

...

## CONTRIBUTE

If you'd like to contribute to Mockdown, start by forking the repository on GitHub:

http://github.com/benbjohnson/mockdown

Then follow these steps to send your 

1. Clone down your fork
1. Create a topic branch to contain your change
1. Code
1. All code must have MiniTest::Unit test coverage.
1. If you are adding new functionality, document it in the README
1. If necessary, rebase your commits into logical chunks, without errors
1. Push the branch up to GitHub
1. Send me a pull request for your branch