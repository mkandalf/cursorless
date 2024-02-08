(comment) @comment
(hash) @map
(regex) @regularExpression
(
  call
    receiver: (_)? @functionCallee
) @functionCall

[
  (array)
  (string_array)
  (symbol_array)
] @list

(_
  (if) @ifStatement
) @_.iteration

;;! Functions
;;! with parameters, non-private, singleton_method/method
(_
  (_
    "def"
    object: (_)?
    name: (_)? @functionName
    parameters: (_) @namedFunction.interior.start.endOf
    (_)+
    "end"  @namedFunction.interior.end.startOf
  ) @namedFunction @_.domain
  (#not-parent-type? @_.domain argument_list)
)

;;! without parameters, non-private, singleton_method/method
(_
  (_
    "def"
    object: (_)?
    name: (_)? @functionName @namedFunction.interior.start.endOf
    (_)+
    "end"  @namedFunction.interior.end.startOf
    !parameters
   ) @namedFunction @_.domain
  (#not-parent-type? @_.domain argument_list)
)

;;! with parameters, modified, singleton_method/method
;; (_
;;   (call
;;     method: (identifier) @sigMethod
;;     block: (_
;;       (call
;;         method: (identifier) @paramsMethod
;;         arguments: (argument_list
;;           (pair
;;             key: (hash_key_symbol) @foo
;;           ) @argumentOrParameter
;;         )
;;         (#eq? @paramsMethod "params")
;;       )
;;     )
;;     (#eq? @sigMethod "sig")
;;   )?
;;   .
;;   (call
;;     method: (identifier)
;;     arguments: (argument_list
;;       (singleton_method
;;         parameters: (method_parameters
;;             (_)? @_.leading.endOf
;;             .
;;             ([
;;               (_
;;                 name: (identifier) @bar
;;               )
;;               (identifier) @bar
;;             ]) @argumentOrParameter
;;             .
;;             (_)? @_.trailing.startOf
;;           ) @dummy
;;           (#allow-multiple! @argumentOrParameter)
;;           (#not-type? @argumentOrParameter "comment")
;;           (#single-or-multi-line-delimiter! @argumentOrParameter @dummy ", " ",\n")
;;       )
;;     )
;;   ) @namedFunction
;;   (#eq? @foo @bar)
;;   (#allow-multiple! @argumentOrParameter)
;; )

;;! with parameters, modified, singleton_method/method
(
  (call
    method: (identifier) @dummy
    arguments: (argument_list
      (_
        "def"
        object: (_)?
        name: (_)? @functionName @namedFunction.interior.start.endOf
        parameters: (_) @namedFunction.interior.start.endOf
        (_)+
        "end"  @namedFunction.interior.end.startOf
      )
    )
  ) @namedFunction @_.domain
)

;;! without parameters, modified, singleton_method/method
(
  (call
    method: (identifier) @dummy
    arguments: (argument_list
      (_
        "def"
        object: (_)?
        name: (_)? @functionName @namedFunction.interior.start.endOf
        (_)+
        "end"  @namedFunction.interior.end.startOf
        !parameters
      )
    )
  ) @namedFunction @_.domain
)

;;! with parameters, block/do_block
(_
  (_
    .
    [
      "{"
      "do"
    ]
    parameters: (_) @anonymousFunction.interior.start.endOf
    (_)*
    [
      "}"
      "end"
    ] @anonymousFunction.interior.start.endOf
   ) @anonymousFunction @_.domain
)

;;! without parameters, block/do_block
(_
  (_
    .
    [
      "{"
      "do"
    ] @anonymousFunction.interior.start.endOf
    (_)*
    [
      "}"
      "end"
    ] @anonymousFunction.interior.start.endOf
    !parameters
   ) @anonymousFunction @_.domain
)

(module) @namedFunction.iteration @functionName.iteration
(class) @namedFunction.iteration @functionName.iteration
(program) @namedFunction.iteration @functionName.iteration

(_
  (class) @class
) @_.iteration

(_
  (class
    name: (_) @className
  ) @_.domain
) @_.iteration

(
  (
    (array
      "[" @list.start @collectionItem.iteration.start.endOf
      (_)? @_.leading.endOf
      .
      (_) @collectionItem
      .
      (_)? @_.trailing.startOf
      "]" @list.end @collectionItem.iteration.end.startOf
      )
  ) @list.domain @collectionItem.iteration.domain
  (#not-type? @collectionItem "comment")
  (#allow-multiple! @collectionItem)
  (#single-or-multi-line-delimiter! @collectionItem @list.domain ", " ",\n")
)

(
  (
  (hash
    "{" @map.start @collectionItem.iteration.start.endOf
    (_)? @_.leading.endOf
    .
    (_) @collectionItem
    .
    (_)? @_.trailing.startOf
    "}" @map.end @collectionItem.iteration.end.startOf
    )
  ) @map.domain @collectionItem.iteration.domain 
  (#not-type? @collectionItem "comment")
  (#allow-multiple! @collectionItem)
  (#single-or-multi-line-delimiter! @collectionItem @map.domain ", " ",\n")
)

(
  (method_parameters
    (_)? @_.leading.endOf
    .
    (_) @argumentOrParameter
    .
    (_)? @_.trailing.startOf
  ) @dummy
  (#not-type? @argumentOrParameter "comment")
  (#single-or-multi-line-delimiter! @argumentOrParameter @dummy ", " ",\n")
)

(method_parameters
  "(" @argumentOrParameter.iteration.start.endOf
  ")" @argumentOrParameter.iteration.end.startOf
) @argumentOrParameter.iteration.domain

(
  (lambda_parameters
    (_)? @_.leading.endOf
    .
    (_) @argumentOrParameter
    .
    (_)? @_.trailing.startOf
  ) @dummy
  (#not-type? @argumentOrParameter "comment")
  (#single-or-multi-line-delimiter! @argumentOrParameter @dummy ", " ",\n")
)

(lambda_parameters
  "(" @argumentOrParameter.iteration.start.endOf
  ")" @argumentOrParameter.iteration.end.startOf
) @argumentOrParameter.iteration.domain

(
  (block_parameters
    (_)? @_.leading.endOf
    .
    (_) @argumentOrParameter
    .
    (_)? @_.trailing.startOf
  ) @dummy
  (#not-type? @argumentOrParameter "comment")
  (#single-or-multi-line-delimiter! @argumentOrParameter @dummy ", " ",\n")
)

(block_parameters
  "|" @argumentOrParameter.iteration.start.endOf
  "|" @argumentOrParameter.iteration.end.startOf
) @argumentOrParameter.iteration.domain

(
  call
  method: _ @method
  (argument_list
    (_)? @_.leading.endOf
    .
    (_) @argumentOrParameter
    .
    (_)? @_.trailing.startOf
  ) @dummy
  (#not-type? @argumentOrParameter "comment")
  (#not-eq? @method "private_class_method")
  (#not-eq? @method "private")
  (#single-or-multi-line-delimiter! @argumentOrParameter @dummy ", " ",\n")
)

(argument_list
  "(" @argumentOrParameter.iteration.start.endOf
  ")" @argumentOrParameter.iteration.end.startOf
) @argumentOrParameter.iteration.domain