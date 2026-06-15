/**
 * Object formUtil() Form 관련 Util을 제공 합니다.<br>
 * Form related Utilities
 * @constructor
 * @extends Object
 */
var formUtil = function() {
	_screenInfo : {};
};

/*
 * form 전체 id, value 값을 가져온다.
 * form id별로 데이터를 가져 올 경우 아래 사용
 * EVF.getComponent("form4").iterator(function() {
 	EVF.getComponent(this.getID()).setValue('');
   });
 */
formUtil.getFormData = function() {
	var a = {};

	EVF.componentManager && EVF.componentManager.each(function(b) {
		b = EVF.C(b);
		if (b instanceof EVF.AbstractEditField) {
			var c = b.getName();
			if (b instanceof EVF.Radio) b.isChecked() && (a[c] = b.getValue());
			else {
				var d = b instanceof EVF.CheckGroup ? b.getValue() : b._getRawValue();
				a[c] = d
			}
		}
		b instanceof EVF.FileManager &&
		(c = b.getID(), a[c] = b.getFileId())
	});

	return a;
};

/*
 * form 전체 id, value 값을 적용한다.
 */
formUtil.setFormData = function(formData) {
	formData = JSON.parse(formData);

	var formValue = formUtil.getFormData();
	var formKey = Object.keys(formValue);

	var formDataKey = Object.keys(formData);

	for(var i = 0; i < formKey.length; i++) {
		for(var j = 0; j < formDataKey.length; j++) {
			if(formKey[i] == formDataKey[j]) {
				if(formData[formDataKey[j]] != "") {
					EVF.getComponent(formDataKey[j]).setValue(formData[formDataKey[j]]);
				}
			}
		}
	}
};


/*
 * form id에 대한 animate
 */
formUtil.animate = function (id, fg) {
	$("#" + id).css('color', '#fff').css('background-color', '#ff988c');

	setTimeout(function () {
		if (fg == "form") {
			$("#" + id).animate({backgroundColor: "#fff", color: "#333"}, 1000)
		} else {
			$("#" + id).animate({backgroundColor: "#ebf2f6", color: "#333"}, 1000)
		}

	}, 4000);
};

/*
 * 다중 form id에 대한 animate
 */
formUtil.animateFor = function (ids, fg) {
	var array = [];

	for (var idx in ids) {
		// select validation 추가
		var $buttonSel = $('#'+ids[idx]).siblings('button');
		if($buttonSel[0] != undefined) {
			array.push($buttonSel);
			$buttonSel.css('color', '#fff').css('background-color', '#ff988c');
		} else {
			array.push(ids[idx]);
			$("#" + ids[idx]).css('color', '#fff').css('background-color', '#ff988c');
		}
	}

	animateSetTime(array, fg);
};

function animateSetTime(array, fg) {
	setTimeout(function () {
		for (var idx in array) {
			if (fg == "form") {
				if(array[idx].constructor === jQuery) {
					array[idx].animate({backgroundColor: "#fff", color: "#333"}, 1000)
				} else {
					$("#" + array[idx]).animate({backgroundColor: "#fff", color: "#333"}, 1000)
				}
			} else {
				$("#" + array[idx]).animate({backgroundColor: "#ebf2f6", color: "#333"}, 1000)
			}
		}
	}, 4000);
}

/**
 * Set Visible attribute for UX Component<br>
 *
 * @param {String}/{Array}
 *            component	component name
 * @param {Boolean}
 *            boolean 	true/false
 */
formUtil.setVisible = function(component, boolean) {
	if(component instanceof Array) {
		for(var x=0; x < component.length; x++) {
			EVF.C(component[x]).setVisible(boolean);
		};
	} else {
		EVF.C(component).setVisible(boolean);
	};
};