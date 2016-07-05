package spn

// A node represents a node in a DAG. There can only be three types of nodes: a univariate
// distribution node, a sum node and a product node.
type Node interface {
	// Node value given a valuation.
	Value(valuation VarSet) float64
	// Returns the MAP state given a valuation.
	Max(valuation VarSet) float64
	// Returns the argmax of the MAP state and the max to avoid recomputation.
	ArgMax(valuation VarSet) (VarSet, float64)
	// Set of children.
	Ch() []Node
	// Parent node. If returns nil, then it is a root node.
	Pa() Node
	// Scope of this node.
	Sc() []int
	// Node type: 'leaf', 'sum' or 'product'.
	Type() string
	// Adds a child node to this node.
	AddChild(c Node)
	// Sets the parent node.
	SetParent(pa Node)
	// Get weights. Returns nil if no weights.
	Weights() []float64
}

// An SPN is the root node of the DAG.
type SPN Node
