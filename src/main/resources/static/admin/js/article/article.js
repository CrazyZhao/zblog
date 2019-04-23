var pager = {page:1,start:0,limit:10};

/**
 * 初始化数据
 */
$(function() {
    $("#article-manage-li").addClass("active");
    $("#article-list-li").addClass("active");
    var page = $("#current-page").val();
    if (page == null || page == 0) {
        page = 1;
    }
    pager.page = page;
    $.ajax({
        url: '/admin/article/initPage',
        data: pager,
        success: function (data) {
            pager = data;
            $("#total-num").text(data.totalCount);
            $("#total-page").text(data.totalPageNum);
            $("#current-page").text(data.page);
            //初始化分页   2017年5月25日 update by eumji 由于插件在没有数据的时候会报错，所以添加一层判断
            if (pager.totalCount > 0 ) {
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
                        pager.page = num;
                        loadArticleList();
                    }
                });
            }else {
                loadArticleList();
            }
            $(".chosen-select").chosen({
                max_selected_options: 5,
                no_results_text: "没有找到",
                allow_single_deselect: true
            });
            $(".chosen-select").trigger("liszt:updated");
        }
    });

});

// 跳转分页
function toPage(page){
	$("#page").val(page);
	loadArticleList();		
}

//0:可用  1：不可用 
$("#dataList").on('click','.article-state',function () {
    var state = $(this).parent().data("state")==1?0:1;
    var id = $(this).parent().data("id");
    new $.flavr({
        content: '确定要修改状态吗?',
        buttons: {
            primary: {
                text: '确定', style: 'primary', action: function () {
                    $.ajax({
                        url: '/admin/article/updateStatue',
                        data: 'id=' + id + '&status=' +state,
                        success: function (data) {
                            if (data.resultCode == 'success') {
                                autoCloseAlert(data.errorInfo, 1000);
                                loadArticleList();
                            } else {
                                autoCloseAlert(data.errorInfo, 1000);
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

// 加载文章列表
function loadArticleList(){

    var categoryId = $("#categoryId option:selected").val();
    var keyword = $("#keyword").val();
    var tagIds = [];
    $("#tagId option:selected").each(function () {
        tagIds.push($(this).val());
    })
	// 查询列表
	$.ajax({
        url : '/admin/article/load',
        data : 'totalCount='+pager.totalCount+'&page='+pager.page+"&categoryId="+categoryId+"&title="+keyword+"&tagIds="+tagIds,
        success  : function(data) {
        	$("#dataList").html(data);
		}
    });
	
}


// 搜索
$("#article-search").on('click',function () {
 loadArticleList();
});

// 新增文章  跳转新页
$("#article-add").on('click',function () {
    window.location.href = "/admin/article/addPage";
});

// 删除文章
$("#dataList").on('click','.article-delete',function () {
    new $.flavr({
        content: '您确定要删除吗?',

        buttons: {
            primary: {
                text: '确定', style: 'primary', action: function () {
                    $.ajax({
                        url : '/admin/article/delete/'+$(this).parent().data("id"),
                        method: "GET",
                        success  : function(data) {
                            if(data.resultCode == 'success'){
                                autoCloseAlert(data.errorInfo,1000);
                                loadArticleList();
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
    // 调到列表页

});



// 编辑文章
$("#dataList").on('click','.article-edit',function () {
	window.open("/admin/article/editJump/?id="+$(this).parent().data("id"));
});