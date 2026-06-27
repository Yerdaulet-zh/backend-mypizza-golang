package product

// Enums
type ItemSize string
type ItemType string
type CurrencyName string

const (
	// Pizza Sizes
	Size20 ItemSize = "20см"
	Size25 ItemSize = "25см"
	Size30 ItemSize = "30см"
	Size35 ItemSize = "35см"

	// Item Types
	Traditional ItemType = "Традиционный"
	Thin        ItemType = "Тонкое"
	Small       ItemType = "Маленькая"
	Big         ItemType = "Большая"

	// Drink Sizes
	Size03L  ItemSize = "0.3L"
	Size045L ItemSize = "0.45L"
	Size05L  ItemSize = "0.5L"
	Size1L   ItemSize = "1.0L"
)

const (
	CurrencyKZT CurrencyName = "KZT"
)
