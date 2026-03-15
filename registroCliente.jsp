<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Crear Cuenta</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #e9ecef 0%, #dee2e6 100%); display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 0; padding: 20px; }
        .card { width: 100%; max-width: 500px; border: none; border-radius: 15px; }
        .btn-success { background-color: #28a745; border: none; }
        .btn-back { color: #6c757d; text-decoration: none; display: inline-block; mb: 20px; }
        .btn-back:hover { color: #28a745; }
    </style>
</head>
<body>

    <div class="card shadow-lg p-4">
        <a href="loginCliente.jsp" class="btn-back mb-3">
            <i class="fas fa-chevron-left"></i> Volver al login
        </a>

        <div class="text-center mb-4">
            <h2 class="font-weight-bold text-dark">Registro de Usuario</h2>
            <p class="text-muted">Únete a InmoHome y encuentra tu próximo hogar</p>
        </div>

        <%-- Formulario que envía los datos a un procesador de registro --%>
        <form action="procesarRegistro.jsp" method="POST">
            <div class="form-group">
                <label><i class="fas fa-user mr-2"></i>Nombre Completo</label>
                <input type="text" name="nombre" class="form-control" placeholder="Juan Pérez" required>
            </div>

            <div class="form-group">
                <label><i class="fas fa-envelope mr-2"></i>Correo Electrónico</label>
                <input type="email" name="email" class="form-control" placeholder="juan@correo.com" required>
            </div>

            <div class="form-group">
                <label><i class="fas fa-lock mr-2"></i>Contraseña</label>
                <input type="password" name="password" class="form-control" placeholder="Crea una contraseña segura" required>
            </div>

            <div class="form-group form-check">
                <input type="checkbox" class="form-check-input" id="terminos" required>
                <label class="form-check-label small text-muted" for="terminos">
                    Acepto los términos y condiciones de InmoHome.
                </label>
            </div>

            <button type="submit" class="btn btn-success btn-block btn-lg shadow-sm font-weight-bold">
                REGISTRARME
            </button>
        </form>

        <div class="text-center mt-4">
            <p class="small">¿Ya tienes cuenta? <a href="loginCliente.jsp" class="text-success font-weight-bold">Inicia sesión aquí</a></p>
        </div>
    </div>

</body>
</html>