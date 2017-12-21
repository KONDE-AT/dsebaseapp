xquery version "3.0";

declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";

import module namespace config="http://www.digital-archiv.at/ns/dsebaseapp/config" at "modules/config.xqm";

let $target-base-default := "C:\Users\pandorfer\Documents\Redmine"
let $app-name := doc(concat($config:app-root, "/repo.xml"))//repo:target/text()
return 

<response>{
try{
    let $source  := request:get-parameter("source",$config:app-root)
    let $target-base := request:get-parameter("target-base",$target-base-default)
    let $synced-files :=  file:sync($source, $target-base||"/"||$app-name, ()) 
    return $synced-files

} catch * {
    let $log := util:log("ERROR", ($err:code, $err:description) )
    return <ERROR>{($err:code, $err:description)}</ERROR>
}
}</response>