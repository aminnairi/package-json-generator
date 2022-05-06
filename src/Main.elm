port module Main exposing ( main )


-- IMPORTS


import Browser
import Browser.Dom
import Html exposing ( Html, Attribute )
import Html.Attributes
import Html.Events
import Json.Encode
import List.Extra
import Html.Events.Extra
import Task
import Flip


-- MAIN


main : Program () Model Message
main =
  Browser.element
    { init    = init
    , update  = update
    , view    = view
    , subscriptions = always Sub.none
    }


-- VIEW


view : Model -> Html Message
view model =
  Html.div
    [ Html.Attributes.style "min-height" "100vh"
    , Html.Attributes.style "max-width" "600px"
    , Html.Attributes.style "margin" "0 auto"
    ]
    [ Html.h1
      [ Html.Attributes.style "font-family" "Poppins"
      , Html.Attributes.style "margin" "20px 0 20px 0"
      , Html.Attributes.style "padding" "0"
      , Html.Attributes.style "font-weight" "200"
      , Html.Attributes.style "text-align" "center"
      ]
      [ Html.text "package.json generator" ]
    , viewAccess model.access
    , viewSpaces model.spaces
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
    , viewDirectories model.directories
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


viewSpaces : Spaces -> Html Message
viewSpaces spaces =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Spaces" ]
    , viewSelect
      [ Html.Attributes.value <| viewSpacesValue spaces
      , Html.Events.Extra.onChange UpdateSpaces
      ]
      [ Html.option [ Html.Attributes.value <| viewSpacesValue TwoSpaces ] [ Html.text "2 spaces" ]
      , Html.option [ Html.Attributes.value <| viewSpacesValue FourSpaces ] [ Html.text "4 spaces" ]
      ]
    ]


viewSpacesValue : Spaces -> String
viewSpacesValue spaces =
  case spaces of
    FourSpaces ->
      "four-spaces"

    TwoSpaces ->
      "two-spaces"


viewDirectories : Directories -> Html Message
viewDirectories ( Directories directories ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Directories" ]
    , viewLibraryDirectory directories.library
    , viewBinaryDirectory directories.binary
    , viewManualDirectory directories.manual
    , viewDocumentationDirectory directories.documentation
    , viewExampleDirectory directories.example
    , viewTestDirectory directories.test
    ]


viewLibraryDirectory : LibraryDirectory -> Html Message
viewLibraryDirectory ( LibraryDirectory libraryDirectory ) =
  viewInputField
    [ Html.Attributes.for "directories-library" ]
    [ Html.text "Library" ]
    [ Html.Attributes.value libraryDirectory
    , Html.Attributes.id "directories-library"
    , Html.Events.onInput UpdateLibraryDirectory
    , Html.Attributes.placeholder "./library"
    , Html.Attributes.type_ "text"
    ]
    []


viewBinaryDirectory : BinaryDirectory -> Html Message
viewBinaryDirectory ( BinaryDirectory binaryDirectory ) =
  viewInputField
    [ Html.Attributes.for "directories-binary" ]
    [ Html.text "Binary" ]
    [ Html.Attributes.value binaryDirectory
    , Html.Attributes.id "directories-binary"
    , Html.Events.onInput UpdateBinaryDirectory
    , Html.Attributes.placeholder "./binary"
    , Html.Attributes.type_ "text"
    ]
    []


viewManualDirectory : ManualDirectory -> Html Message
viewManualDirectory ( ManualDirectory manualDirectory ) =
  viewInputField
    [ Html.Attributes.for "directories-manual" ]
    [ Html.text "Manual" ]
    [ Html.Attributes.value manualDirectory
    , Html.Attributes.id "directories-manual"
    , Html.Events.onInput UpdateManualDirectory
    , Html.Attributes.placeholder "./manual"
    , Html.Attributes.type_ "text"
    ]
    []


viewDocumentationDirectory : DocumentationDirectory -> Html Message
viewDocumentationDirectory ( DocumentationDirectory documentationDirectory ) =
  viewInputField
    [ Html.Attributes.for "directories-documentation" ]
    [ Html.text "Documentation" ]
    [ Html.Attributes.value documentationDirectory
    , Html.Attributes.id "directories-documentation"
    , Html.Events.onInput UpdateDocumentationDirectory
    , Html.Attributes.placeholder "./documentation"
    , Html.Attributes.type_ "text"
    ]
    []


viewExampleDirectory : ExampleDirectory -> Html Message
viewExampleDirectory ( ExampleDirectory exampleDirectory ) =
  viewInputField
    [ Html.Attributes.for "directories-example" ]
    [ Html.text "Example" ]
    [ Html.Attributes.value exampleDirectory
    , Html.Attributes.id "directories-example"
    , Html.Events.onInput UpdateExampleDirectory
    , Html.Attributes.placeholder "examples"
    , Html.Attributes.type_ "text"
    ]
    []


viewTestDirectory : TestDirectory -> Html Message
viewTestDirectory ( TestDirectory testDirectory ) =
  viewInputField
    [ Html.Attributes.for "directories-test" ]
    [ Html.text "Test" ]
    [ Html.Attributes.value testDirectory
    , Html.Attributes.id "directories-test"
    , Html.Events.onInput UpdateTestDirectory
    , Html.Attributes.placeholder "./tests"
    , Html.Attributes.type_ "text"
    ]
    []


viewWorkspaces : List Workspace -> Html Message
viewWorkspaces workspaces =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "Workspaces" ]
        , viewCenteredButton [ Html.Events.onClick AddWorkspace ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewWorkspace workspaces


viewWorkspace : Int -> Workspace -> Html Message
viewWorkspace index ( Workspace workspace ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "workspace-" ++ String.fromInt index ]
      [ Html.text "Name" ]
      [ Html.Attributes.value workspace
      , Html.Attributes.id <| "workspace-" ++ String.fromInt index
      , Html.Events.onInput <| UpdateWorkspace index
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "client, server, mobile, ..."
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveWorkspace index ] [ Html.text "Remove" ]
    ]


viewKeywords : List Keyword -> Html Message
viewKeywords keywords =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "Keywords" ]
        , viewCenteredButton [ Html.Events.onClick AddKeyword ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewKeyword keywords


viewKeyword : Int -> Keyword -> Html Message
viewKeyword index ( Keyword keyword ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "keyword-" ++ String.fromInt index ]
      [ Html.text "Keyword" ]
      [ Html.Attributes.id <| "keyword-" ++ String.fromInt index 
      , Html.Attributes.value keyword
      , Html.Events.onInput <| UpdateKeyword index
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "node, browser, javascript, ..."
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveKeyword index ] [ Html.text "Remove" ]
    ]


viewFiles : List File -> Html Message
viewFiles files =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "Files" ]
        , viewCenteredButton [ Html.Events.onClick AddFile ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewFile files


viewFile : Int -> File -> Html Message
viewFile index ( File file ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "file-" ++ String.fromInt index ]
      [ Html.text "Name" ]
      [ Html.Attributes.value file
      , Html.Attributes.id <| "file-" ++ String.fromInt index 
      , Html.Events.onInput <| UpdateFile index
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "./index.js, ./library/index.js, ./helpers/index.js, ..."
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveFile index ] [ Html.text "Remove" ]
    ]


viewOperatingSystems : List OperatingSystem -> Html Message
viewOperatingSystems operatingSystems =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "Operating systems" ]
        , viewCenteredButton [ Html.Events.onClick AddOperatingSystem ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewOperatingSystem operatingSystems


viewOperatingSystem : Int -> OperatingSystem -> Html Message
viewOperatingSystem index ( OperatingSystem operatingSystem ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "operating-system-" ++ String.fromInt index ]
      [ Html.text "Name" ]
      [ Html.Attributes.id <| "operating-system-" ++ String.fromInt index 
      , Html.Attributes.value operatingSystem
      , Html.Events.onInput <| UpdateOperatingSystem index
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "linux, nt, darwin, ..."
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveOperatingSystem index ] [ Html.text "Remove" ]
    ]


viewCpus : List Cpu -> Html Message
viewCpus cpus =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "CPUs" ]
        , viewCenteredButton [ Html.Events.onClick AddCpu ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewCpu cpus


viewCpu : Int -> Cpu -> Html Message
viewCpu index ( Cpu cpu ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "cpu-" ++ String.fromInt index ]
      [ Html.text "Name" ]
      [ Html.Attributes.id <| "cpu-" ++ String.fromInt index
      , Html.Attributes.value cpu
      , Html.Events.onInput <| UpdateCpu index
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "x64, x86_64, arm, ..."
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveCpu index ] [ Html.text "Remove" ]
    ]



