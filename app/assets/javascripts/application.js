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
var tier_color_map = {
    "-1": 'unknown',
    "0": 'unranked',
    "1": 'bronze',
    "2": 'silver',
    "3": 'gold',
    "4": 'platinum',
    "5": 'diamond',
    "6": 'challenger'
};

var border_classes = "unranked bronze silver gold platinum diamond challenger";

$(document).ready(function(){

    $("#banner").fadeIn(2000).fadeOut({duration: 1400, easing: 'linear'});

    $(".selection").mouseup(function(e){
        $(this).empty();
        var sid = $(this).attr("id")
        if(sid.indexOf("blue") != -1){
            //clicked on a blue team selection
            if(blue_num > 1){ //does blue team have anything on it?
                var max_well = $(blue_side+(blue_num-1)); //last filled slot
                $(this).addClass(max_well.attr("class"))
                    .append(max_well.removeClass(border_classes).children()); //switch the empty one

                blue_num -= 1;
                run_calculation(blue_side);
            }
        }
        if(sid.indexOf("purple") != -1){
            if(purple_num > 1){ //does blue team have anything on it?
                var max_well = $(purple_side+(purple_num-1)); //last filled slot
                $(this).addClass(max_well.attr("class"))
                    .append(max_well.removeClass(border_classes).children()); //switch the empty one

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

    $("#live-search-name").keyup(function(event){
        if(event.keyCode == 13){
            $("#live-button").click();
        }
    });

    $("#live-button").click(function livesearch(){
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
                $("#live-button").toggleClass('active');    
            } else {
                var blue = html._blueteam;
                var purple = html._purpleteam;

                blue_num = 1;
                purple_num = 1;

                $.each(blue, function(index){
                    var tier = blue[index][0];
                    var champion = blue[index][1];
                    var pid = blue[index][2];
                    var tier_color;
                    if(tier == -1){
                        $.ajax({
                            url:"player/"+pid,
                            type: "GET"
                        }).done(function(html){
                            if(html["tier"]){
                                tier_color = html["tier"].toLowerCase();
                            }
                        });
                    } else {
                        tier_color = tier_color_map[tier];
                    }
                    //tier_color = tier_color_map[tier];
                    var image = '<img class="row champ-image" src=' + $(preid + champion).attr("src") + ' data-id=' + champion + '>';
                    var summoner_name = '<div class="row">' + index + '</div>'
                    $(blue_side+blue_num).html(image + summoner_name).toggleClass(tier_color).attr("title", tier_color);
                    blue_num += 1;
                });
                run_calculation(blue_side);

                $.each(purple, function(index){
                    var tier = purple[index][0];
                    var pid = purple[index][2];
                    var tier_color;
                    if(tier == -1){
                        $.ajax({
                            url:"player/"+pid,
                            type: "GET"
                        }).success(function(html){
                            if(html["tier"]){
                                tier_color = html["tier"].toLowerCase();
                            }
                        });
                    } else {
                        tier_color = tier_color_map[tier];
                    }
                    var champion = purple[index][1];
                    var image = '<img class="row champ-image" src=' + $(preid + champion).attr("src") + ' data-id=' + champion + '>';
                    var summoner_name = '<div class="row">' + index + '</div>'
                    $(purple_side+purple_num).html(image + summoner_name).toggleClass(tier_color).attr("title", tier_color);
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

    $.ajax({
        url: "champion/teamcomp/"+champ_ids,
        type: "GET",
        async: false,
        dataType: "json"
    }).success(function(html){
        teamcompat = html["compat"];
    });

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