xquery version "3.0";
import module namespace config="http://www.digital-archiv.at/ns/config" at "modules/config.xqm";

(: grant general execution rights to all scripts in analyze and modules collection :)
for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/analyze/"))
    return sm:chmod(xs:anyURI($config:app-root||'/analyze/'||$resource), "rwxrwxr-x"),

for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/modules/"))
    return sm:chmod(xs:anyURI($config:app-root||'/modules/'||$resource), "rwxrwxr-x"),

for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/ac/"))
    return sm:chmod(xs:anyURI($config:app-root||'/ac/'||$resource), "rwxrwxr-x"),

for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/api/"))
    return sm:chmod(xs:anyURI($config:app-root||'/api/'||$resource), "rwxrwxr-x"),

for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/resolver/"))
    return sm:chmod(xs:anyURI($config:app-root||'/resolver/'||$resource), "rwxrwxr-x")