# FeatureDescriptors

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://invenia.github.io/FeatureDescriptors.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://invenia.github.io/FeatureDescriptors.jl/dev)
[![Build Status](https://github.com/invenia/FeatureDescriptors.jl/workflows/CI/badge.svg)](https://github.com/invenia/FeatureDescriptors.jl/actions)
[![Coverage](https://codecov.io/gh/invenia/FeatureDescriptors.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/invenia/FeatureDescriptors.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

FeatureDescriptors.jl is an interface package for describing features used in [models](https://invenia.github.io/Models.jl/stable/), [feature engineering](https://invenia.github.io/FeatureTransforms.jl/stable/), and other data-science workflows.

## Getting Started

`Descriptor`s provide a way to define at a high level the properties of - and relationships between - a collection of features and the corresponding data.
By associating a type with a given dataset, it allows users to write methods that can dispatch on the given feature and compose pipelines that are agnostic to the characteristics of any particular feature.
Subtypes of `Descriptor`s inherit the properties of the supertype, but these can be overloaded as required. 

For example, say that some weather data is contained in a `weather.csv` file where each column describes a different feature we are interested in using, such as `:temperature` and `:humidity`. 
We can define a general `Weather` `Descriptor` with subtypes `Temperature` and `Humidity` that are loaded from the same table but use the appropriate columns:

```julia
using FeatureDescriptors

abstract type Weather <: Descriptor end

FeatureDescriptors.sources(::Type{<:Weather}) = ["weather.csv"]  # only one table is needed
FeatureDescriptors.categorical_keys(::Type{<:Weather}) = []  # no categories necessary

abstract type Temperature <: Weather end
FeatureDescriptors.quantity_key(::Type{Temperature}) = :temperature

abstract type Humidity <: Weather end
FeatureDescriptors.quantity_key(::Type{Humidity}) = :humidity

```

A more specific instance of a feature can also be defined, such as a `MeanTemperature`, perhaps if that feature requires some [feature engineering](https://invenia.github.io/FeatureTransforms.jl/stable/) before it can be used.

```julia
abstract type MeanTemperature <: Temperature end

using FeatureTransforms

# A trivial feature engineering step in preparing MeanTemperature
function FeatureTransforms.transform(D::Type{<:MeanTemperature}, df) 
    return combine(groupby(df, :time), quantity_key(D) => mean => quantity_key(D))
end
```

Finally, another useful feature might be stored in a different table entirely, but we may still want to encode its relationships to the others.
For example, if we had rainfall data that was saved in another file that we also wanted to use.

```julia
abstract type Precipitation <: Weather end
FeatureDescriptors.sources(::Type{<:Precipitation}) = ["rainfall.csv"]
FeatureDescriptors.quantity_key(::Type{<:Precipitation}) = :rainfall 
```

## The Descriptors API

All `Descriptor`s are required to implement the following:

1. A `sources` method that specifies where to retrieve the data. A `Descriptor` may be associated with multiple sources, because it may be necessary to perform [feature engineering](https://invenia.github.io/FeatureTransforms.jl/stable/) to create the derived feature.
1. A `quantity_key` method that denotes the name of the quantitative variable for the feature, such as `:temperature` or `:price`. For the sake of transparency and simplicity, only one `quantity_key` may be associated with a given `Descriptor`.
1. A `categorical_keys` method that denotes the names of the categorical variables for the feature, such as `:colour` or `:type`. If no categorical variables are needed, this returns an empty vector.

You can ensure your `Descriptor` is implemented correctly by calling the [`TestUtils.test_interface`](https://invenia.github.io/FeatureDescriptors.jl/stable/index/#Testutils) function.
