data "external_schema" "gorm" {
  program = [
    "go",
    "run",
    "-mod=mod",
    "./internal/adapters/repository/postgresql/loader/loader.go",
  ]
}

data "external_schema" "sql_types" {
  program = [
    "cat",
    "./internal/adapters/repository/postgresql/schema/product.enums.sql"
  ]
}

data "composite_schema" "app" {
  schema "public" {
    url = data.external_schema.sql_types.url
  }
  schema "public" {
    url = data.external_schema.gorm.url
  }
}

env "local" {
  url = "postgres://admin:password@localhost:5432/myapp?sslmode=disable"

  src = data.composite_schema.app.url

  dev = "docker://postgres/17/dev?search_path=public"

  migration {
    dir = "file://internal/adapters/repository/postgresql/migrations"
  }

  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}
