xquery version "3.0";

declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";

import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";

let $target-base-default := "/home/csae8092/repos"
let $app-name := doc(concat($config:app-root, "/repo.xml"))//repo:target/text()
let $dirs :=  xmldb:get-child-collections(xs:anyURI($config:app-root))
let $target-base := request:get-parameter("target-base",$target-base-default)
let $collections :=
    for $x in $dirs
        let $target := $target-base||"/"||$app-name||"/"||$x
        let $source := $config:app-root||"/"||$x
        let $synced := if (ends-with($x, 'data')) then () else
            try{

                let $synced-files :=  file:sync($source, $target, ())
                return $synced-files

            } catch * {
                let $log := util:log("ERROR", ($err:code, $err:description) )
                return <ERROR>{($err:code, $err:description)}</ERROR>
            }
        return
            <response>
                <source>{$source}</source>
                <target>{$target}</target>
                <synced>{$synced}</synced>
            </response>

let $meta_dir :=  $config:app-root||'/data/meta'
let $synced_meta_dir :=
    let $target := $target-base||"/"||$app-name||"/data/meta"
    let $source := $meta_dir
    let $synced :=
        try{
            let $synced-files :=  file:sync($source, $target, ())
            return $synced-files

        } catch * {
            let $log := util:log("ERROR", ($err:code, $err:description) )
            return <ERROR>{($err:code, $err:description)}</ERROR>
        }
     return
        <response>
            <source>{$source}</source>
            <target>{$target}</target>
            <synced>{$synced}</synced>
        </response>

let $meta_dir :=  $config:app-root||'/data/indices'
let $synced_meta_dir :=
    let $target := $target-base||"/"||$app-name||"/data/indices"
    let $source := $meta_dir
    let $synced :=
        try{
            let $synced-files :=  file:sync($source, $target, ())
            return $synced-files

        } catch * {
            let $log := util:log("ERROR", ($err:code, $err:description) )
            return <ERROR>{($err:code, $err:description)}</ERROR>
        }
     return
        <response>
            <source>{$source}</source>
            <target>{$target}</target>
            <synced>{$synced}</synced>
        </response>

return
    <result>
        {$collections}
        {$synced_meta_dir}
    </result>
