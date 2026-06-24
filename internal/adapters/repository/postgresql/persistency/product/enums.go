package product

// Enums
type ItemSize string
type CurrencyName string

const (
	// Pizza Sizes
	SizeSmall  ItemSize = "SMALL"
	SizeMedium ItemSize = "MEDIUM"
	SizeLarge  ItemSize = "LARGE"

	// Drink Sizes
	Size03L  ItemSize = "0.3L"
	Size045L ItemSize = "0.45L"
	Size05L  ItemSize = "0.5L"
	Size1L   ItemSize = "1.0L"
)

const (
	CurrencyKZT CurrencyName = "KZT"
)
