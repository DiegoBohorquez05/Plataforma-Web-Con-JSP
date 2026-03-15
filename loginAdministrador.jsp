<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Acceso Administrativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body { background-color: #343a40; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .card { width: 100%; max-width: 400px; border-top: 5px solid #ffc107; position: relative; }
        .btn-back { position: absolute; top: -50px; left: 0; color: white; text-decoration: none; }
        .btn-back:hover { color: #ffc107; }
    </style>
</head>
<body>

    <div class="card shadow-lg p-4">
        <a href="index.jsp" class="btn-back">
            <i class="fas fa-arrow-left"></i> Volver al Inicio
        </a>

        <h3 class="text-center mb-4">Panel Admin</h3>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger">Usuario o contraseña incorrectos.</div>
        <% } %>

        <form action="validarAdmin.jsp" method="POST">
            <div class="form-group">
                <label>Usuario</label>
                <input type="text" name="adminUser" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Contraseña</label>
                <input type="password" name="adminPass" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-warning btn-block font-weight-bold">ENTRAR</button>
        </form>
    </div>

</body>
</html>