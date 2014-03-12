/*Copyright (c) 2012 Jessie

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/


/*
Return URI:
http://127.0.0.1:1337/?addClass=1&appendChild=1&appendHtml=1&createElement=1&findProprietaryStyle=1&getAncestorByClassName=1&getAncestorByTagName=1&getDescendantsByClassName=1&getDescendantsByTagName=1&getElement=1&getElementParentElement=1&getElementPositionStyles=1&getElementTagName=1&getHtml=1&getInnerSize=1&getOuterSize=1&getPositionRelativeToDocument=1&getPositionRelativeToViewport=1&getStyleComputed=1&getText=3&hasClass=1&isDescendant=1&isInQuery=1&isNodeInNodeList=1&prependHtml=1&query=1&removeChild=1&removeClass=1&setHtml=1&setPosition=1&setSize=1&setText=3&attachBoundListener=1&attachBoundWindowListener=1&attachDocumentListener=1&attachListener=1&attachWindowListener=1&cancelDefault=1&cancelPropagation=1&delegateBoundClassNameListener=1&delegateBoundListener=1&delegateBoundQueryListener=1&delegateListener=1&delegateQueryListener=1&delegateTagNameListener=1&detachBoundListener=1&detachListener=1&detachWindowListener=1&getEventTarget=1&getEventTargetRelated=1&bind=1&getViewportScrollPosition=1&getViewportSize=1&htmlToNodes=1&setInputValue=1&setViewportScrollPosition=1&toArray=1&undelegateListener=1&undelegateQueryListener=1
*/

