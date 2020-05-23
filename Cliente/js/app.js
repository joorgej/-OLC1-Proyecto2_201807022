
var archivos = [];

var tabsA = 1;
var tabsB = 1;

var tabPrimaria = "";
var tabSecundaria = "";

const openDocsA = document.getElementById("inputPrimaria");
openDocsA.addEventListener("change", leerPrimaria, false);
const openDocsB = document.getElementById("inputSecundaria");
openDocsB.addEventListener("change", leerSecundaria, false);

function leerPrimaria(e) {
  var archivo = e.target.files[0];
  if (!archivo) {
    return;
  }
  var lector = new FileReader();
  lector.onload = function (e) {
    var contenido = e.target.result;
    mostrarContenido(contenido, archivo.name, 1);
  };
  lector.readAsText(archivo);
}

function leerSecundaria(e) {
  var archivo = e.target.files[0];
  if (!archivo) {
    return;
  }
  var lector = new FileReader();
  lector.onload = function (e) {
    var contenido = e.target.result;
    mostrarContenido(contenido, archivo.name, 2);
  };
  lector.readAsText(archivo);
}

function mostrarContenido(contenido, name, type) {

  if (type === 1) {
    addNewTabA();

    let editor = ace.edit("txtA" + (tabsA - 1));

    editor.getSession().setValue(contenido);

    addFilesOpen("txtA" + (this.tabsA - 1), name);
  } else {
    addNewTabB();

    let editor = ace.edit("txtB" + (this.tabsB - 1));

    editor.getSession().setValue(contenido);

    addFilesOpen("txtB" + (this.tabsB - 1), name);
  }
}

function addFilesOpen(tab, nombre) {
  archivos.push({
    Tab: tab,
    Nombre: nombre,
  });
}

function saveFiles(seleccionada) {
  if (seleccionada != "") {
    let existe = false;
    let nombre = "";
    for (let i = 0; i < archivos.length; i++) {
      if (seleccionada === archivos[i].Tab) {
        existe = true;
        nombre = archivos[i].Nombre;
      }
    }

    let editor = ace.edit(seleccionada);
    let contenido = editor.getSession().getValue();
    if (existe) {
      save(contenido, nombre);
    } else {
      if (seleccionada === tabPrimaria) {
        $("#modal-saveA").modal("show");
      } else {
        $("#modal-saveB").modal("show");
      }
    }
  }
}

function save(contenido, nombre) {
  let a = document.createElement("a");
  let file = new File([contenido], nombre, {
    type: "text/plain;charset=utf-8",
  });
  let url = window.URL.createObjectURL(file);
  document.body.appendChild(a);
  a.href = url;
  a.download = file.name;
  a.style = "display: none";
  a.onclick = destroyClickedElement;
  a.click();
  window.URL.revokeObjectURL(url);
}

function saveAs(eleccion) {
  if(eleccion === 'A'){
    let nombre = document.getElementById("nombre-fileA").value;
    let editor = ace.edit(tabPrimaria);
    let contenido = editor.getSession().getValue();
    save(contenido, nombre);
    $("#modal-saveA").modal("hide");
    document.getElementById("nombre-fileA").value = "text.java";
  }
  else if(eleccion === 'B'){
    let nombre = document.getElementById("nombre-fileB").value;
    let editor = ace.edit(tabSecundaria);
    let value_Txt = editor.getSession().getValue();
    save(value_Txt, nombre);
    $("#modal-saveB").modal("hide");
    document.getElementById("nombre-fileB").value = "text.java";
  } 
}

function destroyClickedElement(event) {
  document.body.removeChild(event.target);
}

function openFiles(file) {
  var url = window.URL.createObjectURL(file);
  window.open(url, "Download");
}

function addNewTabA() {
  var self = this;
  var addTab = document.getElementById("addTabIconA");
  let tabs_Content = document.getElementById("myTabContentA");
  insertTab(self, this.tabsA, tabs_Content, addTab, "txtA", "EditorA");
  this.tabsA++;
}

function addNewTabB() {
  var self = this;
  var addTab = document.getElementById("addTabIconB");
  let tabs_Content = document.getElementById("myTabContentB");
  insertTab(self, this.tabsB, tabs_Content, addTab, "txtB", "EditorB");
  this.tabsB++;
}

function insertTab(self, nTab, tabs_Content, addTab, name, reference) {
  let item = document.createElement("li");
  item.setAttribute("class", "nav-item");
  let nameTab = document.createTextNode("Pestañas " + nTab);
  let reference_Item = document.createElement("a");
  reference_Item.setAttribute("class", "nav-link");
  reference_Item.setAttribute("data-toggle", "tab");
  reference_Item.setAttribute("href", "#" + reference + nTab);
  reference_Item.setAttribute("onclick", "changeTab('" + name + nTab + "')");
  reference_Item.appendChild(nameTab);
  item.appendChild(reference_Item);
  var deletaTab = document.createElement("span");
  deletaTab.className = "fa fa-times";
  deletaTab.addEventListener(
    "click",
    function (event) {
      self.deleteTab(deletaTab);
    },
    false
  );
  
  var referenceDelete = document.createElement("a");
  referenceDelete.href = "#";
  referenceDelete.appendChild(deletaTab);
  reference_Item.appendChild(referenceDelete);
  let new_Tab = document.createElement("div");
  new_Tab.setAttribute("class", "tab-pane fade");
  new_Tab.setAttribute("id", reference + nTab);
  let new_TextArea = document.createElement("div");
  new_TextArea.setAttribute("class", "list-group");
  new_TextArea.setAttribute("style", "height: 400px; position: relative;");
  new_TextArea.setAttribute("id", name + nTab);
  new_Tab.appendChild(new_TextArea);
  tabs_Content.appendChild(new_Tab);
  let editor = ace.edit(name + nTab);
  editor.setTheme("ace/theme/dracula");
  editor.session.setMode("ace/mode/java");
  editor.setFontSize("14px");
  item.contentTab = reference + nTab;
  addTab.parentNode.insertBefore(item, addTab);
}

function deleteTab(tab) {
  while (tab.nodeName != "LI") {
    tab = tab.parentNode;
  }
  document
    .getElementById(tab.contentTab)
    .parentNode.removeChild(document.getElementById(tab.contentTab));
  tab.parentNode.removeChild(tab);
}

function changeTab(id) {
  if (id.includes("A")) {
    tabPrimaria = id;
  } else if (id.includes("B")) {
    tabSecundaria = id;
  }
}

function getText(contenido) {
  var data = { data: contenido.toString()};
  console.log(data);
  fetch('http://localhost:3005/parser', {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
  })
    .then(function(res){
      return res.json();
    })
    .then(function(data){ 
      treeView(data);
      reporteErrores(data);
    });
}

function reporteErrores(json){
  let texto = "";
  for (var i in json.errores){ 
    texto += (Number(i)+1)+') ';
    texto += json.errores[i].error;
    texto += '\n\n';
  }
  let myTextArea = $('#consolaErrores');
  myTextArea.val(texto);
}

function treeView(json){
  document.getElementById("treePlace").innerHTML = "";
  document.getElementById("treePlace").appendChild(renderjson(json.AST));
}

function analyzeA() {
  if (tabPrimaria !== "") {
    analyze(tabPrimaria);
  }
}

function analyzeB() {
  if (tabSecundaria !== "") {
    analyze(tabSecundaria);
  }
}

function analyze(seleccionada) {
  let editor = ace.edit(seleccionada);
  let contenido = editor.getSession().getValue();
  if (contenido !== (undefined || "")) {
    getText(contenido);
  }
}
