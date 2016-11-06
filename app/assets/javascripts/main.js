//bind to the header forms
$(function() {
  $("#add-profile-form").submit(function(event) {
    var form = $("#add-profile-form");
    event.preventDefault();
    $.ajax({
      url: '/api/profiles',
      type: 'post',
      data: form.serialize(),
      success: function(data) {
        if(data.success == true){
          showSuccessAddProfileMessage();
        }else{
          showErrorMessage(data.message);
        }
        form.trigger("reset");
      },
      error: function(error) {
        showErrorMessage();
        form.trigger("reset");
      }
    });
  });

  //---------------------------------------

  $("#search-name-form").submit(function(event) {
    var form = $("#search-name-form");
    event.preventDefault();
    $.ajax({
      url: '/api/profiles',
      type: 'get',
      data: form.serialize(),
      success: function(data) {
        insertTemplateObjects(data);
        form.trigger("reset");
      },
      error: function(error) {
        showErrorMessage();
        form.trigger("reset");
      }
    });
  });

  //---------------------------------------

  $("#search-skills-form").submit(function(event) {
    var form = $("#search-skills-form");
    event.preventDefault();
    $.ajax({
      url: '/api/profiles',
      type: 'get',
      data: form.serialize(),
      success: function(data) {
        insertTemplateObjects(data);
        form.trigger("reset");
      },
      error: function(error) {
        showErrorMessage();
        form.trigger("reset");
      }
    });
  });
});

//---------------------------------------

function insertTemplateObjects(data){
  if(data.length < 1){
    showEmptyResultsMessage();
    return false;
  }
  $("#results-injection").loadTemplate($("#profile-template"), data);
}

//---------------------------------------

function showEmptyResultsMessage(){
  var data = {
    header: "No Results.",
    message: "Sorry, doesn't look like we have any results for that search."
  }
  $("#results-injection").loadTemplate($("#info-template"), data);
}

//---------------------------------------

function showSuccessAddProfileMessage(){
  var data = {
    header: "Sucessfully Added!",
    message: "New Profile has been added into the database."
  }
  $("#results-injection").loadTemplate($("#success-template"), data);
}

//---------------------------------------

function showAlreadAddedProfileMessage(){
  var data = {
    header: "Already Added.",
    message: "Looks like that Profile is already in the Database."
  }
  $("#results-injection").loadTemplate($("#warning-template"), data);
}

//---------------------------------------

function showErrorMessage(message){
  if(!message){
    var message = "For some reason we couldn't complete that request...";
  }
  var data = {
    header: "Error!",
    message: message
  }
  $("#results-injection").loadTemplate($("#danger-template"), data);
}
