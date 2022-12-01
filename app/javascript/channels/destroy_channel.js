import consumer from "./consumer"

consumer.subscriptions.create("DestroyChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const id = data["group_comment_id"]
    const element = document.querySelector('#group_comment_' + id)
    element.remove();
  }
});
