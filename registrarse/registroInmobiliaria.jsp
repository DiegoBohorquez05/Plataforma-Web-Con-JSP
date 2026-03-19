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
                    mensaje = "<div class='alert alert-warning border-0'><i class='fas fa-exclamation-triangle mr-2'></i>Este correo ya está registrado.</div>";
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
                        response.sendRedirect("../logins/loginInmobiliaria.jsp?registro=success");
                        return;
                    }
                }
            } catch (Exception e) {
                mensaje = "<div class='alert alert-danger border-0'>Error: " + e.getMessage() + "</div>";
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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { 
            background: radial-gradient(circle at top left, #1a2a3a, #000000); 
            font-family: 'Inter', sans-serif;
            display: flex; 
            align-items: center; 
            justify-content: center; 
            min-height: 100vh; 
            margin: 0;
            padding: 20px;
        }

        /* Contenedor Glassmorphism Corporativo */
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

        /* Línea superior Cian */
        .register-card::before {
            content: "";
            position: absolute;
            top: 0; left: 0; width: 100%; height: 5px;
            background: linear-gradient(to right, #17a2b8, #0dcaf0);
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
        .btn-back:hover { color: #17a2b8; text-decoration: none; transform: translateX(-5px); }

        h3 { color: #fff; font-weight: 700; letter-spacing: -0.5px; }
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
            border-color: #17a2b8;
            box-shadow: 0 0 0 4px rgba(23, 162, 184, 0.1);
            color: #fff;
        }

        .form-control::placeholder { color: rgba(255,255,255,0.2); }

        /* Botón estilo Info Corporativo */
        .btn-info-custom { 
            background: #17a2b8; 
            border: none; 
            border-radius: 10px;
            padding: 15px;
            font-weight: 700;
            color: #fff;
            margin-top: 10px;
            transition: 0.3s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn-info-custom:hover { 
            background: #138496; 
            transform: translateY(-2px); 
            box-shadow: 0 10px 20px rgba(23, 162, 184, 0.2); 
        }

        .alert { border-radius: 12px; font-size: 0.9rem; }

        hr { border-top: 1px solid rgba(255,255,255,0.1); }
        .login-link { color: #17a2b8; font-weight: 600; text-decoration: none; transition: 0.2s; }
        .login-link:hover { color: #fff; text-decoration: none; }

        /* Decoración de fondo */
        .circle {
            position: absolute;
            width: 400px; height: 400px;
            background: linear-gradient(#17a2b8, #0dcaf0);
            border-radius: 50%;
            filter: blur(120px);
            opacity: 0.08;
            z-index: -1;
        }
    </style>
</head>
<body>

    <div class="circle" style="top: -100px; right: -100px;"></div>
    <div class="circle" style="bottom: -100px; left: -100px;"></div>

    <div class="register-card shadow-lg">
        <a href="../logins/loginInmobiliaria.jsp" class="btn-back">
            <i class="fas fa-chevron-left mr-2"></i> Volver al login
        </a>

        <div class="text-center">
            <div class="mb-3">
                <i class="fas fa-city fa-3x" style="color: #17a2b8;"></i>
            </div>
            <h3>Registro Inmobiliaria</h3>
            <p class="subtitle">Crea una cuenta corporativa para empezar</p>
        </div>

        <%= mensaje %>

        <form action="registroInmobiliaria.jsp" method="POST">
            <div class="form-group">
                <label>Nombre de la Empresa</label>
                <div class="input-group">
                    <input type="text" name="nombre_empresa" class="form-control" placeholder="Ej: Inmobiliaria Central S.A." required>
                </div>
            </div>

            <div class="form-group">
                <label>Correo Electrónico Corporativo</label>
                <input type="email" name="correo" class="form-control" placeholder="contacto@empresa.com" required>
            </div>

            <div class="form-row">
                <div class="form-group col-md-6">
                    <label>Teléfono de Contacto</label>
                    <input type="text" name="telefono" class="form-control" placeholder="3001234567" required>
                </div>
                <div class="form-group col-md-6">
                    <label>Contraseña</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>
            </div>
            
            <button type="submit" name="btnRegistrar" class="btn btn-info-custom btn-block shadow-sm">
                CREAR CUENTA EMPRESARIAL <i class="fas fa-arrow-right ml-2"></i>
            </button>
        </form>

        <hr class="my-4">

        <div class="text-center">
            <p class="mb-1 small text-white-50">¿Su empresa ya posee una cuenta?</p>
            <a href="../logins/loginInmobiliaria.jsp" class="login-link small">
                Iniciar Sesión Corporativa
            </a>
        </div>
    </div>

<%
    if (conexion != null && !conexion.isClosed()) {
        conexion.close();
    }
%>
</body>
</html>