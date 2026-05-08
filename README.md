# Exercise 3.1 — Módulo EC2

Despliegue de infraestructura basado en Terraform para una instancia EC2 que ejecuta un servidor HTTP ligero desarrollado en Ruby.  
Aprovisiona los recursos necesarios en AWS utilizando un módulo reutilizable de Terraform y valida el despliegue mediante pruebas HTTP y evidencia de infraestructura.

---

# Descripción General

En este ejercicio:

- Un módulo reutilizable de Terraform para aprovisionar EC2
- Configuración de IAM Role e Instance Profile
- Permisos limitados de lectura en S3 para descargar la aplicación
- Configuración de Security Group con acceso restringido
- Validación automática usando GitHub Actions
- Evidencia del despliegue y verificación de endpoints

La instancia EC2 descarga automáticamente `server.rb` desde un bucket S3 durante el arranque y ejecuta la aplicación utilizando un script de user-data.

---

# Estructura del Repositorio

```text
oyd-exercise-3-1/
│
├── app/
│   └── server.rb
│
├── infra/
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── main.tf
│   │
│   ├── envs/
│   │   └── dev/
│   │       └── dev.tfvars
│   │
│   ├── modules/
│   │   └── compute_ec2/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   └── evidence/
│       └── instance.txt
│
├── .github/
│   └── workflows/
│       └── terraform-ci.yml
│
├── .gitignore
└── README.md
```

---

# Componentes de Infraestructura

El módulo de Terraform aprovisiona los siguientes recursos en AWS:

- Instancia EC2
- IAM Role
- IAM Instance Profile
- IAM Inline Policy
- Security Group

La infraestructura está parametrizada mediante variables de entrada para garantizar reutilización y flexibilidad entre entornos.

---

# Endpoint Health

La aplicación expone un endpoint `GET /health` utilizado para verificar la disponibilidad del servidor y el tipo de cómputo.

## Solicitud

```bash
curl http://34.220.43.131:8080/health
```

## Respuesta

```json
{ "compute": "ec2", "status": "ok" }
```

---

# Endpoint Echo

La aplicación expone un endpoint `POST /echo` que devuelve el contenido enviado junto con el tipo de cómputo utilizado.

## Solicitud

```bash
curl -X POST http://34.220.43.131:8080/echo \
-H 'Content-Type: application/json' \
-d '{"msg":"hello"}'
```

## Respuesta

```json
{ "compute": "ec2", "msg": "hello" }
```

---

# Evidencia

La siguiente evidencia fue obtenida después del despliegue utilizando AWS CLI:

```text
------------------------------------------------------------------------
|                           DescribeInstances                          |
+------------------+-----------------------+----------+----------------+
|  ruby-server-dev |  i-04909669ddfdd8748  |  running |  34.220.43.131 |
+------------------+-----------------------+----------+----------------+
```

---

# Pipeline CI/CD

Se configuró un workflow de GitHub Actions para validar automáticamente los cambios de Terraform en cada Pull Request dirigido a la rama `main`.

El pipeline ejecuta:

1. Validación de formato Terraform
2. Inicialización de Terraform
3. Validación de configuración Terraform
4. Generación del plan de ejecución
5. Publicación automática del plan en el Pull Request

Las credenciales AWS son utilizadas exclusivamente mediante GitHub Secrets cifrados.

---

# Comandos Terraform Utilizados

## Inicializar Terraform

```bash
terraform init
```

## Validar Configuración

```bash
terraform validate
```

## Generar Plan de Ejecución

```bash
terraform plan -var-file=envs/dev/dev.tfvars
```

## Aplicar Infraestructura

```bash
terraform apply -var-file=envs/dev/dev.tfvars
```

## Destruir Infraestructura

```bash
terraform destroy -var-file=envs/dev/dev.tfvars
```

---
