(function(){

if (!window.TopGenesVizMini)
  window.TopGenesVizMini = {}

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

window.TopGenesVizMini.Spec = {
  "width": 400,
  "height": 200,
  "padding": "strict",
  "autopadInset": 0,
  "signals": [
    { "name": "topN",        "init": 12 },
    { "name": "environment", "init": "in vivo" },
    {
      "name": "highlight",
      "init": null,
      "streams": [
        {"type": "@gene:mouseover", "expr": "datum.gene"},
        {"type": "@gene:mouseout",  "expr": "null"}
      ]
    },
    {
      "name": "click",
      "init": null,
      "streams": [
        {"type": "@gene:click", "expr": "datum"}
      ]
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
        { "type": "filter", "test": "datum.environment === environment && datum.gene" },
        { "type": "sort", "by": ["-subjects", "-unique_sites", "-total_in_gene"] },
        { "type": "rank" },
        { "type": "filter", "test": "datum.rank <= topN" },

        { "type": "formula", "field": "jitter",            "expr": "0.25 * random()" },
        { "type": "formula", "field": "jitter_direction",  "expr": "if(random() < 0.5, 1, -1)" },
        { "type": "formula", "field": "subjects_jittered", "expr": "datum.subjects + datum.jitter * datum.jitter_direction" }
      ]
    }
  ],
  "scales": [
    {
      "name": "color",
      "type": "ordinal",
      "domain": {"data": "genes", "field": "gene", "sort": { "field": "rank", "op": "min" }},
      "range": "category10"
    },
    {
      "name": "x",
      "range": "width",
      "zero": false,
      "round": true,
      "clamp": true,
      "domain": {"data": "genes", "field": "subjects"},
      "domainMin": 0
    },
    {
      "name": "y",
      "range": "height",
      "zero": false,
      "round": true,
      "domain": {"data": "genes", "field": "unique_sites"},
      "domainMin": 0
    }
  ],
  "axes": [
    {
      "type": "x",
      "scale": "x",
      "ticks": 5,
      "offset": 10,
      "title": "Number of Subjects",
      "properties": {
        "title": {
          "fontWeight": {"value": "normal"}
        }
      }
    },
    {
      "type": "y",
      "scale": "y",
      "ticks": 5,
      "offset": 10,
      "orient": "right",
      "title": "Unique IS",
      "properties": {
        "title": {
          "fontWeight": {"value": "normal"}
        }
      }
    }
  ],
  "marks": [
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
          "x": {"scale": "x", "field": "subjects_jittered"},
          "y": {"scale": "y", "field": "unique_sites"},
          "shape": {"value": "circle"},
          "fill": {"scale": "color", "field": "gene"},
          "fillOpacity": [
            {"value": 1, "test": "highlight === datum.gene"},
            {"value": 0.8}
          ],
          "size": [
            {"value": 200, "test": "highlight === datum.gene"},
            {"value": 70}
          ],
          "stroke": [
            {"value": "white", "test": "highlight === datum.gene"},
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
          "x": {"scale": "x", "field": "subjects_jittered"},
          "y": {"scale": "y", "field": "unique_sites"},
          "dx": [
            {"value": -12, "test": "scale('x', datum.subjects) > (width - 100)"},
            {"value": 12}
          ],
          "dy": {"value": 5},
          "align": [
            {"value": "right", "test": "scale('x', datum.subjects) > (width - 100)"},
            {"value": "left"}
          ],
          "fill": {"value": "#444"},
          "stroke": {"value": "transparent"},
          "text": [
            {"template": "{{datum.gene}}", "test": "highlight === datum.gene"},
            {"value": ""}
          ],
          "fontSize": {"value": 14}
        }
      }
    }
  ]
};

})();
