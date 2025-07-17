<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Login - SAJI</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      background-color: #eef2ff;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
      font-family: sans-serif;
    }

    img {
      width: 160px;
      height: 160px;
      border-radius: 50%;
      object-fit: cover;
    }

    h1 {
      margin-top: 20px;
      color: green;
      font-size: 26px;
    }

    p {
      color: gray;
      font-size: 16px;
      margin-top: 10px;
      letter-spacing: 1px;
    }
  </style>

  <script>
    setTimeout(function () {
      window.location.href = "{{ route('login') }}";
    }, 3000); // 3 detik
  </script>
</head>
<body>
  <img src="{{ asset('assets/images/logo_pt_agro.jpg') }}" alt="Logo">
  <h1>SAJI</h1>
  <p>PT. AGRO JAYA INDUSTRI</p>
</body>
</html>
