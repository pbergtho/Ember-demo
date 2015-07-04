<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>

<div class="container" id="ember-app">
		
</div>

<script type="text/x-handlebars" data-template-name="application">
	
		<div class="row">
			<div class="col-md-12" >
				<h2>Date Picker Application</h2>
				<p>  The time on the server is ${serverTime}. </p>
				{{outlet}}
			</div>
		</div>
	
</script>

<script type="text/x-handlebars" data-template-name="index">
	<p>This is the Date Picker Demo Application using Ember!</p>

	<ul>
		{{#each dev in model}}
		<li><a href="#">{{dev}}</a></li>
		{{/each}}
	</ul>
</script>


<script type="text/javascript" src="<%=request.getContextPath()%>/resources/javascripts/vendor/jquery-1.10.2.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/javascripts/vendor/ember/handlebars-1.0.0.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/javascripts/vendor/ember/ember-1.3.2.js"></script>

<script>
	var App = Ember.Application.create({
		rootElement : "#ember-app"
	});
	
	App.IndexRoute = Ember.Route.extend({
		model : function() {
			return [
			     "Patrick Bergthold",
			     "Ritchel Bergthold",
			     "Riley Bergthold"
			      ];
		}
	});
	
</script>

</body>
</html>
