module FeatureDescriptors

export Descriptor
export categorical_keys, label, quantity_key, sources

"""
    Descriptor

The `Descriptor`s interface lets users define the properties and relationships between the
features being used in their models or other data-intensive workflows.

`Descriptor` supertypes define some general properties that can be overloaded for specific
subtypes as required, such as the tables to load or the quantitative variable to use.

Users may define their own Descriptor` type system for their own purposes but must extend
the following methods:
- [`sources`](@ref): The sources for the data needed to build the `Desriptor` feature.
- [`quantity_key`](@ref): The quantitative variable for the `Descriptor`.
- [`categorical_keys`](@ref): The categorical variables for the `Descriptor`.
"""
abstract type Descriptor end

"""
    sources(::Descriptor) -> Vector{String}

Returns the data sources for the [`Descriptor`](@ref), e.g. the names or paths to the tables
containing the required data: `["temperature.csv", "locations.csv"]`.
"""
function sources end

"""
    quantity_key(::Descriptor) -> Symbol

Returns the quantitative variable for the [`Descriptor`](@ref), e.g. `:temperature`.
"""
function quantity_key end

"""
    categorical_keys(::Descriptor) -> Vector

Returns the categorical variables for the [`Descriptor`](@ref), e.g. `[:colour, :shape]`.
Returns an empty vector if no categorical variables exist.
"""
function categorical_keys end

"""
    label(D::Descriptor) -> Symbol

Returns a symbol representation of the [`Descriptor`](@ref).
"""
function label(D::Type{<:Descriptor})
    s = replace(string(D), string(parentmodule(D)) => "")  # remove module name
    s = replace(lowercase(s), r"[^\w]" => "")  # remove any weird characters
    return Symbol(s)
end

# Allow sorting descriptors lexographically
# NOTE: isless(hash(A), hash(B)) would be faster, but:
# 1. we shouldn't need to sort that many descriptors
# 2. this is more human readable/understandable
Base.isless(A::Type{<:Descriptor}, B::Type{<:Descriptor}) = isless(string(A), string(B))

include("test_utils.jl")

end
