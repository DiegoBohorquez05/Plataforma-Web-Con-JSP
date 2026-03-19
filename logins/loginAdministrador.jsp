<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Acceso Administrativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { 
            background: radial-gradient(circle at top right, #2c3e50, #000000); 
            font-family: 'Inter', sans-serif;
            display: flex; 
            align-items: center; 
            justify-content: center; 
            height: 100vh; 
            margin: 0;
            overflow: hidden;
        }

        /* Contenedor con efecto de cristal */
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

        .login-card::before {
            content: "";
            position: absolute;
            top: 0; left: 0; width: 100%; height: 5px;
            background: linear-gradient(to right, #ffc107, #ff9800);
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
        .btn-back:hover { color: #ffc107; text-decoration: none; transform: translateX(-5px); }

        h3 { color: #fff; font-weight: 700; letter-spacing: -0.5px; margin-bottom: 30px; }
        
        /* Estilos de los inputs */
        .form-group label { color: rgba(255,255,255,0.7); font-size: 0.8rem; font-weight: 600; text-transform: uppercase; }
        
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
            border-color: #ffc107;
            box-shadow: 0 0 0 4px rgba(255, 193, 7, 0.1);
            color: #fff;
        }

        .btn-login { 
            background: #ffc107; 
            border: none; 
            border-radius: 10px;
            padding: 14px;
            font-weight: 700;
            color: #000;
            margin-top: 20px;
            transition: 0.3s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn-login:hover { background: #ff9800; transform: translateY(-2px); box-shadow: 0 10px 20px rgba(255, 193, 7, 0.2); }

        .alert-danger {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.2);
            color: #ff8a94;
            border-radius: 10px;
            font-size: 0.9rem;
        }

        /* Decoración de fondo */
        .circle {
            position: absolute;
            width: 200px; height: 200px;
            background: linear-gradient(#ffc107, #ff9800);
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.15;
            z-index: -1;
        }
    </style>
</head>
<body>

    <div class="circle" style="top: 10%; right: 20%;"></div>
    <div class="circle" style="bottom: 10%; left: 20%;"></div>

    <div class="login-card shadow-lg">
        <a href="../index.jsp" class="btn-back">
            <i class="fas fa-chevron-left mr-2"></i> Volver al Portal
        </a>

        <div class="text-center">
            <div class="mb-3">
                <i class="fas fa-user-shield fa-3x text-warning"></i>
            </div>
            <h3>Administración</h3>
        </div>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger animate__animated animate__shakeX">
                <i class="fas fa-exclamation-circle mr-2"></i> Credenciales no válidas.
            </div>
        <% } %>

        <form action="./validarAdmin.jsp" method="POST">
            <div class="form-group">
                <label>Usuario Maestro</label>
                <div class="input-group">
                    <input type="text" name="adminUser" class="form-control" placeholder="Ingrese su usuario" required>
                </div>
            </div>
            
            <div class="form-group">
                <label>Clave de Acceso</label>
                <input type="password" name="adminPass" class="form-control" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-login btn-block">
                Iniciar Sesión <i class="fas fa-sign-in-alt ml-2"></i>
            </button>
        </form>
    </div>

</body>
</html>