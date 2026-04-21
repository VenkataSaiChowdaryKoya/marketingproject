$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Host "Server successfully started."
Write-Host "You can view your page at: http://localhost:$port/"
Write-Host "Press Ctrl+C to stop the server."

try {
    while ($listener.IsListening) {
        # This will block until a request is received
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # Determine the file path
        $path = $request.Url.LocalPath
        if ($path -eq "/" -or $path -eq "") { 
            $path = "/index.html" 
        }
        
        # Safely combine paths
        $localPath = Join-Path -Path $PWD -ChildPath $path.TrimStart('/')
        
        if (Test-Path $localPath -PathType Container) {
            $localPath = Join-Path -Path $localPath -ChildPath "index.html"
            $path = $path.TrimEnd('/') + "/index.html"
        }
        
        if (Test-Path $localPath -PathType Leaf) {
            $content = [System.IO.File]::ReadAllBytes($localPath)
            $response.ContentLength64 = $content.Length
            
            # Simple MIME type checking
            $ext = [System.IO.Path]::GetExtension($localPath).ToLower()
            switch ($ext) {
                ".html" { $response.ContentType = "text/html; charset=utf-8" }
                ".css"  { $response.ContentType = "text/css; charset=utf-8" }
                ".js"   { $response.ContentType = "application/javascript; charset=utf-8" }
                ".json" { $response.ContentType = "application/json; charset=utf-8" }
                ".png"  { $response.ContentType = "image/png" }
                ".jpg"  { $response.ContentType = "image/jpeg" }
                ".jpeg" { $response.ContentType = "image/jpeg" }
                ".svg"  { $response.ContentType = "image/svg+xml" }
                default { $response.ContentType = "application/octet-stream" }
            }
            
            $output = $response.OutputStream
            $output.Write($content, 0, $content.Length)
            $output.Close()
            
            Write-Host "200 GET $path"
        } else {
            $response.StatusCode = 404
            $response.Close()
            Write-Host "404 GET $path (Not Found)"
        }
    }
} finally {
    $listener.Stop()
    $listener.Close()
}
