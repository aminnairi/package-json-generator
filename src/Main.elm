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
    , viewPrivate model.private
    , viewName model.name
    , viewDescription model.description
    , viewVersion model.version
    , viewHomepage model.homepage
    , viewLicense model.license
    , viewMain model.main
    , viewBrowser model.browser
    , viewBugs model.bugs
    , viewAuthor model.author
    , viewRepository model.repository
    , viewEngines model.engines
    , viewCpus model.cpus
    , viewOperatingSystems model.operatingSystems
    , viewFiles model.files
    , viewKeywords model.keywords
    , viewWorkspaces model.workspaces
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


viewWorkspaces : List Workspace -> Html Message
viewWorkspaces workspaces =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Workspaces" ]
        , Html.button [ Html.Events.onClick AddWorkspace ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewWorkspace workspaces


viewWorkspace : Int -> Workspace -> Html Message
viewWorkspace index ( Workspace workspace ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for <| "workspace-" ++ String.fromInt index ] [ Html.text "Workspace name" ]
    , Html.input
      [ Html.Attributes.value workspace
      , Html.Attributes.id <| "workspace-" ++ String.fromInt index
      , Html.Events.onInput <| UpdateWorkspace index
      ]
      []
    , Html.button [ Html.Events.onClick <| RemoveWorkspace index ] [ Html.text "Remove" ]
    ]


viewKeywords : List Keyword -> Html Message
viewKeywords keywords =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Keywords" ]
        , Html.button [ Html.Events.onClick AddKeyword ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewKeyword keywords


viewKeyword : Int -> Keyword -> Html Message
viewKeyword index ( Keyword keyword ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for <| "keyword-" ++ String.fromInt index ] [ Html.text "Keyword" ]
    , Html.input
      [ Html.Attributes.id <| "keyword-" ++ String.fromInt index 
      , Html.Attributes.value keyword
      , Html.Events.onInput <| UpdateKeyword index
      ]
      []
    , Html.button [ Html.Events.onClick <| RemoveKeyword index ] [ Html.text "Keyword" ]
    ]


viewFiles : List File -> Html Message
viewFiles files =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Files" ]
        , Html.button [ Html.Events.onClick AddFile ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewFile files


viewFile : Int -> File -> Html Message
viewFile index ( File file ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for <| "file-" ++ String.fromInt index ] [ Html.text "File name" ]
    , Html.input
      [ Html.Attributes.value file
      , Html.Attributes.id <| "file-" ++ String.fromInt index 
      , Html.Events.onInput <| UpdateFile index
      ]
      []
    , Html.button [ Html.Events.onClick <| RemoveFile index ] [ Html.text "Remove" ]
    ]


viewOperatingSystems : List OperatingSystem -> Html Message
viewOperatingSystems operatingSystems =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "Operating systems" ]
        , Html.button [ Html.Events.onClick AddOperatingSystem ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewOperatingSystem operatingSystems


viewOperatingSystem : Int -> OperatingSystem -> Html Message
viewOperatingSystem index ( OperatingSystem operatingSystem ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for <| "operating-system-" ++ String.fromInt index ] [ Html.text "OS name" ]
    , Html.input
      [ Html.Attributes.id <| "operating-system-" ++ String.fromInt index 
      , Html.Attributes.value operatingSystem
      , Html.Events.onInput <| UpdateOperatingSystem index
      ]
      []
    , Html.button [ Html.Events.onClick <| RemoveOperatingSystem index ] [ Html.text "Remove" ]
    ]


viewCpus : List Cpu -> Html Message
viewCpus cpus =
  Html.div
    []
    <| List.append
        [ Html.label [] [ Html.text "CPUs" ]
        , Html.button [ Html.Events.onClick AddCpu ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewCpu cpus


viewCpu : Int -> Cpu -> Html Message
viewCpu index ( Cpu cpu ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for <| "cpu-" ++ String.fromInt index ] [ Html.text "CPU name" ]
    , Html.input
      [ Html.Attributes.id <| "cpu-" ++ String.fromInt index
      , Html.Attributes.value cpu
      , Html.Events.onInput <| UpdateCpu index
      ]
      []
    , Html.button [ Html.Events.onClick <| RemoveCpu index ] [ Html.text "Remove" ]
    ]



viewBrowser : Browser -> Html Message
viewBrowser ( Browser browser ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "browser" ] [ Html.text "Browser" ]
    , Html.input
      [ Html.Attributes.value browser
      , Html.Attributes.id "browser"
      , Html.Events.onInput UpdateBrowser
      ]
      []
    ]


viewMain : Main -> Html Message
viewMain ( Main entrypoint ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "main" ] [ Html.text "Main" ]
    , Html.input
      [ Html.Attributes.value entrypoint
      , Html.Attributes.id "main"
      , Html.Events.onInput UpdateMain
      ]
      []
    ]


viewLicense : License -> Html Message
viewLicense ( License license ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "license" ] [ Html.text "License" ]
    , Html.input
      [ Html.Attributes.value license
      , Html.Attributes.id "license"
      , Html.Events.onInput UpdateLicense
      ]
      []
    ]


