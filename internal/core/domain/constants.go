// Package domain contains the enterprise business rules and constants
// that are shared across all layers of the application.
package domain

// Application layer labels used for structured logging.
const (
	LogLevelRepository = "Repository"
	LogLevelService    = "Service"
	LogLevelHandler    = "Handler"
	LogLevelMiddleware = "Middleware"
	LogLevelCache      = "Cache"
)

// Product Pizza related constants
// PizzaSizes and PizzaType are served as enums which used to validate when inserting product or item to the db or
// To Decide from which Pizza type and size to start search to get product image and price to show clients in the main page
type PizzaSizes string
type PizzaTypes string

const (
	TraditionalPizza PizzaTypes = "Традиционное"
	ThinPizza        PizzaTypes = "Тонкое"

	PizzaSize20 PizzaSizes = "20см"
	PizzaSize25 PizzaSizes = "25см"
	PizzaSize30 PizzaSizes = "30см"
	PizzaSize35 PizzaSizes = "35см"
)
