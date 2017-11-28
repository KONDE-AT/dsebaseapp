xquery version "3.0";
import module namespace config="http://www.digital-archiv.at/ns/rita-new/config" at "modules/config.xqm";

(: grant general execution rights to all scripts in analyze and modules collection :)
for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/analyze/"))
    return sm:chmod(xs:anyURI($config:app-root||'/analyze/'||$resource), "rwxrwxr-x"),

for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/modules/"))
    return sm:chmod(xs:anyURI($config:app-root||'/modules/'||$resource), "rwxrwxr-x")
