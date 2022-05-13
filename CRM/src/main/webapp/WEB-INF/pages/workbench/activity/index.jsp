<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String baseUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=baseUrl%>">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">
	//写一个函数，用来刷新活动页面
	function refreshActivity(pageNo,pageSize) {
		//获取数据
		var name = $("#conditionName").val();
		var owner = $("#conditionOwner").val();
		// var owner = "蔡";
		// alert(owner);
		var startTime = $("#startTime").val();
		var endTime =$("#endTime").val();
		//发送请求，处理结果
		$.ajax({
			url: 'workbench/activity/queryActivityByConditionForPage.do',
			data: {
				name:name,
				owner:owner,
				startDate:startTime,
				endDate:endTime,
				pageNo:pageNo,
				pageSize:pageSize
			},
			dataType: 'json',
			Type:'post',
			success:function (data) {
				$("#amountOfActivity").text(data.amount);
				var htmlStr ="";
				$.each(data.resultList,function (index,obj) {
					htmlStr+="<tr class=\"active\">";
					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">"+obj.name+"</a></td>";
					htmlStr+="<td>"+obj.owner+"</td>";
					htmlStr+="<td>"+obj.startDate+"</td>";
					htmlStr+="<td>"+obj.endDate+"</td>";
					htmlStr+="</tr>";
				});
				$("#tBody").html(htmlStr);

				//计算总页数
				var totalPages=1;
				if( data.amount%pageSize == 0){
					totalPages = data.amount/pageSize;
				}else {
					totalPages = parseInt(data.amount/pageSize)+1;
				}

				//调用分页的函数
				$("#demo").bs_pagination({
					currentPage:pageNo,

					rowsPerPage:pageSize,
					totalRows:data.amount,
					totalPages:totalPages,

					visiblePageLinks: 5,

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,

					onChangePage:function (event,pageObj) {
						refreshActivity(pageObj.currentPage,pageObj.rowsPerPage);
					}

				})
			}
		})
	}
	//函数，用来保存activity
	function saveActivity() {
		//获取数据
		var owner = $("#create-marketActivityOwner").val();
		var name = $("#create-marketActivityName").val();
		var startDate = $("#create-startTime").val();
		var endDate = $("#create-endTime").val();
		var cost = $("#create-cost").val();
		var description = $("#create-describe").val();
		//数据验证
		if(owner == ""){
			alert("所有者不能为空！");
			return;
		}
		if(name == ""){
			alert("名字不能为空！");
			return;
		}
		if(startDate != "" && endDate != ""){
			if(startDate > endDate){
				alert("结束日期不能小于开始日期！")
				return;
			}
		}
		var regExp = /^(([1-9]\d*)|0)$/
		if(!regExp.test(cost)){
			alert("成本只能为非负整数！")
			return;
		}
		//传递数据，处理响应
		$.ajax({
			url:'workbench/activity/createActivity.do',
			data:{
				owner:owner,
				name:name,
				startDate:startDate,
				endDate:endDate,
				cost:cost,
				description:description
			},
			dataType:'json',
			type:'post',
			success:function (data) {
				if(data.code == 1){
					$("#createActivityModal").modal("hide");
					refreshActivity(1,$("#demo").bs_pagination('getOption','rowsPerPage'));
				}
				if(data.code == 0){
					$("#createActivityModal").modal("show");
					alert(data.msg);
				}
			}
		})
	}
</script>

