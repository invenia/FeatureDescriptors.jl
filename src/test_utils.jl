"""
    FeatureDescriptors.TestUtils

Provides a fake [`Descriptor`](@ref) for testing purposes and a `test_interface` function
to check that any [`Descriptor`](@ref) subtype implements the expected API.
"""
module TestUtils

using ..FeatureDescriptors
using Test

export FakeDescriptor, test_interface

"""
    FakeDescriptor <: Descriptor

A fake [`Descriptor`](@ref) for testing purposes only.
"""
abstract type FakeDescriptor <: Descriptor end

FeatureDescriptors.sources(::Type{<:FakeDescriptor}) = ["fake_table"]
FeatureDescriptors.quantity_key(::Type{<:FakeDescriptor}) = :quantity
FeatureDescriptors.categorical_keys(::Type{<:FakeDescriptor}) = [:category1, :category2]

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
    end
end

end
