<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    String mensajeError = "";
    // Lógica de validación
    if (request.getParameter("btnEntrar") != null) {
        String correoInmo = request.getParameter("inmoCorreo");
        String passwordInmo = request.getParameter("inmoPass");

        if (conexion != null) {
            try {
                String sql = "SELECT id_inmobiliaria, nombre_empresa FROM inmobiliaria WHERE correo = ? AND password = ?";
                PreparedStatement ps = conexion.prepareStatement(sql);
                ps.setString(1, correoInmo);
                ps.setString(2, passwordInmo);
                
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    session.setAttribute("idInmobiliaria", rs.getInt("id_inmobiliaria"));
                    session.setAttribute("nombreInmo", rs.getString("nombre_empresa"));
                    response.sendRedirect("../dashboards/dashboardInmo.jsp");
                    return;
                } else {
                    mensajeError = "Correo o contraseña incorrectos.";
                }
                rs.close();
                ps.close();
            } catch (Exception e) {
                mensajeError = "Error de sistema: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Acceso Inmobiliarias</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        /* Estilo idéntico al que me pasaste pero con color Info (Azul) */
        body { background-color: #343a40; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .card { width: 100%; max-width: 400px; border-top: 5px solid #17a2b8; position: relative; }
        .btn-back { position: absolute; top: -50px; left: 0; color: white; text-decoration: none; }
        .btn-back:hover { color: #17a2b8; }
        .icon-header { color: #17a2b8; font-size: 2.5rem; display: block; margin-bottom: 10px; }
    </style>
</head>
<body>

    <div class="card shadow-lg p-4">
        <a href="../index.jsp" class="btn-back">
            <i class="fas fa-arrow-left"></i> Volver al Inicio
        </a>

        <div class="text-center mb-4">
            <i class="fas fa-building icon-header"></i>
            <h3>Panel Inmobiliaria</h3>
        </div>
        
        <% if(!mensajeError.isEmpty()) { %>
            <div class="alert alert-danger"><%= mensajeError %></div>
        <% } %>

        <form action="loginInmobiliaria.jsp" method="POST">
            <div class="form-group">
                <label>Correo Corporativo</label>
                <input type="email" name="inmoCorreo" class="form-control" placeholder="ejemplo@inmo.com" required>
            </div>
            <div class="form-group">
                <label>Contraseña</label>
                <input type="password" name="inmoPass" class="form-control" placeholder="••••••••" required>
            </div>
            <button type="submit" name="btnEntrar" class="btn btn-info btn-block font-weight-bold">ENTRAR</button>
            <div class="mt-3 text-center">
    <p class="small text-muted">¿Tu empresa no tiene cuenta? 
        <a href="../registrarse/registroInmobiliaria.jsp" class="text-info font-weight-bold">Regístrate aquí</a>
    </p>
</div>
        </form>
    </div>

<%
    // Cerrar conexión al final del archivo
    if (conexion != null && !conexion.isClosed()) {
        conexion.close();
    }
%>
</body>
</html>