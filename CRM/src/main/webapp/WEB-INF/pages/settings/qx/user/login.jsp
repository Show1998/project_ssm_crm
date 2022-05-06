<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String baseUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=baseUrl%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function (){

		//给窗口添加一个事件，用来实现按下回车相当于点击登陆按钮
		$(window).keydown(function (e) {
			if(e.keyCode == 13){
				$("#loginBtn").click();
			}
		})

		$("#loginBtn").click(function (){
			//获取前端的参数
			var userName = $.trim($("#userName").val());
			var pwd = $.trim($("#pwd").val());
			var rememberTenDays = $("#rememberTenDays").prop("checked");
			//参数验证
			if(userName == ""){
				alert("用户名不能为空！");
				return;
			}else if (pwd == ""){
				alert("密码不能为空！");
				return;
			}else {
				$.ajax({
					url:'settings/qx/user/login.do',
					data:{
						userName:userName,
						pwd:pwd,
						rememberTenDays:rememberTenDays
					},
					dataType:'json',
					type:'post',
					success:function (data) {
						if (data.code == "1"){
							window.location.href = "workbench/index.do";
						}
						if (data.code == "0"){
							$("#msg").html(data.msg);
						}
					},
					beforeSend:function () {
						$("#msg").html("正在登陆，处理中！");
					}

				})
			}
		})
	})
</script>

</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
	</div>

	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="userName" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="pwd" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<input type="checkbox" id="rememberTenDays"> 十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg"></span>
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>
