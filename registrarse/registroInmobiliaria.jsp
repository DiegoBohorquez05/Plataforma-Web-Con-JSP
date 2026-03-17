<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    String mensaje = "";
    if (request.getParameter("btnRegistrar") != null) {
        String nombre = request.getParameter("nombre_empresa");
        String correo = request.getParameter("correo");
        String passReg = request.getParameter("password");
        String tel = request.getParameter("telefono");

        if (conexion != null) {
            try {
                // Verificamos si el correo ya existe
                String checkSql = "SELECT id_inmobiliaria FROM inmobiliaria WHERE correo = ?";
                PreparedStatement psCheck = conexion.prepareStatement(checkSql);
                psCheck.setString(1, correo);
                ResultSet rsCheck = psCheck.executeQuery();

                if (rsCheck.next()) {
                    mensaje = "<div class='alert alert-warning'>Este correo ya está registrado.</div>";
                } else {
                    // Insertamos la nueva inmobiliaria
                    String sql = "INSERT INTO inmobiliaria (nombre_empresa, correo, password, telefono) VALUES (?, ?, ?, ?)";
                    PreparedStatement ps = conexion.prepareStatement(sql);
                    ps.setString(1, nombre);
                    ps.setString(2, correo);
                    ps.setString(3, passReg);
                    ps.setString(4, tel);

                    int filas = ps.executeUpdate();
                    if (filas > 0) {
                        // Registro exitoso, redirigimos al login con un aviso
                        response.sendRedirect("../logins/loginInmobiliaria.jsp?registro=success");
                        return;
                    }
                }
            } catch (Exception e) {
                mensaje = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Registro de Empresa</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body { background-color: #343a40; display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 20px 0; }
        .card { width: 100%; max-width: 450px; border-top: 5px solid #17a2b8; }
        .icon-header { color: #17a2b8; font-size: 2rem; }
    </style>
</head>
<body>

    <div class="card shadow-lg p-4">
        <div class="text-center mb-4">
            <i class="fas fa-building-user icon-header"></i>
            <h3 class="mt-2">Registro Inmobiliaria</h3>
            <p class="text-muted small">Crea una cuenta para empezar a publicar</p>
        </div>

        <%= mensaje %>

        <form action="registroInmobiliaria.jsp" method="POST">
            <div class="form-group">
                <label class="small font-weight-bold">Nombre de la Empresa</label>
                <input type="text" name="nombre_empresa" class="form-control" placeholder="Ej: Inmobiliaria Central" required>
            </div>
            <div class="form-group">
                <label class="small font-weight-bold">Correo Electrónico</label>
                <input type="email" name="correo" class="form-control" placeholder="contacto@empresa.com" required>
            </div>
            <div class="form-row">
                <div class="form-group col-md-6">
                    <label class="small font-weight-bold">Teléfono</label>
                    <input type="text" name="telefono" class="form-control" placeholder="3001234567" required>
                </div>
                <div class="form-group col-md-6">
                    <label class="small font-weight-bold">Contraseña</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>
            </div>
            
            <button type="submit" name="btnRegistrar" class="btn btn-info btn-block font-weight-bold shadow-sm">
                CREAR CUENTA
            </button>
        </form>

        <div class="mt-3 text-center">
            <a href="../logins/loginInmobiliaria.jsp" class="text-secondary small">¿Ya tienes cuenta? Inicia sesión</a>
        </div>
    </div>

<%
    if (conexion != null && !conexion.isClosed()) {
        conexion.close();
    }
%>
</body>
</html>