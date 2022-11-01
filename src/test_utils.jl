"""
    FeatureDescriptors.TestUtils

Provides a fake [`Descriptor`](@ref) for testing purposes and a `test_interface` function
to check that any [`Descriptor`](@ref) subtype implements the expected API.
"""
module TestUtils

using ..FeatureDescriptors
using Test

export FakeDescriptor, OtherFakeDescriptor, DerivedFakeDescriptor, test_interface

"""
    FakeDescriptor <: Descriptor

A fake [`Descriptor`](@ref) for testing purposes only.
"""
abstract type FakeDescriptor <: Descriptor end

FeatureDescriptors.sources(::Type{<:FakeDescriptor}) = ["fake_table"]
FeatureDescriptors.quantity_key(::Type{<:FakeDescriptor}) = :quantity
FeatureDescriptors.categorical_keys(::Type{<:FakeDescriptor}) = [:category1, :category2]


"""
    OtherFakeDescriptor <: Descriptor

Another fake [`Descriptor`](@ref) for testing purposes only.
"""
abstract type OtherFakeDescriptor <: Descriptor end

FeatureDescriptors.sources(::Type{<:OtherFakeDescriptor}) = ["other_fake_table"]
FeatureDescriptors.quantity_key(::Type{<:OtherFakeDescriptor}) = :quantity
FeatureDescriptors.categorical_keys(::Type{<:OtherFakeDescriptor}) = [:category1, :category2]


"""
    DerivedFakeDescriptor <: Descriptor

A fake derived [`Descriptor`](@ref) for testing purposes only.
"""
abstract type DerivedFakeDescriptor <: Descriptor end

FeatureDescriptors.sources(::Type{<:DerivedFakeDescriptor}) = ["fake_table", "other_fake_table"]
FeatureDescriptors.quantity_key(::Type{<:DerivedFakeDescriptor}) = :quantity
FeatureDescriptors.categorical_keys(::Type{<:DerivedFakeDescriptor}) = [:category1, :category2]
FeatureDescriptors.parents(::Type{<:DerivedFakeDescriptor}) = [FakeDescriptor, OtherFakeDescriptor]

"""
    TestUtils.test_interface(D::Type{<:Descriptor})

Test that a subtype of [`Descriptor`](@ref) implements the expected API.
"""
function test_interface(D)
    @testset "test_interface $D" begin
        @test FeatureDescriptors.sources(D) isa Vector{String}
        @test FeatureDescriptors.quantity_key(D) isa Symbol
        categories = FeatureDescriptors.categorical_keys(D)
        @test (isempty(categories) || categories isa Vector{Symbol})
        @test FeatureDescriptors.label(D) isa Symbol
        parents = FeatureDescriptors.parents(D)
        @test parents isa Vector
        @test length(parents) == length(FeatureDescriptors.sources(D))
        if !isempty(parents)
            @test union(FeatureDescriptors.sources.(parents)...) == FeatureDescriptors.sources(D)
        end
    end
end

end
