<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Iniciar Sesión - SETDITSX</title>
  <link rel="stylesheet" href="../css/bootstrap/bootstrap.min.css">
  <link rel="stylesheet" href="../css/estilo.css">
</head>
<body>
  <div class="page-header">
    <img src="../img/NewLogo - 1.png" alt="logo" class="brand-logo" />
    <div><div style="font-weight:700;color:#153b52;">SETDITSX - Sindicato ITSX</div></div>
  </div>

  <main class="card card-login">
    <h1 class="title">Iniciar Sesión</h1>

    <!-- form envía por POST a php/login.php -->
    <form method="post" action="/php/login.php" novalidate>
      <div class="mb-3">
        <input name="email" type="email" class="form-control" placeholder="Correo electrónico" required />
      </div>

      <div class="mb-3">
        <input name="password" type="password" class="form-control" placeholder="Contraseña" required />
      </div>

      <button type="submit" class="btn btn-golden">INGRESAR</button>
      <a href="/php/registro.php" class="register-link">Registrarme</a>

      <!-- Mensaje de error opcional -->
      <?php if (!empty($_GET['error'])): ?>
        <div class="alert alert-danger mt-3"><?php echo htmlspecialchars($_GET['error']); ?></div>
      <?php endif; ?>
    </form>
  </main>

  <script src="../js/bootstrap/bootstrap.bundle.min.js"></script>
</body>
</html>
