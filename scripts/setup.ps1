# LT-PDCS-NATS-POC 项目初始化脚本
# PowerShell 脚本用于Windows环境

param(
    [switch]$SkipDocker,
    [switch]$SkipDependencies,
    [switch]$Development
)

Write-Host "🚀 LT-PDCS-NATS-POC 项目初始化开始..." -ForegroundColor Green

# 检查必要的工具
function Test-Command {
    param($Command)
    try {
        Get-Command $Command -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

Write-Host "📋 检查系统依赖..." -ForegroundColor Yellow

# 检查 Docker
if (-not $SkipDocker) {
    if (-not (Test-Command "docker")) {
        Write-Host "❌ Docker 未安装，请先安装 Docker Desktop" -ForegroundColor Red
        exit 1
    }
    
    if (-not (Test-Command "docker-compose")) {
        Write-Host "❌ Docker Compose 未安装" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ Docker 环境检查通过" -ForegroundColor Green
}

# 检查 Node.js
if (-not (Test-Command "node")) {
    Write-Host "❌ Node.js 未安装，请安装 Node.js 18+" -ForegroundColor Red
    exit 1
}

$nodeVersion = node --version
Write-Host "✅ Node.js 版本: $nodeVersion" -ForegroundColor Green

# 检查 .NET
if (-not (Test-Command "dotnet")) {
    Write-Host "❌ .NET SDK 未安装，请安装 .NET 8 SDK" -ForegroundColor Red
    exit 1
}

$dotnetVersion = dotnet --version
Write-Host "✅ .NET SDK 版本: $dotnetVersion" -ForegroundColor Green

# 检查 Go (可选)
if (Test-Command "go") {
    $goVersion = go version
    Write-Host "✅ Go 版本: $goVersion" -ForegroundColor Green
} else {
    Write-Host "⚠️  Go 未安装，sql-flow 扩展开发需要 Go 1.21+" -ForegroundColor Yellow
}

# 创建项目目录结构
Write-Host "📁 创建项目目录结构..." -ForegroundColor Yellow

$directories = @(
    "src/backend",
    "src/frontend", 
    "src/udp-collector",
    "src/sql-flow-nats",
    "src/desktop-app",
    "src/shared/protobuf",
    "src/shared/models",
    "tests/unit",
    "tests/integration",
    "tests/e2e",
    "docs/api",
    "docs/deployment",
    "docs/architecture",
    "scripts/build",
    "scripts/deploy",
    "configs/development",
    "configs/production",
    "data/samples",
    "tools"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  ✅ 创建目录: $dir" -ForegroundColor Green
    }
}

# 启动基础服务
if (-not $SkipDocker) {
    Write-Host "🐳 启动基础服务..." -ForegroundColor Yellow
    
    try {
        docker-compose up -d
        Write-Host "✅ 基础服务启动成功" -ForegroundColor Green
        
        # 等待服务启动
        Write-Host "⏳ 等待服务启动..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        
        # 检查服务状态
        $services = docker-compose ps --services
        foreach ($service in $services) {
            $status = docker-compose ps $service
            Write-Host "  📊 $service 状态检查完成" -ForegroundColor Cyan
        }
        
    }
    catch {
        Write-Host "❌ 基础服务启动失败: $_" -ForegroundColor Red
        exit 1
    }
}

# 安装前端依赖
if (-not $SkipDependencies) {
    Write-Host "📦 安装项目依赖..." -ForegroundColor Yellow
    
    # 创建前端项目基础文件
    if (-not (Test-Path "src/frontend/package.json")) {
        Write-Host "  🔧 初始化前端项目..." -ForegroundColor Cyan
        Set-Location "src/frontend"
        
        # 创建基础的 package.json
        $packageJson = @{
            name = "lt-pdcs-frontend"
            version = "0.1.0"
            private = $true
            dependencies = @{
                "react" = "^18.2.0"
                "react-dom" = "^18.2.0"
                "@tanstack/react-table" = "^8.10.0"
                "@tanstack/react-query" = "^5.0.0"
                "typescript" = "^5.0.0"
                "nats.ws" = "^1.20.0"
            }
            devDependencies = @{
                "@types/react" = "^18.2.0"
                "@types/react-dom" = "^18.2.0"
                "@vitejs/plugin-react" = "^4.0.0"
                "vite" = "^4.4.0"
                "eslint" = "^8.45.0"
                "prettier" = "^3.0.0"
            }
            scripts = @{
                "dev" = "vite"
                "build" = "vite build"
                "preview" = "vite preview"
                "lint" = "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0"
                "format" = "prettier --write ."
            }
        } | ConvertTo-Json -Depth 10
        
        $packageJson | Out-File -FilePath "package.json" -Encoding UTF8
        
        npm install
        Set-Location "../.."
        Write-Host "  ✅ 前端项目初始化完成" -ForegroundColor Green
    }
}

# 创建开发配置文件
Write-Host "⚙️  创建开发配置..." -ForegroundColor Yellow

# 创建环境变量文件
$envContent = @"
# 开发环境配置
NODE_ENV=development

# NATS 配置
NATS_URL=nats://localhost:4222
NATS_STREAM_NAME=lt-events
NATS_CONSUMER_NAME=lt-consumer

# MinIO 配置
MINIO_ENDPOINT=localhost:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin123
MINIO_BUCKET=lt-data

# DuckDB 配置
DUCKDB_PATH=./data/lt.duckdb

# 监控配置
PROMETHEUS_URL=http://localhost:9090
GRAFANA_URL=http://localhost:3000

# 应用配置
BACKEND_PORT=5001
UDP_COLLECTOR_PORT=8080
FRONTEND_PORT=3000
"@

$envContent | Out-File -FilePath ".env.development" -Encoding UTF8

Write-Host "🎉 项目初始化完成！" -ForegroundColor Green
Write-Host ""
Write-Host "📋 下一步操作:" -ForegroundColor Yellow
Write-Host "  1. 访问 http://localhost:8222 查看 NATS 监控面板" -ForegroundColor Cyan
Write-Host "  2. 访问 http://localhost:9001 查看 MinIO 控制台" -ForegroundColor Cyan
Write-Host "  3. 访问 http://localhost:3000 查看 Grafana 监控" -ForegroundColor Cyan
Write-Host "  4. 开始开发第一个组件：UDP 数据采集器" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 开始开发之旅！" -ForegroundColor Green
