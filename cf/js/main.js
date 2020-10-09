/*
	Megacount Template Scripts
*/

(function($){ "use strict";
             
// Preloader
var width = 100,
    perfData = window.performance.timing, // The PerformanceTiming interface represents timing-related performance information for the given page.
    EstimatedTime = -(perfData.loadEventEnd - perfData.navigationStart),
    time = parseInt((EstimatedTime/1000)%60)*100;

// Loadbar Animation
$(".loadbar").animate({
  width: width + "%"
}, time);

// Loadbar Glow Animation
$(".glow").animate({
  width: width + "%"
}, time);

// Percentage Increment Animation
var PercentageID = $("#precent"),
        start = 0,
        end = 100,
        durataion = time;
        animateValue(PercentageID, start, end, durataion);
        
function animateValue(id, start, end, duration) {
  
    var range = end - start,
      current = start,
      increment = end > start? 1 : -1,
      stepTime = Math.abs(Math.floor(duration / range)),
      obj = $(id);
    
    var timer = setInterval(function() {
        current += increment;
        $(obj).text(current + "%");
      //obj.innerHTML = current;
        if (current == end) {
            clearInterval(timer);
        }
    }, stepTime);
}

// Fading Out Loadbar on Finised
setTimeout(function(){
  $('.preloader-wrap').fadeOut(300);
}, time);


/*=========================================================================
	NiceScroll Active
=========================================================================*/
    $(window).on('load', function() {
        $("#sidebar-wrap").niceScroll(".scrollbar-wrap",{
            background: "#ddd",
            cursorcolor:"#f9b701",
            cursorwidth:"8px",
            scrollspeed: 30,
            mousescrollstep: 60,
            cursorborder:"0px solid #eaeaea",
            cursorborderradius: "50px",
            autohidemode: false,
            zindex: "999"
        });  
    });
             
// Tooltip Active
    $('[data-toggle="tooltip"]').tooltip();
             
/*=========================================================================
    Subscribe Form
=========================================================================*/
    $('.subs-btn').on('click', function (event) {
        event.preventDefault();
        var name_attr = [];
        var values = [];
        var fs_process = "";
        if($(this).closest("section").attr('id') !== undefined)
        {
            var section_id = $(this).closest("section").attr('id');
        }else{
            var section_id = $(this).closest("section").attr('id');
        }
        var submit_loader = '<div class="loading text-blue display-inline-block ml-10" id="loading">Loading...</div>';
        $('#' + section_id).find('form').find('button').after(submit_loader);
        $('#' + section_id).find('form input').each(
            function (index) {
                
                if ($(this).is('[data-email="required"]')) {
                    var required_val = $(this).val();
                    if (required_val != '') {
                        name_attr.push($(this).attr('name'));
                        values.push($(this).val());
                        fs_process = true;
                    } else {
                        $('#loading').remove();
                        $(this).addClass('fs-input-error');
                        fs_process = false;
                    }
                }

                if (!$(this).is('[data-email="required"]')) {
                    name_attr.push($(this).attr('name'));
                    values.push($(this).val());
                }

            });
        
        if (fs_process) 
        {
            localStorage.setItem('fs-section',section_id);
            $.post("mail/process.php", {
                data: { input_name: name_attr,values:values,section_id:section_id},
                type: "POST",
            }, function (data) {
                $('#loading').remove();
                var fs_form_output = '';
                if(data) 
                {
                    if(data.type == "fs-message") 
                    {
                       $('#error-msg').remove(); 
                       $('#success-msg').remove();
                       var fs_form_output = '<div id="success-msg" class="padding-15 mt-15 bdrs-3" style="border: 1px solid green; color: green;">'+data.text+'</div>';
                    }else if (data.type == "fs_error") {
                        $('#success-msg').remove();
                        $('#error-msg').remove(); 
                        var fs_form_output = '<div id="error-msg" class="padding-15 mt-15 bdrs-3" style="border: 1px solid red; color: red;">'+data.text+'</div>';
                    }else{
                        var fs_form_output = '';
                    } 
                }

                if(fs_form_output != '')
                {
                    var section_id = localStorage.getItem('fs-section');
                    $('#'+section_id).find('form').after(fs_form_output);
                }
                $('#' + section_id).find('form input').each(function (index) {
                    $(this).val('');
                    $(this).removeClass('fs-input-error');
                });

                setTimeout(function(){
                    $('#success-msg').fadeOut();
                    $('#success-msg').remove();
                    $('#error-msg').fadeOut();
                    $('#error-msg').remove();
                    $(this).submit();
                 },5000);
                localStorage.removeItem('fs_section');
            }, 'json');
        }
        
        $('#' + section_id).find('form input').each(function (index) {
            $(this).keypress(function () {
                $(this).removeClass('fs_input_error');
            });
        });

        $('#' + section_id).find('form input').each(function (index) {
            if ($(this).is(":focus")) {
                $(this).removeClass('fs_input_error');
            }
        });

    });

})(jQuery);
