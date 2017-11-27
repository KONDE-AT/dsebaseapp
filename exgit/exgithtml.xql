xquery version "3.1";
module namespace exgithtml="http://www.digital-archiv.at/ns/dsebaseapp/exgithtml";
import module namespace app="http://www.digital-archiv.at/ns/dsebaseapp/templates" at "../modules/app.xql";

(:~
: returns the path to data collection as hidden input field value
:)
declare function exgithtml:commitAndReport($node as node(), $model as map (*)){
let $repoDir := request:get-parameter('repoDir', 'NONE')
let $gitCollection := request:get-parameter('gitCollection', 'NONE')
let $commitMsg := request:get-parameter('commitMsg', 'NONE')
let $username := request:get-parameter('username', 'NONE')
let $password := request:get-parameter('password', 'NONE')
let $email := request:get-parameter('email', 'NONE')

let $sync := exgit:sync($repoDir, $gitCollection, ())
let $commit := exgit:commit($repoDir, $commitMsg)
let $push := exgit:push($repoDir, "origin", $username, $password)
return
    <pre>
        <syncedFiles>{$sync}</syncedFiles>
        <commit>{$commit}</commit>
        <repoDir>{$repoDir}</repoDir>
        <gitCollection>{$gitCollection}</gitCollection>
        <commitMsg>{$commitMsg}</commitMsg>
        <username>{$username}</username>
        <email>{$email}</email>
    </pre>
};