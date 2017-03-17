# Data

The standard __summary-by-gene.csv__ export is the input data.

# Plot

The plot is made using [Vega][] and a little bit of custom JavaScript to send
signals to the plot to update the number of genes shown.

Group marks are used in order to plot each panel without duplicating large
hunks of the plot spec.  References to a _parent_ in the spec are references to
the enclosing group mark.  You can learn more about Vega's group marks from
these documentation pages:

* [Group Marks](https://github.com/vega/vega/wiki/Group-Marks)
* [Marks](https://github.com/vega/vega/wiki/Marks)
* [Expressions](https://github.com/vega/vega/wiki/Expressions)

If you're unfamiliar with Vega, you may want to [start here][].

[Vega]: https://vega.github.io/vega/
[start here]: https://github.com/vega/vega/wiki/Documentation
