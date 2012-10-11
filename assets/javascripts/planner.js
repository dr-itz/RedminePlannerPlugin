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
