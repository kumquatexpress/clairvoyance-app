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

    $("#banner").fadeIn(2000).fadeOut({duration: 1400, easing: 'linear'});

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
            var image = '<img class="champ-image" src=' + src + ' data-id=' + html[0].id + '>';

            $(whichside+whichnum).html(image);
            if(whichside == blue_side){
                blue_num += 1;
            } else {
                purple_num += 1;
            }
            run_calculation(whichside);
        });
    });

    $(".filter").click(function(){
        var type = $(this).attr("id");
        var icons = $(".champion-select");
        if(type == "all"){
            icons.css("display","inline");
        } else {
            icons.each(function(index, icon){
                if(icon.attributes.datatype.value.split(",").indexOf(type) == -1){
                    icon.style.display = "none";
                } else {
                    icon.style.display = "inline";
                }
            });
        }
        $("#banner").html(type).fadeIn(1000).fadeOut(2500);
    });

});

function run_calculation(side){
    var lastchamp;
    var champ_ids = [];
    var teamcompat;
    var indv_compats = [];
    var detail_box;

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
    for(var i = 0; i < champ_ids.length; i++){
        var cid1 = champ_ids[i];
        var c1;
        for(var j = i; j < champ_ids.length; j++){
            var cid2 = champ_ids[j];
            var c2;
            var games;
            var wins;
            $.ajax({
                url: "champion/compatibility/"+cid1+"/"+cid2,
                type: "GET",
                async: false,
                dataType: "json",
            }).success(function(html){
                indv_compats.push(html.compat);
                games = html.num_games;
                wins = html.wins;

                c1 = html.c1;
                c2 = html.c2;
            });
        }
    }   

    teamcompat = Math.pow(indv_compats.reduce(function(a,b){return a*b;}), 1/(indv_compats.length));

    $(side+"compat").html(Math.round(teamcompat*10000)/100).fadeIn(500);

}

function runsearch(){
    var substring = $("#searchbar").val().toLowerCase();
    var icons = $(".champion-select");
    if(substring == ""){
        icons.css("display","inline");
    } else {
        icons.each(function(index, icon){
            if(icon.attributes.title.value.toLowerCase().indexOf(substring) == -1){
                icon.style.display = "none";
            } else {
                icon.style.display = "inline";
            }
        });
    }
    $("#banner").html(substring).fadeIn(500);
}

function livesearch(){
    var name = $("#live-search-name").val().split(' ').join('_');
    var preid = "#champ-pic";

    $("#live-button").toggleClass('active');

    $.ajax({
        url: "live/"+name,
        type: "GET",
        async: true,
        dataType: "json",
    }).success(function(html){
        if(!html){
            var errormsg = "Summoner not found";
            $("#banner").html(errormsg).fadeIn(500).fadeOut(500);         
        } else {
            var blue = html._blueteam;
            var purple = html._purpleteam;

            blue_num = 1;
            purple_num = 1;

            $.each(blue, function(index){
                var image = '<img class="champ-image" src=' + $(preid + blue[index]).attr("src") + ' data-id=' + blue[index] + '>';
                $(blue_side+blue_num).html(image);
                blue_num += 1;
            });
            run_calculation(blue_side);

            $.each(purple, function(index){
                var image = '<img class="champ-image" src=' + $(preid + purple[index]).attr("src") + ' data-id=' + purple[index] + '>';
                $(purple_side+purple_num).html(image);
                purple_num += 1;
            });    
            run_calculation(purple_side);

            $("#live-button").toggleClass('active');
        }    
    }).error(function(html){
        var errormsg = "Not in a game";
        $("#banner").html(errormsg).fadeIn(500).fadeOut(500);    

        $("#live-button").toggleClass('active');
    });    
}