viewHomepage : Homepage -> Html Message
viewHomepage ( Homepage homepage ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "homepage" ] [ Html.text "Home page" ]
    , Html.input
      [ Html.Attributes.value homepage
      , Html.Attributes.id "homepage"
      , Html.Events.onInput UpdateHomepage
      ]
      []
    ]


viewVersion : Version -> Html Message
viewVersion ( Version version ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "version" ] [ Html.text "Version" ]
    , Html.input
      [ Html.Attributes.value version
      , Html.Attributes.id "version"
      , Html.Events.onInput UpdateVersion
      ]
      []
    ]


viewDescription : Description -> Html Message
viewDescription ( Description description ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "description" ] [ Html.text "Description" ]
    , Html.input
      [ Html.Attributes.value description
      , Html.Attributes.id "description"
      , Html.Events.onInput UpdateDescription
      ]
      []
    ]


viewName : Name -> Html Message
viewName ( Name name ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "name" ] [ Html.text "Name" ]
    , Html.input
      [ Html.Attributes.value name
      , Html.Attributes.id "name"
      , Html.Events.onInput UpdateName
      ]
      []
    ]


viewPrivate : Private -> Html Message
viewPrivate ( Private private ) =
  Html.div
    []
    [ Html.input
      [ Html.Attributes.checked private
      , Html.Events.onCheck UpdatePrivate
      , Html.Attributes.type_ "checkbox"
      , Html.Attributes.id "private"
      ]
      []
    , Html.label [ Html.Attributes.for "private" ] [ Html.text "Private" ]
    ]


viewEngines : Engines -> Html Message
viewEngines ( Engines engines ) =
  Html.div
    []
    [ viewNodeEngine engines.node
    , viewNpmEngine engines.npm
    ]


viewNodeEngine : NodeEngine -> Html Message
viewNodeEngine ( NodeEngine node ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "engines-node" ] [ Html.text "Node version" ]
    , Html.input
      [ Html.Attributes.value node
      , Html.Events.onInput UpdateEnginesNode
      , Html.Attributes.id "engines-node"
      ]
      []
    ]


viewNpmEngine : NpmEngine -> Html Message
viewNpmEngine ( NpmEngine npm ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "engines-npm" ] [ Html.text "NPM version" ]
    , Html.input
      [ Html.Attributes.value npm
      , Html.Events.onInput UpdateEnginesNpm
      , Html.Attributes.id "engines-npm"
      ]
      []
    ]


viewRepository : Repository -> Html Message
viewRepository ( Repository repository ) =
  Html.div
    []
    [ viewRepositoryKind repository.kind
    , viewRepositoryUrl repository.url
    ]


viewRepositoryKind : RepositoryKind -> Html Message
viewRepositoryKind ( RepositoryKind kind ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "repository-type" ] [ Html.text "Repository type" ]
    , Html.input
      [ Html.Attributes.value kind
      , Html.Events.onInput UpdateRepositoryKind
      , Html.Attributes.id "repository-type"
      ]
      []
    ]


viewRepositoryUrl : RepositoryUrl -> Html Message
viewRepositoryUrl ( RepositoryUrl url ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "repository-url" ] [ Html.text "Repository URL" ]
    , Html.input
      [ Html.Attributes.value url
      , Html.Events.onInput UpdateRepositoryUrl
      , Html.Attributes.id "repository-url"
      ]
      []
    ]


viewAuthor : Author -> Html Message
viewAuthor ( Author author ) =
  Html.div
    []
    [ viewAuthorName author.name
    , viewAuthorUrl author.url
    , viewAuthorEmail author.email
    ]


viewAuthorName : AuthorName -> Html Message
viewAuthorName ( AuthorName name ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "author-name" ] [ Html.text "Author name" ] 
    , Html.input
      [ Html.Attributes.value name
      , Html.Events.onInput UpdateAuthorName
      , Html.Attributes.id "author-name"
      ]
      [] 
    ]


viewAuthorUrl : AuthorUrl -> Html Message
viewAuthorUrl ( AuthorUrl url ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "author-url" ] [ Html.text "Author URL" ] 
    , Html.input
      [ Html.Attributes.value url
      , Html.Events.onInput UpdateAuthorUrl
      , Html.Attributes.id "author-url"
      ]
      [] 
    ]


viewAuthorEmail : AuthorEmail -> Html Message
viewAuthorEmail ( AuthorEmail email ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "author-email" ] [ Html.text "Author Email" ] 
    , Html.input
      [ Html.Attributes.value email
      , Html.Events.onInput UpdateAuthorEmail
      , Html.Attributes.id "author-email"
      ]
      [] 
    ]


viewBugs : Bugs -> Html Message
viewBugs ( Bugs bugs ) =
  Html.div
    []
    [ viewBugsUrl bugs.url
    , viewBugsEmail bugs.email
    ]


viewBugsUrl : BugsUrl -> Html Message
viewBugsUrl ( BugsUrl url ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "bugs-url" ] [ Html.text "Bugs URL" ]
    , Html.input
      [ Html.Attributes.value url
      , Html.Events.onInput UpdateBugsUrl
      , Html.Attributes.for "bugs-url"
      ]
      []
    ]


