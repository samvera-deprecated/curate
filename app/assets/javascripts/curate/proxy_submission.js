/**
 * This Javascript/JQuery method is used for the population of the creator field
 * when a proxy user is making a deposit on behalf of someone else.  The method gets the selected
 * person on behalf of whom the proxy person is making the deposit and places that person's name in
 * a creator field and clicks the creator Add button.
 */
function updateCreators(){

    // Get the selected owner name from the owner control.
    // If it is 'Myself', then pluck the name from the display name on the dropdown menu in the title bar of the page.
    // If 'nothing' was selected, do nothing and return.

    var ownerName = $("[id*='_owner'] option:selected").text();
    if (ownerName == 'Myself') {
        ownerName = $(".user-display-name").text().trim();
    }
    else if (ownerName === "") { return; }

    // Put that name into the "Add" creator control and force a click of the Add button.
    // Note that the last creator control is always the one into which a new user is entered.
    $('input[id$=_creator]').last().val(ownerName);
    $("div[class*=_creator] .add").click();
}
