
function $(id) { return document.all ? document.all[id] : document.getElementById(id); }

function mWriteLoadingGif() { return '<img src="/img/ico/loading.gif" />' }

/*При виборі регіону*/
function RegionAsync(id, cmd, code = "") {

    var container = $(id);
    container.innerHTML = mWriteLoadingGif();
    
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            container.innerHTML = this.responseText;
            var myScripts = container.getElementsByTagName("script");
            if (myScripts.length > 0) {
                eval(myScripts[0].innerHTML);
            }
        }
    };

    xhttp.open("GET", "async.aspx?cmd=" + cmd + "&code=" + code, true);
    xhttp.send();
}
