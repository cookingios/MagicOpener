
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.job("free_chance", function(request, status) {
  // Set up to modify user data
  Parse.Cloud.useMasterKey();
  var counter = 0;
  // Query for all users
  var query = new Parse.Query(Parse.User);
  query.each(function(user) {
      // Update to plan value passed in
      user.set("freeChance", 6);
      if (counter % 1000 === 0) {
        // Set the  job's progress status
        status.message(counter + " users got 6 lives.");
      }
      counter += 1;
      return user.save();
  }).then(function() {
    // Set the job's success status
    status.success("fresh completed successfully.");
  }, function(error) {
    // Set the job's error status
    status.error("Uh oh, something went wrong.");
  });
});

Parse.Cloud.define("addFreeChance", function(request, response) {
  var user = request.user;
  user.set("freeChance",6);
  user.save(null,{
    success:function(user){

    },
    error:function(user,error){

    }
  });
});