<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Mi Cuenta</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { 
            background: radial-gradient(circle at bottom left, #1a2a1d, #000000); 
            font-family: 'Inter', sans-serif;
            display: flex; 
            align-items: center; 
            justify-content: center; 
            height: 100vh; 
            margin: 0;
            overflow: hidden;
        }

        /* Contenedor Glassmorphism */
        .login-card { 
            width: 100%; 
            max-width: 420px; 
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            position: relative;
        }

        /* Línea superior con el verde solicitado */
        .login-card::before {
            content: "";
            position: absolute;
            top: 0; left: 0; width: 100%; height: 5px;
            background: linear-gradient(to right, #07ff28, #05b31c);
            border-radius: 20px 20px 0 0;
        }

        .btn-back { 
            color: rgba(255,255,255,0.6); 
            text-decoration: none; 
            font-size: 0.9rem;
            transition: 0.3s;
            display: inline-block;
            margin-bottom: 20px;
        }
        .btn-back:hover { color: #07ff28; text-decoration: none; transform: translateX(-5px); }

        h3 { color: #fff; font-weight: 700; letter-spacing: -0.5px; margin-bottom: 8px; }
        .subtitle { color: rgba(255,255,255,0.5); font-size: 0.9rem; margin-bottom: 30px; }
        
        /* Formulario */
        .form-group label { color: rgba(255,255,255,0.7); font-size: 0.8rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        
        .form-control { 
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            color: #fff;
            border-radius: 10px;
            padding: 12px 15px;
            height: auto;
        }
        
        .form-control:focus { 
            background: rgba(255,255,255,0.08);
            border-color: #07ff28;
            box-shadow: 0 0 0 4px rgba(7, 255, 40, 0.1);
            color: #fff;
        }

        /* Botón con el verde específico */
        .btn-entrar { 
            background: #07ff28; 
            border: none; 
            border-radius: 10px;
            padding: 14px;
            font-weight: 700;
            color: #000;
            margin-top: 10px;
            transition: 0.3s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn-entrar:hover { 
            background: #06e624; 
            transform: translateY(-2px); 
            box-shadow: 0 10px 20px rgba(7, 255, 40, 0.2); 
        }

        .alert-danger {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.2);
            color: #ff8a94;
            border-radius: 10px;
            font-size: 0.85rem;
        }

        hr { border-top: 1px solid rgba(255,255,255,0.1); }

        .create-account { color: #07ff28; font-weight: 600; text-decoration: none; transition: 0.2s; }
        .create-account:hover { color: #fff; text-decoration: none; }

        /* Decoración de fondo */
        .circle {
            position: absolute;
            width: 300px; height: 300px;
            background: linear-gradient(#07ff28, #05b31c);
            border-radius: 50%;
            filter: blur(100px);
            opacity: 0.1;
            z-index: -1;
        }
    </style>
</head>
<body>

    <div class="circle" style="top: -50px; left: -50px;"></div>
    <div class="circle" style="bottom: -50px; right: -50px;"></div>

    <div class="login-card shadow-lg">
        <a href="../index.jsp" class="btn-back">
            <i class="fas fa-arrow-left mr-2"></i> Volver al Inicio
        </a>

        <div class="text-center">
            <div class="mb-3">
                <i class="fas fa-user-circle fa-4x" style="color: #07ff28;"></i>
            </div>
            <h3>Bienvenido</h3>
            <p class="subtitle">Ingresa a tu cuenta de cliente</p>
        </div>
        
        <% if("credenciales_invalidas".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger text-center">
                <i class="fas fa-times-circle mr-2"></i> Correo o contraseña incorrectos.
            </div>
        <% } %>

        <form action="./validarCliente.jsp" method="POST">
            <div class="form-group">
                <label>Correo Electrónico</label>
                <input type="email" name="email" class="form-control" placeholder="ejemplo@correo.com" required>
            </div>
            
            <div class="form-group">
                <label>Contraseña</label>
                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-entrar btn-block">
                ENTRAR <i class="fas fa-chevron-right ml-2"></i>
            </button>
        </form>

        <hr class="my-4">

        <div class="text-center">
            <p class="mb-1 small text-white-50">¿No tienes una cuenta todavía?</p>
            <a href="../registrarse/registroCliente.jsp" class="create-account small">
                Regístrate como nuevo cliente
            </a>
        </div>
    </div>

</body>
</html>