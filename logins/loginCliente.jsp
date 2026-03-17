<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Mi Cuenta</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        /* Estilos heredados del estilo Admin */
        body { 
            background-color: #343a40; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            height: 100vh; 
            margin: 0;
        }
        .card { 
            width: 100%; 
            max-width: 400px; 
            border: none;
            border-top: 5px solid #06e624; 
            border-radius: 4px; 
            position: relative; 
        }
        .btn-back { 
            position: absolute; 
            top: -50px; 
            left: 0; 
            color: white; 
            text-decoration: none; 
        }
        .btn-back:hover { 
            color: #06e624; 
        }

        /* Botón ENTRAR con el color específico solicitado */
        .btn-entrar {
            background-color: #07ff28;
            border: none;
            color: #000; /* Texto negro para mejor contraste con el verde brillante */
            font-weight: bold;
        }
        .btn-entrar:hover {
            background-color: #06e624;
            color: #000;
        }
    </style>
</head>
<body>

    <div class="card shadow-lg p-4">
        <a href="../index.jsp" class="btn-back">
            <i class="fas fa-arrow-left"></i> Volver al Inicio
        </a>

        <h3 class="text-center mb-4">Bienvenido</h3>
        
        <% if("credenciales_invalidas".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger text-center small">El correo o la contraseña son incorrectos.</div>
        <% } %>

        <form action="./validarCliente.jsp" method="POST">
            <div class="form-group">
                <label>Correo Electrónico</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Contraseña</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            
            <%-- Botón con el nuevo color verde --%>
            <button type="submit" class="btn btn-entrar btn-block">ENTRAR</button>
        </form>

        <hr class="my-4">

        <div class="text-center">
            <p class="mb-1 small">¿No tienes una cuenta?</p>
            <a href="../registrarse/registroCliente.jsp" class="text-primary small">Crear cuenta nueva</a>
        </div>
    </div>

</body>
</html>