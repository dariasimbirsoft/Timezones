
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("Timezones", function(request, response) {
                   var query = new Parse.Query("Timezone");
                   var user = new Parse.User();
                   user.id = request.params.userID;
                   query.equalTo("user", user);
                   query.ascending("name");
                   query.find({
                              success: function(results) {
                              if(request.params.filter)
                              {
                                  var filter = request.params.filter.toLowerCase();
                                  results = results.filter(function (element) {
                                                                   var name = element.get("name");
                                                                   if(name === "undefined") return false;
                                                                   return name.toLowerCase().indexOf(filter) >= 0;
                                   });
                              }
                              response.success(results);
                              },
                              error: function() {
                              response.error("movie lookup failed");
                              }
                              });
                   });
