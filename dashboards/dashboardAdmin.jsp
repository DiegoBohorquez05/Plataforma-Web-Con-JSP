<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // VALIDACIÓN DE SESIÓN (Intacta)
    if (session.getAttribute("usuarioAdmin") == null) {
        response.sendRedirect("loginAdministrador.jsp");
        return; 
    }

    // LÓGICA PARA RECUPERAR DATOS (Intacta)
    String idEdit = request.getParameter("editId");
    String dDireccion = "", dEstado = "", dCiudad = "", dDescripcion = "", dPrecio = "";
    boolean editando = (idEdit != null);

    if (editando && conexion != null) {
        try {
            Statement stEdit = conexion.createStatement();
            ResultSet rsEdit = stEdit.executeQuery("SELECT * FROM propiedades WHERE id_propiedad = " + idEdit);
            if (rsEdit.next()) {
                dDireccion = rsEdit.getString("direccion");
                dEstado = rsEdit.getString("estado");
                dCiudad = rsEdit.getString("ciudad");
                dDescripcion = rsEdit.getString("descripcion");
                dPrecio = rsEdit.getString("precio");
            }
            stEdit.close();
        } catch (Exception e) { }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Panel de Administración</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        
        /* Sidebar mejorada */
        .sidebar { 
            background: #1a1d20; 
            min-height: 100vh; 
            color: white; 
            position: fixed; 
            width: 16.666%; 
            box-shadow: 4px 0 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }
        .sidebar-header { border-bottom: 1px solid #343a40; padding-bottom: 20px; }
        .sidebar a { 
            color: #adb5bd; 
            display: block; 
            padding: 12px 15px; 
            transition: all 0.3s; 
            border-radius: 8px;
            margin-bottom: 5px;
            text-decoration: none;
        }
        .sidebar a:hover, .sidebar a.active { 
            color: #fff; 
            background: #ffc107; 
            color: #212529 !important;
            font-weight: 600;
        }
        
        /* Contenido Principal */
        .main-content { margin-left: 16.666%; padding: 40px; width: 83.333%; }
        
        /* Tarjetas Modernas */
        .card { border: none; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); overflow: hidden; }
        .card-header { font-weight: 600; border-bottom: none; }
        
        /* Estilo específico para edición */
        .card-edit { border-top: 5px solid #ffc107 !important; background: #fffdf5; }
        
        /* Tablas */
        .table { background: white; border-radius: 10px; }
        .table thead th { border-top: none; background: #f8f9fa; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 1px; color: #6c757d; }
        .table td { vertical-align: middle !important; }
        
        .badge { padding: 6px 12px; border-radius: 50px; }
        
        .btn-warning { background-color: #ffc107; border: none; transition: 0.3s; }
        .btn-warning:hover { background-color: #e0a800; transform: translateY(-2px); }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 sidebar p-4">
            <div class="sidebar-header mb-4 text-center">
                <h4 class="text-warning font-weight-bold"><i class="fas fa-user-shield"></i> INMOHOME</h4>
                <small class="text-muted">ADMIN PANEL</small>
            </div>
            <a href="./dashboardAdmin.jsp" class="active"><i class="fas fa-building mr-2"></i> Propiedades</a>
            <a href="../index.jsp"><i class="fas fa-external-link-alt mr-2"></i> Ver Sitio</a>
            <hr class="bg-secondary">
            <a href="../logins/logout.jsp" class="text-danger mt-4"><i class="fas fa-sign-out-alt mr-2"></i> Salir del Sistema</a>
        </nav>

        <main class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="font-weight-bold text-dark">Gestión Administrativa</h2>
                <span class="badge badge-dark">Sesión: <%= session.getAttribute("usuarioAdmin") %></span>
            </div>
            
            <hr>

            <% if(editando) { %>
            <div class="card card-edit mb-5 animate__animated animate__fadeIn">
                <div class="card-header bg-warning text-dark d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-edit mr-2"></i> <b>Editando Propiedad ID: <%= idEdit %></b></span>
                    <a href="./dashboardAdmin.jsp" class="btn btn-sm btn-outline-dark">Cancelar</a>
                </div>
                <div class="card-body">
                    <form action="../propiedades/actualizarPropiedad.jsp" method="POST" class="row">
                        <input type="hidden" name="id_propiedad" value="<%= idEdit %>">
                        
                        <div class="col-md-3 mb-3">
                            <label class="small font-weight-bold text-muted">Dirección</label>
                            <input type="text" name="direccion" class="form-control" value="<%= dDireccion %>" required>
                        </div>
                        
                        <div class="col-md-3 mb-3">
                            <label class="small font-weight-bold text-muted">Estado</label>
                            <select name="estado" class="form-control" required>
                                <option value="Disponible" <%= dEstado.equals("Disponible") ? "selected" : "" %>>Disponible</option>
                                <option value="Arrendado" <%= dEstado.equals("Arrendado") ? "selected" : "" %>>Arrendado</option>
                                <option value="Vendido" <%= dEstado.equals("Vendido") ? "selected" : "" %>>Vendido</option>
                            </select>
                        </div>
                        
                        <div class="col-md-3 mb-3">
                            <label class="small font-weight-bold text-muted">Ciudad</label>
                            <input type="text" name="ciudad" class="form-control" value="<%= dCiudad %>" required>
                        </div>
                        
                        <div class="col-md-3 mb-3">
                            <label class="small font-weight-bold text-muted">Precio ($)</label>
                            <input type="number" name="precio" class="form-control" value="<%= dPrecio %>" required>
                        </div>
                        
                        <div class="col-md-12 mb-3">
                            <label class="small font-weight-bold text-muted">Descripción del Inmueble</label>
                            <textarea name="descripcion" class="form-control" rows="2" required><%= dDescripcion %></textarea>
                        </div>

                        <div class="col-md-12 text-right">
                            <button type="submit" class="btn btn-warning px-5 font-weight-bold shadow-sm">
                                <i class="fas fa-save mr-2"></i> GUARDAR CAMBIOS
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <% } %>

            <div class="card mb-5">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-list mr-2"></i> Propiedades en el Sistema</span>
                    <span class="badge badge-warning text-dark">Total Activas</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Dirección</th>
                                <th>Estado</th>
                                <th>Ciudad</th>
                                <th>Precio</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (conexion != null) {
                                    try {
                                        Statement stProp = conexion.createStatement();
                                        ResultSet rsProp = stProp.executeQuery("SELECT * FROM propiedades ORDER BY id_propiedad DESC");
                                        while(rsProp.next()) {
                                            String estado = rsProp.getString("estado");
                                            String badgeClass = "badge-info";
                                            if ("Vendido".equals(estado)) badgeClass = "badge-danger";
                                            if ("Arrendado".equals(estado)) badgeClass = "badge-warning text-dark";
                            %>
                            <tr>
                                <td class="text-muted">#<%= rsProp.getInt("id_propiedad") %></td>
                                <td class="font-weight-bold"><%= rsProp.getString("direccion") %></td>
                                <td><span class="badge <%= badgeClass %>"><%= estado %></span></td>
                                <td><i class="fas fa-map-marker-alt text-muted mr-1"></i><%= rsProp.getString("ciudad") %></td>
                                <td><span class="text-success font-weight-bold">$ <%= String.format("%,.0f", rsProp.getDouble("precio")) %></span></td>
                                <td class="text-center">
                                    <a href="dashboardAdmin.jsp?editId=<%= rsProp.getInt("id_propiedad") %>" class="btn btn-sm btn-outline-warning mr-2" title="Editar">
                                        <i class="fas fa-pen"></i>
                                    </a>
                                    <a href="../propiedades/eliminarPropiedad.jsp?id=<%= rsProp.getInt("id_propiedad") %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('¿Eliminar propiedad?')" title="Eliminar">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% 
                                        }
                                        stProp.close();
                                    } catch(Exception e) { 
                                        out.print("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>"); 
                                    } 
                                } 
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card">
                <div class="card-header bg-secondary text-white"><i class="fas fa-users mr-2"></i> Gestión de Usuarios (Clientes)</div>
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Nombre del Cliente</th>
                                <th>Correo Electrónico</th>
                                <th>Estado Cuenta</th>
                                <th class="text-center">Operaciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (conexion != null) {
                                    try {
                                        Statement stCli = conexion.createStatement();
                                        ResultSet rsCli = stCli.executeQuery("SELECT id_cliente, nombre, email FROM clientes ORDER BY nombre ASC");
                                        while (rsCli.next()) {
                            %>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-light p-2 rounded-circle mr-3 text-primary"><i class="fas fa-user"></i></div>
                                        <span class="font-weight-bold"><%= rsCli.getString("nombre") %></span>
                                    </div>
                                </td>
                                <td class="text-muted"><%= rsCli.getString("email") %></td>
                                <td><span class="text-success small font-weight-bold"><i class="fas fa-check-circle mr-1"></i>Verificado</span></td>
                                <td class="text-center">
                                    <a href="eliminarCliente.jsp?id=<%= rsCli.getInt("id_cliente") %>" class="btn btn-sm btn-danger px-3" onclick="return confirm('¿Seguro que deseas eliminar esta cuenta?')">
                                        <i class="fas fa-user-slash mr-1"></i> Eliminar
                                    </a>
                                </td>
                            </tr>
                            <% 
                                        }
                                        stCli.close();
                                        // conexion.close(); // Nota: Se cierra al final de la página usualmente
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='4' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>

<%
    // Cerrar conexión al final para evitar fugas
    if (conexion != null && !conexion.isClosed()) {
        conexion.close();
    }
%>
</body>
</html>