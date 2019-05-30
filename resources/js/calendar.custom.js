 // most of the code taken from https://github.com/ingoboerner
    //https://github.com/martinantonmueller/Hermann-Bahr_Arthur-Schnitzler/blob/master/app/resources/js/calendar.js
    
 $.ajax({
            cache: true,
            url: "../analyze/calendar_datasource.xql",
            dataType: "json",
            success: function(data) {

                document.getElementById("loader").style.display = "none";
                var $dataSource = [];
                var years = [];
                $.each( data, function( key, entry ) {
                  var $obj = {};
                  var $j = entry.startDate.substring(0,4);
                  var $m = entry.startDate.substring(5,7);
                  var $d = entry.startDate.substring(8,10);
                  $obj.endDate = new Date($j,$m-1,$d);
                  $obj.startDate = new Date($j,$m-1,$d);
                  $obj.id = entry.id;
                  $obj.color = "#254aa5";
                   if (years.indexOf($j) === -1)
                  {
                    years.push($j)   
                  }  
                  $dataSource.push($obj);
                });
                var yearsSorted = years.sort();
                
                $('#calendar').calendar({
                    dataSource: $dataSource,
                    startYear: 1900,
                    language: "de",
                    renderEnd: function(e) {
                        $(".yearbtn").removeClass("focus");
                        $(".yearbtn[value="+e.currentYear+"]").addClass("focus");
                        if ($(".yearscol").css("visibility") === "hidden") {
                            $(".yearscol").css("visibility","visible");
                        }
                    }
                });
                
                for (var i = 0; i <= yearsSorted.length; i++){
                    $('#years-table').append(createyearcell(yearsSorted[i]) +createyearcell(yearsSorted[i+1])+createyearcell(yearsSorted[i+2]));
                    i += 3;
                }
    
                $('#calendar').clickDay(function(e){
                    var ids = []
                    $.each(e.events, function( key, entry ) {
                        ids.push(entry.id)
                    });
                    window.location = ids.join()
                });
            }
            });
            function createyearcell(val) {
                return (val !== undefined) ? '<div class="col-xs-6">\
            <button class="btn btn-light yearbtn" value="'+val+'" onclick="updateyear(this.value)">'+val+'</button>\
        </div>' : '' 
            }
                
            function updateyear(year) {
                $('#calendar').data('calendar').setYear(year);
            }