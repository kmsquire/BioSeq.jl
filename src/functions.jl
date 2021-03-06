## Nucleotide IUPAC Regex ##

macro ntr_str(pattern, flags...)
  npat = Uint8[]
  flag_open = false
  for i in 1:length(pattern)
    elem = pattern[i]
    if elem=='[' && !flag_open && i!=1 && pattern[i-1]!='\\'
      flag_open = true
      push!(npat,elem)
    elseif elem=='[' && !flag_open && i==1
      flag_open = true
      push!(npat,elem)
    elseif flag_open && elem==']' && i!=1 && pattern[i-1]!='\\'
      flag_open = false
      push!(npat,elem)
    elseif has(_AMBIGUOUS_NUCLEIC_IUPAC,elem)
      if !flag_open push!(npat,'[') end
      append!(npat,_AMBIGUOUS_NUCLEIC_IUPAC[elem])
      if !flag_open push!(npat,']') end
    else
      push!(npat,elem)
    end
  end
  Regex(ASCIIString(npat),flags...)
end

## Amino Acid IUPAC Regex ##

macro aar_str(pattern, flags...)
  npat = Uint8[]
  flag_open = false
  for i in 1:length(pattern)
    elem = pattern[i]
    if elem=='[' && !flag_open && i!=1 && pattern[i-1]!='\\'
      flag_open = true
      push!(npat,elem)
    elseif elem=='[' && !flag_open && i==1
      flag_open = true
      push!(npat,elem)
    elseif flag_open && elem==']' && i!=1 && pattern[i-1]!='\\'
      flag_open = false
      push!(npat,elem)
    elseif has(_AMBIGUOUS_AMINO_IUPAC,elem)
      if !flag_open push!(npat,'[') end
      append!(npat,_AMBIGUOUS_AMINO_IUPAC[elem])
      if !flag_open push!(npat,']') end
    else
      push!(npat,elem)
    end
  end
  Regex(ASCIIString(npat),flags...)
end


## DNA to RNA ##

function dna2rna!(s::AbstractArray{Nucleotide})
  for i in 1:length(s)
    if int(s[i]) | 32 == 116
      s[i] += 1
    end
  end
  s
end

dna2rna(s::AbstractArray{Nucleotide}) = dna2rna!(copy(s))

## RNA to DNA ##

function rna2dna!(s::AbstractArray{Nucleotide})
  for i in 1:length(s)
    if int(s[i]) | 32 == 117
      s[i] -= 1
    end
  end
  s
end

rna2dna(s::AbstractArray{Nucleotide}) = rna2dna!(copy(s))

## Complement ##

complement!(s::AbstractArray{Nucleotide},d::Dict) = swap!(s,d)
complement(s::AbstractArray{Nucleotide},d::Dict) = swap(s,d)

## Reverse Complement ##

function reversecomplement!{T<:BioUnit}(s::AbstractArray{T},y::Dict{T,T})
  i=1
  j=length(s)
  while i<=j
    I=s[i]
    J=s[j]
    s[i] = get(y,J,J)
    s[j] = get(y,I,I)
    i += 1
    j -= 1
  end
  s
end

reversecomplement{T<:BioUnit}(s::AbstractArray{T},y::Dict{T,T}) = reversecomplement!(copy(s),y)