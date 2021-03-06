import LinearAlgebra

"""
Abstract decomposition of N-mode tensor.
"""
abstract type TensorDecomposition{T<:Number, N} end

"""
Returns relative error between the re-composed and the original tensors.
"""
function rel_residue(recomposed::AbstractArray{T, N}, tensor::AbstractArray{T, N}) where {T,N}
	nans = .!isnan.(tensor)
    LinearAlgebra.norm(recomposed[nans] .- tensor[nans]) / LinearAlgebra.norm(tensor[nans])
end

"""
Returns relative error between re-composed and the original tensor.
"""
rel_residue(decomp::TensorDecomposition{T, N}, tensor::AbstractArray{T, N}) where {T,N} =
    rel_residue(compose(decomp), tensor)

"""
Returns relative tensor decomposition error, NaN if not available.
"""
rel_residue(decomp::TensorDecomposition) = get(decomp.props, :rel_residue, NaN)

_set_rel_residue(decomp::TensorDecomposition, error::AbstractFloat) = setindex!(decomp.props, error, :rel_residue)

_set_rel_residue(decomp::TensorDecomposition{T,N}, tensor::AbstractArray{T,N}) where {T,N} =
    _set_rel_residue(decomp, rel_residue(decomp, tensor))