var KD = {};
KD.dom = KD.dom || {};
(function(global) {

	var globalDocument = global.document,
		isHostObjectProperty = function(object, property) {
			var objectProperty = object[property];
			return typeof objectProperty == 'object' && null !== objectProperty;
		},
		isHostMethod = function(object, method) {
			var objectMethod = object[method];
			var type = typeof objectMethod;
			return	type == 'function' ||
					type == 'object' && null !== objectMethod ||
					type == 'unknown';
		},
		areFeatures = function() {
			var i = arguments.length;
			while (i--) {
				if (!KD.dom[arguments[i]]) {
				return false;
				}
			}
			return true;
		},
		html = isHostObjectProperty(globalDocument, 'documentElement') && globalDocument.documentElement,
		canCall = !!Function.prototype.call,
		isStyleCapable = !!(html && isHostObjectProperty(html, 'style'));



/*
Description:
*/

var toArray;

toArray = function(a) {
	var result = [];
	for (var i = 0, l = a.length; i < l; i++) {
		result[i] = a[i];
	}
	return result;
};



/*
Description:
Relies on W3C `el.removeEventListener`
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3, NN4, Opera 7.6
*/

/*
Author:
David Mark
*/

var detachListener;

if(html && isHostMethod(html, 'removeEventListener')) {
	detachListener = function(el, eventType, fn) {
		el.removeEventListener(eventType, fn, false);
	};
}



/*
Description:
Relies on W3C `e.target`
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3, Opera 7.6
*/

var getEventTarget;

if(html && isHostMethod(html, 'addEventListener')) {
	getEventTarget = function(e) {
		var target = e.target;
		// Check if not an element (e.g. a text node)
		if (1 != target.nodeType) {
			// Set reference to parent node (which must be an element)
			target = target.parentNode;
		}
		return target;
	};
}



/*
Description:
Relies on W3C `el.addEventListener`
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3, Opera 7.6
*/

/*
Author:
David Mark
*/

var attachListener;

if(html && isHostMethod(html, 'addEventListener')) {
	attachListener = function(el, eventType, fn) {

		var listener = function(e) {
			fn.call(el, e);
		};

		el.addEventListener(eventType, listener, false);

		return listener;
	};
}



/*
Description:
Relies on `document.querySelectorAll` and `jessie.toArray`
*/

/*
Author:
David Mark
*/

var query;

if(globalDocument && isHostMethod(globalDocument, 'querySelectorAll') && toArray) {
	query = function(selector, doc) {
		return toArray((doc || document).querySelectorAll(selector));
	};
}

/*
Description:
Relies on `document.querySelector` and `jessie.toArray`
*/

/*
Author:
Christopher Thorn
*/

var queryOne;

if(globalDocument && isHostMethod(globalDocument, 'querySelector')) {
	queryOne = function(selector, doc) {
		return (doc || document).querySelector(selector);
	};
}



/*
Description:
Iterates a node list to see if any of the nodes match the passed in node.
*/

/*
Author:
Graham Veal
*/

var isNodeInNodeList;

isNodeInNodeList = function( node, nodeList ){

	var isInNodeList = false,
		i = 0,
		l = nodeList.length;

	// could use Array.prototype.indexOf in another rendition
	for( ; i < l; i++ ) {
		if(nodeList[i] === node) {
			isInNodeList = true;
			break;
		}
	}

	return isInNodeList;
};



/*
Description:
Relies on `Function.prototype.bind`
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3, Chrome 6, Firefox 3.6, Safari 5.1, Opera 11.5
*/

/*
Author:
David Mark
*/

var bind;

if(canCall && Function.prototype.bind){
    bind = function(fn, thisObject) {
        return fn.bind.apply(fn, Array.prototype.slice.call(arguments, 1));
    };
}



/*
Description:
Relies on `jessie.detachListener`
*/

/*
Author:
Adam Silver
*/

var undelegateListener;

if(detachListener) {
	undelegateListener = function(el, eventType, delegateListener) {
		return detachListener(el, eventType, delegateListener);
	};
}



/*
Description:
Relies on `jessie.attachListener` and `jessie.getEventTarget` `Function.prototype.call`
*/

/*
Author:
Adam Silver
*/

var delegateListener;

if(attachListener && getEventTarget && canCall) {
	delegateListener = function(el, eventType, fn, fnDelegate) {

		var listener = function(e) {
			var currentTarget = fnDelegate(el, getEventTarget(e));
			if(currentTarget) {
				fn.call(currentTarget, e, currentTarget, el);
			}
		};

		return attachListener(el, eventType, listener);
	};
}



var getElementTagName;

/*
Description:
Relies on `el.tagName` or `el.nodeName`
*/

getElementTagName = function (el) {
	var tagName = (el.tagName || el.nodeName).toLowerCase();
	return tagName.indexOf('html:') > -1 ? tagName.substring(5) : tagName;
};



/*global html, globalDocument, isHostObjectProperty*/

var getElementParentElement;

/*
Description:
Relies on `el.parentNode`
*/

/*
Degrades:
IE5, IE4, IE3
*/

if (html && isHostObjectProperty(html, 'parentNode')) {
	getElementParentElement = function(el) {
		var parentNode = el.parentNode,
			parentElement = null;

		if (parentNode && (parentNode.tagName || parentNode.nodeType == 1)) {
			parentElement = parentNode;
		}
		return parentElement;
	};
}



/*
Description:
Relies on `jessie.isNodeInNodeList`, `jessie.query`
*/

/*
Author:
Graham Veal
*/

var isInQuery;

if(isNodeInNodeList && query) {
	isInQuery = function(el, selector) {

		return isNodeInNodeList( el, query(selector) );
	};
}



/*
Description:
Relies on `el.parentNode` which has very good support
*/

/*
Degrades:
In browsers without `el.parentNode`
*/

var isDescendant;

if(html && 'undefined' != typeof html.parentNode) {
	isDescendant = function(el, elDescendant) {
		var parent = elDescendant.parentNode;
		while(parent && parent != el) {
			parent = parent.parentNode;
		}
		return parent == el;
	};
}



/*
Description:
Relies on `jessie.attachListener`, `jessie.bind` and `jessie.getEventTarget` and `Function.prototype.call`
*/

/*
Author:
Adam Silver
*/

var delegateBoundListener;

if(attachListener && bind && getEventTarget && canCall) {
	delegateBoundListener = function(el, eventType, fn, fnDelegate, thisObject) {

		var listener = bind(function(e) {
			var currentTarget = fnDelegate(el, getEventTarget(e));
			if(currentTarget) {
				fn.call(thisObject, e, currentTarget);
			}
		}, thisObject);

		return attachListener(el, eventType, listener);
	};
}



/*
Description:
Relies on the `el.classList.contains`
*/

/*
Degrades:
IE9, IE8, IE7, IE6, IE5.5, IE5, IE4, IE3, Chrome 7, FF3.5, Safari 5.0, Opera 11.1, IOS Safari 4.3, Opera Mini 6.0, Opera Mobile 11.0, Android Safari 2.3
*/

/*
Author:
Adam Silver
*/

var hasClass;

if (html && isHostObjectProperty(html, "classList") && isHostMethod(html.classList, "contains") ) {
	hasClass = function(el, className) {
		return el.classList.contains(className);
	};
}




/*
Description:
Relies on `window.addEventListener`. No frames.
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3, Opera 7.6
*/

/*
Author:
David Mark
*/

var attachWindowListener;

if(window && isHostMethod(window, 'addEventListener')) {
	attachWindowListener = function(eventType, fn) {

		var listener = function(e) {
			fn.call(window, e);
		};

		window.addEventListener(eventType, listener, false);

		return listener;
	};
}



/*
Description:
Relies on `window.page(X/Y)Offset
*/

/*
Author:
David Mark
*/

var getViewportScrollPosition;

if('number' == typeof window.pageXOffset && 'number' == typeof window.pageYOffset ) {
	getViewportScrollPosition = function() {
		return [window.pageXOffset, window.pageYOffset];
	};
}



/*
Description:
Relies on `el.getBoundingClientRect`
*/

//https://groups.google.com/group/comp.lang.javascript/browse_thread/thread/cd625a14ce603084?hl=en&noredirect=true

/*
Author:
David Mark
*/

var getPositionRelativeToViewport;

if(html && isHostMethod(html, 'getBoundingClientRect')) {
	getPositionRelativeToViewport = function(el) {
		var rect = el.getBoundingClientRect();
		return [rect.left, rect.top];
	};
}



/*
Description:
Basic rendition which relies on valid markup i.e. forms with unique names and ids
*/

/*
See: <a href="https://groups.google.com/forum/#!starred/comp.lang.javascript/fVp-DWAIGnc">Article</a>

That's the most basic rendition: no allowance for screwy markup like this:

<input name="test">
<input id="test">
*/

/*
Degrades:
IE4, IE3, NN4
*/

/*
Author:
David Mark
*/

var getElement;

if (isHostMethod(document, 'getElementById')) {
	getElement = function(id, doc) {
		return (doc || document).getElementById(id);
	};
}



/*
Description:
Relies on `jessie.undelegateListener`
*/

/*
could have simply used detachListener
but this reinforces  that this function
expects a delegate listener which was returned
when it was attached
*/

/*
Author:
Adam Silver
*/

var undelegateQueryListener;

if(undelegateListener) {
	undelegateQueryListener = function(el, eventType, listener) {
		return undelegateListener(el, eventType, listener);
	};
}



/*
Description:
Relies on `window.scrollTo`
*/

var setViewportScrollPosition;

if(isHostMethod(global, "scrollTo")) {
	setViewportScrollPosition = function(x, y) {
		window.scrollTo(x, y);
	};
}



var setInputValue;

/*
Description:
setInputValue
*/

setInputValue = function(elInput, value) {
    elInput.value = value;
};


var getViewportSize;

/*

Description:
Will likely *include* space occupied by scroll bars

*** Viewport META

Relies on:
Degrades: IE8
*/


/*
Author: David Mark
*/

if (typeof global.innerWidth == 'number') {
	getViewportSize = function(win /* window */) {
		if (!win) {
			win = window;
		}
		return [win.innerWidth, win.innerHeight]; // Array
	};
}



/*
Description:
Relies on W3C `e.relatedTarget`
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3, Opera 7.6
*/

/*
Author:
David Mark
*/

var getEventTargetRelated;

if(html && isHostMethod(html, 'addEventListener')) {
	getEventTargetRelated = function(e) {
		var target = e.relatedTarget;
		// Check if not an element (e.g. a text node)
		if (1 != target.nodeType) {
			// Set reference to parent node (which must be an element)
			target = target.parentNode;
		}
		return target;
	};
}



/*
Description:
Relies on W3C `window.removeEventListener`
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3, NN4, Opera 7.6
*/

/*
Author:
David Mark
*/

var detachWindowListener;

if(window && isHostMethod(window, 'removeEventListener')) {
	detachWindowListener = function(eventType, fn) {
		return window.removeEventListener(eventType, fn);
	};
}



/*
Description:
Relies on `jessie.detachListener`
*/

// could have simply used detachListener
// but this reinforces  that this function
// expects a bound listener

/*
Author:
David Mark
*/

var detachBoundListener;

if(detachListener) {
	detachBoundListener = function(el, eventType, boundListener) {
		return detachListener(el, eventType, boundListener);
	};
}



/*
Description:
Relies on `jessie.delegateListener` and `jessie.getElementTagName` and `jessie.getElementParentElement`
*/

/*
Author:
Adam Silver
*/

var delegateTagNameListener;

if(delegateListener && getElementTagName) {
	delegateTagNameListener = function(el, eventType, tagName, fn) {

		var fnDelegate = function(el, target) {
			var sourceNode,
				descendant;

			if(getElementTagName(target) === tagName) {
				sourceNode = target;
			} else {
				descendant = getElementParentElement(target);

				while (null !== descendant && descendant !== el) {
					if (getElementTagName(descendant) === tagName) {
						sourceNode = descendant;
						break;
					}
					descendant = getElementParentElement(descendant);
				}
			}
			return sourceNode;
		};

		return delegateListener(el, eventType, fn, fnDelegate);
	};
}



/*
Description:
Relies on `jessie.isNodeInNodeList`, `jessie.delegateListener`, `jessie.query` and `jessie.isDescendant`
*/

/*
Author:
Adam Silver, Graham Veal
*/

var delegateQueryListener;

if(isNodeInNodeList && delegateListener && query && isDescendant) {

	delegateQueryListener = function(el, eventType, selector, fn) {

		function fnDelegate(target) {

			var elements = query(selector),
				i = 0,
				l,
				el;

			if(isNodeInNodeList(target, elements)) {
				return target;
			}

			// its not in query so loop through by selector
			// if the target is a child of the element then
			// return that element

			for( l = elements.length ; i < l; i++ ) {

				el = elements[i];

				if( isDescendant(el, target) ) {
					return el;
				}
			}
		}

		return delegateListener(el, eventType, fn, fnDelegate);
	};
}



/*
Description:
Relies on `jessie.delegateBoundListener`, `jessie.query`, `jessie.isInQuery` and `jessie.isDecendant`
*/

/*
Author:
Adam Silver
*/

var delegateBoundQueryListener;

if(delegateBoundListener && query && isDescendant) {
	delegateBoundQueryListener = function(el, eventType, selector, fn, thisObject) {

		var fnDelegate = function(el, target) {
			if(isInQuery(target, selector)) {
				return target;
			}

			// its not in query so loop through by selector
			// if the target is a child of the element then
			// return that element
			var elements = jessie.query(selector);
			for(var i = 0; i < elements.length; i++) {
				if( isDescendant(elements[i], target) ) {
					return elements[i];
				}
			}
		};

		return delegateBoundListener(el, eventType, fn, fnDelegate, thisObject);
	};
}



/*
Description:
Relies on `jessie.delegateBoundListener`, `jessie.hasClass`, and `jessie.getElementParentElement`
*/

/*
Author:
Adam Silver
*/

var delegateBoundClassNameListener;

if(delegateBoundListener && hasClass && getElementParentElement) {
	delegateBoundClassNameListener = function(el, eventType, className, fn, thisObject) {

		var fnDelegate = function(el, target) {
			var currentTarget = target;

			if(el === currentTarget) {
				currentTarget = null;
			}

			// traverse up the tree until we find an element with the class or until we find the delegate/el
			while(currentTarget && (currentTarget !== el) && !hasClass(currentTarget, className)) {
				// if we clicked on the delegate/container/el then set to null
				currentTarget = getElementParentElement(currentTarget);
				if(el === currentTarget) {
					currentTarget = null;
				}
			}

			return currentTarget;
		};

		return delegateBoundListener(el, eventType, fn, fnDelegate, thisObject);
	};
}



/*
Description:
Relies on W3C compliant `e.stopPropagation()`
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3, Opera 7.6
*/

/*
Author:
Adam Silver
*/

var cancelPropagation;

if(html && isHostMethod(html, 'addEventListener')) {
	cancelPropagation = function(e) {
		e.stopPropagation();
	};
}



/*
Description:
Relies on W3C compliant `e.preventDefault()`
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3, Opera 7.6
*/

/*
Author:
Adam Silver
*/

var cancelDefault;

if(html && isHostMethod(html, 'addEventListener')) {
	cancelDefault = function(e) {
		e.preventDefault();
	};
}



/*
Description:
Relies on `document.addEventListener`.
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3
*/

var attachDocumentListener;

if(globalDocument && isHostMethod(globalDocument, 'addEventListener') && attachListener) {
	attachDocumentListener = function(eventType, fn) {

		var listener = function(e) {
			fn.call(document, e);
		};

		return attachListener(document, eventType, fn);
	};
}



/*
Description:
Relies on `jessie.bind` and `jessie.attachWindowListener`
*/

/*
Author:
Adam Silver
*/

var attachBoundWindowListener;

if(attachWindowListener && bind) {
	attachBoundWindowListener = function(eventType, fn, thisObject) {
		var listener = bind(fn, thisObject);
		return attachWindowListener(eventType, listener);
	};
}



/*
Description:
Relies on `jessie.bind` and `jessie.attachListener`
*/

/*
Author:
Adam Silver
*/

var attachBoundListener;

if(bind && attachListener) {
	attachBoundListener = function(el, eventType, fn, thisObject) {
		var listener = bind(fn, thisObject);
		thisObject = null;
		return attachListener(el, eventType, listener);
	};
}



/*
Description:
Relies on `el.textContent` or `el.innerText` providing widest browser support.
*/

var setText;

if(html && "string" == typeof html.textContent) {
	setText = function(el, text) {
		el.textContent = text;
	};
} else if(html && "string" == typeof html.innerText) {
	setText = function(el, text) {
		el.innerText = text;
	};
}



var setSize;
if(html && isHostObjectProperty(html, "style")){
  setSize = (function() {
    var px = (typeof html.style.top == 'number') ? 0 : 'px';
    return function(el, h, w) {
      if (h !== null && h >= 0) { el.style.height = h + px; }
      if (w !== null && w >= 0) { el.style.width = w + px; }
    };
  }());
}



var setPosition;
if(html && isHostObjectProperty(html, "style")){
  setPosition = (function(el) {
    var px = (typeof html.style.top == 'number') ? 0 : 'px';
    return function(el, x, y) {
      if (x !== null) { el.style.left = x + px; }
      if (y !== null) { el.style.top = y + px; }
    };
  }());
}



/*
Description:
Relies on `el.innerHTML` which degrades in IE3
*/

/*
See: <a href="https://groups.google.com/forum/#!search/david$20mark$20innerHTML/comp.lang.javascript/QQ9ClOT6igQ/LIZ5QXmmuw0J">Related article</a>
NOTE: Don't use this rendition with anything but DIV's
*/

/*
Degrades:
IE3
*/

/*
Author:
David Mark
*/

var setHtml;

if(html && "string" == typeof html.innerHTML) {
	setHtml = function(el, html) {
		el.innerHTML = html;
	};
}



/*
Description:
Relies on the `el.classList.remove`
*/

/*
Degrades:
Chrome 7, FF3.5, IE9, Safari 5.0, Opera 11.1, IOS Safari 4.3, Opera Mini 6.0, Opera Mobile 11.0, Android Safari 2.3
*/

/*
Author:
Adam Silver
*/

var removeClass;

if (html && isHostObjectProperty(html, "classList") && isHostMethod(html.classList, "remove") ) {
    removeClass = function(el, className) {
			return el.classList.remove(className);
    };
}





/*
Description:
Relies on `el.removeChild`
*/

/*
Author:
Adam Silver
*/

var removeChild;

if(html && isHostMethod(html, "removeChild")) {
	removeChild = function(el, childNode) {
		return el.removeChild(childNode);
	};
}




/*
 Description:
 Relies on `el.insertAdjacentHTML
 IE6 `el.insertAdjacentHtml` does not work on table, tbody, thead, tr elements
 */

/*
 Degrades:
 IE3, Firefox 7, Safari 3, Opera 7
 */

/*
 Author:
 Ben Chidgey
 */

var prependHtml;

if (html && isHostMethod(html, 'insertAdjacentHTML')) {
	prependHtml = function (el, html) {
		el.insertAdjacentHTML('afterBegin', html);
	};
}



/*
Description:
Relies on `el.textContent` or `el.innerText` providing widest browser support.
*/

var getText;

if(html && "string" == typeof html.textContent) {
	getText = function(el) {
		return el.textContent;
	};
} else if(html && "string" == typeof html.innerText) {
	getText = function(el) {
		return el.innerText;
	};
}



/*
Description:
Relies on `document.defaultView.getComputedStyle` which degrades in IE8-
and compatibility modes. No float styles with this one and camel-case
names.
*/

/*
Degrades:
IE8, IE7, IE6, IE5.5, IE5, IE4, IE3
*/

/*
Author:
David Mark
*/

var getStyleComputed;

if (isHostObjectProperty(globalDocument, 'defaultView') &&
	isHostMethod(globalDocument.defaultView, 'getComputedStyle')) {
	getStyleComputed = function(el, style) {

		return document.defaultView.getComputedStyle(el, null)[style];
	};
}



/*
Description:

Note: no borders on the HTML element as that can add cross-browser complications (part of the chrome in IE and other MSHTML-based browsers, not so in others) and no quirks mode (as the BODY then becomes outermost element in the layout in IE and the BODY should be allowed to have borders).
*/

/*
Degrades:
*/

/*
Author:
Adam Silver
*/

var getPositionRelativeToDocument;

if(getPositionRelativeToViewport && getViewportScrollPosition) {
	getPositionRelativeToDocument = function(el) {
		var position = getPositionRelativeToViewport(el),
			scrollPosition = getViewportScrollPosition(),
			x = position[0]+scrollPosition[0],
			y = position[1]+scrollPosition[1];

		return [x, y];
	};
}



/*
Description:
Relies on `el.offsetWidth/Height`
*/

/*
Degrades:
IE3
*/

/*
Author:
David Mark
*/

var getOuterSize;

if(html && typeof html.offsetWidth == 'number') {
	getOuterSize = function(el) {
		return [el.offsetHeight, el.offsetWidth];
	};
}



/*
Description:
Relies on `el.clientWidth/Height`
*/

/*
Degrades:
IE3
*/

/*
Author:
David Mark
*/

var getInnerSize;

if(html && typeof html.clientWidth == 'number') {
	getInnerSize = function(el) {
		return [el.clientHeight, el.clientWidth];
	};
}



/*
Description:
Relies on `el.innerHTML`
*/

// See: https://groups.google.com/forum/#!search/david$20mark$20innerHTML/comp.lang.javascript/QQ9ClOT6igQ/LIZ5QXmmuw0J

/*
Degrades:
IE3
*/

/*
Author:
David Mark
*/

var getHtml;

if(html && "string" == typeof html.innerHTML) {
	getHtml = function(el) {
		return el.innerHTML;
	};
}


/*
Description:
Relies on 'document.getElementsByTagName'
*/

var getDescendantsByTagName;

if(globalDocument && isHostMethod(globalDocument, "getElementsByTagName") && toArray) {
	getDescendantsByTagName = function(el, tagName) {
		return toArray((el || document).getElementsByTagName(tagName));
	};
}



/*
Description:
Relies on 'document.getElementsByClassName'
*/

var getDescendantsByClassName;

if (globalDocument && isHostMethod(globalDocument, "getElementsByClassName") && toArray) {
	getDescendantsByClassName = function(el, className) {
		return toArray((el || document).getElementsByClassName(className));
	};
}



/*
Description:
Relies on `jessie.getElementParentElement` and `jessie.getElementTagName`
*/

var getAncestorByTagName;

if(getElementParentElement && getElementTagName){
	getAncestorByTagName = function(el, tagName) {
		el = getElementParentElement(el);
		while (el && tagName && getElementTagName(el) != tagName) {
			el = getElementParentElement(el);
		}
		return el;
	};
}



/*
Description:
Relies on `el.className` property, `jessie.getElementParentElement` and `jessie.hasClass`
*/

var getAncestorByClassName;

if(html && 'string' == typeof html.className && getElementParentElement && hasClass) {
	getAncestorByClassName = function(el, className) {
		el = getElementParentElement(el);
		while (el && !hasClass(el, className)) {
			el = getElementParentElement(el);
		}
		return el;
	};
}



var findProprietaryStyle;

if(html && isHostObjectProperty(html, "style")){
	findProprietaryStyle = function (style, el) {
		if ('string' != typeof el.style[style]) {
			var prefixes = ['Moz', 'O', 'Khtml', 'Webkit', 'Ms'],
			i = prefixes.length;
			style = style.charAt(0).toUpperCase() + style.substring(1);
			while ( i-- ) {
				if ('undefined' != typeof el.style[prefixes[i] + style]) {
					return prefixes[i] + style;
				}
			}
			return null;
		}
		return style;
	};
}




/*
Description:
Relies on `document.createElement`
*/

/*
Author:
David Mark
*/

var createElement;

if(globalDocument && isHostMethod(globalDocument, "createElement")) {
	createElement = function(tagName, doc) {
		return (doc || document).createElement(tagName);
	};
}


/* */

var htmlToNodes;

/*
 * htmlToNodes
 *
 * Relies on 'jessie.setHtml' and 'jessie.createElement'
 *
 */

if (setHtml && createElement) {
    htmlToNodes = function(html, docNode) {
        var c;

        elTemp = createElement('div', docNode);

        if (elTemp) {
            setHtml(html);
            c = elTemp.childNodes;
            elTemp = null;
        }

        return c;
    };
}





/*
 Description:
 Relies on `el.insertAdjacentHTML
 IE6 `el.insertAdjacentHtml` does not work on table, tbody, thead, tr elements
 */

/*
 Degrades:
 IE3, Firefox 7, Safari 3, Opera 7
 */

/*
 Author:
 Ben Chidgey
 */

var appendHtml;

if (html && isHostMethod(html, 'insertAdjacentHTML')) {
	appendHtml = function (el, html) {
		el.insertAdjacentHTML('beforeEnd', html);
	};
}



/*
Description:
Relies on `el.appendChild`
*/

/*
Author:
Adam Silver
*/

var appendChild;

if(html && isHostMethod(html, 'appendChild')) {
	appendChild = function(el, appendEl) {
		return el.appendChild(appendEl);
	};
}




/*
Description:
Relies on the `el.classList.add`
*/

/*
Degrades:
IE9, IE8, IE7, IE6, IE5.5, IE5, IE4, IE3 Chrome 7, FF3.5, Safari 5.0, Opera 11.1, IOS Safari 4.3, Opera Mini 6.0, Opera Mobile 11.0, Android Safari 2.3
*/

/*
See:
This is the see also section
*/

/*
Author:
Adam Silver
*/

var addClass;

if (html && isHostObjectProperty(html, "classList") && isHostMethod(html.classList, "add") ) {
	addClass = function(el, className) {
		return el.classList.add(className);
	};
}


KD.dom.isHostMethod = isHostMethod;
KD.dom.isHostObjectProperty = isHostObjectProperty;
KD.dom.areFeatures = areFeatures;
KD.dom.toArray = toArray;
KD.dom.detachListener = detachListener;
KD.dom.getEventTarget = getEventTarget;
KD.dom.attachListener = attachListener;
KD.dom.query = query;
KD.dom.queryOne = queryOne;
KD.dom.isNodeInNodeList = isNodeInNodeList;
KD.dom.bind = bind;
KD.dom.undelegateListener = undelegateListener;
KD.dom.delegateListener = delegateListener;
KD.dom.getElementTagName = getElementTagName;
KD.dom.getElementParentElement = getElementParentElement;
KD.dom.isInQuery = isInQuery;
KD.dom.isDescendant = isDescendant;
KD.dom.delegateBoundListener = delegateBoundListener;
KD.dom.hasClass = hasClass;
KD.dom.attachWindowListener = attachWindowListener;
KD.dom.getViewportScrollPosition = getViewportScrollPosition;
KD.dom.getPositionRelativeToViewport = getPositionRelativeToViewport;
KD.dom.getElement = getElement;
KD.dom.undelegateQueryListener = undelegateQueryListener;
KD.dom.setViewportScrollPosition = setViewportScrollPosition;
KD.dom.setInputValue = setInputValue;
KD.dom.getViewportSize = getViewportSize;
KD.dom.getEventTargetRelated = getEventTargetRelated;
KD.dom.detachWindowListener = detachWindowListener;
KD.dom.detachBoundListener = detachBoundListener;
KD.dom.delegateTagNameListener = delegateTagNameListener;
KD.dom.delegateQueryListener = delegateQueryListener;
KD.dom.delegateBoundQueryListener = delegateBoundQueryListener;
KD.dom.delegateBoundClassNameListener = delegateBoundClassNameListener;
KD.dom.cancelPropagation = cancelPropagation;
KD.dom.cancelDefault = cancelDefault;
KD.dom.attachDocumentListener = attachDocumentListener;
KD.dom.attachBoundWindowListener = attachBoundWindowListener;
KD.dom.attachBoundListener = attachBoundListener;
KD.dom.setText = setText;
KD.dom.setSize = setSize;
KD.dom.setPosition = setPosition;
KD.dom.setHtml = setHtml;
KD.dom.removeClass = removeClass;
KD.dom.removeChild = removeChild;
KD.dom.prependHtml = prependHtml;
KD.dom.getText = getText;
KD.dom.getStyleComputed = getStyleComputed;
KD.dom.getPositionRelativeToDocument = getPositionRelativeToDocument;
KD.dom.getOuterSize = getOuterSize;
KD.dom.getInnerSize = getInnerSize;
KD.dom.getHtml = getHtml;
KD.dom.getDescendantsByTagName = getDescendantsByTagName;
KD.dom.getDescendantsByClassName = getDescendantsByClassName;
KD.dom.getAncestorByTagName = getAncestorByTagName;
KD.dom.getAncestorByClassName = getAncestorByClassName;
KD.dom.findProprietaryStyle = findProprietaryStyle;
KD.dom.createElement = createElement;
KD.dom.htmlToNodes = htmlToNodes;
KD.dom.appendHtml = appendHtml;
KD.dom.appendChild = appendChild;
KD.dom.addClass = addClass;

	globalDocument = html = null;

}(window));

module.exports = KD.dom;