viewBugsEmail : BugsEmail -> Html Message
viewBugsEmail ( BugsEmail email ) =
  Html.div
    []
    [ Html.label [ Html.Attributes.for "bugs-email" ] [ Html.text "Bugs email" ]
    , Html.input
      [ Html.Attributes.value email
      , Html.Events.onInput UpdateBugsEmail
      , Html.Attributes.id "bugs-email"
      ]
      []
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
viewOptionalDependency index ( OptionalDependency optionalDependency ) =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [ Html.Attributes.for <| "optional-dependency-key-" ++ String.fromInt index ] [ Html.text "Key" ]
      , Html.input
        [ Html.Attributes.value <| viewOptionalDependencyKey optionalDependency.key
        , Html.Events.onInput <| UpdateOptionalDependencyKey index
        , Html.Attributes.id <| "optional-dependency-key-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [ Html.Attributes.for <| "optional-dependency-value-" ++ String.fromInt index ] [ Html.text "Value" ]
      , Html.input
        [ Html.Attributes.value <| viewOptionalDependencyValue optionalDependency.value
        , Html.Events.onInput <| UpdateOptionalDependencyValue index
        , Html.Attributes.id <| "optional-dependency-value-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveOptionalDependency index ] [ Html.text "Remove" ]
    ]


viewOptionalDependencyKey : OptionalDependencyKey -> String
viewOptionalDependencyKey ( OptionalDependencyKey optionalDependencyKey ) =
  optionalDependencyKey


viewOptionalDependencyValue : OptionalDependencyValue -> String
viewOptionalDependencyValue ( OptionalDependencyValue optionalDependencyValue ) =
  optionalDependencyValue


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
viewBundledDependency index ( BundledDependency bundledDependency ) =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [ Html.Attributes.for <| "bundled-dependency-key-" ++ String.fromInt index ] [ Html.text "Key" ]
      , Html.input
        [ Html.Attributes.value <| viewBundledDependencyKey bundledDependency.key
        , Html.Events.onInput <| UpdateBundledDependencyKey index
        , Html.Attributes.id <| "bundled-dependency-key-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [ Html.Attributes.for <| "bundled-dependency-value-" ++ String.fromInt index ] [ Html.text "Value" ]
      , Html.input
        [ Html.Attributes.value <| viewBundledDependencyValue bundledDependency.value
        , Html.Events.onInput <| UpdateBundledDependencyValue index
        , Html.Attributes.id <| "bundled-dependency-value-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveBundledDependency index ] [ Html.text "Remove" ]
    ]


viewBundledDependencyKey : BundledDependencyKey -> String
viewBundledDependencyKey ( BundledDependencyKey bundledDependencyKey ) =
  bundledDependencyKey


viewBundledDependencyValue : BundledDependencyValue -> String
viewBundledDependencyValue ( BundledDependencyValue bundledDependencyValue ) =
  bundledDependencyValue


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
viewPeerDependency index ( PeerDependency peerDependency ) =
  Html.div
    []
    [ Html.div
      []
      [ Html.label [ Html.Attributes.for <| "peer-dependency-key-" ++ String.fromInt index ] [ Html.text "Key" ]
      , Html.input
        [ Html.Attributes.value <| viewPeerDependencyKey peerDependency.key
        , Html.Events.onInput <| UpdatePeerDependencyKey index
        , Html.Attributes.id <| "peer-dependency-key-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [ Html.Attributes.for <| "peer-dependency-value-" ++ String.fromInt index ] [ Html.text "Value" ]
      , Html.input
        [ Html.Attributes.value <| viewPeerDependencyValue peerDependency.value
        , Html.Events.onInput <| UpdatePeerDependencyValue index
        , Html.Attributes.id <| "peer-dependency-value-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemovePeerDependency index ] [ Html.text "Remove" ]
    ]


viewPeerDependencyKey : PeerDependencyKey -> String
viewPeerDependencyKey ( PeerDependencyKey peerDependencyKey ) =
  peerDependencyKey


viewPeerDependencyValue : PeerDependencyValue -> String
viewPeerDependencyValue ( PeerDependencyValue peerDependencyValue ) =
  peerDependencyValue


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
      [ Html.label [ Html.Attributes.for <| "development-dependency-key-" ++ String.fromInt index ] [ Html.text "Key" ]
      , Html.input
        [ Html.Events.onInput <| UpdateDevelopmentDependencyKey index 
        , Html.Attributes.value developmentDependency.key
        , Html.Attributes.id <| "development-dependency-key-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [ Html.Attributes.for <| "development-dependency-value-" ++ String.fromInt index ] [ Html.text "Value" ]
      , Html.input
        [ Html.Events.onInput <| UpdateDevelopmentDependencyValue index
        , Html.Attributes.value developmentDependency.value
        , Html.Attributes.id <| "development-dependency-value-" ++ String.fromInt index 
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
      [ Html.label [ Html.Attributes.for <| "dependency-key-" ++ String.fromInt index ] [ Html.text "Key" ]
      , Html.input
        [ Html.Events.onInput <| UpdateDependencyKey index
        , Html.Attributes.value dependency.key
        , Html.Attributes.id <| "dependency-key-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [ Html.Attributes.for <| "dependency-value-" ++ String.fromInt index ] [ Html.text "Value" ]
      , Html.input
        [ Html.Events.onInput <| UpdateDependencyValue index
        , Html.Attributes.value dependency.value
        , Html.Attributes.id <| "dependency-value-" ++ String.fromInt index 
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
      [ Html.label [ Html.Attributes.for <| "configuration-key-" ++ String.fromInt index ] [ Html.text "Key" ]
      , Html.input
        [ Html.Events.onInput <| UpdateConfigurationKey index
        , Html.Attributes.value configuration.key
        , Html.Attributes.id <| "configuration-key-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [ Html.Attributes.for <| "configuration-value-" ++ String.fromInt index ] [ Html.text "Value" ]
      , Html.input
        [ Html.Events.onInput <| UpdateConfigurationValue index
        , Html.Attributes.value configuration.value
        , Html.Attributes.id <| "configuration-value-" ++ String.fromInt index 
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
      [ Html.label [ Html.Attributes.for <| "script-key-" ++ String.fromInt index ] [ Html.text "Key" ]
      , Html.input
        [ Html.Events.onInput <| UpdateScriptKey index
        , Html.Attributes.value script.key
        , Html.Attributes.id <| "script-key-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [ Html.Attributes.for <| "script-command-" ++ String.fromInt index ] [ Html.text "Command" ]
      , Html.input
        [ Html.Events.onInput <| UpdateScriptCommand index
        , Html.Attributes.value script.command
        , Html.Attributes.id <| "script-command-" ++ String.fromInt index 
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
      [ Html.label [ Html.Attributes.for <| "funding-type-" ++ String.fromInt index ] [ Html.text "Type" ]
      , Html.input
        [ Html.Events.onInput <| UpdateFundingKind index
        , Html.Attributes.value funding.kind
        , Html.Attributes.id <| "funding-type-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [ Html.Attributes.for <| "funding-url-" ++ String.fromInt index ] [ Html.text "Url" ]
      , Html.input
        [ Html.Events.onInput <| UpdateFundingUrl index
        , Html.Attributes.value funding.url
        , Html.Attributes.id <| "funding-url-" ++ String.fromInt index 
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
      [ Html.label [ Html.Attributes.for <| "contributor-name-" ++ String.fromInt index ] [ Html.text "Name" ]
      , Html.input
        [ Html.Events.onInput <| UpdateContributorName index
        , Html.Attributes.value contributor.name
        , Html.Attributes.id <| "contributor-name-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [ Html.Attributes.for <| "contributor-email-" ++ String.fromInt index ] [ Html.text "Email" ]
      , Html.input
        [ Html.Events.onInput <| UpdateContributorEmail index
        , Html.Attributes.value contributor.email
        , Html.Attributes.id <| "contributor-email-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.div
      []
      [ Html.label [ Html.Attributes.for <| "contributor-url-" ++ String.fromInt index ] [ Html.text "URL" ]
      , Html.input
        [ Html.Events.onInput <| UpdateContributorUrl index
        , Html.Attributes.value contributor.url
        , Html.Attributes.id <| "contributor-url-" ++ String.fromInt index 
        ]
        []
      ]
    , Html.button [ Html.Events.onClick <| RemoveContributor index ] [ Html.text "Remove" ]
    ]


viewModel : Model -> Html Message
viewModel model =
  Html.pre [] [ Html.code [] [ Html.text <| encodeModel model ] ]


-- VIEW HELPERS


encodeModel : Model -> String
encodeModel model =
  Json.Encode.encode 2
    <| Json.Encode.object 
        [ encodePrivate model.private
        , encodeName model.name
        , encodeDescription model.description
        , encodeVersion model.version
        , encodeHomepage model.homepage
        , encodeLicense model.license
        , encodeMain model.main
        , encodeBrowser model.browser
        , encodeBugs model.bugs
        , encodeAuthor model.author
        , encodeRepository model.repository
        , encodeEngines model.engines
        , encodeCpus model.cpus
        , encodeOperatingSystems model.operatingSystems
        , encodeFiles model.files
        , encodeKeywords model.keywords
        , encodeWorkspaces model.workspaces
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


encodeWorkspaces : List Workspace -> ( String, Json.Encode.Value )
encodeWorkspaces workspaces =
  ( "workspaces", Json.Encode.list encodeWorkspace workspaces )


encodeWorkspace : Workspace -> Json.Encode.Value
encodeWorkspace ( Workspace workspace ) =
  Json.Encode.string workspace


encodeFiles : List File -> ( String, Json.Encode.Value )
encodeFiles files =
  ( "files", Json.Encode.list encodeFile files )


encodeFile : File -> Json.Encode.Value
encodeFile ( File file ) =
  Json.Encode.string file


encodeKeywords : List Keyword -> ( String, Json.Encode.Value )
encodeKeywords keywords =
  ( "keywords", Json.Encode.list encodeKeyword keywords )


encodeKeyword : Keyword -> Json.Encode.Value
encodeKeyword ( Keyword keyword ) =
  Json.Encode.string keyword


encodeOperatingSystems : List OperatingSystem -> ( String, Json.Encode.Value )
encodeOperatingSystems operatingSystems =
  ( "os", Json.Encode.list encodeOperatingSystem operatingSystems )


encodeOperatingSystem : OperatingSystem -> Json.Encode.Value
encodeOperatingSystem ( OperatingSystem operatingSystem ) =
  Json.Encode.string operatingSystem


encodeCpus : List Cpu -> ( String, Json.Encode.Value )
encodeCpus cpus =
  ( "cpu", Json.Encode.list encodeCpu cpus )


encodeCpu : Cpu -> Json.Encode.Value
encodeCpu ( Cpu cpu ) =
  Json.Encode.string cpu


encodeEngines : Engines -> ( String, Json.Encode.Value )
encodeEngines ( Engines engines ) =
  ( "engines"
  , Json.Encode.object
    [ encodeNodeEngine engines.node
    , encodeNpmEngine engines.npm
    ]
  )


encodeNodeEngine : NodeEngine -> ( String, Json.Encode.Value )
encodeNodeEngine ( NodeEngine nodeEngine ) =
  ( "node", Json.Encode.string nodeEngine )


encodeNpmEngine : NpmEngine -> ( String, Json.Encode.Value )
encodeNpmEngine ( NpmEngine npmEngine ) =
  ( "npm", Json.Encode.string npmEngine )


encodeRepository : Repository -> ( String, Json.Encode.Value )
encodeRepository ( Repository repository ) =
  ( "repository"
  , Json.Encode.object
    [ encodeRepositoryKind repository.kind
    , encodeRepositoryUrl repository.url
    ]
  )


encodeRepositoryKind : RepositoryKind -> ( String, Json.Encode.Value )
encodeRepositoryKind ( RepositoryKind repositoryKind ) =
  ( "type", Json.Encode.string repositoryKind )


encodeRepositoryUrl : RepositoryUrl -> ( String, Json.Encode.Value )
encodeRepositoryUrl ( RepositoryUrl repositoryUrl ) =
  ( "url", Json.Encode.string repositoryUrl )


encodeAuthor : Author -> ( String, Json.Encode.Value )
encodeAuthor ( Author author ) =
  ( "author"
  , Json.Encode.object
    [ encodeAuthorName author.name
    , encodeAuthorUrl author.url
    , encodeAuthorEmail author.email
    ]
  )


encodeAuthorName : AuthorName -> ( String, Json.Encode.Value )
encodeAuthorName ( AuthorName name ) =
  ( "name", Json.Encode.string name )


encodeAuthorUrl : AuthorUrl -> ( String, Json.Encode.Value )
encodeAuthorUrl (AuthorUrl url ) =
  ( "url", Json.Encode.string url )


encodeAuthorEmail : AuthorEmail -> ( String, Json.Encode.Value )
encodeAuthorEmail ( AuthorEmail email ) =
  ( "email", Json.Encode.string email )


encodeBugs : Bugs -> ( String, Json.Encode.Value )
encodeBugs ( Bugs bugs ) =
  ( "bugs"
  , Json.Encode.object
    [ encodeBugsUrl bugs.url
    , encodeBugsEmail bugs.email
    ]
  )


encodeBugsUrl : BugsUrl -> ( String, Json.Encode.Value )
encodeBugsUrl ( BugsUrl url ) =
  ( "url", Json.Encode.string url )


encodeBugsEmail : BugsEmail -> ( String, Json.Encode.Value )
encodeBugsEmail ( BugsEmail email ) =
  ( "email", Json.Encode.string email )


encodeOptionalDependencies : List OptionalDependency -> ( String, Json.Encode.Value )
encodeOptionalDependencies optionalDependencies =
  ( "optionalDependencies", Json.Encode.object <| List.map encodeOptionalDependency optionalDependencies )


encodeOptionalDependency : OptionalDependency -> ( String, Json.Encode.Value )
encodeOptionalDependency ( OptionalDependency optionalDependency ) =
  ( encodeOptionalDependencyKey optionalDependency.key, encodeOptionalDependencyValue optionalDependency.value )


encodeOptionalDependencyKey : OptionalDependencyKey -> String
encodeOptionalDependencyKey ( OptionalDependencyKey optionalDependencyKey ) =
  optionalDependencyKey


encodeOptionalDependencyValue : OptionalDependencyValue -> Json.Encode.Value
encodeOptionalDependencyValue ( OptionalDependencyValue optionalDependencyValue ) =
  Json.Encode.string optionalDependencyValue


encodeBundledDependencies : List BundledDependency -> ( String, Json.Encode.Value )
encodeBundledDependencies bundledDependencies =
  ( "bundledDependencies", Json.Encode.object <| List.map encodeBundledDependency bundledDependencies )


encodeBundledDependency : BundledDependency -> ( String, Json.Encode.Value )
encodeBundledDependency ( BundledDependency bundledDependency ) =
  ( encodeBundledDependencyKey bundledDependency.key, encodeBundledDependencyValue bundledDependency.value )


encodeBundledDependencyKey : BundledDependencyKey -> String
encodeBundledDependencyKey ( BundledDependencyKey bundledDependencyKey ) =
  bundledDependencyKey


encodeBundledDependencyValue : BundledDependencyValue -> Json.Encode.Value
encodeBundledDependencyValue ( BundledDependencyValue bundledDependencyValue ) =
  Json.Encode.string bundledDependencyValue


encodePeerDependencies : List PeerDependency -> ( String, Json.Encode.Value )
encodePeerDependencies peerDependencies =
  ( "peerDependencies", Json.Encode.object <| List.map encodePeerDependency peerDependencies )


encodePeerDependency : PeerDependency -> ( String, Json.Encode.Value )
encodePeerDependency ( PeerDependency peerDependency ) =
  ( encodePeerDependencyKey peerDependency.key, encodePeerDependencyValue peerDependency.value )


encodePeerDependencyKey : PeerDependencyKey -> String
encodePeerDependencyKey ( PeerDependencyKey peerDependencyKey ) =
  peerDependencyKey


encodePeerDependencyValue : PeerDependencyValue -> Json.Encode.Value
encodePeerDependencyValue ( PeerDependencyValue peerDependencyValue ) =
  Json.Encode.string peerDependencyValue


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


encodePrivate : Private -> ( String, Json.Encode.Value )
encodePrivate ( Private private ) =
  ( "private", Json.Encode.bool private )


encodeBrowser : Browser -> ( String, Json.Encode.Value )
encodeBrowser ( Browser browser ) =
  ( "browser", Json.Encode.string browser )


encodeMain : Main -> ( String, Json.Encode.Value )
encodeMain ( Main entrypoint ) =
  ( "main", Json.Encode.string entrypoint )


encodeLicense : License -> ( String, Json.Encode.Value )
encodeLicense ( License license ) =
  ( "license", Json.Encode.string license )


encodeHomepage : Homepage -> ( String, Json.Encode.Value )
encodeHomepage ( Homepage homepage ) =
  ( "homepage", Json.Encode.string homepage )


encodeVersion : Version -> ( String, Json.Encode.Value )
encodeVersion ( Version version ) =
  ( "version", Json.Encode.string version )


encodeDescription : Description -> ( String, Json.Encode.Value )
encodeDescription ( Description description ) =
  ( "description", Json.Encode.string description )


encodeName : Name -> ( String, Json.Encode.Value )
encodeName ( Name name ) =
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
      { model | name = ( Name name ) }

    UpdateDescription description ->
      { model | description = ( Description description ) }

    UpdateVersion version ->
      { model | version = ( Version version ) }

    UpdateHomepage homepage ->
      { model | homepage = ( Homepage homepage ) }

    UpdateLicense license ->
      { model | license = ( License license ) }

    UpdateMain entrypoint ->
      { model | main = ( Main entrypoint ) }

    UpdateBrowser browser ->
      { model | browser = ( Browser browser ) }

    UpdatePrivate private ->
      { model | private = ( Private private ) }

    UpdateBugsUrl url ->
      { model | bugs = updateBugsUrl ( BugsUrl url ) model.bugs }

    UpdateBugsEmail email ->
      { model | bugs = updateBugsEmail ( BugsEmail email ) model.bugs }

    UpdateAuthorName name ->
      { model | author = updateAuthorName ( AuthorName name ) model.author }

    UpdateAuthorEmail email ->
      { model | author = updateAuthorEmail ( AuthorEmail email ) model.author }

    UpdateAuthorUrl url ->
      { model | author = updateAuthorUrl ( AuthorUrl url ) model.author }

    UpdateRepositoryKind kind ->
      { model | repository = updateRepositoryKind ( RepositoryKind kind ) model.repository }

    UpdateRepositoryUrl url ->
      { model | repository = updateRepositoryUrl ( RepositoryUrl url ) model.repository }

    UpdateEnginesNode node ->
      { model | engines = updateNodeEngine ( NodeEngine node ) model.engines }

    UpdateEnginesNpm npm ->
      { model | engines = updateNpmEngine ( NpmEngine npm ) model.engines }

    AddCpu ->
      { model | cpus = List.append model.cpus [ Cpu "" ] }

    UpdateCpu index value ->
      { model | cpus = List.Extra.updateAt index ( always ( Cpu value ) ) model.cpus }

    RemoveCpu index ->
      { model | cpus = List.Extra.removeAt index model.cpus }

    AddOperatingSystem ->
      { model | operatingSystems = List.append model.operatingSystems [ OperatingSystem "" ] }

    UpdateOperatingSystem index operatingSystem ->
      { model | operatingSystems = List.Extra.updateAt index ( always ( OperatingSystem operatingSystem ) ) model.operatingSystems }

    RemoveOperatingSystem index ->
      { model | operatingSystems = List.Extra.removeAt index model.operatingSystems }

    AddFile ->
      { model | files = List.append model.files [ File "" ] }

    UpdateFile index value ->
      { model | files = List.Extra.updateAt index ( always ( File value ) ) model.files }

    RemoveFile index ->
      { model | files = List.Extra.removeAt index model.files }

    AddKeyword ->
      { model | keywords = List.append model.keywords [ Keyword "" ] }

    UpdateKeyword index keyword ->
      { model | keywords = List.Extra.updateAt index ( always ( Keyword keyword ) ) model.keywords }

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
      { model | peerDependencies = List.append model.peerDependencies [ PeerDependency { key = PeerDependencyKey "", value = PeerDependencyValue "" } ] }

    UpdatePeerDependencyKey index key ->
      { model | peerDependencies = List.Extra.updateAt index ( updatePeerDependencyKey ( PeerDependencyKey key ) ) model.peerDependencies }

    UpdatePeerDependencyValue index value ->
      { model | peerDependencies = List.Extra.updateAt index ( updatePeerDependencyValue ( PeerDependencyValue value ) ) model.peerDependencies }

    RemovePeerDependency index ->
      { model | peerDependencies = List.Extra.removeAt index model.peerDependencies }

    AddBundledDependency ->
      { model | bundledDependencies = List.append model.bundledDependencies [ BundledDependency { key = BundledDependencyKey "", value = BundledDependencyValue "" } ] }

    RemoveBundledDependency index ->
      { model | bundledDependencies = List.Extra.removeAt index model.bundledDependencies }

    UpdateBundledDependencyKey index key ->
      { model | bundledDependencies = List.Extra.updateAt index ( updateBundledDependencyKey ( BundledDependencyKey key ) ) model.bundledDependencies }

    UpdateBundledDependencyValue index value ->
      { model | bundledDependencies = List.Extra.updateAt index ( updateBundledDependencyValue ( BundledDependencyValue value ) ) model.bundledDependencies }

    AddOptionalDependency ->
      { model | optionalDependencies = List.append model.optionalDependencies [ OptionalDependency { key = OptionalDependencyKey "", value = OptionalDependencyValue "" } ] }

    UpdateOptionalDependencyKey index key ->
      { model | optionalDependencies = List.Extra.updateAt index ( updateOptionalDependencyKey ( OptionalDependencyKey key ) ) model.optionalDependencies }

    UpdateOptionalDependencyValue index value ->
      { model | optionalDependencies = List.Extra.updateAt index ( updateOptionalDependencyValue ( OptionalDependencyValue value ) ) model.optionalDependencies }
  
    RemoveOptionalDependency index ->
      { model | optionalDependencies = List.Extra.removeAt index model.optionalDependencies }

    AddWorkspace ->
      { model | workspaces = List.append model.workspaces [ Workspace "" ] } 

    RemoveWorkspace index ->
      { model | workspaces = List.Extra.removeAt index model.workspaces }

    UpdateWorkspace index workspace ->
      { model | workspaces = List.Extra.updateAt index ( always ( Workspace workspace ) ) model.workspaces }


updateNodeEngine : NodeEngine -> Engines -> Engines
updateNodeEngine ( NodeEngine node ) ( Engines engines ) =
  Engines { engines | node = NodeEngine node }


updateNpmEngine : NpmEngine -> Engines -> Engines
updateNpmEngine ( NpmEngine npm ) ( Engines engines ) =
  Engines { engines | npm = NpmEngine npm }


updateRepositoryKind : RepositoryKind -> Repository -> Repository
updateRepositoryKind ( RepositoryKind kind ) ( Repository repository ) =
  Repository { repository | kind = RepositoryKind kind }


updateRepositoryUrl : RepositoryUrl -> Repository -> Repository
updateRepositoryUrl ( RepositoryUrl url ) ( Repository repository ) =
  Repository { repository | url = RepositoryUrl url }


updateAuthorName : AuthorName -> Author -> Author
updateAuthorName ( AuthorName name ) ( Author author ) =
  Author { author | name = ( AuthorName name ) }


updateAuthorUrl : AuthorUrl -> Author -> Author
updateAuthorUrl ( AuthorUrl url ) ( Author author ) =
  Author { author | url = AuthorUrl url }


updateAuthorEmail : AuthorEmail -> Author -> Author
updateAuthorEmail ( AuthorEmail email ) (Author author ) =
  Author { author | email = AuthorEmail email }


updateBugsEmail : BugsEmail -> Bugs -> Bugs
updateBugsEmail ( BugsEmail email ) ( Bugs bugs ) =
  Bugs { bugs | email = BugsEmail email }


updateBugsUrl : BugsUrl -> Bugs -> Bugs
updateBugsUrl ( BugsUrl url ) ( Bugs bugs ) =
  Bugs { bugs | url = BugsUrl url }


updateOptionalDependencyValue : OptionalDependencyValue -> OptionalDependency -> OptionalDependency
updateOptionalDependencyValue ( OptionalDependencyValue value ) ( OptionalDependency optionalDependency ) =
  OptionalDependency { optionalDependency | value = OptionalDependencyValue value }


updateOptionalDependencyKey : OptionalDependencyKey -> OptionalDependency -> OptionalDependency
updateOptionalDependencyKey ( OptionalDependencyKey key ) ( OptionalDependency optionalDependency ) =
  OptionalDependency { optionalDependency | key = OptionalDependencyKey key }


updateBundledDependencyValue : BundledDependencyValue -> BundledDependency -> BundledDependency
updateBundledDependencyValue ( BundledDependencyValue value ) ( BundledDependency bundledDependency ) =
  BundledDependency { bundledDependency | value = BundledDependencyValue value }


updateBundledDependencyKey : BundledDependencyKey -> BundledDependency -> BundledDependency
updateBundledDependencyKey ( BundledDependencyKey key ) ( BundledDependency bundledDependency ) =
  BundledDependency { bundledDependency | key = BundledDependencyKey key }


updatePeerDependencyKey : PeerDependencyKey -> PeerDependency -> PeerDependency
updatePeerDependencyKey ( PeerDependencyKey key ) ( PeerDependency peerDependency ) =
  PeerDependency { peerDependency | key = PeerDependencyKey key }


updatePeerDependencyValue : PeerDependencyValue -> PeerDependency -> PeerDependency
updatePeerDependencyValue ( PeerDependencyValue value ) ( PeerDependency peerDependency ) =
  PeerDependency { peerDependency | value = PeerDependencyValue value }


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
  { name = Name ""
  , description = Description ""
  , version = Version ""
  , homepage = Homepage ""
  , license = License ""
  , main = Main ""
  , browser = Browser ""
  , private = Private False
  , bugs =
      Bugs
        { url = BugsUrl ""
        , email = BugsEmail ""
        }
  , author =
      Author
        { name = AuthorName ""
        , url = AuthorUrl ""
        , email = AuthorEmail ""
        }
  , repository =
      Repository
        { kind = RepositoryKind ""
        , url = RepositoryUrl ""
        }
  , engines =
      Engines 
        { node = NodeEngine ""
        , npm = NpmEngine ""
        }
  , cpus = []
  , operatingSystems = []
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
  , workspaces = []
  }


-- TYPES ( MODEL )


type alias Model =
  { name : Name
  , description : Description
  , version : Version
  , homepage : Homepage
  , license : License
  , main : Main
  , browser : Browser
  , private : Private
  , bugs : Bugs
  , author : Author
  , repository : Repository
  , engines : Engines
  , cpus : List Cpu
  , operatingSystems : List OperatingSystem
  , files : List File
  , keywords : List Keyword
  , contributors : List Contributor
  , fundings : List Funding
  , scripts : List Script
  , configurations : List Configuration
  , dependencies : List Dependency
  , developmentDependencies : List DevelopmentDependency
  , peerDependencies : List PeerDependency
  , bundledDependencies : List BundledDependency
  , optionalDependencies : List OptionalDependency
  , workspaces : List Workspace
  }


type Keyword = Keyword String


type File = File String


type OperatingSystem = OperatingSystem String


type Cpu = Cpu String


type Private = Private Bool


type Browser = Browser String


type Main = Main String


type License = License String


type Homepage = Homepage String


type Version = Version String


type Description = Description String


type Name = Name String


type Workspace = Workspace String


type Engines =
  Engines
    { node : NodeEngine
    , npm : NpmEngine
    }


type NodeEngine = NodeEngine String


type NpmEngine = NpmEngine String


type Repository =
  Repository
    { kind : RepositoryKind
    , url : RepositoryUrl
    }


type RepositoryKind = RepositoryKind String


type RepositoryUrl = RepositoryUrl String


type Author =
  Author
    { name : AuthorName
    , url : AuthorUrl
    , email : AuthorEmail
    }


type AuthorName = AuthorName String


type AuthorUrl = AuthorUrl String


type AuthorEmail = AuthorEmail String


type Bugs =
  Bugs
    { url : BugsUrl
    , email : BugsEmail
    }


type BugsUrl = BugsUrl String


type BugsEmail = BugsEmail String


type OptionalDependency =
  OptionalDependency
    { key : OptionalDependencyKey
    , value : OptionalDependencyValue
    }


type OptionalDependencyKey = OptionalDependencyKey String


type OptionalDependencyValue = OptionalDependencyValue String


type BundledDependency =
  BundledDependency
    { key : BundledDependencyKey
    , value : BundledDependencyValue
    }


type BundledDependencyKey = BundledDependencyKey String


type BundledDependencyValue = BundledDependencyValue String


type PeerDependency =
  PeerDependency 
    { key : PeerDependencyKey
    , value : PeerDependencyValue
    }


type PeerDependencyKey = PeerDependencyKey String


type PeerDependencyValue = PeerDependencyValue String


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
  | UpdateRepositoryKind String
  | UpdateRepositoryUrl String
  | UpdateEnginesNode String
  | UpdateEnginesNpm String
  | AddCpu
  | RemoveCpu Int
  | UpdateCpu Int String
  | AddOperatingSystem
  | UpdateOperatingSystem Int String
  | RemoveOperatingSystem Int
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
  | AddWorkspace
  | UpdateWorkspace Int String
  | RemoveWorkspace Int
