<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //http://127.0.0.1:8080/crm/
    String baseUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=baseUrl%>">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <title>Title</title>
    <%
        String a = request.getScheme();
        String b = request.getServerName();
        String c = String.valueOf(request.getServerPort());
        String d = request.getContextPath();
    %>
    <script type="text/javascript">
        $(function () {
           $("#myDate").datetimepicker({
               language:'zh-CN',
               format:'yyyy-mm-dd',
               minView:'month',
               initialDate:new Date(),
               autoclose:true
           })
        });
    </script>

</head>

<body>
<%out.write(a);out.print(a);%><br>
协议是= <%out.print(a);%><br>
协议是= <%=a%><br>
服务器是=<%=b%><br>
端口号是=<%=c%><br>
根目录是=<%=d%><br>

<input type="text" id="myDate">
</body>
</html>
