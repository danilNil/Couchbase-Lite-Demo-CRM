function(doc) {
  channel("all_channels");
  if (doc.type == "salesperson") {
    var userID = doc.user_id;
    access(userID, "all_channels")
  }
  channel(doc.channels);
}


// sync function we created with Chris

function(doc, oldDoc) {
  channel("all_docs");
  if (doc.type == "salesperson") {
    var userID = doc.user_id;
    if (userID == "dur-perturbador@yandex.ru") {
      role(userID, "role:admin")
    }
    if (oldDoc) {
      // only admin can change existing salespeople
      requireRole("admin")
      if (doc.approved) {
        // only sales people who have been approved can sync
        access(userID, "all_docs")
      }
    }
    else {
      // salespeople can only be created by themselves need to uncomment when we removed fake customers creation
      //      requireUser(userID)
    }
  }
}
