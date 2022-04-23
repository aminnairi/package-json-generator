module Main exposing ( main )

-- IMPORTS

import Browser
import Html exposing ( Html )
import Html.Attributes
import Html.Events
import Json.Encode
import List.Extra


-- MAIN


main : Program () Model Message
main =
  Browser.sandbox
    { init    = init
    , update  = update
    , view    = view
    }


-- VIEW


view : Model -> Html Message
view model =
  Html.div
    []
    [ Html.h1 [] [ Html.text "package.json generator" ]
    , viewCheckbox "Private" model.private UpdatePrivate
    , viewString "Name" model.name UpdateName
    , viewString "Description" model.description UpdateDescription
    , viewString "Version" model.version UpdateVersion
    , viewString "Home page" model.homepage UpdateHomepage
    , viewString "License" model.license UpdateLicense
    , viewString "Main" model.main UpdateMain
    , viewString "Browser" model.browser UpdateBrowser
    , viewString "Bugs URL" model.bugsUrl UpdateBugsUrl
    , viewString "Bugs email" model.bugsEmail UpdateBugsEmail
    , viewString "Author name" model.authorName UpdateAuthorName
    , viewString "Author email" model.authorEmail UpdateAuthorEmail
    , viewString "Author URL" model.authorUrl UpdateAuthorUrl
    , viewString "Repository type" model.repositoryType UpdateRepositoryType
    , viewString "Repository URL" model.repositoryUrl UpdateRepositoryUrl
    , viewString "Node" model.enginesNode UpdateEnginesNode
    , viewString "NPM" model.enginesNpm UpdateEnginesNpm
    , viewList "CPU" AddCpu UpdateCpu RemoveCpu model.cpu
    , viewList "OS" AddOs UpdateOs RemoveOs model.os
    , viewList "Files" AddFile UpdateFile RemoveFile model.files
    , viewList "Keywords" AddKeyword UpdateKeyword RemoveKeyword model.keywords
    , viewContributors model.contributors
    , viewFundings model.fundings
    , viewScripts model.scripts
    , viewConfigurations model.configurations
    , viewDependencies model.dependencies
    , viewDevelopmentDependencies model.developmentDependencies
    , viewPeerDependencies model.peerDependencies
    , viewBundledDependencies model.bundledDependencies
    , viewOptionalDependencies model.optionalDependencies
    , viewModel model
    ]


