function miniAccordion(topdiv)
{
  var acc = jQuery('#' + topdiv + ' .accordion-header');
  acc.addClass('collapsed').next('.accordion-content').addClass('collapsed').hide();

  acc.click(function() {
    var me = jQuery(this);
    var other = me.siblings('.accordion-header');

    other.removeClass('expanded').addClass('collapsed');
    other.next('.expanded').hide(300).removeClass('expanded').addClass('collapsed');

    me.toggleClass('expanded collapsed').next('.accordion-content').slideToggle(300).toggleClass('expanded collapsed');
  });
}

function plannerChartLegendHighlight(chartid)
{
  jQuery('#' + chartid).bind('jqplotDataHighlight', function(ev, idx, pointIndex, data) {
    var legend = jQuery('#' + chartid + '-legend tr.jqplot-table-legend');
    legend.removeClass('legend-row-highlighted');
    legend.children('.jqplot-table-legend-label').removeClass('legend-text-highlighted');
    legend.eq(idx).addClass('legend-row-highlighted');
    legend.eq(idx).children('.jqplot-table-legend-label').addClass('legend-text-highlighted');
  });

  jQuery('#' + chartid).bind('jqplotDataUnhighlight', function(ev, seriesIndex, pointIndex, data) {
    var legend = jQuery('#' + chartid + '-legend tr.jqplot-table-legend');
    legend.removeClass('legend-row-highlighted');
    legend.children('.jqplot-table-legend-label').removeClass('legend-text-highlighted');
  });
}