viewBrowser : Browser -> Html Message
viewBrowser ( Browser browser ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Browser" ]
    , viewInputField
      [ Html.Attributes.for "browser" ]
      [ Html.text "Browser" ]
      [ Html.Attributes.value browser
      , Html.Attributes.id "browser"
      , Html.Events.onInput UpdateBrowser
      , Html.Attributes.placeholder "./dist/index.browser.js"
      , Html.Attributes.type_ "text"
      ]
      []
    ]


viewMain : Main -> Html Message
viewMain ( Main entrypoint ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Main" ]
    , viewInputField
      [ Html.Attributes.for "main" ]
      [ Html.text "Main" ]
      [ Html.Attributes.value entrypoint
      , Html.Attributes.id "main"
      , Html.Events.onInput UpdateMain
      , Html.Attributes.placeholder "./dist/index.js"
      , Html.Attributes.type_ "text"
      ]
      []
    ]


viewLicense : License -> Html Message
viewLicense ( License license ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "License" ]
    , viewInputField
      [ Html.Attributes.for "license" ]
      [ Html.text "License" ]
      [ Html.Attributes.value license
      , Html.Attributes.id "license"
      , Html.Events.onInput UpdateLicense
      , Html.Attributes.placeholder "GPL-3.0-or-later"
      , Html.Attributes.type_ "text"
      ]
      []
    ]


viewHomepage : Homepage -> Html Message
viewHomepage ( Homepage homepage ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Home page" ]
    , viewInputField
      [ Html.Attributes.for "homepage" ]
      [ Html.text "Home page" ]
      [ Html.Attributes.value homepage
      , Html.Attributes.id "homepage"
      , Html.Events.onInput UpdateHomepage
      , Html.Attributes.placeholder "https://github.com/user/repository#readme"
      , Html.Attributes.type_ "url"
      ]
      []
    ]


viewVersion : Version -> Html Message
viewVersion ( Version version ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Version" ]
    , viewInputField
      [ Html.Attributes.for "version" ]
      [ Html.text "Version" ]
      [ Html.Attributes.value version
      , Html.Attributes.id "version"
      , Html.Events.onInput UpdateVersion
      , Html.Attributes.placeholder "0.1.0"
      , Html.Attributes.type_ "text"
      ]
      []
    ]


viewDescription : Description -> Html Message
viewDescription ( Description description ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Description" ]
    , viewInputField
      [ Html.Attributes.for "description" ]
      [ Html.text "Description" ]
      [ Html.Attributes.value description
      , Html.Attributes.id "description"
      , Html.Events.onInput UpdateDescription
      , Html.Attributes.placeholder "An awesome package that does things"
      , Html.Attributes.type_ "text"
      ]
      []
    ]


viewName : Name -> Html Message
viewName ( Name name ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Name" ]
    , viewInputField
      [ Html.Attributes.for "name" ]
      [ Html.text "Name" ]
      [ Html.Attributes.value name
      , Html.Attributes.id "name"
      , Html.Events.onInput UpdateName
      , Html.Attributes.autofocus True
      , Html.Attributes.placeholder "@user/package"
      , Html.Attributes.type_ "text"
      ]
      []
    ]


viewAccess : Access -> Html Message
viewAccess access =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Access" ]
    , viewSelect
      [ Html.Attributes.value <| viewAccessValue access
      , Html.Events.Extra.onChange UpdateAccess
      ]
      [ Html.option [ Html.Attributes.value <| viewAccessValue Private ] [ Html.text "Private" ]
      , Html.option [ Html.Attributes.value <| viewAccessValue Public ] [ Html.text "Public" ]
      ]
    ]


viewAccessValue : Access -> String
viewAccessValue access =
  case access of
    Private ->
      "private"

    Public ->
      "public"


viewEngines : Engines -> Html Message
viewEngines ( Engines engines ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Engines" ]
    , viewNodeEngine engines.node
    , viewNpmEngine engines.npm
    ]


viewNodeEngine : NodeEngine -> Html Message
viewNodeEngine ( NodeEngine node ) =
  viewInputField
    [ Html.Attributes.for "engines-node" ]
    [ Html.text "Node" ]
    [ Html.Attributes.value node
    , Html.Events.onInput UpdateEnginesNode
    , Html.Attributes.id "engines-node"
    , Html.Attributes.placeholder ">=17.0.0"
    , Html.Attributes.type_ "text"
    ]
    []


viewNpmEngine : NpmEngine -> Html Message
viewNpmEngine ( NpmEngine npm ) =
  viewInputField
    [ Html.Attributes.for "engines-npm" ]
    [ Html.text "NPM" ]
    [ Html.Attributes.value npm
    , Html.Events.onInput UpdateEnginesNpm
    , Html.Attributes.id "engines-npm"
    , Html.Attributes.placeholder ">=8.0.0"
    , Html.Attributes.type_ "text"
    ]
    []


viewRepository : Repository -> Html Message
viewRepository ( Repository repository ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Repository" ]
    , viewRepositoryKind repository.kind
    , viewRepositoryUrl repository.url
    ]


viewRepositoryKind : RepositoryKind -> Html Message
viewRepositoryKind ( RepositoryKind kind ) =
  viewInputField
    [ Html.Attributes.for "repository-type" ]
    [ Html.text "Type" ]
    [ Html.Attributes.value kind
    , Html.Events.onInput UpdateRepositoryKind
    , Html.Attributes.id "repository-type"
    , Html.Attributes.placeholder "git"
    , Html.Attributes.type_ "text"
    ]
    []


viewRepositoryUrl : RepositoryUrl -> Html Message
viewRepositoryUrl ( RepositoryUrl url ) =
  viewInputField
    [ Html.Attributes.for "repository-url" ]
    [ Html.text "URL" ]
    [ Html.Attributes.value url
    , Html.Events.onInput UpdateRepositoryUrl
    , Html.Attributes.id "repository-url"
    , Html.Attributes.placeholder "https://github.com/user/repository.git"
    , Html.Attributes.type_ "url"
    ]
    []


viewAuthor : Author -> Html Message
viewAuthor ( Author author ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Author" ]
    , viewAuthorName author.name
    , viewAuthorUrl author.url
    , viewAuthorEmail author.email
    ]


viewAuthorName : AuthorName -> Html Message
viewAuthorName ( AuthorName name ) =
  viewInputField
    [ Html.Attributes.for "author-name" ]
    [ Html.text "Name" ] 
    [ Html.Attributes.value name
    , Html.Events.onInput UpdateAuthorName
    , Html.Attributes.id "author-name"
    , Html.Attributes.placeholder "User NAME"
    , Html.Attributes.type_ "text"
    ]
    [] 


viewAuthorUrl : AuthorUrl -> Html Message
viewAuthorUrl ( AuthorUrl url ) =
  viewInputField
    [ Html.Attributes.for "author-url" ]
    [ Html.text "URL" ] 
    [ Html.Attributes.value url
    , Html.Events.onInput UpdateAuthorUrl
    , Html.Attributes.id "author-url"
    , Html.Attributes.placeholder "https://github.com/user"
    , Html.Attributes.type_ "url"
    ]
    [] 


viewAuthorEmail : AuthorEmail -> Html Message
viewAuthorEmail ( AuthorEmail email ) =
  viewInputField
    [ Html.Attributes.for "author-email" ]
    [ Html.text "Email" ] 
    [ Html.Attributes.value email
    , Html.Events.onInput UpdateAuthorEmail
    , Html.Attributes.id "author-email"
    , Html.Attributes.placeholder "user@repository.com"
    , Html.Attributes.type_ "email"
    ]
    [] 


viewBugs : Bugs -> Html Message
viewBugs ( Bugs bugs ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Bugs" ]
    , viewBugsUrl bugs.url
    , viewBugsEmail bugs.email
    ]


viewBugsUrl : BugsUrl -> Html Message
viewBugsUrl ( BugsUrl url ) =
  viewInputField
    [ Html.Attributes.for "bugs-url" ]
    [ Html.text "URL" ]
    [ Html.Attributes.value url
    , Html.Events.onInput UpdateBugsUrl
    , Html.Attributes.for "bugs-url"
    , Html.Attributes.placeholder "https://github.com/user/repository/issues"
    , Html.Attributes.type_ "url"
    ]
    []


viewBugsEmail : BugsEmail -> Html Message
viewBugsEmail ( BugsEmail email ) =
  viewInputField
    [ Html.Attributes.for "bugs-email" ]
    [ Html.text "Email" ]
    [ Html.Attributes.value email
    , Html.Events.onInput UpdateBugsEmail
    , Html.Attributes.id "bugs-email"
    , Html.Attributes.placeholder "user@repository.com"
    , Html.Attributes.type_ "email"
    ]
    []


