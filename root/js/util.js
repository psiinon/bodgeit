
function loadfile(filename){
 var filetype = filename.split('.').pop();
 switch (filetype){
     case "js":
         var insert=document.createElement('script')
         insert.setAttribute("type","text/javascript")
         insert.setAttribute("src", filename)
         break;
    case 'css':
        var insert=document.createElement("link");
        insert.setAttribute("type", "text/css")
        insert.setAttribute("href", filename)
        insert.setAttribute("rel", "stylesheet")
        break;
 }
 if (typeof insert!="undefined")
  document.getElementsByTagName("head")[0].appendChild(insert);
 return false;
}


////The following is from:
//http://stackoverflow.com/questions/316781/how-to-build-query-string-with-javascript

function form_to_params( form )
{
    var output = "";
    var length = form.elements.length
    for( var i = 0; i < length; i++ )
    {
        element = form.elements[i]

        if(element.tagName == 'TEXTAREA' )
        {
                output += "|" + element.name + ":" + element.value; 
        }
        else if( element.tagName == 'INPUT' )
        {
           switch(element.type){
                case 'radio':
                case 'checkbox':
                    if(element.checked && !element.value){
                        output += "|" + element.name + ":on";
                        break;
                    }
                case 'text':
                case 'hidden':
                case 'password':
                    if(element.value)
                        output += "|" + element.name + ":" + element.value;
                break;     
          }
        }
    }
    return output.substring(1);
}


function htmlEntities(str) {
    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}