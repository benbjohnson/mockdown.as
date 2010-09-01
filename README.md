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

	$ [sudo] gem install mockdown

This will install the command line tool, `mockdown`, which you can use to
export your mockups into a visual format such as HTML or PNG.

Next create a new project folder and change directories into it:

	$ mockdown init my_proj
	$ cd my_proj

Once in your project folder, create a new file called `home.mkd` with the
following contents:

	%page
	    # Acme Inc
	    
	    %row
	        %link label="Home"
	        %link label="About"
	        %link label="Contact Us"
	    
	    Welcome to the Acme web site! We're excited to have you here! Please
	    look around.

Save the file and then run mockdown on your file:

	mockdown home

You should then see a `home.png` file in your directory. Open it to see your
mockup.


## LANGAUGE

The mockdown language is a cross between (HAML)[http://haml-lang.com] and
(Markdown)[http://daringfireball.net/projects/markdown]. These two langauges
were used because they're known for their ease of use and readability.

### Tag Overview

Mockdown files (*.mkd) are structured hierarchically using tags. Markdown can
be placed inside tags. Tags are created using the `%` sign.

Tags are a single word followed by properties which are a comma-delimited list
of key-value pairs. For example, this is a tag for a button:

	%button width=100, label="Click Me!"

Property values do not need to be wrapped in double quotes unless the value
contains a space, comma or a double quote. Double quotes inside a value can
be escaped with a backspace character.

### White Space Aware

Mockdown is a white space aware language. That means that tags that are
indented are nested within the previous tag that had a smaller indentation.

For example, in this mockdown example the `button` is inside the `row` which
is inside the `col`. However, the `checkbox` is inside the `col` since it is
indented the same as the `row`:

	%col
		%row
			%button label="Click me"
		%checkbox selected=true


### Common Properties

The following properties are available to all tags:

#### Dimension Properties

* `top` - The number of pixels to position the top of the tag from the top of
  its parent tag.
* `bottom` - The number of pixels to position the bottom of the tag from the
  bottom of its parent tag.
* `left` - The number of pixels to position the left of the tag from the
  left of its parent tag.
* `right` - The number of pixels to position the right of the tag from the
  right of its parent tag.
* `width` - The width of the tag in pixels. This can be determined
  automatically if the `left` and `right` properties are set. This can be set
  as a percentage by appending the percent sign to the value.
* `height` - The height of the tag in pixels. This can be determined
  automatically if the `top` and `bottom` properties are set.

#### Action Properties

* `link` - Links to another document. See the *Links* section below.


### Container Tags

These tags can hold other tags inside of them. They are used for laying out
your mockup.

* `col` - A box that contains elements that are vertically aligned.
* `row` - A box that contains elements that are horizontally aligned.
* `canvas` - An area that allows for elements to be positioned using `x` and
  `y` positioning.


### Drawing Tags

These tags are drawing primitives designed to perform basic styling of your
mockup.

* `line` - Draws a line.
* `circle` - Draws a circle.
* `rect` - Draws a rectangle.
* `poly` - Draws a polygon. This tag must contain 3 or more `point` tags.
* `point` - Specifies points in a polygon.
* `image` - Draws an image.

Drawing tags have the following properties available:

* `fill-color` - The fill color for the shape.
* `fill-alpha` - The opacity of the fill of shape. Value is between 0 and 100.
* `stroke-color` - The stroke color for the shape.
* `stroke-alpha` - The opacity of the stroke of the shape. Value is between 0
  and 100.
* `stroke-thickness` - The thickness of the stroke in pixels.
* `stroke-pattern` - The style of stroke to use. (solid, dashed, dotted)
* `border-radius` - The amount to curve the corners of the shape. This is only
  available on the `rect`. Individual corners can be curved using
  `border-radius-` and then appending `tl`, `tr`, `bl`, or `br` to specify the
  corner.


### Custom Tags

Tags can be reused within a project or they can be packaged and distributed as
libraries. To create a custom tag, simply refer to the filename (without the
extension) when using the tag. If a tag is in a subdirectory, directory names
can be separated by a colon.

For example, consider the following file structure for a project:

	+ my_project/
	  + splash.mkd
	  + home.mkd
	  + big_button.mkd
	  + misc/
	    + little_button.mkd

In the `home.mkd` file, you can use `big_button` and `little_button` as tags:

	# Acme Corp!
	
	Welcome to the Acme Corp website!
	
	%big_button label="Order Now!"
	%misc:little_button label="Cancel Order"

In this example, the `big_button.mkd` and `misc/little_button.mkd` will be
embedded in the `home.mkd`.

Custom tags are searched for first in the current directory and then are
searched for in the `tags` directory in the root of the project.


### Tag Libraries

Mockups for various devices and platforms means that no one set of controls is
enough to effectively mockup everything. Because of this, tag libraries can be
built and distributed as Ruby gems.

To install a library, use the `gem` command from the command line:

	$ [sudo] gem install mockdown-iphone

This will install the `mockdown-iphone` library. To use the library, you need
to import it into your mockdown document like this:

	!import mockdown-iphone

This will allow you to use any of the tags defined in the `mockdown-iphone`
library.


### Inline Markdown

Full Markdown capabilities are allowed within a Mockdown document with a few
exceptions:

1. Code blocks
1. Inline HTML

Because Mockdown is meant for quick, simple mockups these two restrictions are
typically not a problem.


### Links

Any tag can link to another mockdown document by using the `link` property of
the tag. Tags will goto the specified document when clicked. Documents can be
referenced using a relative or absolute path. The file extension should be
omitted. Directories should be delimited with a forward slash.

For example, these two buttons will link to two different documents using
relative and absolute paths:

	%button label="View Products", link="../products/view"
	%button label="Home" link="/home"



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