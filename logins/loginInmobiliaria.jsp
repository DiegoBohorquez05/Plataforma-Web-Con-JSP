<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    String mensajeError = "";
    // Lógica de validación (Intacta)
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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { 
            background: radial-gradient(circle at top left, #1a2a3a, #000000); 
            font-family: 'Inter', sans-serif;
            display: flex; 
            align-items: center; 
            justify-content: center; 
            height: 100vh; 
            margin: 0;
            overflow: hidden;
        }

        /* Contenedor Glassmorphism unificado */
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

        /* Línea superior con color Info (Cian) */
        .login-card::before {
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

        h3 { color: #fff; font-weight: 700; letter-spacing: -0.5px; margin-bottom: 8px; }
        .subtitle { color: rgba(255,255,255,0.5); font-size: 0.9rem; margin-bottom: 30px; }
        
        /* Estilos de Formulario unificados */
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

        /* Botón estilo Info */
        .btn-info-custom { 
            background: #17a2b8; 
            border: none; 
            border-radius: 10px;
            padding: 14px;
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

        .alert-danger {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.2);
            color: #ff8a94;
            border-radius: 10px;
            font-size: 0.85rem;
        }

        hr { border-top: 1px solid rgba(255,255,255,0.1); }
        .reg-link { color: #17a2b8; font-weight: 600; text-decoration: none; transition: 0.2s; }
        .reg-link:hover { color: #fff; text-decoration: none; }

        /* Decoración de fondo */
        .circle {
            position: absolute;
            width: 300px; height: 300px;
            background: linear-gradient(#17a2b8, #0dcaf0);
            border-radius: 50%;
            filter: blur(100px);
            opacity: 0.1;
            z-index: -1;
        }
    </style>
</head>
<body>

    <div class="circle" style="top: -50px; right: -50px;"></div>
    <div class="circle" style="bottom: -50px; left: -50px;"></div>

    <div class="login-card shadow-lg">
        <a href="../index.jsp" class="btn-back">
            <i class="fas fa-arrow-left mr-2"></i> Volver al Inicio
        </a>

        <div class="text-center">
            <div class="mb-3">
                <i class="fas fa-building fa-3x" style="color: #17a2b8;"></i>
            </div>
            <h3>Socio Inmobiliario</h3>
            <p class="subtitle">Gestiona tus propiedades y citas</p>
        </div>
        
        <% if(!mensajeError.isEmpty()) { %>
            <div class="alert alert-danger text-center">
                <i class="fas fa-exclamation-triangle mr-2"></i> <%= mensajeError %>
            </div>
        <% } %>

        <form action="loginInmobiliaria.jsp" method="POST">
            <div class="form-group">
                <label>Correo Corporativo</label>
                <input type="email" name="inmoCorreo" class="form-control" placeholder="nombre@empresa.com" required>
            </div>
            
            <div class="form-group">
                <label>Contraseña</label>
                <input type="password" name="inmoPass" class="form-control" placeholder="••••••••" required>
            </div>

            <button type="submit" name="btnEntrar" class="btn btn-info-custom btn-block">
                INGRESAR AL PANEL <i class="fas fa-sign-in-alt ml-2"></i>
            </button>
        </form>

        <hr class="my-4">

        <div class="text-center">
            <p class="mb-1 small text-white-50">¿Aún no eres socio?</p>
            <a href="../registrarse/registroInmobiliaria.jsp" class="reg-link small">
                Registra tu inmobiliaria aquí
            </a>
        </div>
    </div>

<%
    // Cerrar conexión al final del archivo (Intacto)
    if (conexion != null && !conexion.isClosed()) {
        conexion.close();
    }
%>
</body>
</html>