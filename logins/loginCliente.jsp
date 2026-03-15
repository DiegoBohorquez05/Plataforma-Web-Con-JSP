<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Mi Cuenta</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .card { width: 100%; max-width: 450px; border: none; border-radius: 15px; }
        .btn-primary { background-color: #007bff; border: none; }
        .btn-primary:hover { background-color: #0056b3; }
        .btn-back { position: absolute; top: -50px; left: 0; color: #495057; text-decoration: none; font-weight: 500; }
        .btn-back:hover { color: #007bff; }
    </style>
</head>
<body>

    <div class="card shadow-lg p-4">
        <a href="../index.jsp" class="btn-back">
            <i class="fas fa-arrow-left"></i> Volver a la página principal
        </a>

        <div class="text-center mb-4">
            <i class="fas fa-user-circle fa-4x text-primary mb-2"></i>
            <h2 class="font-weight-bold">Bienvenido</h2>
            <p class="text-muted">Ingresa tus credenciales para continuar</p>
        </div>
        
        <%-- Alerta de error si las credenciales fallan --%>
        <% if("credenciales_invalidas".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger text-center small">El correo o la contraseña son incorrectos.</div>
        <% } %>

        <%-- Formulario que envía a validarCliente.jsp --%>
        <form action="./validarCliente.jsp" method="POST">
            <div class="form-group">
                <label><i class="fas fa-envelope mr-2"></i>Correo Electrónico</label>
                <input type="email" name="email" class="form-control" placeholder="ejemplo@correo.com" required>
            </div>
            <div class="form-group">
                <label><i class="fas fa-lock mr-2"></i>Contraseña</label>
                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg shadow-sm">Iniciar Sesión</button>
        </form>

        <hr class="my-4">

        <div class="text-center">
            <p class="mb-1">¿No tienes una cuenta?</p>
            <a href="../registrarse/registroCliente.jsp" class="btn btn-outline-secondary btn-sm px-4">Crear cuenta nueva</a>
        </div>
    </div>

</body>
</html>