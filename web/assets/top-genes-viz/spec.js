(function(){

if (!window.TopGenesViz)
  window.TopGenesViz = {}

var dataKey, dataType, dataValue;

if (window.ISDB && window.ISDB.Exports && window.ISDB.Exports["summary-by-gene"]) {
  dataKey   = "values";
  dataType  = "json";
  dataValue = window.ISDB.Exports["summary-by-gene"];
} else {
  dataKey   = "url";
  dataType  = "csv";
  dataValue = "exports/summary-by-gene.csv";
}

window.TopGenesViz.Spec = {
  "width": 700,
  "height": 1000,
  "name": "Genes containing in vivo integration sites",
  "signals": [
    { "name": "panelWidth",           "init": 400 },
    { "name": "rightGeneLabelMargin", "init": 100 },
    {
      "name": "highlight",
      "init": {},
      "streams": [
        {"type": "@gene:mouseover",   "expr": "{ gene: datum.gene, parent: parent, group: eventGroup() }"},
        {"type": "@gene:mouseout",    "expr": "{}"},
        {"type": "@legend:mouseover", "expr": "{ gene: datum.gene, parent: null, group: null }"},
        {"type": "@legend:mouseout",  "expr": "{}"}
      ]
    },
    {
      "name": "click",
      "init": null,
      "streams": [
        {"type": "@gene:click",   "expr": "datum"},
        {"type": "@legend:click", "expr": "datum"}
      ]
    },
    {
      "name": "topN",
      "init": 20
    }
  ],
  "data": [
    {
      "name": "genes",
      [dataKey]: dataValue,
      "format": {
        "type": dataType,
        "parse": {
          "subjects": "integer",
          "total_in_gene": "integer",
          "unique_sites": "integer",
          "proliferating_sites": "integer"
        }
      },
      "transform": [
        { "type": "filter", "test": "datum.environment === 'in vivo' && datum.gene" },
        { "type": "sort", "by": ["-proliferating_sites", "-unique_sites", "-subjects", "-total_in_gene"] },
        { "type": "rank" },
        { "type": "formula", "field": "shape", "expr": "topN > 20 ? floor((datum.rank - 1) / 20) : 0" },
        { "type": "formula", "field": "group", "expr": "topN > 25 ? floor((datum.rank - 1) / 25) : 0" },
        { "type": "formula", "field": "groupRank", "expr": "((datum.rank - 1) % 25) + 1" },
        { "type": "filter", "test": "datum.rank <= topN" }
      ]
    },
    {
      "name": "panels",
      "values": [
        { "xField": "unique_sites", "yField": "proliferating_sites" },
        { "xField": "subjects",     "yField": "proliferating_sites" },
        { "xField": "unique_sites", "yField": "subjects" },
        { "xField": "unique_sites", "yField": "total_in_gene" },
        { "xField": "subjects",     "yField": "total_in_gene" }
      ],
      "transform": [
        { "type": "rank" }
      ]
    },
    {
      "name": "labels",
      "values": [
        { "field": "subjects",            "label": "Number of Subjects" },
        { "field": "unique_sites",        "label": "Number of Unique Sites" },
        { "field": "total_in_gene",       "label": "Number of Integrations" },
        { "field": "proliferating_sites", "label": "Number of Proliferating Sites" }
      ]
    }
  ],
  "scales": [
    {
      "name": "gy",
      "type": "ordinal",
      "range": "height",
      "round": true,
      "domain": {"data": "panels", "field": "rank"}
    },
    {
      "name": "color",
      "type": "ordinal",
      "domain": {"data": "genes", "field": "gene", "sort": { "field": "rank", "op": "min" }},
      "range": "category20"
    },
    {
      "name": "shape",
      "type": "ordinal",
      "domain": {"data": "genes", "field": "shape", "sort": { "field": "shape", "op": "min" }},
      "range": ["circle", "square", "cross", "triangle-up", "triangle-down"]
    },
    {
      "name": "l",
      "type": "ordinal",
      "domain": {"data": "labels", "field": "field"},
      "range": {"data": "labels", "field": "label"}
    }
  ],
  "marks": [
    {
      "name": "legend",
      "type": "group",
      "from": {
        "data": "genes",
        "transform": [
          {
            "type": "facet",
            "groupby": "group",
            "transform": [
              { "type": "sort", "by": ["groupRank"] }
            ]
          }
        ]
      },
      "properties": {
        "update": {
          "x": {"signal": "panelWidth", "offset": 50},
          "y": {"value": 0},
          "width": {"value": 130, "mult": 4},
          "height": {"signal": "panelWidth"}
        }
      },
      "marks": [
        {
          "type": "text",
          "properties": {
            "update": {
              "x": {"field": "group", "mult": 130, "offset": 10},
              "y": {"field": "groupRank", "mult": 21, "offset": -21},
              "fill": {"value": "#444"},
              "stroke": {"value": "transparent"},
              "text": {"field": "gene"},
              "fontSize": {"value": 14},
              "fontWeight": [
                {"value": "bold", "test": "highlight.gene === datum.gene"},
                {"value": "normal"}
              ],
              "cursor": {"value": "pointer"}
            }
          }
        },
        {
          "type": "symbol",
          "properties": {
            "update": {
              "x": {"field": "group", "mult": 130},
              "y": {"field": "groupRank", "mult": 21, "offset": -26},
              "fill": {"scale": "color", "field": "gene"},
              "shape": {"scale": "shape", "field": "shape"},
              "size": [
                {"value": 140, "test": "highlight.gene === datum.gene"},
                {"value": 50}
              ],
              "cursor": {"value": "pointer"}
            }
          }
        }
      ]
    },
    {
      "name": "field",
      "type": "group",
      "from": {
        "data": "panels"
      },
      "properties": {
        "update": {
          "x": {"value": 0},
          "y": {"scale": "gy", "field": "rank"},
          "width": {"signal": "panelWidth"},
          "height": {"scale": "gy", "band": true, "offset": -100},
          "fill": {"value": "#fff"}
        }
      },
      "scales": [
        {
          "name": "x",
          "range": "width",
          "zero": false,
          "round": true,
          "domain": {"data": "genes", "field": {"parent": "xField"}},
          "domainMin": 0
        },
        {
          "name": "y",
          "range": "height",
          "zero": false,
          "round": true,
          "domain": {"data": "genes", "field": {"parent": "yField"}},
          "domainMin": 0
        }
      ],
      "axes": [
        {
          "type": "x",
          "scale": "x",
          "ticks": 5,
          "offset": 10,
          "title": "x",
          "properties": {
            "title": {
              "text": { "scale": "l", "field": { "parent": "xField", "level": 2 } },
              "fontWeight": {"value": "normal"}
            }
          }
        },
        {
          "type": "y",
          "scale": "y",
          "ticks": 5,
          "offset": 10,
          "title": "y",
          "properties": {
            "title": {
              "text": { "scale": "l", "field": { "parent": "yField", "level": 2 } },
              "fontWeight": {"value": "normal"}
            }
          }
        }
      ],
      "marks": [
        {
          "type": "rule",
          "from": {
            "data": "genes",
            "transform": [
              { "type": "sort", "by": ["-rank"] }
            ]
          },
          "properties": {
            "update": {
              "x": {"scale": "x", "value": 0, "offset": -9},
              "x2": {"scale": "x", "field": {"datum": {"parent": "xField"}}, "offset": -5},
              "y": {"scale": "y", "field": {"datum": {"parent": "yField"}}},
              "stroke": [
                {"value": "transparent", "test": "parent.yField === 'proliferating_sites' && datum.proliferating_sites === 0"},
                {"field": "gene", "scale": "color", "test": "highlight.gene === datum.gene"},
                {"value": "transparent"}
              ]
            }
          }
        },
        {
          "type": "rule",
          "from": {
            "data": "genes",
            "transform": [
              { "type": "sort", "by": ["-rank"] }
            ]
          },
          "properties": {
            "update": {
              "x": {"scale": "x", "field": {"datum": {"parent": "xField"}}},
              "y": {"scale": "y", "value": 0, "offset": 10},
              "y2": {"scale": "y", "field": {"datum": {"parent": "yField"}}, "offset": 5},
              "stroke": [
                {"value": "transparent", "test": "parent.yField === 'proliferating_sites' && datum.proliferating_sites === 0"},
                {"field": "gene", "scale": "color", "test": "highlight.gene === datum.gene"},
                {"value": "transparent"}
              ]
            }
          }
        },
        {
          "name": "gene",
          "type": "symbol",
          "from": {
            "data": "genes",
            "transform": [
              { "type": "sort", "by": ["-rank"] }
            ]
          },
          "properties": {
            "update": {
              "x": {"scale": "x", "field": {"datum": {"parent": "xField"}}},
              "y": {"scale": "y", "field": {"datum": {"parent": "yField"}}},
              "shape": {"scale": "shape", "field": "shape"},
              "fill": {"scale": "color", "field": "gene"},
              "fillOpacity": [
                {"value": 0, "test": "parent.yField === 'proliferating_sites' && datum.proliferating_sites === 0"},
                {"value": 1, "test": "highlight.gene === datum.gene"},
                {"value": 0.8}
              ],
              "size": [
                {"value": 0, "test": "parent.yField === 'proliferating_sites' && datum.proliferating_sites === 0"},
                {"value": 200, "test": "highlight.gene === datum.gene"},
                {"value": 70}
              ],
              "stroke": [
                {"value": "transparent", "test": "parent.yField === 'proliferating_sites' && datum.proliferating_sites === 0"},
                {"value": "white", "test": "highlight.gene === datum.gene"},
                {"value": "transparent"}
              ],
              "cursor": {"value": "pointer"}
            }
          }
        },
        {
          "type": "text",
          "from": {
            "data": "genes",
            "transform": [
              { "type": "sort", "by": ["-rank"] }
            ]
          },
          "properties": {
            "update": {
              "x": {"scale": "x", "field": {"datum": {"parent": "xField"}}},
              "y": {"scale": "y", "field": {"datum": {"parent": "yField"}}},
              "dx": [
                {"value": -8, "test": "highlight.group && scale('x', datum[parent.xField], highlight.group) > (panelWidth - rightGeneLabelMargin)"},
                {"value": 12}
              ],
              "dy": [
                {"value": 20, "test": "highlight.group && scale('x', datum[parent.xField], highlight.group) > (panelWidth - rightGeneLabelMargin)"},
                {"value": 5}
              ],
              "align": [
                {"value": "right", "test": "highlight.group && scale('x', datum[parent.xField], highlight.group) > (panelWidth - rightGeneLabelMargin)"},
                {"value": "left"}
              ],
              "fill": {"value": "#444"},
              "stroke": {"value": "transparent"},
              "text": [
                {"value": "", "test": "parent.yField === 'proliferating_sites' && datum.proliferating_sites === 0"},
                {"template": "{{datum.gene}}", "test": "highlight.gene === datum.gene && highlight.parent === parent"},
                {"value": ""}
              ],
              "fontSize": {"value": 14}
            }
          }
        }
      ]
    }
  ]
};

window.TopGenesViz.Theme = {
  "background": "white",
  "axis": {
    "tickLabelFontSize": 14,
    "titleFontSize": 14
  },
  "legend": {
    "labelFontSize": 14,
    "titleFontSize": 14
  }
};

})();
