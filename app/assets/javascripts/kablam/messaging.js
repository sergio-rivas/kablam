var scrollPosition;
document.addEventListener('turbolinks:load', refreshScroll());

function refreshScroll(){
  if (scrollPosition) {
    window.scrollTo.apply(window, scrollPosition);
    scrollPosition = null;
  }
}

function TurboRefresh(){
  scrollPosition = [window.scrollX, window.scrollY];
  Turbolinks.visit(window.location.toString(), { action: 'replace' });
}

function Sound(path) {
  var audio = new Audio(path);
  audio.play();
}

function TopDot(dot_id, dot_class="dot bg-officeblue"){
  var topdotspan = document.getElementById(dot_id);
  topdotspan.className = dot_class;
}


function RemoveChatsSub(chatid) {
  var all = App.cable.subscriptions.subscriptions;
  var all_chats_sub_id = all.map(function (x) {return JSON.parse(x.identifier).id});
  var index_of_subed_chats = [];
  all_chats_sub_id.forEach(function(item,index) {
    if (chatid != undefined) {
        if (item != undefined && item != chatid) {
          index_of_subed_chats.push(index);
      }
    } else {
        if (item != undefined) {
          index_of_subed_chats.push(index);
      }
    }
  });
  index_of_subed_chats.forEach(function(item) {
    App.cable.subscriptions.remove(all[item]);
  });
}


function RemoveNotificationDot(dot_id){
  var dotspan = document.getElementById(dot_id);
  dotspan.className = "";
}

function UserChatSub(chat_div_id, chat_id, channel, user_id, options={}){
  RemoveChatsSub();
  var chatdiv = document.getElementById(chat_div_id);

  App.cable.subscriptions.create({ channel: channel, id: chat_id }, {
    received: function(data) {
      HtmlNode(data, options);
      if (data['chat']['sender_id'] != user_id) {
        TopDot();
      }
    }
  })
}

function HtmlNode(data, options={}){
  options = {
    outerDivClass: options.outerDivClass || "pt3 ph3 ph2-l bg-white br2 shadow1 mb3",
    innerDivClass: options.innerDivClass || "dt w-100 pb2 ph2 mt2",
    imgDivClass: options.imgDivClass || "dtc w2 w3-ns v-mid",
    imgClass: options.imgClass || "ba b--black-10 db br-100 w2 w3-ns h2 h3-ns",
    userDivClass: options.userDivClass || "dtc v-mid pl3",
    userNameClass: options.userNameClass || "f6 f5-ns fw6 lh-title black mv0",
    timestampClass: options.timestampClass || "f6 fw4 mt0 mb0 black-60 i",
    messageDivClass: options.messageDivClass || "ph3-l pb2",
    messageClass: options.messageClass || "f5 lh-copy measure pb3"
  }

  var new_message = document.createElement("div");

    new_message.className = options.outerDivClass;
    var content = data['chat'].content.replace(/(?:\r\n|\r|\n)/g, '<br>');
    new_message.innerHTML = `<div class="${options.innerDivClass}">
    <div class="${options.imgDivClass}">
    <img src="${data['chat'].image}" class="${options.imgClass}"/>
    </div>
    <div class="${options.userDivClass}">
      <h1 class="${options.userNameClass}">${data['chat'].username}</h1>
      <h2 class="${options.timestampClass}">${data['chat'].created_at}</h2>
    </div>
    </div>
    <div class="${options.messageDivClass}"><p class="${options.messageClass}">${content}</p></div>`;
    chatdiv.insertAdjacentElement('afterbegin', new_message);
}
