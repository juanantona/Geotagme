$('#btn_observer_save').on('click', saveObserver);

function saveObserver() 
{
    $.ajax(
    {
        url: "/obervers/new",
        type: "POST",
    });
};