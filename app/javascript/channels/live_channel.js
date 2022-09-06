import consumer from "./consumer"

consumer.subscriptions.create("LiveChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const element = document.querySelector('#group_comment_container')
    element.insertAdjacentHTML('afterbegin', data['group_comment'])
    // Called when there's incoming data on the websocket for this channel
  },

  speak: function(group_comment) {
    return this.perform('speak', {group_comment: group_comment});
  }
});
