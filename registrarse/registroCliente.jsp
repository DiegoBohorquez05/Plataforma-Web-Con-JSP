<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Crear Cuenta</title>
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
            min-height: 100vh; 
            margin: 0;
            padding: 20px;
            overflow-x: hidden;
        }

        /* Contenedor Glassmorphism */
        .register-card { 
            width: 100%; 
            max-width: 500px; 
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            position: relative;
        }

        /* Línea superior Verde Neón */
        .register-card::before {
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

        h2 { color: #fff; font-weight: 700; letter-spacing: -0.5px; }
        .subtitle { color: rgba(255,255,255,0.5); font-size: 0.9rem; margin-bottom: 30px; }
        
        /* Estilos de Formulario */
        .form-group label { 
            color: rgba(255,255,255,0.7); 
            font-size: 0.8rem; 
            font-weight: 600; 
            text-transform: uppercase; 
            letter-spacing: 0.5px;
        }
        
        .form-control { 
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            color: #fff;
            border-radius: 10px;
            padding: 12px 15px;
            height: auto;
            transition: 0.3s;
        }
        
        .form-control:focus { 
            background: rgba(255,255,255,0.08);
            border-color: #07ff28;
            box-shadow: 0 0 0 4px rgba(7, 255, 40, 0.1);
            color: #fff;
        }

        .form-control::placeholder { color: rgba(255,255,255,0.3); }

        /* Checkbox personalizado */
        .form-check-label { color: rgba(255,255,255,0.5); cursor: pointer; }
        
        /* Botón de Registro Verde */
        .btn-register { 
            background: #07ff28; 
            border: none; 
            border-radius: 10px;
            padding: 15px;
            font-weight: 700;
            color: #000;
            margin-top: 10px;
            transition: 0.3s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn-register:hover { 
            background: #06e624; 
            transform: translateY(-2px); 
            box-shadow: 0 10px 20px rgba(7, 255, 40, 0.2); 
        }

        hr { border-top: 1px solid rgba(255,255,255,0.1); }
        .login-link { color: #07ff28; font-weight: 600; text-decoration: none; transition: 0.2s; }
        .login-link:hover { color: #fff; text-decoration: none; }

        /* Decoración de fondo */
        .circle {
            position: absolute;
            width: 400px; height: 400px;
            background: linear-gradient(#07ff28, #05b31c);
            border-radius: 50%;
            filter: blur(120px);
            opacity: 0.08;
            z-index: -1;
        }
    </style>
</head>
<body>

    <div class="circle" style="top: -100px; left: -100px;"></div>
    <div class="circle" style="bottom: -100px; right: -100px;"></div>

    <div class="register-card shadow-lg">
        <a href="../logins/loginCliente.jsp" class="btn-back">
            <i class="fas fa-chevron-left mr-2"></i> Volver al login
        </a>

        <div class="text-center">
            <div class="mb-3">
                <i class="fas fa-user-plus fa-3x" style="color: #07ff28;"></i>
            </div>
            <h2>Crear Cuenta</h2>
            <p class="subtitle">Únete a InmoHome y encuentra tu próximo hogar</p>
        </div>

        <form action="./procesarRegistro.jsp" method="POST">
            <div class="form-group">
                <label><i class="fas fa-user mr-2"></i>Nombre Completo</label>
                <input type="text" name="nombre" class="form-control" placeholder="Ej. Juan Pérez" required>
            </div>

            <div class="form-group">
                <label><i class="fas fa-envelope mr-2"></i>Correo Electrónico</label>
                <input type="email" name="email" class="form-control" placeholder="juan@correo.com" required>
            </div>

            <div class="form-group">
                <label><i class="fas fa-lock mr-2"></i>Contraseña</label>
                <input type="password" name="password" class="form-control" placeholder="Mínimo 8 caracteres" required>
            </div>

            <div class="form-group form-check mt-4">
                <input type="checkbox" class="form-check-input" id="terminos" required>
                <label class="form-check-label small" for="terminos">
                    Acepto los <span style="color: #07ff28;">términos y condiciones</span> de InmoHome.
                </label>
            </div>

            <button type="submit" class="btn btn-register btn-block shadow-sm">
                REGISTRARME <i class="fas fa-paper-plane ml-2"></i>
            </button>
        </form>

        <hr class="my-4">

        <div class="text-center">
            <p class="mb-1 small text-white-50">¿Ya tienes una cuenta registrada?</p>
            <a href="../logins/loginCliente.jsp" class="login-link small">
                Inicia sesión aquí
            </a>
        </div>
    </div>

</body>
</html>