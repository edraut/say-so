// TODO: remove this class and refactor all subclasses to extend Class, since it's too hard to remember to call super,
// and has been replaced in the anytimeLoad function
var AnytimeLoader = Class.extend({
  init: function(jq_obj){
    this.jq_obj = jq_obj;
    jq_obj.data('anytime_loaded',true);
  }
});
var datePickerLoader = AnytimeLoader.extend({
  init: function(jq_obj){
    jq_obj.datepicker({
      showOtherMonths: true,
      onClose: function(){
        jq_obj.trigger('datechange');
      },
      beforeShowDay: function(date) {
        var reservedDates = $('[data-reserved_days]').data();
        var day = date.getDate();
        var dateTime = date.getTime();
        if (reservedDates != null) {
          var date = jQuery.datepicker.formatDate('yy-mm-dd', date);
          if (null == reservedDates.reserved_days) {
            return [true, "cal_date_available day_" + day, null]
          } else if (reservedDates.reserved_days.indexOf(date) == -1) {
            if (dateTime < new Date().getTime()) {
              return [true, "date_past", null]
            } else {
              return [true, "cal_date_available day_" + day, null]
            }
          } else {
            return [false, "cal_date_resereved", null]
          }
        } else {
          return [true, "cal_date_available day_" + day, null]
        }
      }
    });
  }
})

var frontEndDatePickerLoader = AnytimeLoader.extend({
  init: function($calendar_control){
    $calendar_control.click(function() {
      loadAndFillCal($calendar_control);
      $(".cal_date_resereved span").each(function() { $(this).text("X"); });
      changeFilterBarPosition($calendar_control);
    });
  }
})

var frontEndStartDatePickerLoader = AnytimeLoader.extend({
  init: function($start_date_input) {
    $start_date_input.datepicker({
      inline: true,
      minDate: new Date(),
      dayNamesMin: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],

      beforeShowDay: function(date) {
        var day = date.getDate();
        var dateTime = date.getTime();
        if($('[data-available_days]').data()){
          setTimeout(function(){
            changeDayText(day, date, $('[data-available_days]').data().available_days);
          }, 5);
        }
        if ($('[data-reserved_days]').data() != null) {
          var date = jQuery.datepicker.formatDate('yy-mm-dd', date);
          if ($('[data-reserved_days]').data().reserved_days.indexOf(date) == -1) {
          if (dateTime < new Date().getTime()) {
            return [true, "date_past", null]
          } else {
            return [true, "cal_date_available day_" + day, null]
          }
        } else {
          return [false, "cal_date_resereved", null]
        }
        } else {
          return [true, "cal_date_available day_" + day, null]
        }
      },
      onChangeMonthYear: function(date) {
        if($('[data-reserved_days]').length != 0) {
          setTimeout(function(){
            $(".cal_date_available").not(".date_with_rate").addClass('ui-datepicker-unselectable').addClass('ui-state-disabled');
          }, 250);
        }
      },
      onSelect: function(date){
        dateRearrange = date.split('/')
        dateRearrange.unshift(dateRearrange.pop());
        var tempDate = $start_date_input.datepicker("getDate")
        populateDateText($('.filter-arrival'), $start_date_input);
        if($(".filter").width() > 480) {
          $('.filter-arrival').trigger('change');
        }
      },
      onClose: function(){
       loadAndFillCal($('.filter-departure'));
       changeFilterBarPosition($('.filter-departure'));
      }
    });
  }
})


function ajaxCompleteLoaders(){
  $('[data-browser-push-progress-indicator]').each(function(){
    anytimeLoad($(this),'AjaxBrowserPushConnector');
  })
}

var AjaxPushState = AnytimeLoader.extend({
  init: function(obj) {
    if (obj.data('push-state') != null && obj.data('push-state') != "") {
      history.pushState(null, null, obj.data('push-state'));
    }
  }
});

function anytimeLoaders(){
  $("[data-push-state]").each(function(){
    anytimeLoad($(this),'AjaxPushState');
  });
  $('[data-range_submitter]').each(function(){
    anytimeLoad($(this), getSubClass($(this).data('range_submitter'),'RangeSubmitter'));
  })
  $('.filter-arrival').each(function(){
    anytimeLoad($(this),'frontEndDatePickerLoader');
    anytimeLoad($(this).find('input'),'frontEndStartDatePickerLoader');
  });
  $('.filter-departure').each(function(){
    anytimeLoad($(this),'frontEndDatePickerLoader');
  });
  $("[data-sortable]").each(function(){
    anytimeLoad($(this),'AjaxSorter');
  });
  $('[data-date_picker="admin"]').each(function(){
    anytimeLoad($(this),'datePickerLoader');
  });
  $("[data-hover_overflow]").each(function(){
    anytimeLoad($(this),'HoverOverflow');
  })
  $('[data-hidey_button]').each(function(){
    anytimeLoad($(this), getSubClass($(this).data('hidey_button'),'HideyButton'));
  })
  $('[data-expand_state]').each(function(){
    anytimeLoad($(this), getSubClass($(this).data('expand-class'),'Expandable'));
  })
  $('[data-submit_proxy]').each(function(){
    anytimeLoad($(this),'SubmitProxy')
  })
  $('[data-click_proxy]').each(function(){
    anytimeLoad($(this),'ClickProxy')
  })
  $('[data-end_date]').each(function(){
    anytimeLoad($(this),'StartDateSetter');
  })
  $('[data-field_filler]').each(function(){
    anytimeLoad($(this),getSubClass($(this).data('field_filler'),'FieldFiller'));
  })
  $('[data-listener]').each(function(){
    anytimeRun($(this),browser_push,'addListener');
  })
  $('[data-ajax-browser-push-flash]').each(function(){
    anytimeLoad($(this),'AjaxBrowserPushFlash');
  })
  $('[data-upload_trigger]').each(function(){
    anytimeLoad($(this),getSubClass($(this).data('upload_trigger'),'UploadTrigger'));
  })
  $('[data-upload_csv_trigger]').each(function(){
    anytimeLoad($(this),getSubClass($(this).data('upload_csv_trigger'),'UploadCsvTrigger'));
  })
  $('[data-revealer]').each(function(){
    anytimeLoad($(this),getSubClass($(this).data('revealer'),'Revealer'));
  });
  $('[data-checkbox-hidden-proxy]').each(function(){
    anytimeLoad($(this),getSubClass($(this).data('checkbox-hidden-proxy'),'CheckboxHiddenProxy'));
  });
  $('[data-prevent-double-submit]').each(function(){
    anytimeLoad($(this),'PreventDoubleSubmit')
  });
  $('[data-prevent-double-link-click]').each(function(){
    anytimeLoad($(this),'PreventDoubleLinkClick')
  });
    // Initailizes auto complete for select inputs
  $("[data-autocomplete='full_width']").chosen({
   width: "100%",
   allow_single_deselect: true
  });
  $("[data-autocomplete]").chosen(
    {
      allow_single_deselect: true
    });
};
function anytimeLoad(jq_obj, class_name){
  if(!jq_obj.data('anytime_loaded')){
    jq_obj.data('anytime_loaded',true);
    var this_class = eval(class_name);
    new this_class(jq_obj);
  }
};
function anytimeRun(jq_obj, resource, method_name){
  if(!jq_obj.data('anytime_run')){
    jq_obj.data('anytime_run',true);
    resource[method_name](jq_obj);
  }
}
$(document).ajaxComplete(function(){
  ajaxCompleteLoaders();
  anytimeLoaders();
})
$(document).ready(function(){
  anytimeLoaders();
});
