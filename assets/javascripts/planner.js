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

  acc.children('a').click(function() {
    window.location = jQuery(this).attr('href');
    return false;
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

function plannerChart(data)
{
  var notIE = !jQuery.jqplot.use_excanvas;
  jQuery.jqplot(data.chartid, data.data, {
    animate: jQuery.browser.mozilla,
    stackSeries: true,
    showMarker: false,
    seriesDefaults:{
      shadow: notIE,
      renderer:jQuery.jqplot.BarRenderer,
      pointLabels: { show: true, hideZeros: true, formatString: '%d\%' },
      rendererOptions: {
        animation: {
          speed: 1000
        }
      }
    },
    series: data.series,
    axes: {
      xaxis: {
        renderer: jQuery.jqplot.CategoryAxisRenderer,
        ticks: data.xTicks,
        label: data.xLabel,
        rendererOptions: {
          tickRenderer: jQuery.jqplot.CanvasAxisTickRenderer
        },
        tickOptions:{
          angle: -40
        }
      },
      yaxis: {
        labelRenderer: jQuery.jqplot.CanvasAxisLabelRenderer,
        min: 0,
        max: data.yMax,
        label: data.yLabel,
        tickInterval: data.yTickInterval,
        tickOptions: {
          suffix: '%'
        },
        padMin: 0
      }
    },
    grid: {
      background: 'white',
      drawBorder: false,
      shadow: notIE,
      gridLineWidth: 1
    },
    gridPadding: { left: 65 },
    legend: { show: false },
    canvasOverlay: {
      show: true,
      objects: [
        {
          horizontalLine: {
            y: data.yLimit,
            lineWidth: 2,
            xOffset: 0,
            color: '#2ca02c',
            shadow: false
          }
        }
      ]
    }
  });
  plannerChartLegendHighlight(data.chartid);

  jQuery.jqplot(data.chartid + '-summary', data.threshold_data, {
    stackSeries: true,
    showMarker: false,
    seriesDefaults:{
      shadow: notIE,
      renderer:jQuery.jqplot.BarRenderer,
      pointLabels: { show: true, hideZeros: true, formatString: '%d\%' }
    },
    series: data.threshold_series,
    axes: {
      xaxis: {
        renderer: jQuery.jqplot.CategoryAxisRenderer,
        ticks: data.xWeekTicks
      },
      yaxis: {
        showTicks: false,
        min: 0,
        max: 1
      }
    },
    grid: {
      background: 'white',
      drawBorder: false,
      shadow: notIE,
      gridLineWidth: 1
    },
    gridPadding: { left: 65 },
    legend: { show: false }
  });
}