<script type="text/javascript">

	$(function(){
		//调用函数，查询活动
		refreshActivity(1,10);
		//给查询按钮添加函数
		$("#searchBtn").click(function () {
            var i = $("#demo").bs_pagination('getOption','rowsPerPage');
			refreshActivity(1,i);
		});
		//点击创建按钮
		$("#createActivityBtn").click(function () {
            //初始化工作
            //重置表单
            $("#createActivityForm")[0].reset();

			//模态窗口显示
			$("#createActivityModal").modal("show");

            //加载日历
            $("#create-startTime").datetimepicker({
                language:'zh-CN',
                format:'yyyy-mm-dd',
                minView:'month',
                initialDate:new Date(),
                autoclose:true,
                todayBtn:true,
                clearBtn:true
            });
            $("#create-endTime").datetimepicker({
                language:'zh-CN',
                format:'yyyy-mm-dd',
                minView:'month',
                initialDate:new Date(),
                autoclose:true,
                todayBtn:true,
                clearBtn:true
            });

            //点击保存按钮
			$("#saveActivityBtn").click(function () {
				saveActivity();
			})
		})
		//给全选按钮添加事件

		//点击删除按钮
		$("#deleteActivityBtn").click(function () {
			var checkArr = $("#tBody input[type = 'checkbox']:checked");
			var ids = "";
			if(checkArr.size() == 0){
				alert("请选中一条数据！")
				return;
			}
			if(window.confirm("确定删除吗？")) {
				$.each(checkArr, function () {
					ids += "id=" + this.value + "&"
				})
				ids = ids.substr(0, ids.length - 1);

				$.ajax({
					url: 'workbench/activity/deleteActivityById.do',
					data: ids,
					dataType: 'json',
					type: 'post',
					success: function (data) {
						if (data.code == 0) {
							alert(data.msg)
						}
						if (data.code == 1) {
							refreshActivity(1, $("#demo").bs_pagination('getOption', 'rowsPerPage'));
						}
					}
				})
			}
		})
		//点击修改按钮
		$("#alertActivityBtn").click(function () {
			var id = $("#tBody input[type = 'checkbox']:checked")
			if(id.size() != 1){
				alert("请选择一条数据！")
				return;
			}
			$.ajax({
				url:'workbench/activity/queryActivityById.do',
				data:{
					id:id.val()
				},
				type:'get',
				dataType:'json',
				success:function (data) {
					$("#edit-id-hidden").val(data.id);
					$("#edit-marketActivityOwner").val(data.owner);
					$("#edit-marketActivityName").val(data.name);
					$("#edit-startTime").val(data.startDate);
					$("#edit-endTime").val(data.endDate);
					$("#edit-cost").val(data.cost);
					$("#edit-describe").html(data.description);
					//弹出模态窗口
					$("#editActivityModal").modal("show");
					//加载日历
					$("#edit-startTime").datetimepicker({
						language:'zh-CN',
						format:'yyyy-mm-dd',
						minView:'month',
						initialDate:new Date(),
						autoclose:true,
						todayBtn:true,
						clearBtn:true
					});
					$("#edit-endTime").datetimepicker({
						language:'zh-CN',
						format:'yyyy-mm-dd',
						minView:'month',
						initialDate:new Date(),
						autoclose:true,
						todayBtn:true,
						clearBtn:true
					});
				}
			})
			//点击更新按钮
			$("#updateActivityBtn").click(function () {
				//获取数据
				var id = $("#edit-id-hidden").val();
				var owner = $("#edit-marketActivityOwner").val();
				var name = $("#edit-marketActivityName").val();
				var startDate = $("#edit-startTime").val();
				var endDate = $("#edit-endTime").val();
				var cost = $("#edit-cost").val();
				var description = $("#edit-describe").val();
				//数据验证
				if(owner == ""){
					alert("所有者不能为空！");
					return;
				}
				if(name == ""){
					alert("名字不能为空！");
					return;
				}
				if(startDate != "" && endDate != ""){
					if(startDate > endDate){
						alert("结束日期不能小于开始日期！")
						return;
					}
				}
				var regExp = /^(([1-9]\d*)|0)$/
				if(!regExp.test(cost)){
					alert("成本只能为非负整数！")
					return;
				}
				$.ajax({
					url:'workbench/activity/updateActivityById.do',
					data:{
						id:id,
						owner:owner,
						name:name,
						startDate:startDate,
						endDate:endDate,
						cost:cost,
						description:description
					},
					type:'post',
					dataType:'json',
					success:function (data) {
						if(data.code == 1){
							$("#editActivityModal").modal("hide");
							refreshActivity(1,$("#demo").bs_pagination('getOption','rowsPerPage'));
						}
						if(data.code == 0){
							$("#editActivityModal").modal("show");
							alert(data.msg);
						}
					}
				})
			})

		})
	});

</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form id="createActivityForm" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>

                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id-hidden">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>


	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="conditionName">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="conditionOwner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="endTime">
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="alertActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
					<tr style="color: #B3B3B3;">
						<td><input type="checkbox" id="checkAllBtn"/></td>
						<td>名称</td>
						<td>所有者</td>
						<td>开始日期</td>
						<td>结束日期</td>
					</tr>
					</thead>
					<tbody id="tBody">
<%--					<tr class="active">--%>
<%--						<td><input type="checkbox" /></td>--%>
<%--						<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
<%--						<td>zhangsan</td>--%>
<%--						<td>2020-10-10</td>--%>
<%--						<td>2020-10-20</td>--%>
<%--					</tr>--%>
					</tbody>
				</table>
				<div id="demo"></div>
			</div>

<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default"  style="cursor: default;">共<b id="amountOfActivity"></b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" id="pageSize">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
<%--			</div>--%>

		</div>

	</div>
</body>
</html>