viewOptionalDependencies : List OptionalDependency -> Html Message
viewOptionalDependencies optionalDependencies =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "Optional dependencies" ]
        , viewCenteredButton [ Html.Events.onClick AddOptionalDependency ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewOptionalDependency optionalDependencies


viewOptionalDependency : Int -> OptionalDependency -> Html Message
viewOptionalDependency index ( OptionalDependency optionalDependency ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "optional-dependency-name-" ++ String.fromInt index ]
      [ Html.text "Name" ]
      [ Html.Attributes.value <| viewOptionalDependencyKey optionalDependency.key
      , Html.Events.onInput <| UpdateOptionalDependencyKey index
      , Html.Attributes.id <| "optional-dependency-name-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "react, react-dom, react-router-dom"
      ]
      []
    , viewInputField
      [ Html.Attributes.for <| "optional-dependency-value-" ++ String.fromInt index ]
      [ Html.text "Version" ]
      [ Html.Attributes.value <| viewOptionalDependencyValue optionalDependency.value
      , Html.Events.onInput <| UpdateOptionalDependencyValue index
      , Html.Attributes.id <| "optional-dependency-value-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "18.0.0, 6.1.4, 0.21.9"
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveOptionalDependency index ] [ Html.text "Remove" ]
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
        [ viewSecondLevelTitle [] [ Html.text "Bundled dependencies" ]
        , viewCenteredButton [ Html.Events.onClick AddBundledDependency ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewBundledDependency bundledDependencies


viewBundledDependency : Int -> BundledDependency -> Html Message
viewBundledDependency index ( BundledDependency bundledDependency ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "bundled-dependency-name-" ++ String.fromInt index ]
      [ Html.text "Name" ]
      [ Html.Attributes.value <| viewBundledDependencyKey bundledDependency.key
      , Html.Events.onInput <| UpdateBundledDependencyKey index
      , Html.Attributes.id <| "bundled-dependency-name-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "react, react-dom, react-router-dom"
      ]
      []
    , viewInputField
      [ Html.Attributes.for <| "bundled-dependency-value-" ++ String.fromInt index ]
      [ Html.text "Version" ]
      [ Html.Attributes.value <| viewBundledDependencyValue bundledDependency.value
      , Html.Events.onInput <| UpdateBundledDependencyValue index
      , Html.Attributes.id <| "bundled-dependency-value-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "18.0.0, 6.1.4, 0.21.9"
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveBundledDependency index ] [ Html.text "Remove" ]
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
        [ viewSecondLevelTitle [] [ Html.text "Peer dependencies" ]
        , viewCenteredButton [ Html.Events.onClick AddPeerDependency ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewPeerDependency peerDependencies


viewPeerDependency : Int -> PeerDependency -> Html Message
viewPeerDependency index ( PeerDependency peerDependency ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "peer-dependency-name-" ++ String.fromInt index ]
      [ Html.text "Name" ]
      [ Html.Attributes.value <| viewPeerDependencyKey peerDependency.key
      , Html.Events.onInput <| UpdatePeerDependencyKey index
      , Html.Attributes.id <| "peer-dependency-name-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "react, react-dom, react-router-dom"
      ]
      []
    , viewInputField
      [ Html.Attributes.for <| "peer-dependency-value-" ++ String.fromInt index ]
      [ Html.text "Version" ]
      [ Html.Attributes.value <| viewPeerDependencyValue peerDependency.value
      , Html.Events.onInput <| UpdatePeerDependencyValue index
      , Html.Attributes.id <| "peer-dependency-value-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "18.0.0, 6.1.4, 0.21.9"
      ]
      []
    , viewButton [ Html.Events.onClick <| RemovePeerDependency index ] [ Html.text "Remove" ]
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
        [ viewSecondLevelTitle [] [ Html.text "Development dependencies" ]
        , viewCenteredButton [ Html.Events.onClick AddDevelopmentDependency ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewDevelopmentDependency developmentDependencies


viewDevelopmentDependency : Int -> DevelopmentDependency -> Html Message
viewDevelopmentDependency index ( DevelopmentDependency developmentDependency ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "development-dependency-name-" ++ String.fromInt index ]
      [ Html.text "Name" ]
      [ Html.Events.onInput <| UpdateDevelopmentDependencyKey index 
      , Html.Attributes.value <| viewDevelopmentDependencyKey developmentDependency.key
      , Html.Attributes.id <| "development-dependency-name-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "react, react-dom, react-router-dom"
      ]
      []
    , viewInputField
      [ Html.Attributes.for <| "development-dependency-value-" ++ String.fromInt index ]
      [ Html.text "Version" ]
      [ Html.Events.onInput <| UpdateDevelopmentDependencyValue index
      , Html.Attributes.value <| viewDevelopmentDependencyValue developmentDependency.value
      , Html.Attributes.id <| "development-dependency-value-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "18.0.0, 6.1.4, 0.21.9"
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveDevelopmentDependency index ] [ Html.text "Remove" ]
    ]


viewDevelopmentDependencyKey : DevelopmentDependencyKey -> String
viewDevelopmentDependencyKey ( DevelopmentDependencyKey developmentDependencyKey ) =
  developmentDependencyKey


viewDevelopmentDependencyValue : DevelopmentDependencyValue -> String
viewDevelopmentDependencyValue ( DevelopmentDependencyValue developmentDependencyValue ) =
  developmentDependencyValue


viewDependencies : List Dependency -> Html Message
viewDependencies dependencies =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "Dependencies" ]
        , viewCenteredButton [ Html.Events.onClick AddDependency ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewDependency dependencies


viewDependency : Int -> Dependency -> Html Message
viewDependency index ( Dependency dependency ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "dependency-name-" ++ String.fromInt index ]
      [ Html.text "Name" ]
      [ Html.Events.onInput <| UpdateDependencyKey index
      , Html.Attributes.value <| viewDependencyKey dependency.key
      , Html.Attributes.id <| "dependency-name-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "react, react-dom, react-router-dom"
      ]
      []
    , viewInputField
      [ Html.Attributes.for <| "dependency-value-" ++ String.fromInt index ]
      [ Html.text "Version" ]
      [ Html.Events.onInput <| UpdateDependencyValue index
      , Html.Attributes.value <| viewDependencyValue dependency.value
      , Html.Attributes.id <| "dependency-value-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "18.0.0, 6.1.4, 0.21.9"
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveDependency index ] [ Html.text "Remove" ]
    ]


viewDependencyKey : DependencyKey -> String
viewDependencyKey ( DependencyKey dependencyKey ) =
  dependencyKey


viewDependencyValue : DependencyValue -> String
viewDependencyValue ( DependencyValue dependencyValue ) =
  dependencyValue


viewConfigurations : List Configuration -> Html Message
viewConfigurations configurations =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "Configurations" ]
        , viewCenteredButton [ Html.Events.onClick AddConfiguration ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewConfiguration configurations


viewConfiguration : Int -> Configuration -> Html Message
viewConfiguration index ( Configuration configuration ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "configuration-key-" ++ String.fromInt index ]
      [ Html.text "Key" ]
      [ Html.Events.onInput <| UpdateConfigurationKey index
      , Html.Attributes.value <| viewConfigurationKey configuration.key
      , Html.Attributes.id <| "configuration-key-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "port, host, url, ..."
      ]
      []
    , viewInputField
      [ Html.Attributes.for <| "configuration-value-" ++ String.fromInt index ]
      [ Html.text "Value" ]
      [ Html.Events.onInput <| UpdateConfigurationValue index
      , Html.Attributes.value <| viewConfigurationValue configuration.value
      , Html.Attributes.id <| "configuration-value-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "8000, localhost, https://api.domain.com"
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveConfiguration index ] [ Html.text "Remove" ]
    ]


viewConfigurationKey : ConfigurationKey -> String
viewConfigurationKey ( ConfigurationKey configurationKey ) =
  configurationKey


viewConfigurationValue : ConfigurationValue -> String
viewConfigurationValue ( ConfigurationValue configurationValue ) =
  configurationValue


viewScripts : List Script -> Html Message
viewScripts scripts =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "Scripts" ]
        , viewCenteredButton [ Html.Events.onClick AddScript ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewScript scripts


viewScript : Int -> Script -> Html Message
viewScript index ( Script script ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "script-key-" ++ String.fromInt index ]
      [ Html.text "Key" ]
      [ Html.Events.onInput <| UpdateScriptKey index
      , Html.Attributes.value <| viewScriptKey script.key
      , Html.Attributes.id <| "script-key-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "dev, prod, test, ..."
      ]
      []
    , viewInputField
      [ Html.Attributes.for <| "script-command-" ++ String.fromInt index ]
      [ Html.text "Command" ]
      [ Html.Events.onInput <| UpdateScriptCommand index
      , Html.Attributes.value <| viewScriptCommand script.command
      , Html.Attributes.id <| "script-command-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "vite, vite build, eslint, ..."
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveScript index ] [ Html.text "Remove" ]
    ]


viewScriptKey : ScriptKey -> String
viewScriptKey ( ScriptKey scriptKey ) =
  scriptKey


viewScriptCommand : ScriptCommand -> String
viewScriptCommand ( ScriptCommand scriptCommand ) =
  scriptCommand


viewFundings : List Funding -> Html Message
viewFundings fundings =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "Fundings" ]
        , viewCenteredButton [ Html.Events.onClick AddFunding ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewFunding fundings


viewFunding : Int -> Funding -> Html Message
viewFunding index ( Funding funding ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "funding-type-" ++ String.fromInt index ]
      [ Html.text "Type" ]
      [ Html.Events.onInput <| UpdateFundingKind index
      , Html.Attributes.value <| viewFundingKind funding.kind
      , Html.Attributes.id <| "funding-type-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "individual, patreon, ..."
      ]
      []
    , viewInputField
      [ Html.Attributes.for <| "funding-url-" ++ String.fromInt index ]
      [ Html.text "Url" ]
      [ Html.Events.onInput <| UpdateFundingUrl index
      , Html.Attributes.value <| viewFundingUrl funding.url
      , Html.Attributes.id <| "funding-url-" ++ String.fromInt index 
      , Html.Attributes.type_ "url"
      , Html.Attributes.placeholder "https://patreon.com/user"
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveFunding index ] [ Html.text "Remove" ]
    ]


viewFundingKind : FundingKind -> String
viewFundingKind ( FundingKind fundingKind ) =
  fundingKind


viewFundingUrl : FundingUrl -> String
viewFundingUrl ( FundingUrl fundingUrl ) =
  fundingUrl


viewContributors : List Contributor -> Html Message
viewContributors contributors =
  Html.div []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "Contributors" ]
        , viewCenteredButton [ Html.Events.onClick AddContributor ] [ Html.text "Add" ]
        ]
        <| List.indexedMap viewContributor contributors


