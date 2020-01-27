/*https://www.sitepoint.com/url-parameters-jquery/*/
$.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results==null){
       return null;
    }
    else{
       return results[1] || 0;
    }
}

/*http://stackoverflow.com/questions/5448545/how-to-retrieve-get-parameters-from-javascript*/
function findGetParameter(parameterName) {
    var result = null,
        tmp = [];
    var items = location.search.substr(1).split("&");
    for (var index = 0; index < items.length; index++) {
        tmp = items[index].split("=");
        if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
    }
    return result;
}

/*script for loading the content of the modal */
$(document).ready(function(){
   var trigger = $('a[data-key],a[data-keys]');
   $(trigger).click(function(){
   var dataType = $( this ).attr('data-type');
   var dataKey = $( this ).attr('data-key');
   var dataKeys = $( this ).attr('data-keys');
   // if (dataKeys != undefined && dataKeys != "" && dataKeys != null){
   if(dataKeys != undefined){
      let html = "<div id='linksModal' tabindex='-1' class='modal' role='dialog' aria-labelledby='modal-label'>";
      html = html + "<div class='modal-dialog modal-sm' role='document'>";
      html = html + "<div class='modal-content'>";
      html = html + "<div class='modal-header'>";
      html = html + "<h3 class='modal-title' id='modal-label'>Links</h3></div>";
      html = html + "<div class='modal-body'>";
      let keys = dataKeys.split(' ');
      if(dataType != undefined){
          for (let j = 0; j < keys.length; j++){
              keys[j] = keys[j].substring(1,keys[j].length); // Remove hash
          }
      }
      let linkTitles = [];
      let promises = [];
      for (let i = 0; i < keys.length; i++){
          let dataTypeInKey = '';
          let key = '';
          if(dataType != undefined){
              dataTypeInKey = dataType;
              key = keys[i];
          }
          else {
            if (keys[i].startsWith('work')){ dataTypeInKey = 'listwork.xml'; key = keys[i].substring(5,keys[i].length); }
            else if (keys[i].startsWith('org')){ dataTypeInKey = 'listorg.xml'; key = keys[i].substring(4,keys[i].length); }
            else if (keys[i].startsWith('person')){ dataTypeInKey = 'listperson.xml'; key = keys[i].substring(7,keys[i].length); }
            else if (keys[i].startsWith('place')){ dataTypeInKey = 'listplace.xml'; key = keys[i].substring(6,keys[i].length); }
          }
          let linkTitle = '';
          let url = "showNoTemplate.html?directory=indices&document=" + dataTypeInKey + "&entiyID=" + key;
          promises[i] = $.get(url,function(data){
                let parser = new DOMParser();
                let contentAsDOM = parser.parseFromString(data, "text/html");
                linkTitle = contentAsDOM
                    .getElementsByTagName('div')[0]
                    .getElementsByTagName('div')[0]
                    .getElementsByTagName('div')[0]
                    .getElementsByTagName('div')[1]
                    .getElementsByTagName('table')[0]
                    .getElementsByTagName('tr')[0]
                    .getElementsByTagName('td')[0].childNodes[0].nodeValue;
                linkTitles.push(linkTitle);
          });
          promises[i].always(function(){
            let anchor = "<div><a data-type='" + dataTypeInKey + "' data-key='" + key + "'>" + linkTitle + "</a></div>";
            html = html + anchor;
          });
      }
      Promise.all(promises).then(function(){
        html = html + "</div><div class='modal-footer'><button onclick='$(`#linksModal`).modal(`hide`);$(`#linksModal`).remove();' type='button' class='btn btn-secondary' data-dismiss='modal'>Close</button></div>" + "</div></div></div>";
        $('#linksModal').remove();
        $('#loadModal').append(html);
        $('#linksModal').modal('show');
        $('#linksModal').focus();
              
        let handlesForModalLinks = $('#linksModal div div a');
        console.log(handlesForModalLinks);
        $(handlesForModalLinks).each(function(){$(this).click(function(){
            let dataType = $( this ).attr('data-type');
            let dataKey = $( this ).attr('data-key');
            let baseUrl = "showNoTemplate.html?directory=indices&document=";
            let url = baseUrl + dataType + "&entiyID=" + dataKey;
            $('#loadModal').load(url, function(){
                $('.modal-backdrop').remove();
                $('#linksModal').remove();
                $('#myModal').modal('show');
            });
        });
        });
      });
   }
   else{
       var xsl = dataType.replace(".xml", "");
       var baseUrl = "showNoTemplate.html?directory=indices&document="
       var url = baseUrl+dataType+"&entiyID="+dataKey;
       $('#loadModal').load(url, function(){
       $('#myModal').modal('show');
       });
   }
   });
});