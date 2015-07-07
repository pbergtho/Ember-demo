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

	{{#view App.DatePicker}}{{/view}}
	
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
	
	JQ = Ember.Namespace.create();
	
	JQ.Widget = Em.Mixin.create({
		
		didInsertElement: function() {
			
			var options = this._gatherOptions();
			
			this._gatherEvents(options);
			
			var ui;
			if(typeof jQuery.ui[this.get('uiType')] === 'function') 
			{
				ui = jQuery.ui[this.get('uiType')](options, this.get('element'));
			}
			else
			{
				ui = this.$()[this.get('uiType')](options);		
			}
			
			this.set('ui', ui);
		},
		
		willDestroyElement: function() { 
			var ui = this.get('ui');
			
			if(ui) {
				
				var observers = this._observers;
				for(var prop in observers) {
					if(observers.hasOwnProperty(prop)) {
						this.removeObserver(prop, observers[prop]);
					}
				}
				ui._destroy();
			}
		},
		
		_gatherOptions: function() {
			var uiOptions = this.get('uiOptions'), options = {};
			
			uiOptions.forEach(function(key) {
				options[key] = this.get(key);
			
				var observer = function() {
					var value = this.get(key);
					this.get('ui').option(key, value);
				};
				
				this.addObserver(key, observer);
				
				this._observers = this._observers || {};
				this._observers[key] = observer;
			}, this);
			
			return options;
		},
		
		_gatherEvents: function(options) {
			var uiEvents = this.get('uiEvents') || [], self = this;
			
			uiEvents.forEach(function(event) {
				var callback = self[event];
				
				if(callback) {
					options[event] = function(event, ui) {callback.call(self, event, ui); };
				}
			});
		}
	});
			
	JQ.Button = Em.View.extend(JQ.Widget, { 
		uiType: 'button',
		uiOptions: ['disabled', 'text', 'icons', 'label'],
		uiEvents: ['create'],
		
		tagName: 'button'
	});
	
	JQ.Menu = Em.CollectionView.extend(JQ.Widget, {
		uiType: 'menu',
		uiOptions: ['disabled'],
		uiEvents: ['create', 'focus', 'blur', 'select'],
		
		tagName: 'ul',
		
		arrayDidChange: function(content, start, removed, added) {
			"use strict";
			this._super(content, start, removed, added);
			
			var ui = this.get('ui');
			if(ui) {
				Em.run.schedule('render', function() {
					ui.refresh();
				});
			}
		}
	});
	
	JQ.DatePicker = Em.View.extend(JQ.Widget, {
		uiType: 'datepicker',
		uiOptions:  ['disabled', 'altField', 'altFormat', 'appendText', 
		             'autoSize', 'buttonImage', 'buttonImageOnly', 
		             'buttonText', 'calculateWeek', 'changeMonth', 
		             'changeYear', 'closeText', 'constrainInput', 
		             'currentText', 'dateFormat', 'dayNames', 
		             'dayNamesMin', 'dayNamesShort', 'defaultDate', 
		             'duration', 'firstDay', 'gotoCurrent', 
		             'hideIfNoPrevNext', 'isRTL', 'maxDate', 'minDate', 
		             'monthNames', 'monthNamesShort', 
		             'navigationAsDateFormat', 'nextText', 
		             'numberOfMonths', 'prevText', 'selectOtherMonths', 
		             'shortYearCutoff', 'showAnim', 'showButtonPanel', 
		             'showCurrentAtPos', 'showMonthAfterYear', 
		             'showOn', 'showOptions', 'showOtherMonths', 
		             'showWeek', 'stepMonths', 'weekHeader', 'yearRange',
		             'yearSuffix'],
		             
		uiEvents: ['create','beforeShow', 'beforeShowDat', 'onChangeMonthYear', 'onClose', 'onSelect'],
		
		tagName: 'input',
		type: 'text',
		attributeBindings: ['type', 'value']
	});
	
	App.DatePicker = JQ.DatePicker.extend({
		dateFormat: 'mm-dd-yy',
		onSelect: function(dateText, inst) {
			alert(dateText);
		},
		
		attributeBindings: ['value']
		
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
	});
	
	App.Router.map(function () {
		this.resource("user", { path: "/users/:login"});
	});
	
	App.UserRoute = Ember.Route.extend({
		model: function(params) {
			return Ember.$.getJSON("https:/api.github.com/users/" + params.login);
		}
	
	});
	
	
	
</script>
<!-- https://gist.github.com/BlakeWilliams/5375707 -->
</body>
</html>
