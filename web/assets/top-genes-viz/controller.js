// vim: set ts=2 sw=2 :
(function(){
  'use strict';

  var topN  = 25;
  var match = window.location.search.match(/topN=(\d+)/);
  if (match)
    topN = parseInt(match[1], 10);

  var spec = {
    spec: TopGenesViz.Spec,
    config: TopGenesViz.Theme,
    renderer: "svg",
    actions: {
      export: true,
      source: false,
      editor: false
    },
    parameters: [
      {
        type: "range",
        signal: "topN",
        name: "Top N genes",
        value: topN,
        min: 5,
        max: 100
      }
    ]
  };

  var viz = document.querySelector("#top-genes-viz");

  vg.embed(viz, spec, function(error, result){
    if (error) {
      console.error(error);
      return;
    }

    // Make viz available on the DOM for easier debugging.
    viz.view = result.view;

    // Sync signal/view with initial topN
    result.view.signal("topN", topN).update();

    // Sync location with current topN
    if (window.history)
      result.view.onSignal("topN", updateLocation);

    // Register handler with click signal
    result.view.onSignal("click", gotoGene);

    // Tweak DOM of topN param slider
    tweakParam();
  });

  var timeout;
  function updateLocation(_, value) {
    if (timeout)
      clearTimeout(timeout);

    var query = "?" + encodeURIComponent("topN") + "=" + encodeURIComponent(value);
    var replaceState = window.history.replaceState.bind(window.history, null, "", query);
    timeout = setTimeout(replaceState, 500);
  }

  function gotoGene(signal, datum) {
    if (datum.ncbi_gene_id)
      window.location.href = 'https://www.ncbi.nlm.nih.gov/gene/' + datum.ncbi_gene_id
  }

  function tweakParam() {
    // Manipulate param DOM to read better.  The idea is to replace the "N"
    // in the param name with the label showing the current slider value.
    try {
      var topN   = viz.querySelector("[name=topN]");
      var param  = topN.parentNode;
      var name   = param.querySelector(".vega-param-name");
      var phrase = name.textContent
        .split(/\bN\b/)
        .map(function(t){ return document.createTextNode(t) });

      phrase.splice(1, 0, param.querySelector(".vega-range"));

      name.innerHTML = "";
      phrase.forEach(function(p){ name.appendChild(p) });
    }
    catch (e) {
      console.error("Error manipulating topN param DOM: ", e);
    }
  }
})();
