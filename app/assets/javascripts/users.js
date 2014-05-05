$(document).ready(function()
{ 
	$('body').on('click', '.delete-user', function()
	{
		var user_id = $(this).attr('user-id');
		$('.modal-header .modal-title').html("Remove User");
		$('#modal-form').attr('action', '/users/' + user_id);
	});

	$('body').on('click', '.delete-product', function()
	{
		var product_id = $(this).attr('product-id');
		$('.modal-header .modal-title').html("Remove Product");
		$('#modal-form').attr('action', '/products/' + product_id);
	});

	$('body').on('click', '.delete-sale', function()
	{
		var sale_id = $(this).attr('sale-id');
		$('.modal-header .modal-title').html("Remove Sale");
		$('#modal-form').attr('action', '/sales/' + sale_id);
	});
	
}); 
