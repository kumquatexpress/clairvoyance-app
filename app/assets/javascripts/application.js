// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var blue_num = 1;
var purple_num = 1;
var blue_side = "#blue";
var purple_side = "#purple";

$(document).ready(function(){
    $("#banner").fadeOut({duration: 1400, easing: 'linear'});

    $(".selection").mouseup(function(e){
        $(this).empty();
        var sid = $(this).attr("id")
        if(sid.indexOf("blue") != -1){
            //clicked on a blue team selection
            if(blue_num > 1){ //does blue team have anything on it?
                var max_well = $(blue_side+(blue_num-1)); //last filled slot
                $(this).append(max_well.find("img")); //switch the empty one

                blue_num -= 1;
                run_calculation(blue_side);
            }
        }
        if(sid.indexOf("purple") != -1){
            if(purple_num > 1){ //does blue team have anything on it?
                var max_well = $(purple_side+(purple_num-1)); //last filled slot
                $(this).append(max_well.find("img")); //switch the empty one

                purple_num -= 1;
                run_calculation(purple_side);
            }
        }
    });

    $(".champion-select").mouseup(function(e){
        var src = $(this).find("img").attr("src");
        var whichside = blue_side;
        var whichnum = blue_num;
        var name = $(this).attr("id");
        switch(e.which){
            case 1:
            whichside = blue_side;
            whichnum = blue_num;
            break;
            case 3:
            whichside = purple_side;
            whichnum = purple_num;
            break;
            default:
            break;
        }
        if(whichnum == 6){
            return;
        }

        $.ajax({
            url: "champion/"+name,
            type: "GET",
            dataType: "json",
        }).success(function(html){
            var image = '<img src=' + src + ' data-id=' + html[0].id + '>';

            $(whichside+whichnum).html(image);
            if(whichside == blue_side){
                blue_num += 1;
            } else {
                purple_num += 1;
            }
            run_calculation(whichside);
        });
    });
});

function run_calculation(side){
    var lastchamp;
    var champ_ids = [];
    var teamcompat;
    var indv_compats = [];

    if(side == purple_side){
        lastchamp = purple_num;
    } else {
        lastchamp = blue_num;
    }
    $(side+"compat").fadeOut(500);

    if(lastchamp < 2){
        $(side+"compat").html("").fadeIn(500);
    }

    for(var i = 1; i < lastchamp; i++){
        champ_ids.push($(side + i + " img").attr("data-id"));
    }
    champ_ids.forEach(function(cid1){
        var champ_compat = 0;
        champ_ids.forEach(function(cid2){
            $.ajax({
                url: "champion/compatibility/"+cid1+"/"+cid2,
                type: "GET",
                async: false,
                dataType: "json",
            }).success(function(html){
                champ_compat += html.compat;
            });
        });
        indv_compats.push(champ_compat);

    });

    teamcompat = indv_compats.reduce(function(a,b){return a*b;});
    $(side+"compat").html(Math.round(teamcompat*10000)/100).fadeIn(500);

}