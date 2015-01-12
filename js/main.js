/* Codekit imports
@codekit-prepend "jquery-1.8.0.min.js"
@codekit-prepend "bootstrap.js"
*/
/* Form Handling module */

var forms = (function (form) {
	//private variables
	var that = this;

	//constructor
	var forms = function(form) {
		that.form = $(form);
		that.form.submit(function(e){
			e.preventDefault();
			var url = that.form.find('#url').val(),
				query = that.form.find('#query').val();

			if (url!='' && query!='') {
				console.log('test');
				$.ajax({
					url: url,
					data: { 'query': query},
					dataType:'json',
					success: function(results){
						var mod = $("#myModal"),
							str = '';

						$.each(results, function(key,value){
							str = str +  key + ': ' + value + '<br>';
						});

						mod.find('.modal-body').html('<pre>' + str + '</pre>');
						mod.modal('show');
					},
					error: function(jqXHR, textStatus, errorThrown) {
						alert(errorThrown);
					}
				})
			}
			else
			{
				console.log('url: ' + url);
				console.log('query: ' + query);
			}
		});
	};

	//prototype
	forms.prototype = {
		constructor: forms,

		cancellable: function() {
			$(that.form).find('.cancel').each(function(){
				$(this).click(function(){
					that.form.find(':input').each(function(){
						this.value = '';
					});
				});
			})
		},
	};//eof prototype

	//return the module
	return forms;
})();

$(document).ready(function(){
	var my_forms = new forms('#form-1');
	my_forms.cancellable();
});