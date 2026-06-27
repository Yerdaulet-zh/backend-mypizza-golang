data "external_schema" "gorm" {
  program = [
    "go",
    "run",
    "-mod=mod",
    "./internal/adapters/repository/postgresql/loader/loader.go",
  ]
}

// data "composite_schema" "app" {
//   schema "public" {
//     url = data.external_schema.gorm.url
//   }
// }

env "local" {
  url = "postgres://admin:password@localhost:5432/myapp?sslmode=disable"

  src = data.external_schema.gorm.url

  // dev = "docker://postgres/18.4/dev?search_path=public"
  dev = "postgres://postgres:password@localhost:5433/postgres?sslmode=disable"

  migration {
    dir = "file://internal/adapters/repository/postgresql/migrations"
  }

  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}