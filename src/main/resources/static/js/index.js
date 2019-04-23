var pager = {page:1,start:0,limit:10};
/*初始化文章分页信息*/
$(function () {
    $('body').addClass('loaded');
            $.ajax({
                type: 'GET',
                url: '/pager/articles/load',
                data:pager,
                success: function (data){
                    pager = data;
                    $("#pagination").data("type","article");
                    // 2017年5月25日 update by eumji 由于插件在没有数据的时候会报错，所以添加一层判断
                    if (pager.totalCount > 0){
                        initPage(null);
                    }
                }
        });

})

/*function initPage() {
    $('.M-box').pagination({
        pagerCount:pager.totalPageNum, //	总页数
        current:pager.pager,//当前第几页
        showData:pager.limit,//每页显示的条数
        count:3,//	当前选中页前后页数
        callback:function(api){
            $('.now').text(api.getCurrent());
        }
    },function(api){
        $('.now').text(api.getCurrent());
    });
}*/
/*将初始化页面封装成一个方法*/
function initPage(id) {

    $("#total-num").text(pager.totalCount);
    $("#total-page").text(pager.totalPageNum);
    $("#current-page").text(pager.page);
    $.jqPaginator('#pagination', {
        totalPages: pager.totalPageNum,
        totalCounts: pager.totalCount,
        visiblePages: 5,
        currentPage: pager.page,
        prev: '<li class="prev"><a href="javascript:;">Previous</a></li>',
        next: '<li class="next"><a href="javascript:;">Next</a></li>',
        page: '<li class="page"><a href="javascript:;">{{page}}</a></li>',
        onPageChange: function (num, type) {
            pager.page = num;
            var type = $("#pagination").data("type");
            loadList(type,id);
            // 当前第几页
            $("#current-page").text(num);
            $(".chosen-select").chosen({
                max_selected_options: 5,
                no_results_text: "没有找到",
                allow_single_deselect: true
            });
            $(".chosen-select").trigger("liszt:updated");
        }
    });
}

/*将加载文章,文章分类,标签分类重构成一个方法*/
function  loadList(type,id) {
    var url = "";
    if (type == "article"){
        url = '/'+type+'/load';
    }
    else{
        url = '/'+type+'/load/'+id;
    }
    $.ajax({
        type: 'GET',
        url: url,
        data: pager,
        success: function (data) {
            $("#main-article").html(data);
            //初始化文章分页信息
            //初始化文章
            /*分享初始化*/
            $(".socialShare").socialShare({
                content: "Bright在IT,生活,音乐方面的分享",
                url:"www.backender.cn/",
                title:$("#article-title").text(),
                summary:'Bright个人博客分享,欢迎指教',
                pic:'http://img.dongqiudi.com/uploads/avatar/2015/07/25/QM387nh7As_thumb_1437790672318.jpg'
            });
            $('#loader-wrapper .load_title').remove();
        }
    });
}

$("#main-article").on('click','.article-tag-link',function () {
    var tagId = $(this).data("id");
    var loadPager = {page:1,start:0,limit:10};
    $.ajax({
        type: 'GET',
        url: '/pager/tags/' + tagId,
        data: loadPager,
        success: function (data) {
            pager = data;
            $("#pagination").data("type","tags");
            initPage(tagId);
        }
    });
})

/*文章归档点击事件*/
$(".archive-list-link").on('click',function () {
    var createTime = $(this).data("id");
    var count  = $(this).next().text();
    pager.totalCount = parseInt(count);
    pager.totalPageNum = Math.floor(count/pager.limit)+1;
    pager.page = 1;
    $("#pagination").data("type","createTime");
    initPage(createTime);
})
/*文章分类点击事件*/
$(".category-list-link").on('click',function () {
    var categoryId = $(this).data("id");
    var loadPager = {page:1,start:0,limit:10};
    $.ajax({
        type: 'GET',
        url: '/pager/categories/' + categoryId,
        data: loadPager,
        success: function (data) {
            pager = data;
            $("#pagination").data("type","categories");
            initPage(categoryId);
        }
    });
})

/*为动态元素绑定lick事件*/
$("#main-article").on('click','.article-category-link',function () {
    var categoryId = $(this).data("id");
    var loadPager = {page:1,start:0,limit:10};
    $.ajax({
        type: 'GET',
        url: '/pager/categories/' + categoryId,
        data: loadPager,
        success: function (data) {
            pager = data;
            $("#pagination").data("type","categories");
            initPage(categoryId);
        }
    });
})


