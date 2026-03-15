<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String idProp = request.getParameter("id_propiedad");
    if (idProp == null) { response.sendRedirect("index.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Agendar Cita - InmoHome</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow mx-auto" style="max-width: 450px;">
            <div class="card-header bg-primary text-white"><h4>Programar Visita</h4></div>
            <div class="card-body">
                <form action="guardarCita.jsp" method="POST">
                    <input type="hidden" name="id_propiedad" value="<%= idProp %>">
                    <div class="form-group">
                        <label>Fecha:</label>
                        <input type="date" name="txtFecha" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Hora:</label>
                        <input type="time" name="txtHora" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-success btn-block">Confirmar Cita</button>
                    <a href="index.jsp" class="btn btn-link btn-block">Cancelar</a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>