viewContributor : Int -> Contributor -> Html Message
viewContributor index ( Contributor contributor ) =
  Html.div
    []
    [ viewInputField
      [ Html.Attributes.for <| "contributor-name-" ++ String.fromInt index ]
      [ Html.text "Name" ]
      [ Html.Events.onInput <| UpdateContributorName index
      , Html.Attributes.value <| viewContributorName contributor.name
      , Html.Attributes.id <| "contributor-name-" ++ String.fromInt index 
      , Html.Attributes.type_ "text"
      , Html.Attributes.placeholder "John DOE"
      ]
      []
    , viewInputField
      [ Html.Attributes.for <| "contributor-email-" ++ String.fromInt index ]
      [ Html.text "Email" ]
      [ Html.Events.onInput <| UpdateContributorEmail index
      , Html.Attributes.value <| viewContributorEmail contributor.email
      , Html.Attributes.id <| "contributor-email-" ++ String.fromInt index 
      , Html.Attributes.type_ "email"
      , Html.Attributes.placeholder "johndoe@domain.com"
      ]
      []
    , viewInputField
      [ Html.Attributes.for <| "contributor-url-" ++ String.fromInt index ]
      [ Html.text "URL" ]
      [ Html.Events.onInput <| UpdateContributorUrl index
      , Html.Attributes.value <| viewContributorUrl contributor.url
      , Html.Attributes.id <| "contributor-url-" ++ String.fromInt index 
      , Html.Attributes.type_ "url"
      , Html.Attributes.placeholder "https://johndoe.com"
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveContributor index ] [ Html.text "Remove" ]
    ]


viewContributorEmail : ContributorEmail -> String
viewContributorEmail ( ContributorEmail contributorEmail ) =
  contributorEmail


viewContributorName : ContributorName -> String
viewContributorName ( ContributorName contributorName ) =
  contributorName


viewContributorUrl : ContributorUrl -> String
viewContributorUrl ( ContributorUrl contributorUrl ) =
  contributorUrl


viewModel : Model -> Html Message
viewModel model =
  Html.pre [] [ Html.code [ Html.Attributes.style "font-size" "1rem" ] [ Html.text <| encodeModel model ] ]


viewInputField : List ( Attribute Message ) -> List ( Html Message ) -> List ( Attribute Message ) -> List ( Html Message ) -> Html Message
viewInputField labelAttributes labelChildren inputAttributes inputChildren =
  Html.div
    [ Html.Attributes.style "position" "relative"
    , Html.Attributes.style "margin" "20px 0"
    , Html.Attributes.style "padding" "0 10px"
    ]
    [ viewInputFieldLabel labelAttributes labelChildren
    , viewInput inputAttributes inputChildren
    ]


viewInputFieldLabel : List ( Attribute Message ) -> List ( Html Message ) -> Html Message
viewInputFieldLabel attributes children =
  Html.label
    ( List.append
      [ Html.Attributes.style "font-family" "Poppins"
      , Html.Attributes.style "font-weight" "400"
      , Html.Attributes.style "font-size" "0.75rem"
      , Html.Attributes.style "position" "absolute"
      , Html.Attributes.style "top" "0"
      , Html.Attributes.style "left" "20px"
      , Html.Attributes.style "padding" "0 5px"
      , Html.Attributes.style "margin" "0"
      , Html.Attributes.style "transform" "translateX(-50%)"
      , Html.Attributes.style "transform" "translatey(-50%)"
      , Html.Attributes.style "background-color" "white"
      ]
      attributes
    )
    children


viewInput : List ( Attribute Message ) -> List ( Html Message ) -> Html Message
viewInput attributes children =
  Html.input
    ( List.append
      [ Html.Attributes.style "padding" "10px"
      , Html.Attributes.style "margin" "0"
      , Html.Attributes.style "box-sizing" "border-box"
      , Html.Attributes.style "border" "1px solid black"
      , Html.Attributes.style "border-radius" "5px"
      , Html.Attributes.style "width" "100%"
      ]
      attributes
    )
    children


viewButton : List ( Attribute Message ) -> List ( Html Message ) -> Html Message
viewButton attributes children =
  Html.button
    ( List.append
      [ Html.Attributes.style "border" "1px solid black"
      , Html.Attributes.style "background-color" "white"
      , Html.Attributes.style "color" "black"
      , Html.Attributes.style "border-radius" "5px"
      , Html.Attributes.style "padding" "5px 10px"
      , Html.Attributes.style "margin" "10px"
      , Html.Attributes.style "cursor" "pointer"
      , Html.Attributes.style "text-transform" "uppercase"
      , Html.Attributes.style "font-weight" "400"
      ]
      attributes
    )
    children


viewCenteredButton : List ( Attribute Message ) -> List ( Html Message ) -> Html Message
viewCenteredButton attributes children =
  viewButton
    ( List.append
      [ Html.Attributes.style "margin-left" "auto"
      , Html.Attributes.style "margin-right" "auto"
      , Html.Attributes.style "display" "block"
      ]
      attributes
    )
    children


viewSecondLevelTitle : List ( Attribute Message ) -> List ( Html Message ) -> Html Message
viewSecondLevelTitle attributes children =
  Html.h2
    ( List.append
      [ Html.Attributes.style "text-align" "center"
      , Html.Attributes.style "font-weight" "200"
      , Html.Attributes.style "font-family" "Poppins"
      , Html.Attributes.style "margin" "0"
      , Html.Attributes.style "padding" "0"
      , Html.Attributes.style "font-weight" "200"
      ]
      attributes
    )
    children


viewSelect : List ( Attribute Message ) -> List ( Html Message ) -> Html Message
viewSelect attributes children =
  Html.select
    ( List.append
      [ Html.Attributes.style "display" "block"
      , Html.Attributes.style "margin" "10px auto"
      , Html.Attributes.style "border" "1px solid black"
      , Html.Attributes.style "background-color" "white"
      , Html.Attributes.style "padding" "5px 10px"
      ]
      attributes
    )
    children


-- VIEW HELPERS


