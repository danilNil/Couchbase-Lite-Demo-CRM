function(doc) {
  channel("all_channels");
  if (doc.type == "salesperson") {
    var userID = doc.user_id;
    access(userID, "all_channels")
  }
  channel(doc.channels);
}
