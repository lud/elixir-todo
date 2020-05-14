locals_without_parens = [
  todo: 1
]

[
  inputs: ["mix.exs", "{lib,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens,
  export: [locals_without_parens: locals_without_parens]
]

