function byId(e){return document.getElementById(e);}
function newEl(tag){return document.createElement(tag);}
function newTxt(txt){return document.createTextNode(txt);}
function hide(e) {
  var contentId = document.getElementById(e);
  contentId.style.display = "none";
}
//  random hex string generator
function randHex(len) {
  var maxlen = 8,
      min = Math.pow(16,Math.min(len,maxlen)-1)
      max = Math.pow(16,Math.min(len,maxlen)) - 1,
      n   = Math.floor( Math.random() * (max-min+1) ) + min,
      r   = n.toString(16);
  while ( r.length < len ) {
     r = r + randHex( len - maxlen );
  }
  return r;
};

function insertAndExecute(id, text) {
  byId(id).innerHTML = text;
  var scripts = Array.prototype.slice.call(byId(id).getElementsByTagName("script"));
  for (var i = 0; i < scripts.length; i++) {
    if (scripts[i].src != "") {
      var tag = newEl("script");
      tag.src = scripts[i].src;
      document.getElementsByTagName("head")[0].appendChild(tag);
    }
    else {
      eval(scripts[i].innerHTML);
    }
  }
}

function load(target, url) {
  AjaxRequest.get(
    {
      'url':url,
      'onSuccess':function(req){ insertAndExecute(target, req.responseText); }
    }
  );
}

var W3CDOM = (document.createElement && document.getElementsByTagName);

function initFileUploads(opt) {
  if (!W3CDOM) return;
  var fakeFileUpload = document.createElement('div');
    fakeFileUpload.className = 'kablam_fakefile';
  var upload_icon = document.createElement('i');
    upload_icon.className = opt['icon'];
    upload_icon.innerText = "Upload file here..."

  var input = document.createElement('input');
    input.type = "text";
    input.className = opt['class'];

  fakeFileUpload.appendChild(upload_icon);
  fakeFileUpload.appendChild(input);

  var x = document.getElementsByClassName('kablam_file');
  for (var i=0;i<x.length;i++) {
    if (x[i].type != 'file') continue;
    if (x[i].parentElement.className != 'kablam_fileinput_init') continue;

    x[i].parentElement.className = 'kablam_fileinputs';
    var clone = fakeFileUpload.cloneNode(true);
    x[i].parentElement.appendChild(clone);
    x[i].relatedElement = clone.getElementsByTagName('input')[0];
    x[i].onchange = x[i].onmouseout = function () {
      path = this.value
      path = path.replace( /fakepath\\/, '...' );
      path = path.replace('C:\\', '');
      this.relatedElement.value = path;
    }
  }
}

function addInput(id, name, classes){
  var input_set = document.getElementById(id);
  var new_set = document.createElement('div');
    new_set.id = randHex(12);
    new_set.className = classes['group'];

  var input = document.createElement('input');
    input.type = "text";
    input.className = classes['input'];
    input.name = name;
  var button = document.createElement('a');
    button.className = classes['btn'];
    button.setAttribute("onclick", "event.preventDefault();rmParent(this);");
  var icon = document.createElement('i');
    icon.className = classes['icon'];

  button.appendChild(icon);
  new_set.appendChild(input);
  new_set.appendChild(button);
  input_set.appendChild(new_set);
}

function rmParent(el){
  el.parentElement.remove();
}


Object.defineProperty(HTMLElement, 'From', {
    enumerable: false,
    value: (function (document) {
        //https://www.measurethat.net/Benchmarks/Show/2149/0/element-creation-speed
        var rgx = /(\S+)=(["'])(.*?)(?:\2)|(\w+)/g;
        return function CreateElementFromHTML(html) {
            html = html.trim();
            var bodystart = html.indexOf('>') + 1, bodyend = html.lastIndexOf('<');
            var elemStart = html.substr(0, bodystart);
            var innerHTML = html.substr(bodystart, bodyend - bodystart);
            rgx.lastIndex = 0;
            var elem = document.createElement(rgx.exec(elemStart)[4]);
            var match; while ((match = rgx.exec(elemStart))) {
                if (match[1] === undefined) {
                    elem.setAttribute(match[4], "");
                } else {
                    elem.setAttribute(match[1], match[3]);
                }
            }
            elem.innerHTML = innerHTML;
            return elem;
        };
    }(window.document))
});


function submitRemove(form_id){
  var form = document.getElementById(form_id);
  form.addEventListener("ajax:success", function(e) {
    e.preventDefault();
    form.remove();
  });
}

function submitRedirect(form_id){
  var form = document.getElementById(form_id),
      path = document.getElementById(form_id+'_redirect').value;
  form.addEventListener("ajax:success", function(e) {
    e.preventDefault();
    Turbolinks.visit(path);
  });
}


function submitToTop(form_id){
  var form = document.getElementById(form_id);
  form.addEventListener("ajax:success", function(e) {
    e.preventDefault();
    scrollToTop(500);
  });
}

function scrollToTop(scrollDuration) {
const   scrollHeight = window.scrollY,
        scrollStep = Math.PI / ( scrollDuration / 15 ),
        cosParameter = scrollHeight / 2;
var     scrollCount = 0,
        scrollMargin,
        scrollInterval = setInterval( function() {
            if ( window.scrollY != 0 ) {
                scrollCount = scrollCount + 1;
                scrollMargin = cosParameter - cosParameter * Math.cos( scrollCount * scrollStep );
                window.scrollTo( 0, ( scrollHeight - scrollMargin ) );
            }
            else clearInterval(scrollInterval);
        }, 15 );
}

function toggle_visibility(id) {
   var e = document.getElementById(id);
      e.style.display = 'none';
}
