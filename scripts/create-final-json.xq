(: Script transforms data.json exported from Gephi 
   using SigmaJS export to the final format used in
   published visualization 

   To be used in BaseX (http://basex.org)
  
  Matti Lassila, University of Jyväskylä, Open Science Center, 2017.
  Licensed under a Creative Commons Attribution 4.0 International License.
  <http://creativecommons.org/licenses/by/4.0/>

  :)

let $orig_json:=/json


let $nodes:=
  <nodes type="array">{
  for $node in $orig_json/nodes/_
    let $id:=$node/id
    let $attributes:=$node/attributes
    
    
    
    let $label:=
      if($node/label) then
        data($node/label)
        else(concat("CDL-", $id))
    
    let $scribe_title:=
      if(not($attributes/scribe__title eq 'none')) then
        $attributes/scribe__title
        else()
    
    let $doc_type:=
      if(not($attributes/doc__type eq 'none')) then
       $attributes/doc__type
       else()
    
    let $entity_type:=
      if($attributes/is__scribe eq 'TRUE') then
      'scribe'
      else if ($attributes/is__place eq 'TRUE') then
      'place'
      else(
        'document'
      )
    
    let $period:=
          string-join(distinct-values(
            tokenize(
              replace(
                replace(
                  replace($attributes/Interval,'&lt;\[',''),'\]&gt;',''),'\.0',''),', ')
              ),
            '–') 
    
    return
    
     <_ type="object">
     <label>{$label}</label>
     {$node/x}
     {$node/y}
     {$node/id}
     <attributes type="object">
     <entity__type>{$entity_type}</entity__type>
     {$scribe_title}
     {$doc_type}
     {$attributes/class__prep}
     {$attributes/ae}
     {$attributes/gen__pl}
     {$attributes/sum__z-score}
     {$attributes/spelling__corr}
     <time__interval>{$period}</time__interval>
     
     </attributes>
     {$node/color}
     {$node/size}
     </_>
   
    
}</nodes>
let $json:=

<json type="object">

{$nodes}

{$orig_json/edges}

</json>


return json:serialize($json)