viewOptionalDependencies : List OptionalDependency -> Html Message
viewOptionalDependencies optionalDependencies =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Optional dependencies" ]
        , Html.button [ Html.Events.onClick AddOptionalDependency ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewOptionalDependency optionalDependencies


viewOptionalDependency : Int -> OptionalDependency -> Html Message
viewOptionalDependency index optionalDependency =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [] [ Html.text "Key" ]
      , Html.input
        [ Html.Attributes.value optionalDependency.key
        , Html.Events.onInput <| UpdateOptionalDependencyKey index
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [] [ Html.text "Value" ]
      , Html.input
        [ Html.Attributes.value optionalDependency.value
        , Html.Events.onInput <| UpdateOptionalDependencyValue index
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveOptionalDependency index ] [ Html.text "Remove" ]
    ]


viewBundledDependencies : List BundledDependency -> Html Message
viewBundledDependencies bundledDependencies =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Bundled dependencies" ]
        , Html.button [ Html.Events.onClick AddBundledDependency ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewBundledDependency bundledDependencies


viewBundledDependency : Int -> BundledDependency -> Html Message
viewBundledDependency index bundledDependency =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [] [ Html.text "Key" ]
      , Html.input
        [ Html.Attributes.value bundledDependency.key
        , Html.Events.onInput <| UpdateBundledDependencyKey index
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [] [ Html.text "Value" ]
      , Html.input
        [ Html.Attributes.value bundledDependency.value
        , Html.Events.onInput <| UpdateBundledDependencyValue index
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveBundledDependency index ] [ Html.text "Remove" ]
    ]


viewPeerDependencies : List PeerDependency -> Html Message
viewPeerDependencies peerDependencies =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Peer dependencies" ]
        , Html.button [ Html.Events.onClick AddPeerDependency ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewPeerDependency peerDependencies


viewPeerDependency : Int -> PeerDependency -> Html Message
viewPeerDependency index peerDependency =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [] [ Html.text "Key" ]
      , Html.input
        [ Html.Attributes.value peerDependency.key
        , Html.Events.onInput <| UpdatePeerDependencyKey index
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [] [ Html.text "value" ]
      , Html.input
        [ Html.Attributes.value peerDependency.value
        , Html.Events.onInput <| UpdatePeerDependencyValue index
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemovePeerDependency index ] [ Html.text "Remove" ]
    ]


viewDevelopmentDependencies : List DevelopmentDependency -> Html Message
viewDevelopmentDependencies developmentDependencies =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Development dependencies" ]
        , Html.button [ Html.Events.onClick AddDevelopmentDependency ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewDevelopmentDependency developmentDependencies


viewDevelopmentDependency : Int -> DevelopmentDependency -> Html Message
viewDevelopmentDependency index developmentDependency =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [] [ Html.text "Key" ]
      , Html.input
        [ Html.Events.onInput <| UpdateDevelopmentDependencyKey index 
        , Html.Attributes.value developmentDependency.key
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [] [ Html.text "Value" ]
      , Html.input
        [ Html.Events.onInput <| UpdateDevelopmentDependencyValue index
        , Html.Attributes.value developmentDependency.value
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveDevelopmentDependency index ] [ Html.text "Remove" ]
    ]


viewDependencies : List Dependency -> Html Message
viewDependencies dependencies =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Dependencies" ]
        , Html.button [ Html.Events.onClick AddDependency ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewDependency dependencies


viewDependency : Int -> Dependency -> Html Message
viewDependency index dependency =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [] [ Html.text "Key" ]
      , Html.input
        [ Html.Events.onInput <| UpdateDependencyKey index
        , Html.Attributes.value dependency.key
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [] [ Html.text "Value" ]
      , Html.input
        [ Html.Events.onInput <| UpdateDependencyValue index
        , Html.Attributes.value dependency.value
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveDependency index ] [ Html.text "Remove" ]
    ]


viewConfigurations : List Configuration -> Html Message
viewConfigurations configurations =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Configurations" ]
        , Html.button [ Html.Events.onClick AddConfiguration ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewConfiguration configurations


viewConfiguration : Int -> Configuration -> Html Message
viewConfiguration index configuration =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [] [ Html.text "Key" ]
      , Html.input
        [ Html.Events.onInput <| UpdateConfigurationKey index
        , Html.Attributes.value configuration.key
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [] [ Html.text "Value" ]
      , Html.input
        [ Html.Events.onInput <| UpdateConfigurationValue index
        , Html.Attributes.value configuration.value
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveConfiguration index ] [ Html.text "Remove" ]
    ]


viewScripts : List Script -> Html Message
viewScripts scripts =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Scripts" ]
        , Html.button [ Html.Events.onClick AddScript ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewScript scripts


viewScript : Int -> Script -> Html Message
viewScript index script =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [] [ Html.text "Key" ]
      , Html.input
        [ Html.Events.onInput <| UpdateScriptKey index
        , Html.Attributes.value script.key
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [] [ Html.text "Command" ]
      , Html.input
        [ Html.Events.onInput <| UpdateScriptCommand index
        , Html.Attributes.value script.command
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveScript index ] [ Html.text "Remove" ]
    ]


viewFundings : List Funding -> Html Message
viewFundings fundings =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Fundings" ]
        , Html.button [ Html.Events.onClick AddFunding ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewFunding fundings


viewFunding : Int -> Funding -> Html Message
viewFunding index funding =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [] [ Html.text "Type" ]
      , Html.input
        [ Html.Events.onInput <| UpdateFundingKind index
        , Html.Attributes.value funding.kind
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [] [ Html.text "Url" ]
      , Html.input
        [ Html.Events.onInput <| UpdateFundingUrl index
        , Html.Attributes.value funding.url
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveFunding index ] [ Html.text "Remove" ]
    ]


viewContributors : List Contributor -> Html Message
viewContributors contributors =
  Html.div []
    <| List.append
        [ Html.label [] [ Html.text "Contributors" ]
        , Html.button [ Html.Events.onClick AddContributor ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewContributor contributors


viewContributor : Int -> Contributor -> Html Message
viewContributor index contributor =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [] [ Html.text "Name" ]
      , Html.input
        [ Html.Events.onInput <| UpdateContributorName index
        , Html.Attributes.value contributor.name
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [] [ Html.text "Email" ]
      , Html.input
        [ Html.Events.onInput <| UpdateContributorEmail index
        , Html.Attributes.value contributor.email
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [] [ Html.text "URL" ]
      , Html.input
        [ Html.Events.onInput <| UpdateContributorUrl index
        , Html.Attributes.value contributor.url
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveContributor index ] [ Html.text "Remove" ]
    ]


viewCheckbox : String -> Bool -> ( Bool -> Message ) -> Html Message
viewCheckbox label checked onCheck =
  Html.div
    []
    [ Html.input
      [ Html.Attributes.id label
      , Html.Attributes.type_ "checkbox"
      , Html.Attributes.checked checked
      , Html.Events.onCheck onCheck
      ]
      []
    , Html.label [ Html.Attributes.for label ] [ Html.text label ]
    ]


viewModel : Model -> Html Message
viewModel model =
  Html.pre [] [ Html.code [] [ Html.text <| encodeModel model ] ]


viewString : String -> String -> ( String -> Message ) -> Html Message
viewString label value onUpdate =
  Html.div
    []
    [ Html.label [ Html.Attributes.for label ] [ Html.text label ]
    , Html.input
      [ Html.Attributes.id label
      , Html.Attributes.type_ "text"
      , Html.Attributes.value value
      , Html.Events.onInput onUpdate
      ]
      []
    ]


viewList : String -> Message -> ( Int -> String -> Message ) -> ( Int -> Message ) -> List String -> Html Message
viewList label onAdd onUpdate onRemove list =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text label ]
        , Html.button [ Html.Events.onClick onAdd ] [ Html.text "Add" ]
        ]
        <| List.indexedMap ( viewStringField onRemove onUpdate ) list

viewStringField : ( Int -> Message ) -> ( Int -> String -> Message ) -> Int -> String -> Html Message
viewStringField removeAtIndex updateAtIndex index item =
  Html.div
    []
    [ Html.input
        [ Html.Attributes.value item
        , Html.Events.onInput <| updateAtIndex index
        ]
        []
    , Html.button [ Html.Events.onClick <| removeAtIndex index ] [ Html.text "Remove" ]
    ]


-- VIEW HELPERS


encodeModel : Model -> String
encodeModel model =
  Json.Encode.encode 2
    <| Json.Encode.object 
        [ encodeName model.name
        , encodeDescription model.description
        , encodeVersion model.version
        , encodeHomepage model.homepage
        , encodeLicense model.license
        , encodeMain model.main
        , encodeBrowser model.browser
        , encodePrivate model.private
        , ( "bugs"
          , Json.Encode.object
              [ ( "url", Json.Encode.string model.bugsUrl )
              , ( "email", Json.Encode.string model.bugsEmail )
              ]
          )
        , ( "author"
          , Json.Encode.object
              [ ( "name", Json.Encode.string model.authorName )
              , ( "email", Json.Encode.string model.authorEmail )
              , ( "url", Json.Encode.string model.authorUrl )
              ]
          )
        , ( "repository"
          , Json.Encode.object
              [ ( "type", Json.Encode.string model.repositoryType )
              , ( "url", Json.Encode.string model.repositoryUrl )
              ]
          )
        , ( "engines"
          , Json.Encode.object
              [ ( "node", Json.Encode.string model.enginesNode )
              , ( "npm", Json.Encode.string model.enginesNpm )
              ]
          )
        , ( "cpu" , Json.Encode.list Json.Encode.string model.cpu )
        , ( "os" , Json.Encode.list Json.Encode.string model.os )
        , ( "files" , Json.Encode.list Json.Encode.string model.files )
        , ( "keywords" , Json.Encode.list Json.Encode.string model.keywords )
        , encodeContributors model.contributors
        , encodeFundings model.fundings
        , encodeScripts model.scripts
        , encodeConfigurations model.configurations
        , encodeDependencies model.dependencies
        , encodeDevelopmentDependencies model.developmentDependencies
        , encodePeerDependencies model.peerDependencies
        , encodeBundledDependencies model.bundledDependencies
        , encodeOptionalDependencies model.optionalDependencies
        ]


encodeOptionalDependencies : List OptionalDependency -> ( String, Json.Encode.Value )
encodeOptionalDependencies optionalDependencies =
  ( "optionalDependencies", Json.Encode.object <| List.map encodeOptionalDependency optionalDependencies )


encodeOptionalDependency : OptionalDependency -> ( String, Json.Encode.Value )
encodeOptionalDependency optionalDependency =
  ( optionalDependency.key, Json.Encode.string optionalDependency.value )


encodeBundledDependencies : List BundledDependency -> ( String, Json.Encode.Value )
encodeBundledDependencies bundledDependencies =
  ( "bundledDependencies", Json.Encode.object <| List.map encodeBundledDependency bundledDependencies )


encodeBundledDependency : BundledDependency -> ( String, Json.Encode.Value )
encodeBundledDependency bundledDependency =
  ( bundledDependency.key, Json.Encode.string bundledDependency.value )


encodePeerDependencies : List PeerDependency -> ( String, Json.Encode.Value )
encodePeerDependencies peerDependencies =
  ( "peerDependencies", Json.Encode.object <| List.map encodePeerDependency peerDependencies )


encodePeerDependency : PeerDependency -> ( String, Json.Encode.Value )
encodePeerDependency peerDependency =
  ( peerDependency.key, Json.Encode.string peerDependency.value )


encodeDependencies : List Dependency -> ( String, Json.Encode.Value )
encodeDependencies dependencies =
  ( "dependencies", Json.Encode.object <| List.map encodeDependency dependencies )


encodeDependency : Dependency -> ( String, Json.Encode.Value )
encodeDependency dependency =
  ( dependency.key, Json.Encode.string dependency.value )


encodeDevelopmentDependencies : List DevelopmentDependency -> ( String, Json.Encode.Value )
encodeDevelopmentDependencies developmentDependencies =
  ( "devDependencies", Json.Encode.object <| List.map encodeDevelopmentDependency developmentDependencies )


encodeDevelopmentDependency : DevelopmentDependency -> ( String, Json.Encode.Value )
encodeDevelopmentDependency developmentDependency =
  ( developmentDependency.key, Json.Encode.string developmentDependency.value )


encodePrivate : Bool -> ( String, Json.Encode.Value )
encodePrivate private =
  ( "private", Json.Encode.bool private )


encodeBrowser : String -> ( String, Json.Encode.Value )
encodeBrowser browser =
  ( "browser", Json.Encode.string browser )


encodeMain : String -> ( String, Json.Encode.Value )
encodeMain mainFile =
  ( "main", Json.Encode.string mainFile )


encodeLicense : String -> ( String, Json.Encode.Value )
encodeLicense license =
  ( "license", Json.Encode.string license )


encodeHomepage : String -> ( String, Json.Encode.Value )
encodeHomepage homepage =
  ( "homepage", Json.Encode.string homepage )


encodeVersion : String -> ( String, Json.Encode.Value )
encodeVersion version =
  ( "version", Json.Encode.string version )


encodeDescription : String -> ( String, Json.Encode.Value )
encodeDescription description =
  ( "description", Json.Encode.string description )


encodeName : String -> ( String, Json.Encode.Value )
encodeName name =
  ( "name", Json.Encode.string name )


encodeConfigurations : List Configuration -> ( String, Json.Encode.Value )
encodeConfigurations configurations =
  ( "config", Json.Encode.object <| List.map encodeConfiguration configurations )


encodeConfiguration : Configuration -> ( String, Json.Encode.Value )
encodeConfiguration configuration =
  ( configuration.key, Json.Encode.string configuration.value )


encodeScripts : List Script -> ( String, Json.Encode.Value )
encodeScripts scripts =
  ( "scripts", Json.Encode.object <| List.map encodeScript scripts )


encodeScript : Script -> ( String, Json.Encode.Value )
encodeScript script =
  ( script.key, Json.Encode.string script.command )


encodeFundings : List Funding -> ( String, Json.Encode.Value )
encodeFundings fundings =
  ( "fundings", Json.Encode.list encodeFunding fundings )


encodeFunding : Funding -> Json.Encode.Value
encodeFunding funding =
  Json.Encode.object
    [ ( "type", Json.Encode.string funding.kind )
    , ( "url", Json.Encode.string funding.url )
    ]


encodeContributors : List Contributor -> ( String, Json.Encode.Value )
encodeContributors contributors =
  ( "contributors", Json.Encode.list encodeContributor contributors )


encodeContributor : Contributor -> Json.Encode.Value
encodeContributor contributor =
  Json.Encode.object
    [ ( "name", Json.Encode.string contributor.name )
    , ( "email", Json.Encode.string contributor.email )
    , ( "url", Json.Encode.string contributor.url )
    ]


-- UPDATE


update : Message -> Model -> Model
update message model =
  case message of
    UpdateName name ->
      { model | name = name }

    UpdateDescription description ->
      { model | description = description }

    UpdateVersion version ->
      { model | version = version }

    UpdateHomepage homepage ->
      { model | homepage = homepage }

    UpdateLicense license ->
      { model | license = license }

    UpdateMain newMain ->
      { model | main = newMain }

    UpdateBrowser browser ->
      { model | browser = browser }

    UpdatePrivate private ->
      { model | private = private }

    UpdateBugsUrl bugsUrl ->
      { model | bugsUrl = bugsUrl }

    UpdateBugsEmail bugsEmail ->
      { model | bugsEmail = bugsEmail }

    UpdateAuthorName authorName ->
      { model | authorName = authorName }

    UpdateAuthorEmail authorEmail ->
      { model | authorEmail = authorEmail }

    UpdateAuthorUrl authorUrl ->
      { model | authorUrl = authorUrl }

    UpdateRepositoryType repositoryType ->
      { model | repositoryType = repositoryType }

    UpdateRepositoryUrl repositoryUrl ->
      { model | repositoryUrl = repositoryUrl }

    UpdateEnginesNode enginesNode ->
      { model | enginesNode = enginesNode }

    UpdateEnginesNpm enginesNpm ->
      { model | enginesNpm = enginesNpm }

    AddCpu ->
      { model | cpu = List.append model.cpu [ "" ] }

    UpdateCpu index value ->
      { model | cpu = List.Extra.updateAt index ( always value ) model.cpu }

    RemoveCpu index ->
      { model | cpu = List.Extra.removeAt index model.cpu }

    AddOs ->
      { model | os = List.append model.os [ "" ] }

    UpdateOs index value ->
      { model | os = List.Extra.updateAt index ( always value ) model.os }

    RemoveOs index ->
      { model | os = List.Extra.removeAt index model.os }

    AddFile ->
      { model | files = List.append model.files [ "" ] }

    UpdateFile index value ->
      { model | files = List.Extra.updateAt index ( always value ) model.files }

    RemoveFile index ->
      { model | files = List.Extra.removeAt index model.files }

    AddKeyword ->
      { model | keywords = List.append model.keywords [ "" ] }

    UpdateKeyword index value ->
      { model | keywords = List.Extra.updateAt index ( always value ) model.keywords }

    RemoveKeyword index ->
      { model | keywords = List.Extra.removeAt index model.keywords }

    AddContributor ->
      { model | contributors = List.append model.contributors [ { name = "", email = "", url = "" } ] }

    RemoveContributor index ->
      { model | contributors = List.Extra.removeAt index model.contributors }

    UpdateContributorName index name ->
      { model | contributors = List.Extra.updateAt index ( updateContributorName name ) model.contributors }

    UpdateContributorEmail index email ->
      { model | contributors = List.Extra.updateAt index ( updateContributorEmail email ) model.contributors }

    UpdateContributorUrl index url ->
      { model | contributors = List.Extra.updateAt index ( updateContributorUrl url ) model.contributors }

    AddFunding ->
      { model | fundings = List.append model.fundings [ { kind = "", url = "" } ] }

    UpdateFundingKind index kind ->
      { model | fundings = List.Extra.updateAt index ( updateFundingKind kind ) model.fundings }

    UpdateFundingUrl index url ->
      { model | fundings = List.Extra.updateAt index ( updateFundingUrl url ) model.fundings }

    RemoveFunding index ->
      { model | fundings = List.Extra.removeAt index model.fundings }

    AddScript ->
      { model | scripts = List.append model.scripts [ { key = "", command = "" } ] }

    RemoveScript index ->
      { model | scripts = List.Extra.removeAt index model.scripts }

    UpdateScriptKey index key ->
      { model | scripts = List.Extra.updateAt index ( updateScriptKey key ) model.scripts }

    UpdateScriptCommand index command ->
      { model | scripts = List.Extra.updateAt index ( updateScriptCommand command ) model.scripts }

    AddConfiguration ->
      { model | configurations = List.append model.configurations [ { key = "", value = "" } ] }

    RemoveConfiguration index ->
      { model | configurations = List.Extra.removeAt index model.configurations }

    UpdateConfigurationKey index key ->
      { model | configurations = List.Extra.updateAt index ( updateConfigurationKey key ) model.configurations }

    UpdateConfigurationValue index value ->
      { model | configurations = List.Extra.updateAt index ( updateConfigurationValue value ) model.configurations }

    AddDependency ->
      { model | dependencies = List.append model.dependencies [ { key = "", value = "" } ] }

    RemoveDependency index ->
      { model | dependencies = List.Extra.removeAt index model.dependencies }

    UpdateDependencyKey index key ->
      { model | dependencies = List.Extra.updateAt index ( updateDependencyKey key ) model.dependencies }
    
    UpdateDependencyValue index value ->
      { model | dependencies = List.Extra.updateAt index ( updateDependencyValue value ) model.dependencies }

    AddDevelopmentDependency ->
      { model | developmentDependencies = List.append model.developmentDependencies [ { key = "", value = "" } ] }

    UpdateDevelopmentDependencyValue index value ->
      { model | developmentDependencies = List.Extra.updateAt index ( updateDevelopmentDependencyValue value ) model.developmentDependencies }

    UpdateDevelopmentDependencyKey index key ->
      { model | developmentDependencies = List.Extra.updateAt index ( updateDevelopmentDependencyKey key ) model.developmentDependencies }

    RemoveDevelopmentDependency index ->
      { model | developmentDependencies = List.Extra.removeAt index model.developmentDependencies }

    AddPeerDependency ->
      { model | peerDependencies = List.append model.peerDependencies [ { key = "", value = "" } ] }

    UpdatePeerDependencyKey index key ->
      { model | peerDependencies = List.Extra.updateAt index ( updatePeerDependencyKey key ) model.peerDependencies }

    UpdatePeerDependencyValue index value ->
      { model | peerDependencies = List.Extra.updateAt index ( updatePeerDependencyValue value ) model.peerDependencies }

    RemovePeerDependency index ->
      { model | peerDependencies = List.Extra.removeAt index model.peerDependencies }

    AddBundledDependency ->
      { model | bundledDependencies = List.append model.bundledDependencies [ { key = "", value = "" } ] }

    RemoveBundledDependency index ->
      { model | bundledDependencies = List.Extra.removeAt index model.bundledDependencies }

    UpdateBundledDependencyKey index key ->
      { model | bundledDependencies = List.Extra.updateAt index ( updateBundledDependencyKey key ) model.bundledDependencies }

    UpdateBundledDependencyValue index value ->
      { model | bundledDependencies = List.Extra.updateAt index ( updateBundledDependencyValue value ) model.bundledDependencies }

    AddOptionalDependency ->
      { model | optionalDependencies = List.append model.optionalDependencies [ { key = "", value = "" } ] }

    UpdateOptionalDependencyKey index key ->
      { model | optionalDependencies = List.Extra.updateAt index ( updateOptionalDependencyKey key ) model.optionalDependencies }

    UpdateOptionalDependencyValue index value ->
      { model | optionalDependencies = List.Extra.updateAt index ( updateOptionalDependencyValue value ) model.optionalDependencies }
  
    RemoveOptionalDependency index ->
      { model | optionalDependencies = List.Extra.removeAt index model.optionalDependencies }


updateOptionalDependencyValue : String -> OptionalDependency -> OptionalDependency
updateOptionalDependencyValue value optionalDependency =
  { optionalDependency | value = value }


updateOptionalDependencyKey : String -> OptionalDependency -> OptionalDependency
updateOptionalDependencyKey key optionalDependency =
  { optionalDependency | key = key }


updateBundledDependencyValue : String -> BundledDependency -> BundledDependency
updateBundledDependencyValue value bundledDependency =
  { bundledDependency | value = value }


updateBundledDependencyKey : String -> BundledDependency -> BundledDependency
updateBundledDependencyKey key bundledDependency =
  { bundledDependency | key = key }


updatePeerDependencyKey : String -> PeerDependency -> PeerDependency
updatePeerDependencyKey key peerDependency =
  { peerDependency | key = key }


updatePeerDependencyValue : String -> PeerDependency -> PeerDependency
updatePeerDependencyValue value peerDependency =
  { peerDependency | value = value }


updateDevelopmentDependencyKey : String -> DevelopmentDependency -> DevelopmentDependency
updateDevelopmentDependencyKey key developmentDependency =
  { developmentDependency | key = key }


updateDevelopmentDependencyValue : String -> DevelopmentDependency -> DevelopmentDependency
updateDevelopmentDependencyValue value developmentDependency =
  { developmentDependency | value = value }


updateDependencyValue : String -> Dependency -> Dependency
updateDependencyValue value dependency =
  { dependency | value = value }


updateDependencyKey : String -> Dependency -> Dependency
updateDependencyKey key dependency =
  { dependency | key = key }


updateConfigurationValue : String -> Configuration -> Configuration
updateConfigurationValue value configuration =
  { configuration | value = value }


updateConfigurationKey : String -> Configuration -> Configuration
updateConfigurationKey key configuration =
  { configuration | key = key }


updateScriptCommand : String -> Script -> Script
updateScriptCommand command script =
  { script | command = command }


updateScriptKey : String -> Script -> Script
updateScriptKey key script =
  { script | key = key }


updateFundingUrl : String -> Funding -> Funding
updateFundingUrl url funding =
  { funding | url = url }


updateFundingKind : String -> Funding -> Funding
updateFundingKind kind funding =
  { funding | kind = kind }


updateContributorUrl : String -> Contributor -> Contributor
updateContributorUrl url contributor =
  { contributor | url = url }


updateContributorEmail : String -> Contributor -> Contributor
updateContributorEmail email contributor =
  { contributor | email = email }


updateContributorName : String -> Contributor -> Contributor
updateContributorName name contributor =
  { contributor | name = name }


-- INIT


init : Model
init =
  { name = ""
  , description = ""
  , version = ""
  , homepage = ""
  , license = ""
  , main = ""
  , browser = ""
  , private = False
  , bugsUrl = ""
  , bugsEmail = ""
  , authorName = ""
  , authorEmail = ""
  , authorUrl = ""
  , repositoryType = ""
  , repositoryUrl = ""
  , enginesNode = ""
  , enginesNpm = ""
  , cpu = []
  , os = []
  , files = []
  , keywords = []
  , contributors = []
  , fundings = []
  , scripts = []
  , configurations = []
  , dependencies = []
  , developmentDependencies = []
  , peerDependencies = []
  , bundledDependencies = []
  , optionalDependencies = []
  }


-- TYPES ( MODEL )


type alias Model =
  { name : String
  , description : String
  , version : String
  , homepage : String
  , license : String
  , main : String
  , browser : String
  , private : Bool
  , bugsUrl: String
  , bugsEmail : String
  , authorName : String
  , authorEmail : String
  , authorUrl : String
  , repositoryType : String
  , repositoryUrl : String
  , enginesNode : String
  , enginesNpm : String
  , cpu : List String
  , os : List String
  , files : List String
  , keywords : List String
  , contributors : List Contributor
  , fundings : List Funding
  , scripts : List Script
  , configurations : List Configuration
  , dependencies : List Dependency
  , developmentDependencies : List DevelopmentDependency
  , peerDependencies : List PeerDependency
  , bundledDependencies : List BundledDependency
  , optionalDependencies : List OptionalDependency
  }


type alias OptionalDependency =
  { key : String
  , value : String
  }


type alias BundledDependency =
  { key : String
  , value : String
  }


type alias PeerDependency =
  { key : String
  , value : String
  }


type alias DevelopmentDependency =
  { key : String
  , value : String
  }


type alias Dependency =
  { key : String
  , value : String
  }


type alias Configuration =
  { key : String
  , value : String
  }


type alias Script =
  { key : String
  , command : String
  }


type alias Funding =
  { kind : String
  , url : String
  }


type alias Contributor =
  { name : String
  , email : String
  , url : String
  }


-- TYPES ( MESSAGE )


type Message
  = UpdateName String
  | UpdateDescription String
  | UpdateVersion String
  | UpdateHomepage String
  | UpdateLicense String
  | UpdateMain String
  | UpdateBrowser String
  | UpdatePrivate Bool
  | UpdateBugsUrl String
  | UpdateBugsEmail String
  | UpdateAuthorName String
  | UpdateAuthorEmail String
  | UpdateAuthorUrl String
  | UpdateRepositoryType String
  | UpdateRepositoryUrl String
  | UpdateEnginesNode String
  | UpdateEnginesNpm String
  | AddCpu
  | RemoveCpu Int
  | UpdateCpu Int String
  | AddOs
  | UpdateOs Int String
  | RemoveOs Int
  | AddFile
  | UpdateFile Int String
  | RemoveFile Int
  | AddKeyword
  | UpdateKeyword Int String
  | RemoveKeyword Int
  | AddContributor
  | RemoveContributor Int
  | UpdateContributorName Int String
  | UpdateContributorEmail Int String
  | UpdateContributorUrl Int String
  | AddFunding
  | UpdateFundingKind Int String
  | UpdateFundingUrl Int String
  | RemoveFunding Int
  | AddScript
  | UpdateScriptKey Int String
  | UpdateScriptCommand Int String
  | RemoveScript Int
  | AddConfiguration
  | UpdateConfigurationKey Int String
  | UpdateConfigurationValue Int String
  | RemoveConfiguration Int
  | AddDependency
  | RemoveDependency Int
  | UpdateDependencyKey Int String
  | UpdateDependencyValue Int String
  | AddDevelopmentDependency
  | UpdateDevelopmentDependencyKey Int String
  | UpdateDevelopmentDependencyValue Int String
  | RemoveDevelopmentDependency Int
  | AddPeerDependency
  | UpdatePeerDependencyKey Int String
  | UpdatePeerDependencyValue Int String
  | RemovePeerDependency Int
  | AddBundledDependency
  | RemoveBundledDependency Int
  | UpdateBundledDependencyKey Int String
  | UpdateBundledDependencyValue Int String
  | AddOptionalDependency
  | RemoveOptionalDependency Int
  | UpdateOptionalDependencyKey Int String
  | UpdateOptionalDependencyValue Int String
