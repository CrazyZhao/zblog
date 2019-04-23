$(function() {
    $("#partner-manage-li").addClass("active");
    $("#partner-list-li").addClass("active");
    $("#partner-list-li").parent().addClass("in");
    var page = $("#current-page").val();
    if (page == null || page == 0) {
        page = 1;
    }
    $.ajax({
        url: '/admin/partner/initPage',
        data: 'page=' + page,
        success: function (data) {
            $("#total-num").text(data.totalCount);
            $("#total-page").text(data.totalPageNum);
            $("#current-page").text(data.page);
            if (data.totalCount > 0) {

                $.jqPaginator('#pagination', {
                    totalPages: data.totalPageNum,
                    totalCounts: data.totalCount,
                    visiblePages: 5,
                    currentPage: data.page,
                    prev: '<li class="prev"><a href="javascript:;">Previous</a></li>',
                    next: '<li class="next"><a href="javascript:;">Next</a></li>',
                    page: '<li class="page"><a href="javascript:;">{{page}}</a></li>',
                    onPageChange: function (num, type) {
                        $("#current-page").text(num);
                        loadPartnerList();
                    }
                });
            }else {
                loadPartnerList();
            }
        }
    });
});


// 跳转分页
function toPage(page) {
    $("#page").val(page);
    loadPartnerList();
}

// 加载菜单列表
function loadPartnerList() {
    var param = $("#keyword").val();
    // 收集参数
    var page = $("#now").val();
    if (isEmpty(page) || page == 0) {
        page = 1;
    }

    // 查询列表
    $.ajax({
        url: '/admin/partner/load',
        data: 'page=' + page+"&param="+param,
        success: function (data) {
            $("#dataList").html(data);
        }
    });

}


// 搜索
$("#partner-search").on('click',function () {
    loadPartnerList();

});

// 删除栏目
$("#dataList").on('click','.partner-delete',function () {
    new $.flavr({
        content: '确定要删除吗?',
        buttons: {
            primary: {
                text: '确定', style: 'primary', action: function () {
                    $.ajax({
                        url: '/admin/partner/delete/' + $(this).parent().data("id"),
                        method: "GET",
                        success: function (data) {
                            if (data.resultCode == 'success') {
                                autoCloseAlert(data.errorInfo, 1000);
                                loadPartnerList();
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

// 跳转栏目编辑页
$("#dataList").on('click','.partner-edit',function () {
    $.ajax({
        url: '/admin/partner/editJump/'+$(this).parent().data("id"),
        method: "GET",
        success: function (data) {
            $('#editPartnerContent').html(data);
            $('#editPartnerModal').modal('show');
            $('#editPartnerModal').addClass('animated');
            $('#editPartnerModal').addClass('flipInY');
        }
    });
});


// 跳转新增页面
$("#partner-add").on("click",function () {
    $.ajax({
        url: '/admin/partner/addJump',
        success: function (data) {
            $('#addPartnerContent').html(data);
            $('#addPartnerModal').modal('show');
            $('#addPartnerModal').addClass('animated');
            $('#addPartnerModal').addClass('bounceInLeft');
        }
    });
});




