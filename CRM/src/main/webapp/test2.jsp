<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //http://127.0.0.1:8080/crm/
    String baseUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=baseUrl%>">
    <title>Title</title>
<%--    引入jQuery--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<%--    引入bootStrap--%>
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<%--    引入插件--%>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/el.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#demo").bs_pagination({

            })
        })
    </script>
</head>
<body>
<div id="demo"></div>
</body>
</html>
