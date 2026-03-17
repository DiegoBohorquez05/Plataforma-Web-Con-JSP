<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // 1. VERIFICACIÓN DE SESIÓN
    Integer idInmoSesion = (Integer) session.getAttribute("idInmobiliaria");
    if (idInmoSesion == null) {
        response.sendRedirect("../logins/loginInmobiliaria.jsp");
        return;
    }

    // 2. LÓGICA PARA CAPTURAR DATOS SI SE VA A EDITAR
    int idEdit = 0;
    String dDireccion = "", dCiudad = "", dEstado = "Disponible", dDescripcion = "";
    double dPrecio = 0;
    boolean editando = false;

    if (request.getParameter("id_edit") != null) {
        try {
            idEdit = Integer.parseInt(request.getParameter("id_edit"));
            editando = true;
            
            String sqlEdit = "SELECT * FROM propiedades WHERE id_propiedad = ? AND fk_inmobiliaria = ?";
            PreparedStatement psEdit = conexion.prepareStatement(sqlEdit);
            psEdit.setInt(1, idEdit);
            psEdit.setInt(2, idInmoSesion);
            ResultSet rsEdit = psEdit.executeQuery();
            
            if (rsEdit.next()) {
                dDireccion = rsEdit.getString("direccion");
                dCiudad = rsEdit.getString("ciudad");
                dEstado = rsEdit.getString("estado");
                dPrecio = rsEdit.getDouble("precio");
                dDescripcion = rsEdit.getString("descripcion");
            }
            rsEdit.close();
            psEdit.close();
        } catch (Exception e) {
            System.out.println("Error al cargar datos: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Inmobiliaria - InmoHome</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body { background-color: #f4f7f6; }
        .navbar { background-color: #17a2b8; }
        .card-header { font-weight: bold; }
        .btn-header { transition: all 0.3s; }
        .btn-header:hover { transform: translateY(-1px); }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark mb-4 shadow-sm">
        <a class="navbar-brand font-weight-bold" href="#">
            <i class="fas fa-building"></i> Panel Inmobiliaria: <%= session.getAttribute("nombreInmo") %>
        </a>
        <div class="ml-auto">
            <a href="../index.jsp" class="btn btn-info btn-sm btn-header border-light mr-2">
                <i class="fas fa-eye"></i> Ver Sitio Público
            </a>
            <a href="../logins/logout.jsp" class="btn btn-outline-light btn-sm btn-header">
    <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
</a>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            
            <div class="col-md-4">
                <div class="card shadow-sm border-0">
                    <div class="card-header <%= editando ? "bg-warning text-dark" : "bg-info text-white" %>">
                        <i class="fas <%= editando ? "fa-edit" : "fa-plus-circle" %>"></i> 
                        <%= editando ? "Modificar Propiedad ID: " + idEdit : "Publicar Nueva Propiedad" %>
                    </div>
                    <div class="card-body">
                        <form action="<%= editando ? "../propiedades/actualizarPropiedad.jsp" : "../propiedades/procesarPropiedad.jsp" %>" method="POST">
                            
                            <% if(editando) { %> 
                                <input type="hidden" name="id_propiedad" value="<%= idEdit %>"> 
                            <% } %>
                            <input type="hidden" name="fk_inmo" value="<%= idInmoSesion %>">

                            <div class="form-group">
                                <label class="small font-weight-bold">Dirección</label>
                                <input type="text" name="direccion" class="form-control" value="<%= dDireccion %>" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="small font-weight-bold">Ciudad</label>
                                <input type="text" name="ciudad" class="form-control" value="<%= dCiudad %>" required>
                            </div>

                            <div class="form-group">
                                <label class="small font-weight-bold">Precio ($)</label>
                                <input type="number" name="precio" class="form-control" value="<%= (int)dPrecio %>" required>
                            </div>

                            <div class="form-group">
                                <label class="small font-weight-bold">Estado</label>
                                <select name="estado" class="form-control">
                                    <option value="Disponible" <%= dEstado.equals("Disponible") ? "selected" : "" %>>Disponible</option>
                                    <option value="Arrendado" <%= dEstado.equals("Arrendado") ? "selected" : "" %>>Arrendado</option>
                                    <option value="Vendido" <%= dEstado.equals("Vendido") ? "selected" : "" %>>Vendido</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="small font-weight-bold">Descripción</label>
                                <textarea name="descripcion" class="form-control" rows="3" placeholder="Detalles del inmueble..." required><%= dDescripcion %></textarea>
                            </div>

                            <button type="submit" class="btn <%= editando ? "btn-warning" : "btn-info" %> btn-block font-weight-bold shadow-sm">
                                <%= editando ? "GUARDAR CAMBIOS" : "PUBLICAR INMUEBLE" %>
                            </button>
                            
                            <% if(editando) { %>
                                <a href="dashboardInmo.jsp" class="btn btn-link btn-block btn-sm text-muted mt-2">Cancelar edición</a>
                            <% } %>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-dark text-white">
                        Mis Propiedades Publicadas
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="thead-light">
                                <tr>
                                    <th>Dirección</th>
                                    <th>Ciudad</th>
                                    <th>Precio</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        String sql = "SELECT * FROM propiedades WHERE fk_inmobiliaria = ? ORDER BY id_propiedad DESC";
                                        PreparedStatement ps = conexion.prepareStatement(sql);
                                        ps.setInt(1, idInmoSesion);
                                        ResultSet rs = ps.executeQuery();

                                        while(rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getString("direccion") %></td>
                                    <td><%= rs.getString("ciudad") %></td>
                                    <td class="text-success font-weight-bold">$<%= String.format("%,.0f", rs.getDouble("precio")) %></td>
                                    <td class="text-center">
                                        <a href="dashboardInmo.jsp?id_edit=<%= rs.getInt("id_propiedad") %>" class="text-warning mr-3" title="Editar">
                                            <i class="fas fa-edit fa-lg"></i>
                                        </a>
                                        <a href="../propiedades/eliminarPropiedad.jsp?id=<%= rs.getInt("id_propiedad") %>" 
                                           class="text-danger" title="Eliminar"
                                           onclick="return confirm('¿Estás seguro de eliminar esta propiedad?')">
                                            <i class="fas fa-trash-alt fa-lg"></i>
                                        </a>
                                    </td>
                                </tr>
                                <% 
                                        }
                                        rs.close();
                                        ps.close();
                                    } catch (Exception e) {
                                        out.print("<tr><td colspan='4'>Error al listar: " + e.getMessage() + "</td></tr>");
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <%-- CIERRE DE CONEXIÓN --%>
    <%
        if (conexion != null && !conexion.isClosed()) {
            conexion.close();
        }
    %>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>