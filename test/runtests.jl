using FeatureDescriptors
using FeatureDescriptors.TestUtils
using Test

# used for testing
abstract type NaiveFakeDescriptor <: FakeDescriptor end
abstract type SpecialFakeDescriptor <: FakeDescriptor end

# used to test isless
abstract type FakeDescriptorA <: FakeDescriptor end
abstract type FakeDescriptorB <: FakeDescriptor end
abstract type FakeDescriptorC{T} <: FakeDescriptor end

@testset "FeatureDescriptors.jl" begin

    @testset "FakeDescriptor" begin

        test_interface(FakeDescriptor)

        @testset "naive subtyping" begin
            # Inherits the supertype behaviour
            test_interface(NaiveFakeDescriptor)
            @test sources(NaiveFakeDescriptor) == ["fake_table"]
            @test quantity_key(NaiveFakeDescriptor) == :quantity
            @test categorical_keys(NaiveFakeDescriptor) == [:category1, :category2]
            @test label(NaiveFakeDescriptor) == :naivefakedescriptor
        end

        @testset "special subtyping" begin
            # Define different quantitative variable and no categories
            FeatureDescriptors.quantity_key(::Type{<:SpecialFakeDescriptor}) = :foo
            FeatureDescriptors.categorical_keys(::Type{<:SpecialFakeDescriptor}) = []

            test_interface(SpecialFakeDescriptor)
            @test sources(SpecialFakeDescriptor) == ["fake_table"]
            @test quantity_key(SpecialFakeDescriptor) == :foo
            @test isempty(categorical_keys(SpecialFakeDescriptor))
            @test label(SpecialFakeDescriptor) == :specialfakedescriptor
        end

    end

    @testset "isless" begin
        @test isless(FakeDescriptorA, FakeDescriptorB)
        @test isless(FakeDescriptorA, FakeDescriptorC{Float64})
        @test !isless(FakeDescriptorC, FakeDescriptorB)
        unordered = [FakeDescriptorC{Int64}, FakeDescriptorB, FakeDescriptorC{Float64}, FakeDescriptorA]
        ordered = [FakeDescriptorA, FakeDescriptorB, FakeDescriptorC{Float64}, FakeDescriptorC{Int64}]
        @test sort(unordered) == ordered
    end

end