encodeModel : Model -> String
encodeModel model =
  Json.Encode.encode ( encodeSpaces model.spaces )
    <| Json.Encode.object 
        [ encodeAccess model.access
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
        , encodeDirectories model.directories
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


encodeSpaces : Spaces -> Int
encodeSpaces spaces =
  case spaces of
    TwoSpaces ->
      2

    FourSpaces ->
      4


encodeDirectories : Directories -> ( String, Json.Encode.Value )
encodeDirectories ( Directories directories ) =
  ( "directories"
  , Json.Encode.object
    [ encodeLibraryDirectory directories.library
    , encodeBinaryDirectory directories.binary
    , encodeManualDirectory directories.manual
    , encodeDocumentationDirectory directories.documentation
    , encodeExampleDirectory directories.example
    , encodeTestDirectory directories.test
    ]
  )


encodeLibraryDirectory : LibraryDirectory -> ( String, Json.Encode.Value )
encodeLibraryDirectory ( LibraryDirectory libraryDirectory ) =
  ( "lib", Json.Encode.string <| String.trim libraryDirectory )


encodeBinaryDirectory : BinaryDirectory -> ( String, Json.Encode.Value )
encodeBinaryDirectory ( BinaryDirectory binaryDirectory ) =
  ( "bin", Json.Encode.string <| String.trim binaryDirectory )


encodeManualDirectory : ManualDirectory -> ( String, Json.Encode.Value )
encodeManualDirectory ( ManualDirectory manualDirectory ) =
  ( "man", Json.Encode.string <| String.trim manualDirectory )


encodeDocumentationDirectory : DocumentationDirectory -> ( String, Json.Encode.Value )
encodeDocumentationDirectory ( DocumentationDirectory documentationDirectory ) =
  ( "doc", Json.Encode.string <| String.trim documentationDirectory )


encodeExampleDirectory : ExampleDirectory -> ( String, Json.Encode.Value )
encodeExampleDirectory ( ExampleDirectory exampleDirectory ) =
  ( "example", Json.Encode.string <| String.trim exampleDirectory )


encodeTestDirectory : TestDirectory -> ( String, Json.Encode.Value )
encodeTestDirectory ( TestDirectory testDirectory ) =
  ( "test", Json.Encode.string <| String.trim testDirectory )


encodeWorkspaces : List Workspace -> ( String, Json.Encode.Value )
encodeWorkspaces workspaces =
  ( "workspaces", Json.Encode.list encodeWorkspace workspaces )


encodeWorkspace : Workspace -> Json.Encode.Value
encodeWorkspace ( Workspace workspace ) =
  Json.Encode.string <| String.trim workspace


encodeFiles : List File -> ( String, Json.Encode.Value )
encodeFiles files =
  ( "files", Json.Encode.list encodeFile files )


encodeFile : File -> Json.Encode.Value
encodeFile ( File file ) =
  Json.Encode.string <| String.trim file


encodeKeywords : List Keyword -> ( String, Json.Encode.Value )
encodeKeywords keywords =
  ( "keywords", Json.Encode.list encodeKeyword keywords )


encodeKeyword : Keyword -> Json.Encode.Value
encodeKeyword ( Keyword keyword ) =
  Json.Encode.string <| String.trim keyword


encodeOperatingSystems : List OperatingSystem -> ( String, Json.Encode.Value )
encodeOperatingSystems operatingSystems =
  ( "os", Json.Encode.list encodeOperatingSystem operatingSystems )


encodeOperatingSystem : OperatingSystem -> Json.Encode.Value
encodeOperatingSystem ( OperatingSystem operatingSystem ) =
  Json.Encode.string <| String.trim operatingSystem


encodeCpus : List Cpu -> ( String, Json.Encode.Value )
encodeCpus cpus =
  ( "cpu", Json.Encode.list encodeCpu cpus )


encodeCpu : Cpu -> Json.Encode.Value
encodeCpu ( Cpu cpu ) =
  Json.Encode.string <| String.trim cpu


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
  ( "node", Json.Encode.string <| String.trim nodeEngine )


encodeNpmEngine : NpmEngine -> ( String, Json.Encode.Value )
encodeNpmEngine ( NpmEngine npmEngine ) =
  ( "npm", Json.Encode.string <| String.trim npmEngine )


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
  ( "type", Json.Encode.string <| String.trim repositoryKind )


encodeRepositoryUrl : RepositoryUrl -> ( String, Json.Encode.Value )
encodeRepositoryUrl ( RepositoryUrl repositoryUrl ) =
  ( "url", Json.Encode.string <| String.trim repositoryUrl )


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
  ( "name", Json.Encode.string <| String.trim name )


encodeAuthorUrl : AuthorUrl -> ( String, Json.Encode.Value )
encodeAuthorUrl (AuthorUrl url ) =
  ( "url", Json.Encode.string <| String.trim url )


encodeAuthorEmail : AuthorEmail -> ( String, Json.Encode.Value )
encodeAuthorEmail ( AuthorEmail email ) =
  ( "email", Json.Encode.string <| String.trim email )


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
  ( "url", Json.Encode.string <| String.trim url )


encodeBugsEmail : BugsEmail -> ( String, Json.Encode.Value )
encodeBugsEmail ( BugsEmail email ) =
  ( "email", Json.Encode.string <| String.trim email )


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
  Json.Encode.string <| String.trim optionalDependencyValue


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
  Json.Encode.string <| String.trim bundledDependencyValue


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
  Json.Encode.string <| String.trim peerDependencyValue


encodeDependencies : List Dependency -> ( String, Json.Encode.Value )
encodeDependencies dependencies =
  ( "dependencies", Json.Encode.object <| List.map encodeDependency dependencies )


encodeDependency : Dependency -> ( String, Json.Encode.Value )
encodeDependency ( Dependency dependency ) =
  ( encodeDependencyKey dependency.key, encodeDependencyValue dependency.value )


encodeDependencyKey : DependencyKey -> String
encodeDependencyKey ( DependencyKey dependencyKey ) =
  dependencyKey


encodeDependencyValue : DependencyValue -> Json.Encode.Value
encodeDependencyValue ( DependencyValue dependencyValue ) =
  Json.Encode.string <| String.trim dependencyValue


encodeDevelopmentDependencies : List DevelopmentDependency -> ( String, Json.Encode.Value )
encodeDevelopmentDependencies developmentDependencies =
  ( "devDependencies", Json.Encode.object <| List.map encodeDevelopmentDependency developmentDependencies )


encodeDevelopmentDependency : DevelopmentDependency -> ( String, Json.Encode.Value )
encodeDevelopmentDependency ( DevelopmentDependency developmentDependency ) =
  ( encodeDevelopmentDependencyKey developmentDependency.key, encodeDevelopmentDependencyValue developmentDependency.value )


encodeDevelopmentDependencyKey : DevelopmentDependencyKey -> String
encodeDevelopmentDependencyKey ( DevelopmentDependencyKey developmentDependencyKey ) =
  developmentDependencyKey


encodeDevelopmentDependencyValue : DevelopmentDependencyValue -> Json.Encode.Value
encodeDevelopmentDependencyValue ( DevelopmentDependencyValue developmentDependencyValue ) =
  Json.Encode.string <| String.trim developmentDependencyValue


encodeAccess : Access -> ( String, Json.Encode.Value )
encodeAccess access =
  case access of
    Private ->
      ( "private", Json.Encode.bool True )

    Public ->
      ( "private", Json.Encode.bool False )


encodeBrowser : Browser -> ( String, Json.Encode.Value )
encodeBrowser ( Browser browser ) =
  ( "browser", Json.Encode.string <| String.trim browser )


encodeMain : Main -> ( String, Json.Encode.Value )
encodeMain ( Main entrypoint ) =
  ( "main", Json.Encode.string <| String.trim entrypoint )


encodeLicense : License -> ( String, Json.Encode.Value )
encodeLicense ( License license ) =
  ( "license", Json.Encode.string <| String.trim license )


encodeHomepage : Homepage -> ( String, Json.Encode.Value )
encodeHomepage ( Homepage homepage ) =
  ( "homepage", Json.Encode.string <| String.trim homepage )


encodeVersion : Version -> ( String, Json.Encode.Value )
encodeVersion ( Version version ) =
  ( "version", Json.Encode.string <| String.trim version )


encodeDescription : Description -> ( String, Json.Encode.Value )
encodeDescription ( Description description ) =
  ( "description", Json.Encode.string <| String.trim description )


encodeName : Name -> ( String, Json.Encode.Value )
encodeName ( Name name ) =
  ( "name", Json.Encode.string <| String.trim name )


encodeConfigurations : List Configuration -> ( String, Json.Encode.Value )
encodeConfigurations configurations =
  ( "config", Json.Encode.object <| List.map encodeConfiguration configurations )


encodeConfiguration : Configuration -> ( String, Json.Encode.Value )
encodeConfiguration ( Configuration configuration ) =
  ( encodeConfigurationKey configuration.key, encodeConfigurationValue configuration.value )


encodeConfigurationKey : ConfigurationKey -> String
encodeConfigurationKey ( ConfigurationKey configurationKey ) = 
  configurationKey


encodeConfigurationValue : ConfigurationValue -> Json.Encode.Value
encodeConfigurationValue ( ConfigurationValue configurationValue ) =
  Json.Encode.string <| String.trim configurationValue


encodeScripts : List Script -> ( String, Json.Encode.Value )
encodeScripts scripts =
  ( "scripts", Json.Encode.object <| List.map encodeScript scripts )


encodeScript : Script -> ( String, Json.Encode.Value )
encodeScript ( Script script ) =
  ( encodeScriptKey script.key, encodeScriptCommand script.command )


encodeScriptKey : ScriptKey -> String
encodeScriptKey ( ScriptKey scriptKey ) =
  scriptKey


encodeScriptCommand : ScriptCommand -> Json.Encode.Value
encodeScriptCommand ( ScriptCommand scriptCommand ) =
  Json.Encode.string <| String.trim scriptCommand


encodeFundings : List Funding -> ( String, Json.Encode.Value )
encodeFundings fundings =
  ( "fundings", Json.Encode.list encodeFunding fundings )


encodeFunding : Funding -> Json.Encode.Value
encodeFunding ( Funding funding ) =
  Json.Encode.object
    [ encodeFundingKind funding.kind
    , encodeFundingUrl funding.url
    ]


encodeFundingKind : FundingKind -> ( String, Json.Encode.Value )
encodeFundingKind ( FundingKind fundingKind ) =
  ( "type", Json.Encode.string <| String.trim fundingKind )


encodeFundingUrl : FundingUrl -> ( String, Json.Encode.Value )
encodeFundingUrl ( FundingUrl fundingUrl ) =
  ( "url", Json.Encode.string <| String.trim fundingUrl )


encodeContributors : List Contributor -> ( String, Json.Encode.Value )
encodeContributors contributors =
  ( "contributors", Json.Encode.list encodeContributor contributors )


encodeContributor : Contributor -> Json.Encode.Value
encodeContributor ( Contributor contributor ) =
  Json.Encode.object
    [ encodeContributorName contributor.name
    , encodeContributorEmail contributor.email
    , encodeContributorUrl contributor.url
    ]


encodeContributorName : ContributorName -> ( String, Json.Encode.Value )
encodeContributorName ( ContributorName contributorName ) =
  ( "name", Json.Encode.string <| String.trim contributorName )


encodeContributorEmail : ContributorEmail -> ( String, Json.Encode.Value )
encodeContributorEmail ( ContributorEmail contributorEmail ) =
  ( "email", Json.Encode.string <| String.trim contributorEmail )


encodeContributorUrl : ContributorUrl -> ( String, Json.Encode.Value )
encodeContributorUrl ( ContributorUrl contributorUrl ) =
  ( "url", Json.Encode.string <| String.trim contributorUrl )


-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
  case message of
    None ->
      ( model, Cmd.none )

    UpdateName name ->
      ( { model | name = ( Name name ) }
      , Cmd.none
      )

    UpdateDescription description ->
      ( { model | description = ( Description description ) }
      , Cmd.none
      )

    UpdateVersion version ->
      ( { model | version = ( Version version ) }
      , Cmd.none
      )

    UpdateHomepage homepage ->
      ( { model | homepage = ( Homepage homepage ) }
      , Cmd.none
      )

    UpdateLicense license ->
      ( { model | license = ( License license ) }
      , Cmd.none
      )

    UpdateMain entrypoint ->
      ( { model | main = ( Main entrypoint ) }
      , Cmd.none
      )

    UpdateBrowser browser ->
      ( { model | browser = ( Browser browser ) }
      , Cmd.none
      )

    UpdateAccess access ->
      ( { model | access = updateAccess access }
      , Cmd.none
      )

    UpdateBugsUrl url ->
      ( { model | bugs = updateBugsUrl ( BugsUrl url ) model.bugs }
      , Cmd.none
      )

    UpdateBugsEmail email ->
      ( { model | bugs = updateBugsEmail ( BugsEmail email ) model.bugs }
      , Cmd.none
      )

    UpdateAuthorName name ->
      ( { model | author = updateAuthorName ( AuthorName name ) model.author }
      , Cmd.none
      )

    UpdateAuthorEmail email ->
      ( { model | author = updateAuthorEmail ( AuthorEmail email ) model.author }
      , Cmd.none
      )

    UpdateAuthorUrl url ->
      ( { model | author = updateAuthorUrl ( AuthorUrl url ) model.author }
      , Cmd.none
      )

    UpdateRepositoryKind kind ->
      ( { model | repository = updateRepositoryKind ( RepositoryKind kind ) model.repository }
      , Cmd.none
      )

    UpdateRepositoryUrl url ->
      ( { model | repository = updateRepositoryUrl ( RepositoryUrl url ) model.repository }
      , Cmd.none
      )

    UpdateEnginesNode node ->
      ( { model | engines = updateNodeEngine ( NodeEngine node ) model.engines }
      , Cmd.none
      )

    UpdateEnginesNpm npm ->
      ( { model | engines = updateNpmEngine ( NpmEngine npm ) model.engines }
      , Cmd.none
      )

    AddCpu ->
      ( { model | cpus = List.append model.cpus [ Cpu "" ] }
      , Cmd.batch
        [ focusAfterAdd model.cpus "cpu-"
        , vibrate ()
        ]
      )

    UpdateCpu index value ->
      ( { model | cpus = List.Extra.updateAt index ( always ( Cpu value ) ) model.cpus }
      , Cmd.none
      )

    RemoveCpu index ->
      ( { model | cpus = List.Extra.removeAt index model.cpus }
      , Cmd.batch
        [ focusBeforeRemove model.cpus "cpu-"
        , vibrate ()
        ]
      )

    AddOperatingSystem ->
      ( { model | operatingSystems = List.append model.operatingSystems [ OperatingSystem "" ] }
      , Cmd.batch
        [ focusAfterAdd model.operatingSystems "operating-system-"
        , vibrate ()
        ]
      )

    UpdateOperatingSystem index operatingSystem ->
      ( { model | operatingSystems = List.Extra.updateAt index ( always ( OperatingSystem operatingSystem ) ) model.operatingSystems }
      , Cmd.none
      )

    RemoveOperatingSystem index ->
      ( { model | operatingSystems = List.Extra.removeAt index model.operatingSystems }
      , Cmd.batch
        [ focusBeforeRemove model.operatingSystems "operating-system-"
        , vibrate ()
        ]
      )

    AddFile ->
      ( { model | files = List.append model.files [ File "" ] }
      , Cmd.batch
        [ focusAfterAdd model.files "file-"
        , vibrate ()
        ]
      )

    UpdateFile index value ->
      ( { model | files = List.Extra.updateAt index ( always ( File value ) ) model.files }
      , Cmd.none
      )

    RemoveFile index ->
      ( { model | files = List.Extra.removeAt index model.files }
      , Cmd.batch 
        [ focusBeforeRemove model.files "cpu-"
        , vibrate ()
        ]
      )

    AddKeyword ->
      ( { model | keywords = List.append model.keywords [ Keyword "" ] }
      , Cmd.batch
        [ focusAfterAdd model.keywords "keyword-"
        , vibrate ()
        ]
      )

    UpdateKeyword index keyword ->
      ( { model | keywords = List.Extra.updateAt index ( always ( Keyword keyword ) ) model.keywords }
      , Cmd.none
      )

    RemoveKeyword index ->
      ( { model | keywords = List.Extra.removeAt index model.keywords }
      , Cmd.batch
        [ focusBeforeRemove model.keywords "keyword-"
        , vibrate ()
        ]
      )

    AddContributor ->
      ( { model | contributors = List.append model.contributors [ Contributor { name = ContributorName "", email = ContributorEmail "", url = ContributorUrl "" } ] }
      , Cmd.batch
        [ focusAfterAdd model.contributors "contributor-name-"
        , vibrate ()
        ]
      )

    RemoveContributor index ->
      ( { model | contributors = List.Extra.removeAt index model.contributors }
      , Cmd.batch
        [ focusBeforeRemove model.contributors "contributor-name-"
        , vibrate ()
        ]
      )

    UpdateContributorName index name ->
      ( { model | contributors = List.Extra.updateAt index ( updateContributorName ( ContributorName name ) ) model.contributors }
      , Cmd.none
      )

    UpdateContributorEmail index email ->
      ( { model | contributors = List.Extra.updateAt index ( updateContributorEmail ( ContributorEmail email ) ) model.contributors }
      , Cmd.none
      )

    UpdateContributorUrl index url ->
      ( { model | contributors = List.Extra.updateAt index ( updateContributorUrl ( ContributorUrl url ) ) model.contributors }
      , Cmd.none
      )

    AddFunding ->
      ( { model | fundings = List.append model.fundings [ Funding { kind = FundingKind "", url = FundingUrl "" } ] }
      , Cmd.batch
        [ focusAfterAdd model.fundings "funding-type-"
        , vibrate ()
        ]
      )

    UpdateFundingKind index kind ->
      ( { model | fundings = List.Extra.updateAt index ( updateFundingKind ( FundingKind kind ) ) model.fundings }
      , Cmd.none
      )

    UpdateFundingUrl index url ->
      ( { model | fundings = List.Extra.updateAt index ( updateFundingUrl ( FundingUrl url ) ) model.fundings }
      , Cmd.none
      )

    RemoveFunding index ->
      ( { model | fundings = List.Extra.removeAt index model.fundings }
      , Cmd.batch
        [ focusBeforeRemove model.fundings "funding-type-"
        , vibrate ()
        ]
      )

    AddScript ->
      ( { model | scripts = List.append model.scripts [ Script { key = ScriptKey "", command = ScriptCommand "" } ] }
      , Cmd.batch 
        [ focusAfterAdd model.scripts "script-key-"
        , vibrate ()
        ]
      )

    RemoveScript index ->
      ( { model | scripts = List.Extra.removeAt index model.scripts }
      , Cmd.batch
        [ focusBeforeRemove model.scripts "script-key-"
        , vibrate ()
        ]
      )

    UpdateScriptKey index key ->
      ( { model | scripts = List.Extra.updateAt index ( updateScriptKey ( ScriptKey key ) ) model.scripts }
      , Cmd.none
      )

    UpdateScriptCommand index command ->
      ( { model | scripts = List.Extra.updateAt index ( updateScriptCommand ( ScriptCommand command ) ) model.scripts }
      , Cmd.none
      )

    AddConfiguration ->
      ( { model | configurations = List.append model.configurations [ Configuration { key = ConfigurationKey "", value = ConfigurationValue "" } ] }
      , Cmd.batch
        [ focusAfterAdd model.configurations "configuration-key-"
        , vibrate ()
        ]
      )

    RemoveConfiguration index ->
      ( { model | configurations = List.Extra.removeAt index model.configurations }
      , Cmd.batch
        [ focusBeforeRemove model.configurations "configuration-key-"
        , vibrate ()
        ]
      )

    UpdateConfigurationKey index key ->
      ( { model | configurations = List.Extra.updateAt index ( updateConfigurationKey ( ConfigurationKey key ) ) model.configurations }
      , Cmd.none
      )

    UpdateConfigurationValue index value ->
      ( { model | configurations = List.Extra.updateAt index ( updateConfigurationValue ( ConfigurationValue value ) ) model.configurations }
      , Cmd.none
      )

    AddDependency ->
      ( { model | dependencies = List.append model.dependencies [ Dependency { key = DependencyKey "", value = DependencyValue "" } ] }
      , Cmd.batch
        [ focusAfterAdd model.dependencies "dependency-name-"
        , vibrate ()
        ]
      )

    RemoveDependency index ->
      ( { model | dependencies = List.Extra.removeAt index model.dependencies }
      , Cmd.batch
        [ focusBeforeRemove model.dependencies "dependency-name-"
        , vibrate ()
        ]
      )

    UpdateDependencyKey index key ->
      ( { model | dependencies = List.Extra.updateAt index ( updateDependencyKey ( DependencyKey key ) ) model.dependencies }
      , Cmd.none
      )
    
    UpdateDependencyValue index value ->
      ( { model | dependencies = List.Extra.updateAt index ( updateDependencyValue ( DependencyValue value ) ) model.dependencies }
      , Cmd.none
      )

    AddDevelopmentDependency ->
      ( { model | developmentDependencies = List.append model.developmentDependencies [ DevelopmentDependency { key = DevelopmentDependencyKey "", value = DevelopmentDependencyValue "" } ] }
      , Cmd.batch
        [ focusAfterAdd model.developmentDependencies "development-dependency-name-"
        , vibrate ()
        ]
      )

    UpdateDevelopmentDependencyValue index value ->
      ( { model | developmentDependencies = List.Extra.updateAt index ( updateDevelopmentDependencyValue ( DevelopmentDependencyValue value ) ) model.developmentDependencies }
      , Cmd.none
      )

    UpdateDevelopmentDependencyKey index key ->
      ( { model | developmentDependencies = List.Extra.updateAt index ( updateDevelopmentDependencyKey ( DevelopmentDependencyKey key ) ) model.developmentDependencies }
      , Cmd.none
      )

    RemoveDevelopmentDependency index ->
      ( { model | developmentDependencies = List.Extra.removeAt index model.developmentDependencies }
      , Cmd.batch
        [ focusBeforeRemove model.developmentDependencies "development-dependency-name-"
        , vibrate ()
        ]
      )

    AddPeerDependency ->
      ( { model | peerDependencies = List.append model.peerDependencies [ PeerDependency { key = PeerDependencyKey "", value = PeerDependencyValue "" } ] }
      , Cmd.batch
        [ focusAfterAdd model.peerDependencies "peer-dependency-name-"
        , vibrate ()
        ]
      )

    UpdatePeerDependencyKey index key ->
      ( { model | peerDependencies = List.Extra.updateAt index ( updatePeerDependencyKey ( PeerDependencyKey key ) ) model.peerDependencies }
      , Cmd.none
      )

    UpdatePeerDependencyValue index value ->
      ( { model | peerDependencies = List.Extra.updateAt index ( updatePeerDependencyValue ( PeerDependencyValue value ) ) model.peerDependencies }
      , Cmd.none
      )

    RemovePeerDependency index ->
      ( { model | peerDependencies = List.Extra.removeAt index model.peerDependencies }
      , Cmd.batch 
        [ focusBeforeRemove model.peerDependencies "peer-dependency-name-"
        , vibrate ()
        ]
      )

    AddBundledDependency ->
      ( { model | bundledDependencies = List.append model.bundledDependencies [ BundledDependency { key = BundledDependencyKey "", value = BundledDependencyValue "" } ] }
      , Cmd.batch
        [ focusAfterAdd model.bundledDependencies "bundled-dependency-name-"
        , vibrate ()
        ]
      )

    RemoveBundledDependency index ->
      ( { model | bundledDependencies = List.Extra.removeAt index model.bundledDependencies }
      , Cmd.batch
        [ focusBeforeRemove model.bundledDependencies "bundled-dependency-name-"
        , vibrate ()
        ]
      )

    UpdateBundledDependencyKey index key ->
      ( { model | bundledDependencies = List.Extra.updateAt index ( updateBundledDependencyKey ( BundledDependencyKey key ) ) model.bundledDependencies }
      , Cmd.none
      )

    UpdateBundledDependencyValue index value ->
      ( { model | bundledDependencies = List.Extra.updateAt index ( updateBundledDependencyValue ( BundledDependencyValue value ) ) model.bundledDependencies }
      , Cmd.none
      )

    AddOptionalDependency ->
      ( { model | optionalDependencies = List.append model.optionalDependencies [ OptionalDependency { key = OptionalDependencyKey "", value = OptionalDependencyValue "" } ] }
      , Cmd.batch
        [ focusAfterAdd model.optionalDependencies "optional-dependency-name-"
        , vibrate ()
        ]
      )

    UpdateOptionalDependencyKey index key ->
      ( { model | optionalDependencies = List.Extra.updateAt index ( updateOptionalDependencyKey ( OptionalDependencyKey key ) ) model.optionalDependencies }
      , Cmd.none
      )

    UpdateOptionalDependencyValue index value ->
      ( { model | optionalDependencies = List.Extra.updateAt index ( updateOptionalDependencyValue ( OptionalDependencyValue value ) ) model.optionalDependencies }
      , Cmd.none
      )
  
    RemoveOptionalDependency index ->
      ( { model | optionalDependencies = List.Extra.removeAt index model.optionalDependencies }
      , Cmd.batch
        [ focusBeforeRemove model.optionalDependencies "optional-dependency-name-"
        , vibrate ()
        ]
      )

    AddWorkspace ->
      ( { model | workspaces = List.append model.workspaces [ Workspace "" ] } 
      , Cmd.batch
        [ focusAfterAdd model.workspaces "workspace-"
        , vibrate ()
        ]
      )

    RemoveWorkspace index ->
      ( { model | workspaces = List.Extra.removeAt index model.workspaces }
      , Cmd.batch
        [ focusBeforeRemove model.workspaces "workspace-"
        , vibrate ()
        ]
      )

    UpdateWorkspace index workspace ->
      ( { model | workspaces = List.Extra.updateAt index ( always ( Workspace workspace ) ) model.workspaces }
      , Cmd.none
      )

    UpdateLibraryDirectory libraryDirectory ->
      ( { model | directories = updateLibraryDirectory ( LibraryDirectory libraryDirectory ) model.directories }
      , Cmd.none
      )

    UpdateBinaryDirectory binaryDirectory ->
      ( { model | directories = updateBinaryDirectory ( BinaryDirectory binaryDirectory ) model.directories }
      , Cmd.none
      )

    UpdateManualDirectory manualDirectory ->
      ( { model | directories = updateManualDirectory ( ManualDirectory manualDirectory ) model.directories }
      , Cmd.none
      )

    UpdateDocumentationDirectory documentationDirectory ->
      ( { model | directories = updateDocumentationDirectory ( DocumentationDirectory documentationDirectory ) model.directories }
      , Cmd.none
      )

    UpdateExampleDirectory exampleDirectory ->
      ( { model | directories = updateExampleDirectory ( ExampleDirectory exampleDirectory ) model.directories }
      , Cmd.none
      )

    UpdateTestDirectory testDirectory ->
      ( { model | directories = updateTestDirectory ( TestDirectory testDirectory ) model.directories }
      , Cmd.none
      )

    UpdateSpaces spaces ->
      ( { model | spaces = updateSpaces spaces }
      , Cmd.none
      )


updateAccess : String -> Access
updateAccess access =
  case access of
    "public" ->
      Public

    _ ->
      Private


updateSpaces : String -> Spaces
updateSpaces spaces =
  case spaces of
    "four-spaces" ->
      FourSpaces

    _ ->
      TwoSpaces


updateTestDirectory : TestDirectory -> Directories -> Directories
updateTestDirectory ( TestDirectory test ) ( Directories directories ) =
  Directories { directories | test = TestDirectory test }


updateExampleDirectory : ExampleDirectory -> Directories -> Directories
updateExampleDirectory ( ExampleDirectory example ) ( Directories directories ) =
  Directories { directories | example = ExampleDirectory example }


updateDocumentationDirectory : DocumentationDirectory -> Directories -> Directories
updateDocumentationDirectory ( DocumentationDirectory documentation ) ( Directories directories ) =
  Directories { directories | documentation = DocumentationDirectory documentation }


updateManualDirectory : ManualDirectory -> Directories -> Directories
updateManualDirectory ( ManualDirectory manual ) ( Directories directories ) =
  Directories { directories | manual = ManualDirectory manual }


updateBinaryDirectory : BinaryDirectory -> Directories -> Directories
updateBinaryDirectory ( BinaryDirectory binary ) ( Directories directories ) =
  Directories { directories | binary = BinaryDirectory binary }


updateLibraryDirectory : LibraryDirectory -> Directories -> Directories
updateLibraryDirectory ( LibraryDirectory library ) ( Directories directories ) =
  Directories { directories | library = LibraryDirectory library }


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


updateDevelopmentDependencyKey : DevelopmentDependencyKey -> DevelopmentDependency -> DevelopmentDependency
updateDevelopmentDependencyKey ( DevelopmentDependencyKey key ) ( DevelopmentDependency developmentDependency ) =
  DevelopmentDependency { developmentDependency | key = DevelopmentDependencyKey key }


updateDevelopmentDependencyValue : DevelopmentDependencyValue -> DevelopmentDependency -> DevelopmentDependency
updateDevelopmentDependencyValue ( DevelopmentDependencyValue value ) ( DevelopmentDependency developmentDependency ) =
  DevelopmentDependency { developmentDependency | value = DevelopmentDependencyValue value }


updateDependencyValue : DependencyValue -> Dependency -> Dependency
updateDependencyValue ( DependencyValue value ) ( Dependency dependency ) =
  Dependency { dependency | value = DependencyValue value }


updateDependencyKey : DependencyKey -> Dependency -> Dependency
updateDependencyKey ( DependencyKey key ) ( Dependency dependency ) =
  Dependency { dependency | key = DependencyKey key }


updateConfigurationValue : ConfigurationValue -> Configuration -> Configuration
updateConfigurationValue ( ConfigurationValue value ) ( Configuration configuration ) =
  Configuration { configuration | value = ConfigurationValue value }


updateConfigurationKey : ConfigurationKey -> Configuration -> Configuration
updateConfigurationKey ( ConfigurationKey key ) ( Configuration configuration ) =
  Configuration { configuration | key = ConfigurationKey key }


updateScriptCommand : ScriptCommand -> Script -> Script
updateScriptCommand ( ScriptCommand command ) ( Script script ) =
  Script { script | command = ScriptCommand command }


updateScriptKey : ScriptKey -> Script -> Script
updateScriptKey ( ScriptKey key ) ( Script script ) =
  Script { script | key = ScriptKey key }


updateFundingUrl : FundingUrl -> Funding -> Funding
updateFundingUrl ( FundingUrl url ) ( Funding funding ) =
  Funding { funding | url = FundingUrl url }


updateFundingKind : FundingKind -> Funding -> Funding
updateFundingKind ( FundingKind kind ) ( Funding funding ) =
  Funding { funding | kind = FundingKind kind }


updateContributorUrl : ContributorUrl -> Contributor -> Contributor
updateContributorUrl ( ContributorUrl url ) ( Contributor contributor ) =
  Contributor { contributor | url = ContributorUrl url }


updateContributorEmail : ContributorEmail -> Contributor -> Contributor
updateContributorEmail ( ContributorEmail email ) ( Contributor contributor ) =
  Contributor { contributor | email = ContributorEmail email }


updateContributorName : ContributorName -> Contributor -> Contributor
updateContributorName ( ContributorName name ) ( Contributor contributor ) =
  Contributor { contributor | name = ContributorName name }


-- COMMANDS


focusAfterAdd : List a -> String -> Cmd Message
focusAfterAdd list identifier =
  Task.attempt
    ( always None )
    ( list
      |> List.length
      |> String.fromInt
      |> (++) identifier
      |> Browser.Dom.focus
    )


focusBeforeRemove : List a -> String -> Cmd Message
focusBeforeRemove list identifier =
  Task.attempt
    ( always None )
    ( list
      |> List.length
      |> Flip.flip (-) 2
      |> String.fromInt
      |> (++) identifier
      |> Browser.Dom.focus
    )


-- INIT


init : () -> ( Model, Cmd Message )
init flags =
  ( { name = Name ""
    , description = Description ""
    , version = Version ""
    , homepage = Homepage ""
    , license = License ""
    , main = Main ""
    , browser = Browser ""
    , access = Private
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
    , directories =
        Directories
          { library = LibraryDirectory ""
          , binary = BinaryDirectory ""
          , manual = ManualDirectory ""
          , documentation = DocumentationDirectory ""
          , example = ExampleDirectory ""
          , test = TestDirectory ""
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
    , spaces = TwoSpaces
    }
  , Cmd.none
  )


-- PORTS


port vibrate : () -> Cmd message


-- TYPES ( MODEL )


type alias Model =
  { name : Name
  , description : Description
  , version : Version
  , homepage : Homepage
  , license : License
  , main : Main
  , browser : Browser
  , access : Access
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
  , directories : Directories
  , spaces : Spaces
  }


type Spaces
  = TwoSpaces
  | FourSpaces


type Directories =
  Directories
    { library : LibraryDirectory
    , binary : BinaryDirectory
    , manual : ManualDirectory
    , documentation : DocumentationDirectory
    , example : ExampleDirectory
    , test : TestDirectory
    }


type LibraryDirectory = LibraryDirectory String


type BinaryDirectory = BinaryDirectory String


type ManualDirectory = ManualDirectory String


type DocumentationDirectory = DocumentationDirectory String


type ExampleDirectory = ExampleDirectory String


type TestDirectory = TestDirectory String


type Keyword = Keyword String


type File = File String


type OperatingSystem = OperatingSystem String


type Cpu = Cpu String


type Access
  = Private
  | Public


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


type DevelopmentDependency =
  DevelopmentDependency
    { key : DevelopmentDependencyKey
    , value : DevelopmentDependencyValue
    }


type DevelopmentDependencyValue = DevelopmentDependencyValue String


type DevelopmentDependencyKey = DevelopmentDependencyKey String


type Dependency =
  Dependency
    { key : DependencyKey
    , value : DependencyValue
    }


type DependencyKey = DependencyKey String


type DependencyValue = DependencyValue String


type Configuration =
  Configuration
    { key : ConfigurationKey
    , value : ConfigurationValue
    }


type ConfigurationKey = ConfigurationKey String


type ConfigurationValue = ConfigurationValue String


type Script =
  Script
    { key : ScriptKey
    , command : ScriptCommand
    }


type ScriptKey = ScriptKey String


type ScriptCommand = ScriptCommand String


type Funding =
  Funding 
    { kind : FundingKind
    , url : FundingUrl
    }


type FundingKind = FundingKind String


type FundingUrl = FundingUrl String


type Contributor =
  Contributor
    { name : ContributorName
    , email : ContributorEmail
    , url : ContributorUrl
    }


type ContributorName = ContributorName String


type ContributorEmail = ContributorEmail String


type ContributorUrl = ContributorUrl String


-- TYPES ( MESSAGE )


type Message
  = None
  | UpdateName String
  | UpdateDescription String
  | UpdateVersion String
  | UpdateHomepage String
  | UpdateLicense String
  | UpdateMain String
  | UpdateBrowser String
  | UpdateAccess String
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
  | UpdateLibraryDirectory String
  | UpdateBinaryDirectory String
  | UpdateManualDirectory String
  | UpdateDocumentationDirectory String
  | UpdateExampleDirectory String
  | UpdateTestDirectory String
  | UpdateSpaces String
