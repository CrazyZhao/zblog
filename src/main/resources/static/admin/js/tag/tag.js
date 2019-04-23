$(function() {
    $("#label-manage-li").addClass("active");
    $("#label-list-li").addClass("active");
    $("#label-list-li").parent().addClass("in");
    var page = $("#current-page").val();
    if (page == null || page == 0) {
        page = 1;
    }
    $.ajax({
        url: '/admin/tag/initPage',
        data: 'page=' + page,
        success: function (data) {
            $("#total-num").text(data.totalCount);
            $("#total-page").text(data.totalPageNum);
            $("#current-page").text(data.page);
            if (data.totalCount > 0) {
                $.jqPaginator('#pagination', {
                    totalPages: data.totalPageNum,
                    visiblePages: 5,
                    currentPage: data.page,
                    prev: '<li class="prev"><a href="javascript:;">Previous</a></li>',
                    next: '<li class="next"><a href="javascript:;">Next</a></li>',
                    page: '<li class="page"><a href="javascript:;">{{page}}</a></li>',
                    onPageChange: function (num, type) {
                        // 加载管理员列表
                        $("#current-page").text(num);
                        loadTagList();
                    }
                });
            }else{
                loadTagList();
            }

        }
    });
});


// 加载管理员列表
function loadTagList(){
	// 收集参数
	var param = $("#keyword").val();
	var page = $("#current-page").text();
	if(isEmpty(page) || page == 0){
		page = 1;
	}
	
	// 查询列表
	$.ajax({
        url : '/admin/tag/load',
        data : 'page='+page+"&tagName="+param,
        success  : function(data) {
        	$("#dataList").html(data);
		}
    });

}


// 搜索
$("#tag-search").on('click',function () {
	loadTagList();
});

// 删除
$("#dataList").on('click','.tag-delete',function () {
    var id = $(this).parent().data("id");
    new $.flavr({
        content: '确定要删除吗?',
        buttons: {
            primary: {
                text: '确定', style: 'primary', action: function () {
                    $.ajax({
                        url : '/admin/tag/delete/'+id,
                        method: "GET",
                        success  : function(data) {
                            if(data.resultCode == 'success'){
                                autoCloseAlert(data.errorInfo,1000);
                                window.location.href = "/admin/tag/list";
                            }else{
                                autoCloseAlert(data.errorInfo,1000);
                            }
                        }
                    });
                }
            },
            success: {
                text: '取消', style: 'danger', action: function () {

                }
            }
        }
    });

});

// 跳转编辑页
$("#dataList").on('click','.tag-edit',function () {
	$.ajax({
        url : '/admin/tag/editJump/'+$(this).parent().data("id"),
      	method: "GET",
        success  : function(data) {
        	$('#editTagContent').html(data);
        	$('#editTagModal').modal('show');
        	$('#editTagModal').addClass('animated');
        	$('#editTagModal').addClass('flipInY');
		}
    });
});

// 关闭编辑管理员窗口
function closeEditWindow(){
	$('#editTagModal').modal('hide');
}

// 关闭新增管理员窗口
function closeAddWindow(){
	$('#addTagModal').modal('hide');
}


// 编辑管理员
function saveEditTag(){
	if(validateEditTag()){
		$.ajax({
	        url : '/admin/tag/update',
	        data : encodeURI($("#editForm").serialize()),
	        success  : function(data) {
	        	if(data.resultCode == 'success'){
	        		$('#editTagModal').modal('hide');
                    loadTagList();
                    autoCloseAlert(data.errorInfo,1000);
                }else{
	        		autoCloseAlert(data.errorInfo,1000);
	        	}
			}
	    });
	}
}

// 新增管理员
function saveAddTag(){
	if(validateAddTag()){
		$.ajax({
	        url : '/admin/tag/save',
	        data : encodeURI($("#addForm").serialize()),
	        success  : function(data) {
	        	if(data.resultCode == 'success'){
                    autoCloseAlert(data.errorInfo,1000);
                    window.location.href = "/admin/tag/list";
	        	}else{
	        		autoCloseAlert(data.errorInfo,1000);
	        	}
			}
	    });
	}
}

// 校验新增管理员输入框
function validateAddTag(){
	var tagName = $("#tagName").val();
	var aliasName = $("#aliasName").val();
	if(!isEmpty(tagName)){
		if(isSpecialSymbols(tagName)){
			autoCloseAlert("标签不能包含特殊符号",1000);
			return false;
		}
	}else{
		autoCloseAlert("标签不能为空",1000);
		return false;
	}
    if(!isEmpty(aliasName)){
        if(isSpecialSymbols(aliasName)){
            autoCloseAlert("标签不能包含特殊符号",1000);
            return false;
        }
    }else{
        autoCloseAlert("标签不能为空",1000);
        return false;
    }
	return true;
}

// 校验编辑管理员输入框
function validateEditTag(){
	var tagName = $("#tagName").val();
	if(!isEmpty(tagName)){
		if(isSpecialSymbols(tagName)){
			autoCloseAlert("标签不能包含特殊符号",1000);
			return false;
		}
	}else{
		autoCloseAlert("标签不能为空",1000);
		return false;
	}

	return true;
}

// 跳转新增管理员页面
$("#tag-add").on('click',function () {
	$.ajax({
        url : '/admin/tag/addJump',
        success  : function(data) {
        	$('#addTagContent').html(data);
        	$('#addTagModal').modal('show');
        	$('#addTagModal').addClass('animated');
        	$('#addTagModal').addClass('bounceInLeft');
		}
    });
});