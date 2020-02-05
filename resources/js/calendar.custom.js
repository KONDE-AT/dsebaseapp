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
                  $obj.color = "#A63437";
                   if (years.indexOf($j) === -1)
                  {
                    years.push($j)   
                  }  
                  $dataSource.push($obj);
                });
                var yearsSorted = years.sort();
                
                
                
                $('#calendar').calendar({
                    dataSource: $dataSource,
                    startYear: 1893,
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
                    i += 2;
                }
    
                $('#calendar').clickDay(function(e){
                    var ids = []
                    $.each(e.events, function( key, entry ) {
                        ids.push(entry.id)
                    });
                    //window.location = ids.join();
                    if(ids.length > 1){
                        let html = "<div class='modal' id='dialogForLinks' tabindex='-1' role='dialog' aria-labelledby='modalLabel' aria-hidden='true'>";
                        html += "<div class='modal-dialog' role='document'>";
                        html += "<div class='modal-content'>";
                        html += "<div class='modal-header'>";
                        html += "<h3 class='modal-title' id='modalLabel'>Links</h3>";
                        html += "<button type='button' class='close' data-dismiss='modal' aria-label='Close'>";
                        html += "<span aria-hidden='true'>&times;</span>";
                        html += "</button></div>";
                        html += "<div class='modal-body'>";
                        let promises = [];
                        for (let i = 0; i < ids.length; i++){
                            let linkTitle = '';
                            let url = ids[i];
                            promises[i] = $.get(url);
                            promises[i].then(function(data){
                                let parser = new DOMParser();
                                let contentAsDOM = parser.parseFromString(data, "text/html");
                                linkTitle = contentAsDOM.getElementById('content')
                                .getElementsByTagName('div')[0]
                                .getElementsByTagName('div')[0]
                                .getElementsByTagName('div')[0]
                                .getElementsByTagName('div')[0]
                                .getElementsByTagName('div')[1]
                                .getElementsByTagName('h2')[0].innerHTML;
                                console.log(linkTitle);
                                html += "<div><a href='" + ids[i] + "'>" + linkTitle + "</a></div>";
                            });
                        }
                        Promise.all(promises).then(function(){
                            html += "</div>";
                            html += "<div class='modal-footer'>";
                            html += "<button type='button' class='btn btn-secondary' data-dismiss='modal'>Close</button>";
                            html += "</div></div></div></div>";
                            $('#dialogForLinks').remove();
                            $('#loadModal').append(html);
                            $('#dialogForLinks').modal('show');
                        });
                    }
                    else { window.location = ids.join(); }
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