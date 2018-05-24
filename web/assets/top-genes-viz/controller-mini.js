// vim: set ts=2 sw=2 :
(function(){
  'use strict';

  var viz  = document.querySelector("#top-genes-viz-mini"),
      spec = TopGenesVizMini.Spec;

  vg.parse.spec(spec, function(error, chart) {
    if (error) {
      console.error("Error parsing Vega spec: " + error);
      return;
    }

    // Create Vega view for this visualization spec.  The view is
    // stashed on the DOM element for easier debugging.
    var view = viz.view = chart({ el: viz, renderer: "svg" });

    // Register handler with click signal
    view.onSignal("click", gotoGene);


    // Sync initial width
    view.width(viz.clientWidth).update();

    // Resize dynamically
    var timeout;
    window.addEventListener("resize", function(){
      if (timeout)
        clearTimeout(timeout);

      // Only re-render the view every 200ms at most
      timeout = setTimeout(
        function(){ view.width(viz.clientWidth).update() },
        200
      );
    }, false);


    // Find gene names elsewhere in the page and link them to the highlight signal
    toArray( document.querySelectorAll("[data-gene]") ).forEach(function(el) {
      if (!el.dataset.gene)
        return;
      el.addEventListener("mouseover", function(){ view.signal("highlight", this.dataset.gene).update() }, false);
      el.addEventListener("mouseout",  function(){ view.signal("highlight", null).update()              }, false);
    });

  });

  function gotoGene(signal, datum) {
    if (datum.ncbi_gene_id)
      window.location.href = 'https://www.ncbi.nlm.nih.gov/gene/' + datum.ncbi_gene_id
  }

  function toArray(x) {
    return [].slice.call(x);
  }

})();
