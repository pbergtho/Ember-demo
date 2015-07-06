<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	
	<title>Home</title>
	
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/javascripts/vendor/bootstrap-3.3.5/css/bootstrap.css">
	
</head>
<body>

<div class="container" id="ember-app">
		
</div>

<script type="text/x-handlebars" data-template-name="application">
	
		<div class="row">
			<div class="col-md-12" >
				<h2>Example Application</h2>
				<p>  The time on the server is ${serverTime}. </p>
				{{outlet}}
			</div>
		</div>
	
</script>

<!-- handlebars 1.0.0 js function for clicked instead of clickMe needed to create action in controller changed in newer versions -->
<script type="text/x-handlebars" data-template-name="index">
	<p>This is the Example Application using Ember!</p>

	<ul>
		{{#each}}
		<li>{{#link-to 'user' this}}{{name}}{{/link-to}}</a></li> 
		{{/each}}
	</ul>
	<p>
		<button type="button" class="btn btn-success" {{action "clicked"}}>Click Me!</button> 
	</p>
	<p>{{renderedOn}}</p>
</script>

<script type="text/x-handlebars" data-template-name="user">
	<h3>{{name}}'s Github</h3>
	
</script>

<script type="text/javascript" src="<%=request.getContextPath()%>/resources/javascripts/vendor/jquery-1.10.2.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/javascripts/vendor/ember/handlebars-1.0.0.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/javascripts/vendor/ember/ember-1.3.2.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/javascripts/vendor/bootstrap-3.3.5/js/bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/javascripts/vendor/jquery-ui-1.10.3.js"></script>

<script>

	var devs = [
           { login: "pbergtho", name: "Patrick Bergthold" },
           { login: "wycats", name: "Yehuda Katz" },
           { login: "haacked", name: "Phil Haack" },
    ] 
	
	
	var App = Ember.Application.create({
		rootElement : "#ember-app"
	});
	
	App.IndexRoute = Ember.Route.extend({
		model : function() {
			return devs
		}
	});
	
	App.IndexController = Ember.ArrayController.extend({
			renderedOn: function() {
				return new Date();
			}.property(),
			
			actions : {
				clicked : function() {
					alert("I've been clicked!");
				},
				

			}
	})
	
	App.Router.map(function () {
		this.resource("user", { path: "/users/:login"});
	});
	
	App.UserRoute = Ember.Route.extend({
		model: function(params) {
			return Ember.$.getJSON("https:/api.github.com/users/" + params.login);
		}
	
	})
	
	App.Datepicker = Ember.View.extend({ 
		attributes: ['altField', 'altFormat', 'appendText', 'autoSize', 'beforeShow', 'beforeShowDay', 'buttonImage', 
		             'buttonImage', 'buttonImageOnly', 'buttonText', 'calculateWeek', 'changeMonth', 'closeText', 'constraintInput',
		             'currentText', 'dateFormat', 'dayNames', 'dayNamesMin', 'dayNamesShort', 'defaultDate', 'duration', 'firstDay', 'gotoCurrent',
		             'hideIfNoPrevNext', 'isRTL', 'maxDate', 'minDate', 'monthNames', 'monthNamesShort', 'navigationAsDateFormat', 'nextText', 
		             'numberofMonths', 'onChangemonthYear', 'onClose', 'onSelect', 'prevText', 'selectOtherMonths', 'shortYearCutoff', 'showAnim', 
		             'showButtonPanel', 'showCurrentAtPos', 'showMonthAfterYear', 'showOn',  'showOptions', 'showOtherMonths', 'showWeek', 
		             'stepMonths', 'weekHeader', 'yearRange', 'yearSuffix', 'destroy', 'dialog', 'getDate', 'hide', 'isDisabled', 'option', 'refresh',
		             'setDate', 'show', 'widget'],
		             
		tagname: 'input',
		classNames: 'datepicker',
		
		didInsertElement: function() {
			var options = {};
			var self = this;
			
			this.get('attributes').forEach(function(attr) {
				if(self[attr] !== undefined) {
					options[attr] = self[attr];
				} 
			});
			
			var onSelectCallback = options.onSelect;
			options.onSelect = function() {
				Ember.set(self, 'value', this.getDate(true));
				if(onSelectCallback) {
					onSelectCallback.call(this)
				}
			}
			
			this.$().datepicker(options);
		},
	});
</script>
<!-- https://gist.github.com/BlakeWilliams/5375707 -->
</body>
</html>
