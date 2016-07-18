(:
 : derived from http://www.xqueryfunctions.com/xq/functx_pad-string-to-length.html
 :)

declare function local:pad-string-to-length-on-the-left
  ( $stringToPad as xs:string? ,
    $padChar as xs:string ,
    $length as xs:integer )  as xs:string {

   let $length0 := string-length($stringToPad)
   let $length1 := $length - $length0

   return substring(

     concat( string-join( (for $i in (1 to $length1) return $padChar) , '' ) ,
             $stringToPad )

    ,1,$length)
 } ;
