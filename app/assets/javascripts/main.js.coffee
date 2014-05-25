$ ->
  "use strict"

  ajax_loader = image_path('ajax-loader.gif')

  $('.inner .row.sort').sortable();
  $('[colourpicker=true]').colorpicker();


  responsiveHelper = `undefined`
  breakpointDefinition =
    tablet: 1024
    phone: 480

  tableElement = $('.dataTable')

  tableElement.dataTable({
    "sDom": "<'row'<'col-md-12'<'pull-right datatables-menu'il>>>t<'row'<'col-lg-6'f><'col-lg-6'p>>"
    "sPaginationType": "bootstrap"
    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100,"All"]]
    "oLanguage":
      "sLengthMenu": "_MENU_ entries per page"
      "sInfo": "Listing (_START_ to _END_) of _TOTAL_ entries"
    "iDisplayLength": 100
    "bAutoWidth": false
    "sScrollX": "100%"
    fnPreDrawCallback: ->
      # Initialize the responsive datatables helper once.
      responsiveHelper = new ResponsiveDatatablesHelper(tableElement, breakpointDefinition) unless responsiveHelper

    fnRowCallback: (nRow) ->
      responsiveHelper.createExpandIcon nRow

    fnDrawCallback: (oSettings) ->
      responsiveHelper.respond()
  }).columnFilter()

  tableElement2 = $('.dataTable2')

  tableElement2.dataTable({
    "sDom": "<'row'<'col-md-12'<'pull-left'f><'pull-right datatables-menu'il>>><'row'<'col-md-12'<'pull-right'p>>>t"
    "sPaginationType": "bootstrap"
    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100,"All"]]
    "oLanguage":
      "sLengthMenu": "_MENU_ entries per page"
      "sInfo": "Listing (_START_ to _END_) of _TOTAL_ entries"
    "iDisplayLength": 100
    "bAutoWidth": false
    "sScrollX": "100%"
    fnPreDrawCallback: ->
      # Initialize the responsive datatables helper once.
      responsiveHelper = new ResponsiveDatatablesHelper(tableElement2, breakpointDefinition) unless responsiveHelper

    fnRowCallback: (nRow) ->
      responsiveHelper.createExpandIcon nRow

    fnDrawCallback: (oSettings) ->
      responsiveHelper.respond()
  }).columnFilter()

  tableElement3 = $('.dataTable3')

  tableElement3.dataTable({
    "sDom": "t<'row'<'col-lg-3'f><'col-lg-9'p>>"
    "sPaginationType": "bootstrap"
    "oLanguage":
      "sLengthMenu": "_MENU_ entries per page"
      "sInfo": "Listing (_START_ to _END_) of _TOTAL_ entries"
    "iDisplayLength": 6
    "bAutoWidth": false
    "sScrollX": "100%"
    "aoColumns": [{sWidth: "30%"}, {sWidth: "70%"}]
    fnPreDrawCallback: ->
      # Initialize the responsive datatables helper once.
      responsiveHelper = new ResponsiveDatatablesHelper(tableElement3, breakpointDefinition) unless responsiveHelper

    fnRowCallback: (nRow) ->
      responsiveHelper.createExpandIcon nRow

    fnDrawCallback: (oSettings) ->
      responsiveHelper.respond()
  }).columnFilter()


  tableElementUsers = $('#dataTableUsers')
  tableElementUsers.dataTable({
    "sDom": "<'row'<'col-md-12'<'pull-left'f>r<'pull-right datatables-menu'il>>><'row'<'col-md-12'<'pull-right'p>>>t<'row'<'col-md-12'<'pull-left'f><'pull-right datatables-menu'il>>><'row'<'col-md-12'<'pull-right'p>>>"
    "sPaginationType": "bootstrap"
    "aLengthMenu": [[10, 25, 50, 100], [10, 25, 50, 100]]
    "aoColumnDefs":[{
      "bSortable": false
      "aTargets": ["no-sort"]
    }]
    "oLanguage":
      "sProcessing": "<div class='alert alert-info' id='ajax-loader'>Processing data... <img src='" + ajax_loader + "' /></div>"
      "sLengthMenu": "_MENU_ entries per page"
      "sInfo": "Listing (_START_ to _END_) of _TOTAL_ entries"
    "iDisplayLength": 100
    "bAutoWidth": false
    "sScrollX": "100%"
    "bProcessing": true
    "bServerSide": true
    "sAjaxSource": $('#dataTableUsers').data('source')
    fnPreDrawCallback: ->
      # Initialize the responsive datatables helper once.
      responsiveHelper = new ResponsiveDatatablesHelper(tableElementUsers, breakpointDefinition) unless responsiveHelper

    fnRowCallback: (nRow) ->
      responsiveHelper.createExpandIcon nRow

    fnDrawCallback: (oSettings) ->
      responsiveHelper.respond()
  }).columnFilter()

  $('.chosen').chosen
    width: "100%"
    allow_single_deselect: true

  $('input.datetimepicker').datetimepicker
    useSeconds: false
    format: 'YYYY-MM-DD H:mm:ss'

  $(".cleditor").cleditor()

  #----------- BEGIN uniform CODE -------------------------#
  $('[type=checkbox], [type=radio]').uniform()
  #----------- END uniform CODE -------------------------#

  $("a[href=#]").on "click", (e) ->
    e.preventDefault()

  $("a[data-toggle=tooltip]").tooltip()
  $("a[data-tooltip=tooltip]").tooltip()
  $(".minimize-box").on "click", (e) ->
    e.preventDefault()
    $icon = $(this).children("i")
    if $icon.hasClass("icon-chevron-down")
      $icon.removeClass("icon-chevron-down").addClass "icon-chevron-up"
    else $icon.removeClass("icon-chevron-up").addClass "icon-chevron-down"  if $icon.hasClass("icon-chevron-up")

  $(".close-box").click ->
    $(this).closest(".box").hide "slow"

  $("#changeSidebarPos").on "click", (e) ->
    $("body").toggleClass "hide-sidebar"

  $("li.accordion-group > a").on "click", (e) ->
    $(this).children("span").children("i").toggleClass "icon-angle-down"

  $("#inline-validate").validate
    addClassRules:
      required: "required"
      email:
        required: true
        email: true

      date:
        required: true
        date: true

      url:
        required: true
        url: true
      youtube_id:
        minlength: 8
        maxlength: 13
      password_check:
        required: true
        minlength: 5

      confirm_password_check:
        required: true
        minlength: 5
        equalTo: "#password"

      agree: "required"
      minsize:
        required: true
        minlength: 3

      maxsize:
        required: true
        maxlength: 6

      minNum:
        required: true
        min: 3

      maxNum:
        required: true
        max: 16

    errorClass: "help-block col-lg-6"
    errorElement: "span"
    highlight: (element, errorClass, validClass) ->
      $(element).parents(".form-group").removeClass("has-success").addClass "has-error"

    unhighlight: (element, errorClass, validClass) ->
      $(element).parents(".form-group").removeClass("has-error").addClass "has-success"

  $('#scrollTop').on 'click', ()->
    $('body, html').animate({ scrollTop: 0 }, 'slow')
    false;
  
  $('#chat-messages').on 'click', ()->
    $('#layouts-chat-widget').dialog();
    $.ajax
      type: "PUT"
      url: "/read_all_booth_user_chats"
      success: (chat_resource) ->
        $("#chat-messages .unread-msgs").html(0).removeClass('label-danger').addClass('label-success')
        return