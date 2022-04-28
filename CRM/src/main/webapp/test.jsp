<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%
        String a = request.getScheme();
        String b = request.getServerName();
        String c = String.valueOf(request.getServerPort());
        String d = request.getContextPath();
    %>

</head>
<body>
<%out.write(a);out.print(a);%><br>
协议是= <%out.print(a);%><br>
协议是= <%=a%><br>
服务器是=<%=b%><br>
端口号是=<%=c%><br>
根目录是=<%=d%><br>
</body>
</html>
