function hide_pages (){
    $("li a.page-number").hide();
    
    $("li.active").show();
};
 $(document).ready(function() {
   
$('table.table').each(function() {
    var currentPage = 0;
    var numPerPage = 10;
    var $table = $(this);
    $table.bind('repaginate', function() {
        $table.find('tbody tr').hide().slice(currentPage * numPerPage, (currentPage + 1) * numPerPage).show();
    });

    $table.trigger('repaginate');
    var numRows = $table.find('tbody tr').length;
    var numPages = Math.ceil(numRows / numPerPage);
    var $pager = $('<ul></ul>');
    for (var page = 0; page < numPages; page++) {
        $('<a class="page-number" href="#"></a>').text(page + 1).bind('click', {
            newPage: page
        }, function(event) {
            currentPage = event.data['newPage'];
            $table.trigger('repaginate');
            $(this).addClass('active').siblings().removeClass('active');
        }).appendTo($pager);
    }
    $pager.appendTo(".pagination");
    
    
    $('ul > a').wrap('<li></li>');
    $(".pagination").find('li:first').addClass('active');
    hide_pages();
});
 });


