port module Main exposing ( main )


-- IMPORTS


import Browser
import Browser.Events
import Browser.Dom
import Html exposing ( Html, Attribute )
import Html.Attributes
import Html.Events
import Json.Encode
import Json.Decode
import List.Extra
import Html.Events.Extra
import Task
import Flip
import Triple
import SyntaxHighlight


-- MAIN


main : Program Int Model Message
main =
  Browser.element
    { init    = init
    , update  = update
    , view    = view
    , subscriptions = subscriptions
    }


-- VIEW


view : Model -> Html Message
view model =
  Html.div
    [ Html.Attributes.style "max-height" "100vh"
    , Html.Attributes.style "display" "flex"
    , Html.Attributes.style "flex-direction" ( if model.windowWidth < tabletWidthBreakpoint then "column" else "row" )
    , Html.Attributes.style "max-width" "1200px"
    , Html.Attributes.style "margin" "0 auto"
    ]
    [ Html.div
      [ Html.Attributes.style "flex" "1"
      , Html.Attributes.style "max-height" ( if model.windowWidth < tabletWidthBreakpoint then "unset" else "100vh" )
      , Html.Attributes.style "overflow-y" ( if model.windowWidth < tabletWidthBreakpoint then "unset" else "scroll" )
      ]
      [ Html.h1
        [ Html.Attributes.style "font-family" "Poppins"
        , Html.Attributes.style "margin" "20px 0 20px 0"
        , Html.Attributes.style "padding" "0"
        , Html.Attributes.style "font-weight" "200"
        , Html.Attributes.style "text-align" "center"
        ]
        [ Html.text "package.json generator" ]
      , viewCenteredButton [ Html.Events.onClick Reset ] [ Html.text "reset" ]
      , viewSpaces model.spaces
      , viewAccess model.access
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
      , viewActions model
      ]
    , Html.div
      [ Html.Attributes.style "flex" "1"
      , Html.Attributes.style "max-height" ( if model.windowWidth < tabletWidthBreakpoint then "unset" else "100vh" )
      , Html.Attributes.style "overflow-y" ( if model.windowWidth < tabletWidthBreakpoint then "unset" else "scroll" )
      ]
      [ viewHighlightedModel model ]
    ]


viewNotification : String -> Html Message
viewNotification notification =
  Html.small
    [ Html.Attributes.style "display" "block"
    , Html.Attributes.style "text-align" "center"
    , Html.Attributes.style "font-family" "Poppins"
    , Html.Attributes.style "font-weight" "300"
    ]
    [ Html.text notification ]


viewActions : Model -> Html Message
viewActions model =
  Html.div
    [ Html.Attributes.style "display" "flex"
    , Html.Attributes.style "flex-direction" "column"
    , Html.Attributes.style "justify-content" "center"
    , Html.Attributes.style "align-items" "center"
    ]
    [ viewSecondLevelTitle [] [ Html.text "Actions" ]
    , viewNotification model.notification
    , Html.div
      [ Html.Attributes.style "display" "flex"
      , Html.Attributes.style "flex-direction" "row"
      , Html.Attributes.style "justify-content" "center"
      , Html.Attributes.style "align-items" "center"
      ]
      [ viewButton [ Html.Events.onClick CopyToClipboard ] [ Html.text "Copy" ]
      , viewButton [ Html.Events.onClick SaveToDisk ] [ Html.text "Save as" ]
      ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#directories" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetDirectories ] [ Html.text "Reset" ]
      ]
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddWorkspace ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetWorkspaces ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#workspaces" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddWorkspace ), ( "Backspace", RemoveWorkspace index ), ( "Delete", ResetWorkspaces ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddKeyword ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetKeywords ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#keywords" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddKeyword ), ( "Backspace", RemoveKeyword index ), ( "Delete", ResetKeywords ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddFile ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetFiles ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#files" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddFile ), ( "Backspace", RemoveFile index ), ( "Delete", ResetFiles ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddOperatingSystem ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetOperatingSystems ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#os" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddOperatingSystem ), ( "Backspace", RemoveOperatingSystem index ), ( "Delete", ResetOperatingSystems ) ] )
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveOperatingSystem index ] [ Html.text "Remove" ]
    ]


viewRow : List ( Attribute Message ) -> List ( Html Message ) -> Html Message
viewRow attributes children =
  Html.div
    ( List.append
      [ Html.Attributes.style "display" "flex"
      , Html.Attributes.style "flex-direction" "row"
      , Html.Attributes.style "justify-content" "center"
      , Html.Attributes.style "align-items" "center"
      ]
      attributes
    )
    children

viewCpus : List Cpu -> Html Message
viewCpus cpus =
  Html.div
    []
    <| List.append
        [ viewSecondLevelTitle [] [ Html.text "CPUs" ]
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddCpu ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetCpus ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#cpu" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter",  AddCpu ), ( "Backspace", ( RemoveCpu index ) ), ( "Delete", ResetCpus ) ] )
      ]
      []
    , viewButton [ Html.Events.onClick <| RemoveCpu index ] [ Html.text "Remove" ]
    ]



viewBrowser : Browser -> Html Message
viewBrowser ( Browser browser ) =
  Html.div
    []
    [ viewSecondLevelTitle [] [ Html.text "Browser" ]
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#browser" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetBrowser ] [ Html.text "Reset" ]
      ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#main" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetMain ] [ Html.text "Reset" ]
      ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#license" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetLicense ] [ Html.text "Reset" ]
      ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#homepage" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetHomepage ] [ Html.text "Reset" ]
      ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#version" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetVersion ] [ Html.text "Reset" ]
      ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#description" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetDescription ] [ Html.text "Reset" ]
      ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#name" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetName ] [ Html.text "Reset" ]
      ]
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
    , viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/using-npm/config#access" ]
        [ viewCenteredButton [] [ Html.text "help" ] ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#engines" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetEngines ] [ Html.text "Reset" ]
      ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#repository" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetRepository ] [ Html.text "Reset" ]
      ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#people-fields-author-contributors" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetAuthor ] [ Html.text "Reset" ]
      ]
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
    , viewRow
      []
      [ viewLink
        [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#bugs" ]
        [ viewButton [] [ Html.text "help" ] ]
      , viewButton [ Html.Events.onClick ResetBugs ] [ Html.text "Reset" ]
      ]
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
    , Html.Attributes.id "bugs-url"
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddOptionalDependency ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetOptionalDependencies ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#optionaldependencies" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddOptionalDependency ), ( "Backspace", RemoveOptionalDependency index ), ( "Delete", ResetOptionalDependencies ) ] )
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddOptionalDependency ), ( "Backspace", RemoveOptionalDependency index ), ( "Delete", ResetOptionalDependencies ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddBundledDependency ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetBundledDependencies ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#bundleddependencies" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddBundledDependency ), ( "Backspace", RemoveBundledDependency index ), ( "Delete", ResetBundledDependencies ) ] )
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddBundledDependency ), ( "Backspace", RemoveBundledDependency index ), ( "Delete", ResetBundledDependencies ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddPeerDependency ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetPeerDependencies ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#peerdependencies" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddPeerDependency ), ( "Backspace", RemovePeerDependency index ), ( "Delete", ResetPeerDependencies ) ] )
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddPeerDependency ), ( "Backspace", RemovePeerDependency index ), ( "Delete", ResetPeerDependencies ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddDevelopmentDependency ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetDevelopmentDependencies ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#devdependencies" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddDevelopmentDependency ), ( "Backspace", RemoveDevelopmentDependency index ), ( "Delete", ResetDevelopmentDependencies ) ] )
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddDevelopmentDependency ), ( "Backspace", RemoveDevelopmentDependency index ), ( "Delete", ResetDevelopmentDependencies ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddDependency ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetDependencies ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#dependencies" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddDependency ), ( "Backspace", RemoveDependency index ), ( "Delete", ResetDependencies ) ] )
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddDependency ), ( "Backspace", RemoveDependency index ), ( "Delete", ResetDependencies ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddConfiguration ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetConfigurations ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#config" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddConfiguration ), ( "Backspace", RemoveConfiguration index ), ( "Delete", ResetConfigurations ) ] )
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddConfiguration ), ( "Backspace", RemoveConfiguration index ), ( "Delete", ResetConfigurations ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddScript ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetScripts ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#scripts" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddScript ), ( "Backspace", RemoveScript index ), ( "Delete", ResetScripts ) ] )
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddScript ), ( "Backspace", RemoveScript index ), ( "Delete", ResetScripts ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddFunding ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetFundings ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#funding" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddFunding ), ( "Backspace", RemoveFunding index ), ( "Delete", ResetFundings ) ] )
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddFunding ), ( "Backspace", RemoveFunding index ), ( "Delete", ResetFundings ) ] )
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
        , viewRow
          []
          [ viewButton [ Html.Events.onClick AddContributor ] [ Html.text "Add" ]
          , viewButton [ Html.Events.onClick ResetContributors ] [ Html.text "Reset" ]
          , viewLink
            [ Html.Attributes.href "https://docs.npmjs.com/cli/v8/configuring-npm/package-json#people-fields-author-contributors" ]
            [ viewButton [] [ Html.text "help" ] ]
          ]
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddContributor ), ( "Backspace", RemoveContributor index ), ( "Delete", ResetContributors ) ] )
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddContributor ), ( "Backspace", RemoveContributor index ), ( "Delete", ResetContributors ) ] )
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
      , Html.Events.on "keydown" ( onControlAltKey [ ( "Enter", AddContributor ), ( "Backspace", RemoveContributor index ), ( "Delete", ResetContributors ) ] )
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


viewHighlightedModel : Model -> Html Message
viewHighlightedModel model =
  Html.div []
    [ SyntaxHighlight.useTheme SyntaxHighlight.gitHub
    , encodeModel model
        |> SyntaxHighlight.json
        |> Result.map ( SyntaxHighlight.toBlockHtml ( Just 1 ) )
        |> Result.withDefault ( viewModel model )
    ]


viewModel : Model -> Html Message
viewModel model =
  Html.pre
    [ Html.Attributes.style "overflow-x" "scroll" ]
    [ Html.code
      [ Html.Attributes.style "font-size" "1rem" ]
      [ Html.text <| encodeModel model ]
    ]


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


viewLink : List ( Attribute Message ) -> List ( Html Message ) -> Html Message
viewLink attributes children =
  Html.a
    ( List.append
      [ Html.Attributes.style "text-decoration" "none"
      , Html.Attributes.style "color" "inherit"
      , Html.Attributes.target "blank"
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
      , Html.Attributes.style "margin" "5px"
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


tabletWidthBreakpoint : Int
tabletWidthBreakpoint =
  900


onControlAltKey : List ( String , Message ) -> Json.Decode.Decoder Message
onControlAltKey keyMessages =
  Json.Decode.map3 Triple.triple
    ( Json.Decode.field "ctrlKey" Json.Decode.bool )
    ( Json.Decode.field "altKey" Json.Decode.bool )
    ( Json.Decode.field "key" Json.Decode.string )
    |> Json.Decode.andThen
      ( \( control, alt, keyCode ) ->
        if not control && not alt then
          Json.Decode.fail "Nor control, alt are pressed"

        else
          keyMessages
            |> List.filter ( Tuple.first >> (==) keyCode )
            |> List.head
            |> Maybe.map ( Tuple.second >> Json.Decode.succeed )
            |> Maybe.withDefault ( Json.Decode.fail "No matching key" )
      )


-- JSON


encodeModel : Model -> String
encodeModel model =
  Json.Encode.encode ( encodeSpaces model.spaces )
    <| Json.Encode.object 
      <| List.filterMap identity
        [ maybeEncodeAccess model.access
        , maybeEncodeName model.name
        , maybeEncodeDescription model.description
        , maybeEncodeVersion model.version
        , maybeEncodeHomepage model.homepage
        , maybeEncodeLicense model.license
        , maybeEncodeMain model.main
        , maybeEncodeBrowser model.browser
        , maybeEncodeBugs model.bugs
        , maybeEncodeAuthor model.author
        , maybeEncodeRepository model.repository
        , maybeEncodeEngines model.engines
        , maybeEncodeDirectories model.directories
        , maybeEncodeCpus model.cpus
        , maybeEncodeOperatingSystems model.operatingSystems
        , maybeEncodeFiles model.files
        , maybeEncodeKeywords model.keywords
        , maybeEncodeWorkspaces model.workspaces
        , maybeEncodeContributors model.contributors
        , maybeEncodeFundings model.fundings
        , maybeEncodeScripts model.scripts
        , maybeEncodeConfigurations model.configurations
        , maybeEncodeDependencies model.dependencies
        , maybeEncodeDevelopmentDependencies model.developmentDependencies
        , maybeEncodePeerDependencies model.peerDependencies
        , maybeEncodeBundledDependencies model.bundledDependencies
        , maybeEncodeOptionalDependencies model.optionalDependencies
        ]


encodeSpaces : Spaces -> Int
encodeSpaces spaces =
  case spaces of
    TwoSpaces ->
      2

    FourSpaces ->
      4


maybeEncodeDirectories : Directories -> Maybe ( String, Json.Encode.Value )
maybeEncodeDirectories ( Directories directories ) =
  let
    trimmedDirectories : List ( String, Json.Encode.Value )
    trimmedDirectories =
      List.filterMap identity
        [ maybeEncodeLibraryDirectory directories.library
        , maybeEncodeBinaryDirectory directories.binary
        , maybeEncodeManualDirectory directories.manual
        , maybeEncodeDocumentationDirectory directories.documentation
        , maybeEncodeExampleDirectory directories.example
        , maybeEncodeTestDirectory directories.test
        ]

  in
    case trimmedDirectories of
      [] ->
        Nothing

      _ ->
        Just ( "directories" , Json.Encode.object trimmedDirectories)


maybeEncodeLibraryDirectory : LibraryDirectory -> Maybe ( String, Json.Encode.Value )
maybeEncodeLibraryDirectory ( LibraryDirectory libraryDirectory ) =
  let
    trimmedLibraryDirectory : String
    trimmedLibraryDirectory =
      String.trim libraryDirectory

  in
    case trimmedLibraryDirectory of
      "" ->
        Nothing

      _ ->
        Just ( "lib", Json.Encode.string trimmedLibraryDirectory )


maybeEncodeBinaryDirectory : BinaryDirectory -> Maybe ( String, Json.Encode.Value )
maybeEncodeBinaryDirectory ( BinaryDirectory binaryDirectory ) =
  let
    trimmedBinaryDirectory : String
    trimmedBinaryDirectory =
      String.trim binaryDirectory

  in
    case trimmedBinaryDirectory of
      "" ->
        Nothing

      _ ->
        Just ( "bin", Json.Encode.string trimmedBinaryDirectory )


maybeEncodeManualDirectory : ManualDirectory -> Maybe ( String, Json.Encode.Value )
maybeEncodeManualDirectory ( ManualDirectory manualDirectory ) =
  let
    trimmedManualDirectory : String
    trimmedManualDirectory =
      String.trim manualDirectory

  in
    case trimmedManualDirectory of
      "" ->
        Nothing

      _ ->
        Just ( "man", Json.Encode.string trimmedManualDirectory )


maybeEncodeDocumentationDirectory : DocumentationDirectory -> Maybe ( String, Json.Encode.Value )
maybeEncodeDocumentationDirectory ( DocumentationDirectory documentationDirectory ) =
  let
    trimmedDocumentationDirectory : String
    trimmedDocumentationDirectory =
      String.trim documentationDirectory

  in
    case trimmedDocumentationDirectory of
      "" ->
        Nothing

      _ ->
        Just ( "doc", Json.Encode.string trimmedDocumentationDirectory )


maybeEncodeExampleDirectory : ExampleDirectory -> Maybe ( String, Json.Encode.Value )
maybeEncodeExampleDirectory ( ExampleDirectory exampleDirectory ) =
  let
    trimmedExampleDirectory : String
    trimmedExampleDirectory =
      String.trim exampleDirectory

  in
    case trimmedExampleDirectory of
      "" ->
        Nothing

      _ ->
        Just ( "example", Json.Encode.string trimmedExampleDirectory )


maybeEncodeTestDirectory : TestDirectory -> Maybe ( String, Json.Encode.Value )
maybeEncodeTestDirectory ( TestDirectory testDirectory ) =
  let
    trimmedTestDirectory : String
    trimmedTestDirectory =
      String.trim testDirectory

  in
    case trimmedTestDirectory of
      "" ->
        Nothing

      _ ->
        Just ( "test", Json.Encode.string trimmedTestDirectory )


maybeEncodeWorkspaces : List Workspace -> Maybe ( String, Json.Encode.Value )
maybeEncodeWorkspaces workspaces =
  let
    trimmedWorkspaces : List String
    trimmedWorkspaces =
      workspaces
        |> List.map ( getWorkspaceValue >> String.trim )
        |> List.filter ( String.isEmpty >> not )

  in
    case trimmedWorkspaces of
      [] ->
        Nothing

      _ ->
        Just ( "workspaces", Json.Encode.list Json.Encode.string trimmedWorkspaces )


getWorkspaceValue : Workspace -> String
getWorkspaceValue ( Workspace workspace ) =
  workspace


maybeEncodeFiles : List File -> Maybe ( String, Json.Encode.Value )
maybeEncodeFiles files =
  let
    trimmedFiles : List String
    trimmedFiles =
      files
        |> List.map ( getFileValue >> String.trim )
        |> List.filter ( String.isEmpty >> not )

  in
    case trimmedFiles of
      [] ->
        Nothing

      _ ->
        Just ( "files", Json.Encode.list Json.Encode.string trimmedFiles )


getFileValue : File -> String
getFileValue ( File file ) =
  file


maybeEncodeKeywords : List Keyword -> Maybe ( String, Json.Encode.Value )
maybeEncodeKeywords keywords =
  let
    trimmedKeywords : List String
    trimmedKeywords =
      keywords
        |> List.map ( getKeywordValue >> String.trim )
        |> List.filter ( String.isEmpty >> not )

  in
    case trimmedKeywords of
      [] ->
        Nothing

      _ ->
        Just ( "keywords", Json.Encode.list Json.Encode.string trimmedKeywords )


getKeywordValue : Keyword -> String
getKeywordValue ( Keyword keyword ) =
  keyword


maybeEncodeOperatingSystems : List OperatingSystem -> Maybe ( String, Json.Encode.Value )
maybeEncodeOperatingSystems operatingSystems =
  let
    trimmedOperatingSystems : List String
    trimmedOperatingSystems =
      operatingSystems
        |> List.map ( getOperatingSystemValue >> String.trim )
        |> List.filter ( String.isEmpty >> not )

  in
    case trimmedOperatingSystems of
      [] ->
        Nothing

      _ ->
        Just ( "os", Json.Encode.list Json.Encode.string trimmedOperatingSystems )


getOperatingSystemValue : OperatingSystem -> String
getOperatingSystemValue ( OperatingSystem operatingSystem ) =
  operatingSystem


maybeEncodeCpus : List Cpu -> Maybe ( String, Json.Encode.Value )
maybeEncodeCpus cpus =
  let
    trimmedCpus : List String
    trimmedCpus =
      cpus
        |> List.map ( getCpuValue >> String.trim )
        |> List.filter ( String.isEmpty >> not )

  in
    case trimmedCpus of
      [] ->
        Nothing

      _ ->
        Just ( "cpu", Json.Encode.list Json.Encode.string trimmedCpus )


getCpuValue : Cpu -> String
getCpuValue ( Cpu cpu ) =
  cpu
        


maybeEncodeEngines : Engines -> Maybe ( String, Json.Encode.Value )
maybeEncodeEngines ( Engines engines ) =
  let
    trimmedEngines : List ( String, Json.Encode.Value )
    trimmedEngines =
      List.filterMap identity
        [ maybeEncodeNodeEngine engines.node
        , maybeEncodeNpmEngine engines.npm
        ]

  in
    case trimmedEngines of
      [] ->
        Nothing

      _ ->
        Just ( "engines" , Json.Encode.object trimmedEngines)


maybeEncodeNodeEngine : NodeEngine -> Maybe ( String, Json.Encode.Value )
maybeEncodeNodeEngine ( NodeEngine nodeEngine ) =
  let
    trimmedNodeEngine : String
    trimmedNodeEngine =
      String.trim nodeEngine

  in
    case trimmedNodeEngine of
      "" ->
        Nothing

      _ ->
        Just ( "node", Json.Encode.string trimmedNodeEngine )


maybeEncodeNpmEngine : NpmEngine -> Maybe ( String, Json.Encode.Value )
maybeEncodeNpmEngine ( NpmEngine npmEngine ) =
  let
    trimmedNpmEngine : String
    trimmedNpmEngine =
      String.trim npmEngine

  in
    case trimmedNpmEngine of
      "" ->
        Nothing

      _ ->
        Just ( "npm", Json.Encode.string trimmedNpmEngine )


maybeEncodeRepository : Repository -> Maybe ( String, Json.Encode.Value )
maybeEncodeRepository ( Repository repository ) =
  let
    trimmedRepository : List ( String, Json.Encode.Value )
    trimmedRepository =
      List.filterMap identity
        [ maybeEncodeRepositoryKind repository.kind
        , maybeEncodeRepositoryUrl repository.url
        ]

  in
    case trimmedRepository of
      [] ->
        Nothing

      _ ->
        Just ( "repository" , Json.Encode.object trimmedRepository)


maybeEncodeRepositoryKind : RepositoryKind -> Maybe ( String, Json.Encode.Value )
maybeEncodeRepositoryKind ( RepositoryKind repositoryKind ) =
  let
    trimmedRepositoryKind : String
    trimmedRepositoryKind =
      String.trim repositoryKind

  in
    case trimmedRepositoryKind of
      "" ->
        Nothing

      _ ->
        Just ( "type", Json.Encode.string trimmedRepositoryKind )


maybeEncodeRepositoryUrl : RepositoryUrl -> Maybe ( String, Json.Encode.Value )
maybeEncodeRepositoryUrl ( RepositoryUrl repositoryUrl ) =
  let
    trimmedRepositoryUrl : String
    trimmedRepositoryUrl =
      String.trim repositoryUrl

  in
    case trimmedRepositoryUrl of
      "" ->
        Nothing


      _ ->
        Just ( "url", Json.Encode.string trimmedRepositoryUrl )


maybeEncodeAuthor : Author -> Maybe ( String, Json.Encode.Value )
maybeEncodeAuthor ( Author author ) =
  let
    trimmedAuthor : List ( String, Json.Encode.Value )
    trimmedAuthor =
      List.filterMap identity
        [ maybeEncodeAuthorName author.name
        , maybeEncodeAuthorUrl author.url
        , maybeEncodeAuthorEmail author.email
        ]

  in
    case trimmedAuthor of
      [] ->
        Nothing

      _ ->
        Just ( "author" , Json.Encode.object trimmedAuthor)


maybeEncodeAuthorName : AuthorName -> Maybe ( String, Json.Encode.Value )
maybeEncodeAuthorName ( AuthorName name ) =
  let
    trimmedName : String
    trimmedName =
      String.trim name

  in
    case trimmedName of
      "" ->
        Nothing

      _ ->
        Just ( "name", Json.Encode.string trimmedName )


maybeEncodeAuthorUrl : AuthorUrl -> Maybe ( String, Json.Encode.Value )
maybeEncodeAuthorUrl (AuthorUrl url ) =
  let
    trimmedUrl : String
    trimmedUrl =
      String.trim url

  in
    case trimmedUrl of
      "" ->
        Nothing

      _ ->
        Just ( "url", Json.Encode.string trimmedUrl )


maybeEncodeAuthorEmail : AuthorEmail -> Maybe ( String, Json.Encode.Value )
maybeEncodeAuthorEmail ( AuthorEmail email ) =
  let
    trimmedEmail : String
    trimmedEmail =
      String.trim email

  in
    case trimmedEmail of
      "" ->
        Nothing

      _ ->
        Just ( "email", Json.Encode.string trimmedEmail )


maybeEncodeBugs : Bugs -> Maybe ( String, Json.Encode.Value )
maybeEncodeBugs ( Bugs bugs ) =
  let
    trimmedBugs : List ( String, Json.Encode.Value )
    trimmedBugs =
      List.filterMap identity
        [ maybeEncodeBugsUrl bugs.url
        , maybeEncodeBugsEmail bugs.email
        ]

  in
    case trimmedBugs of
      [] ->
        Nothing

      _ ->
        Just ( "bugs" , Json.Encode.object trimmedBugs )


maybeEncodeBugsUrl : BugsUrl -> Maybe ( String, Json.Encode.Value )
maybeEncodeBugsUrl ( BugsUrl url ) =
  let
    trimmedUrl : String
    trimmedUrl =
      String.trim url

  in
    case trimmedUrl of
      "" ->
        Nothing

      _ ->
        Just ( "url", Json.Encode.string trimmedUrl )


maybeEncodeBugsEmail : BugsEmail -> Maybe ( String, Json.Encode.Value )
maybeEncodeBugsEmail ( BugsEmail email ) =
  let
    trimmedEmail : String
    trimmedEmail =
      String.trim email

  in
    case trimmedEmail of
      "" ->
        Nothing

      _ ->
        Just ( "email", Json.Encode.string trimmedEmail )


maybeEncodeOptionalDependencies : List OptionalDependency -> Maybe ( String, Json.Encode.Value )
maybeEncodeOptionalDependencies optionalDependencies =
  Just ( "optionalDependencies", Json.Encode.object <| List.map encodeOptionalDependency optionalDependencies )


encodeOptionalDependency : OptionalDependency -> ( String, Json.Encode.Value )
encodeOptionalDependency ( OptionalDependency optionalDependency ) =
  ( encodeOptionalDependencyKey optionalDependency.key, encodeOptionalDependencyValue optionalDependency.value )


encodeOptionalDependencyKey : OptionalDependencyKey -> String
encodeOptionalDependencyKey ( OptionalDependencyKey optionalDependencyKey ) =
  optionalDependencyKey


encodeOptionalDependencyValue : OptionalDependencyValue -> Json.Encode.Value
encodeOptionalDependencyValue ( OptionalDependencyValue optionalDependencyValue ) =
  Json.Encode.string <| String.trim optionalDependencyValue


maybeEncodeBundledDependencies : List BundledDependency -> Maybe ( String, Json.Encode.Value )
maybeEncodeBundledDependencies bundledDependencies =
  Just ( "bundledDependencies", Json.Encode.object <| List.map encodeBundledDependency bundledDependencies )


encodeBundledDependency : BundledDependency -> ( String, Json.Encode.Value )
encodeBundledDependency ( BundledDependency bundledDependency ) =
  ( encodeBundledDependencyKey bundledDependency.key, encodeBundledDependencyValue bundledDependency.value )


encodeBundledDependencyKey : BundledDependencyKey -> String
encodeBundledDependencyKey ( BundledDependencyKey bundledDependencyKey ) =
  bundledDependencyKey


encodeBundledDependencyValue : BundledDependencyValue -> Json.Encode.Value
encodeBundledDependencyValue ( BundledDependencyValue bundledDependencyValue ) =
  Json.Encode.string <| String.trim bundledDependencyValue


maybeEncodePeerDependencies : List PeerDependency -> Maybe ( String, Json.Encode.Value )
maybeEncodePeerDependencies peerDependencies =
  Just ( "peerDependencies", Json.Encode.object <| List.map encodePeerDependency peerDependencies )


encodePeerDependency : PeerDependency -> ( String, Json.Encode.Value )
encodePeerDependency ( PeerDependency peerDependency ) =
  ( encodePeerDependencyKey peerDependency.key, encodePeerDependencyValue peerDependency.value )


encodePeerDependencyKey : PeerDependencyKey -> String
encodePeerDependencyKey ( PeerDependencyKey peerDependencyKey ) =
  peerDependencyKey


encodePeerDependencyValue : PeerDependencyValue -> Json.Encode.Value
encodePeerDependencyValue ( PeerDependencyValue peerDependencyValue ) =
  Json.Encode.string <| String.trim peerDependencyValue


maybeEncodeDependencies : List Dependency -> Maybe ( String, Json.Encode.Value )
maybeEncodeDependencies dependencies =
  Just ( "dependencies", Json.Encode.object <| List.map encodeDependency dependencies )


encodeDependency : Dependency -> ( String, Json.Encode.Value )
encodeDependency ( Dependency dependency ) =
  ( encodeDependencyKey dependency.key, encodeDependencyValue dependency.value )


encodeDependencyKey : DependencyKey -> String
encodeDependencyKey ( DependencyKey dependencyKey ) =
  dependencyKey


encodeDependencyValue : DependencyValue -> Json.Encode.Value
encodeDependencyValue ( DependencyValue dependencyValue ) =
  Json.Encode.string <| String.trim dependencyValue


maybeEncodeDevelopmentDependencies : List DevelopmentDependency -> Maybe ( String, Json.Encode.Value )
maybeEncodeDevelopmentDependencies developmentDependencies =
  Just ( "devDependencies", Json.Encode.object <| List.map encodeDevelopmentDependency developmentDependencies )


encodeDevelopmentDependency : DevelopmentDependency -> ( String, Json.Encode.Value )
encodeDevelopmentDependency ( DevelopmentDependency developmentDependency ) =
  ( encodeDevelopmentDependencyKey developmentDependency.key, encodeDevelopmentDependencyValue developmentDependency.value )


encodeDevelopmentDependencyKey : DevelopmentDependencyKey -> String
encodeDevelopmentDependencyKey ( DevelopmentDependencyKey developmentDependencyKey ) =
  developmentDependencyKey


encodeDevelopmentDependencyValue : DevelopmentDependencyValue -> Json.Encode.Value
encodeDevelopmentDependencyValue ( DevelopmentDependencyValue developmentDependencyValue ) =
  Json.Encode.string <| String.trim developmentDependencyValue


maybeEncodeAccess : Access -> Maybe ( String, Json.Encode.Value )
maybeEncodeAccess access =
  case access of
    Private ->
      Just ( "private", Json.Encode.bool True )

    Public ->
      Nothing


maybeEncodeBrowser : Browser -> Maybe ( String, Json.Encode.Value )
maybeEncodeBrowser ( Browser browser ) =
  let
    trimmedBrowser : String
    trimmedBrowser =
      String.trim browser

  in
    case trimmedBrowser of
      "" ->
        Nothing

      _ ->
        Just ( "browser", Json.Encode.string trimmedBrowser )


maybeEncodeMain : Main -> Maybe ( String, Json.Encode.Value )
maybeEncodeMain ( Main entrypoint ) =
  let
    trimmedEntrypoint : String
    trimmedEntrypoint =
      String.trim entrypoint

  in
    case trimmedEntrypoint of
      "" ->
        Nothing

      _ ->
        Just ( "main", Json.Encode.string trimmedEntrypoint )


maybeEncodeLicense : License -> Maybe ( String, Json.Encode.Value )
maybeEncodeLicense ( License license ) =
  let
    trimmedLicense : String
    trimmedLicense =
      String.trim license

  in
    case trimmedLicense of
      "" ->
        Nothing

      _ ->
        Just ( "license", Json.Encode.string trimmedLicense )


maybeEncodeHomepage : Homepage -> Maybe ( String, Json.Encode.Value )
maybeEncodeHomepage ( Homepage homepage ) =
  let
    trimmedHomepage : String
    trimmedHomepage =
      String.trim homepage

  in
    case trimmedHomepage of
      "" ->
        Nothing

      _ ->
        Just ( "homepage", Json.Encode.string trimmedHomepage )


maybeEncodeVersion : Version -> Maybe ( String, Json.Encode.Value )
maybeEncodeVersion ( Version version ) =
  let
    trimmedVersion : String
    trimmedVersion =
      String.trim version

  in
    case trimmedVersion of
      "" ->
        Nothing

      _ ->
        Just ( "version", Json.Encode.string trimmedVersion )


maybeEncodeDescription : Description -> Maybe ( String, Json.Encode.Value )
maybeEncodeDescription ( Description description ) =
  let
    trimmedDescription : String
    trimmedDescription =
      String.trim description

  in
    case trimmedDescription of
      "" ->
        Nothing

      _ ->
        Just ( "description", Json.Encode.string trimmedDescription )


maybeEncodeName : Name -> Maybe ( String, Json.Encode.Value )
maybeEncodeName ( Name name ) =
  let
    trimmedName : String
    trimmedName =
      String.trim name

  in
    case trimmedName of
      "" ->
        Nothing

      _ ->
        Just ( "name", Json.Encode.string trimmedName )


maybeEncodeConfigurations : List Configuration -> Maybe ( String, Json.Encode.Value )
maybeEncodeConfigurations configurations =
  let
    trimmedConfigurations : List ( String, Json.Encode.Value )
    trimmedConfigurations =
      List.filterMap maybeEncodeConfiguration configurations

  in
    case trimmedConfigurations of
      [] ->
        Nothing

      _ ->
        Just ( "config", Json.Encode.object trimmedConfigurations )


maybeEncodeConfiguration : Configuration -> Maybe ( String, Json.Encode.Value )
maybeEncodeConfiguration ( Configuration configuration ) =
  let
    trimmedConfigurationKey : String
    trimmedConfigurationKey =
      configuration
        |> .key
        |> getConfigurationKey
        |> String.trim

    trimmedConfigurationValue : String
    trimmedConfigurationValue =
      configuration
        |> .value
        |> getConfigurationValue
        |> String.trim

  in
    case [trimmedConfigurationKey, trimmedConfigurationValue] of
      ["", ""] ->
        Nothing

      _ ->
        Just ( trimmedConfigurationKey, Json.Encode.string trimmedConfigurationValue )


getConfigurationKey : ConfigurationKey -> String
getConfigurationKey ( ConfigurationKey configurationKey ) = 
  configurationKey


getConfigurationValue : ConfigurationValue -> String
getConfigurationValue ( ConfigurationValue configurationValue ) =
  configurationValue


maybeEncodeScripts : List Script -> Maybe ( String, Json.Encode.Value )
maybeEncodeScripts scripts =
  let
    trimmedScripts : List ( String, Json.Encode.Value )
    trimmedScripts =
      scripts
        |> List.filterMap maybeEncodeScript

  in
    case trimmedScripts of
      [] ->
        Nothing

      _ ->
        Just ( "scripts", Json.Encode.object trimmedScripts )


maybeEncodeScript : Script -> Maybe ( String, Json.Encode.Value )
maybeEncodeScript ( Script script ) =
  let
    trimmedScriptKey : String
    trimmedScriptKey =
      script.key
        |> getScriptKeyValue
        |> String.trim

    trimmedScriptCommand : String
    trimmedScriptCommand =
      script.command
        |> getScriptCommandValue
        |> String.trim

  in
    case [trimmedScriptKey, trimmedScriptCommand] of
      ["", ""] ->
        Nothing

      _ ->
        Just ( trimmedScriptKey, Json.Encode.string trimmedScriptCommand )


getScriptKeyValue : ScriptKey -> String
getScriptKeyValue ( ScriptKey scriptKey ) =
  scriptKey


getScriptCommandValue : ScriptCommand -> String
getScriptCommandValue ( ScriptCommand scriptCommand ) =
  scriptCommand


maybeEncodeFundings : List Funding -> Maybe ( String, Json.Encode.Value )
maybeEncodeFundings fundings =
  let
    trimmedFundings : List Json.Encode.Value
    trimmedFundings =
      fundings
        |> List.filterMap maybeEncodeFunding

  in
    case trimmedFundings of
      [] ->
        Nothing

      _ ->
        Just ( "fundings", Json.Encode.list identity trimmedFundings )


maybeEncodeFunding : Funding -> Maybe Json.Encode.Value
maybeEncodeFunding ( Funding funding ) =
  let
    trimmedFunding : List ( String, Json.Encode.Value )
    trimmedFunding =
      List.filterMap identity
        [ maybeEncodeFundingKind funding.kind
        , maybeEncodeFundingUrl funding.url
        ]

  in
    case trimmedFunding of
      [] ->
        Nothing

      _ ->
        Just ( Json.Encode.object trimmedFunding )


maybeEncodeFundingKind : FundingKind -> Maybe ( String, Json.Encode.Value )
maybeEncodeFundingKind ( FundingKind fundingKind ) =
  let
    trimmedFundingKind : String
    trimmedFundingKind =
      String.trim fundingKind

  in
    case trimmedFundingKind of
      "" ->
        Nothing

      _ ->
        Just ( "type", Json.Encode.string trimmedFundingKind )


maybeEncodeFundingUrl : FundingUrl -> Maybe ( String, Json.Encode.Value )
maybeEncodeFundingUrl ( FundingUrl fundingUrl ) =
  let
    trimmedFundingUrl : String
    trimmedFundingUrl =
      String.trim fundingUrl

  in
    case trimmedFundingUrl of
      "" ->
        Nothing

      _ ->
        Just ( "url", Json.Encode.string trimmedFundingUrl )


maybeEncodeContributors : List Contributor -> Maybe ( String, Json.Encode.Value )
maybeEncodeContributors contributors =
  let
    trimmedContributors : List Json.Encode.Value
    trimmedContributors =
      contributors
        |> List.map maybeEncodeContributor
        |> List.filterMap identity

  in
    case trimmedContributors of
      [] ->
        Nothing

      _ ->
        Just ( "contributors", Json.Encode.list identity trimmedContributors )


maybeEncodeContributor : Contributor -> Maybe Json.Encode.Value
maybeEncodeContributor ( Contributor contributor ) =
  let
    trimmedContributor : List ( String, Json.Encode.Value )
    trimmedContributor =
      List.filterMap identity
        [ maybeEncodeContributorName contributor.name
        , maybeEncodeContributorEmail contributor.email
        , maybeEncodeContributorUrl contributor.url
        ]

  in
    case trimmedContributor of
      [] ->
        Nothing

      _ ->
       Just ( Json.Encode.object trimmedContributor )


maybeEncodeContributorName : ContributorName -> Maybe ( String, Json.Encode.Value )
maybeEncodeContributorName ( ContributorName contributorName ) =
  let
    trimmedContributorName : String
    trimmedContributorName =
      String.trim contributorName

  in
    case trimmedContributorName of
      "" ->
        Nothing

      _ ->
        Just ( "name", Json.Encode.string trimmedContributorName )


maybeEncodeContributorEmail : ContributorEmail -> Maybe ( String, Json.Encode.Value )
maybeEncodeContributorEmail ( ContributorEmail contributorEmail ) =
  let
    trimmedContributorEmail : String
    trimmedContributorEmail =
      String.trim contributorEmail

  in
    case trimmedContributorEmail of
      "" ->
        Nothing

      _ ->
        Just ( "email", Json.Encode.string trimmedContributorEmail )


maybeEncodeContributorUrl : ContributorUrl -> Maybe ( String, Json.Encode.Value )
maybeEncodeContributorUrl ( ContributorUrl contributorUrl ) =
  let
    trimmedContributorUrl : String
    trimmedContributorUrl =
      String.trim contributorUrl

  in
    case trimmedContributorUrl of
      "" ->
        Nothing

      _ ->
        Just ( "url", Json.Encode.string trimmedContributorUrl )


-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
  case message of
    None ->
      ( { model | notification = "" }
      , Cmd.none
      )

    UpdateName name ->
      ( { model
          | name = ( Name name )
          , notification = ""
        }
      , Cmd.none
      )

    UpdateDescription description ->
      ( { model
          | description = ( Description description )
          , notification = ""
        }
      , Cmd.none
      )

    UpdateVersion version ->
      ( { model
          | version = ( Version version )
          , notification = ""
        }
      , Cmd.none
      )

    UpdateHomepage homepage ->
      ( { model
          | homepage = ( Homepage homepage )
          , notification = ""
        }
      , Cmd.none
      )

    UpdateLicense license ->
      ( { model
          | license = ( License license )
          , notification = ""
        }
      , Cmd.none
      )

    UpdateMain entrypoint ->
      ( { model
          | main = ( Main entrypoint )
          , notification = ""
        }
      , Cmd.none
      )

    UpdateBrowser browser ->
      ( { model
          | browser = ( Browser browser )
          , notification = ""
        }
      , Cmd.none
      )

    UpdateAccess access ->
      ( { model
          | access = updateAccess access
          , notification = ""
        }
      , Cmd.none
      )

    UpdateBugsUrl url ->
      ( { model
          | bugs = updateBugsUrl ( BugsUrl url ) model.bugs
          , notification = ""
        }
      , Cmd.none
      )

    UpdateBugsEmail email ->
      ( { model
          | bugs = updateBugsEmail ( BugsEmail email ) model.bugs
          , notification = ""
        }
      , Cmd.none
      )

    UpdateAuthorName name ->
      ( { model
          | author = updateAuthorName ( AuthorName name ) model.author
          , notification = ""
        }
      , Cmd.none
      )

    UpdateAuthorEmail email ->
      ( { model
          | author = updateAuthorEmail ( AuthorEmail email ) model.author
          , notification = ""
        }
      , Cmd.none
      )

    UpdateAuthorUrl url ->
      ( { model
          | author = updateAuthorUrl ( AuthorUrl url ) model.author
          , notification = ""
        }
      , Cmd.none
      )

    UpdateRepositoryKind kind ->
      ( { model
          | repository = updateRepositoryKind ( RepositoryKind kind ) model.repository
          , notification = ""
        }
      , Cmd.none
      )

    UpdateRepositoryUrl url ->
      ( { model
          | repository = updateRepositoryUrl ( RepositoryUrl url ) model.repository
          , notification = ""
        }
      , Cmd.none
      )

    UpdateEnginesNode node ->
      ( { model
          | engines = updateNodeEngine ( NodeEngine node ) model.engines
          , notification = ""
        }
      , Cmd.none
      )

    UpdateEnginesNpm npm ->
      ( { model
          | engines = updateNpmEngine ( NpmEngine npm ) model.engines
          , notification = ""
        }
      , Cmd.none
      )

    AddCpu ->
      ( { model
          | cpus = List.append model.cpus [ Cpu "" ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.cpus "cpu-"
        , vibrate ()
        ]
      )

    UpdateCpu index value ->
      ( { model
          | cpus = List.Extra.updateAt index ( always ( Cpu value ) ) model.cpus
          , notification = ""
        }
      , Cmd.none
      )

    RemoveCpu index ->
      ( { model
          | cpus = List.Extra.removeAt index model.cpus
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.cpus "cpu-"
        , vibrate ()
        ]
      )

    AddOperatingSystem ->
      ( { model
          | operatingSystems = List.append model.operatingSystems [ OperatingSystem "" ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.operatingSystems "operating-system-"
        , vibrate ()
        ]
      )

    UpdateOperatingSystem index operatingSystem ->
      ( { model
          | operatingSystems = List.Extra.updateAt index ( always ( OperatingSystem operatingSystem ) ) model.operatingSystems
          , notification = ""
        }
      , Cmd.none
      )

    RemoveOperatingSystem index ->
      ( { model
          | operatingSystems = List.Extra.removeAt index model.operatingSystems
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.operatingSystems "operating-system-"
        , vibrate ()
        ]
      )

    AddFile ->
      ( { model
          | files = List.append model.files [ File "" ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.files "file-"
        , vibrate ()
        ]
      )

    UpdateFile index value ->
      ( { model
          | files = List.Extra.updateAt index ( always ( File value ) ) model.files
          , notification = ""
        }
      , Cmd.none
      )

    RemoveFile index ->
      ( { model
          | files = List.Extra.removeAt index model.files
          , notification = ""
        }
      , Cmd.batch 
        [ focusBeforeRemove model.files "file-"
        , vibrate ()
        ]
      )

    AddKeyword ->
      ( { model
          | keywords = List.append model.keywords [ Keyword "" ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.keywords "keyword-"
        , vibrate ()
        ]
      )

    UpdateKeyword index keyword ->
      ( { model
          | keywords = List.Extra.updateAt index ( always ( Keyword keyword ) ) model.keywords
          , notification = ""
        }
      , Cmd.none
      )

    RemoveKeyword index ->
      ( { model
          | keywords = List.Extra.removeAt index model.keywords
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.keywords "keyword-"
        , vibrate ()
        ]
      )

    AddContributor ->
      ( { model
          | contributors = List.append model.contributors [ Contributor { name = ContributorName "", email = ContributorEmail "", url = ContributorUrl "" } ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.contributors "contributor-name-"
        , vibrate ()
        ]
      )

    RemoveContributor index ->
      ( { model
          | contributors = List.Extra.removeAt index model.contributors
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.contributors "contributor-name-"
        , vibrate ()
        ]
      )

    UpdateContributorName index name ->
      ( { model
          | contributors = List.Extra.updateAt index ( updateContributorName ( ContributorName name ) ) model.contributors
          , notification = ""
        }
      , Cmd.none
      )

    UpdateContributorEmail index email ->
      ( { model | contributors = List.Extra.updateAt index ( updateContributorEmail ( ContributorEmail email ) ) model.contributors }
      , Cmd.none
      )

    UpdateContributorUrl index url ->
      ( { model
          | contributors = List.Extra.updateAt index ( updateContributorUrl ( ContributorUrl url ) ) model.contributors
          , notification = ""
        }
      , Cmd.none
      )

    AddFunding ->
      ( { model
          | fundings = List.append model.fundings [ Funding { kind = FundingKind "", url = FundingUrl "" } ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.fundings "funding-type-"
        , vibrate ()
        ]
      )

    UpdateFundingKind index kind ->
      ( { model
          | fundings = List.Extra.updateAt index ( updateFundingKind ( FundingKind kind ) ) model.fundings
          , notification = ""
        }
      , Cmd.none
      )

    UpdateFundingUrl index url ->
      ( { model
          | fundings = List.Extra.updateAt index ( updateFundingUrl ( FundingUrl url ) ) model.fundings
          , notification = ""
        }
      , Cmd.none
      )

    RemoveFunding index ->
      ( { model
          | fundings = List.Extra.removeAt index model.fundings
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.fundings "funding-type-"
        , vibrate ()
        ]
      )

    AddScript ->
      ( { model
          | scripts = List.append model.scripts [ Script { key = ScriptKey "", command = ScriptCommand "" } ]
          , notification = ""
        }
      , Cmd.batch 
        [ focusAfterAdd model.scripts "script-key-"
        , vibrate ()
        ]
      )

    RemoveScript index ->
      ( { model
          | scripts = List.Extra.removeAt index model.scripts
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.scripts "script-key-"
        , vibrate ()
        ]
      )

    UpdateScriptKey index key ->
      ( { model
          | scripts = List.Extra.updateAt index ( updateScriptKey ( ScriptKey key ) ) model.scripts
          , notification = ""
        }
      , Cmd.none
      )

    UpdateScriptCommand index command ->
      ( { model
          | scripts = List.Extra.updateAt index ( updateScriptCommand ( ScriptCommand command ) ) model.scripts
          , notification = ""
        }
      , Cmd.none
      )

    AddConfiguration ->
      ( { model
          | configurations = List.append model.configurations [ Configuration { key = ConfigurationKey "", value = ConfigurationValue "" } ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.configurations "configuration-key-"
        , vibrate ()
        ]
      )

    RemoveConfiguration index ->
      ( { model
          | configurations = List.Extra.removeAt index model.configurations
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.configurations "configuration-key-"
        , vibrate ()
        ]
      )

    UpdateConfigurationKey index key ->
      ( { model
          | configurations = List.Extra.updateAt index ( updateConfigurationKey ( ConfigurationKey key ) ) model.configurations
          , notification = ""
        }
      , Cmd.none
      )

    UpdateConfigurationValue index value ->
      ( { model
          | configurations = List.Extra.updateAt index ( updateConfigurationValue ( ConfigurationValue value ) ) model.configurations
          , notification = ""
        }
      , Cmd.none
      )

    AddDependency ->
      ( { model
          | dependencies = List.append model.dependencies [ Dependency { key = DependencyKey "", value = DependencyValue "" } ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.dependencies "dependency-name-"
        , vibrate ()
        ]
      )

    RemoveDependency index ->
      ( { model
          | dependencies = List.Extra.removeAt index model.dependencies
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.dependencies "dependency-name-"
        , vibrate ()
        ]
      )

    UpdateDependencyKey index key ->
      ( { model
          | dependencies = List.Extra.updateAt index ( updateDependencyKey ( DependencyKey key ) ) model.dependencies
          , notification = ""
        }
      , Cmd.none
      )
    
    UpdateDependencyValue index value ->
      ( { model
          | dependencies = List.Extra.updateAt index ( updateDependencyValue ( DependencyValue value ) ) model.dependencies
          , notification = ""
        }
      , Cmd.none
      )

    AddDevelopmentDependency ->
      ( { model
          | developmentDependencies = List.append model.developmentDependencies [ DevelopmentDependency { key = DevelopmentDependencyKey "", value = DevelopmentDependencyValue "" } ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.developmentDependencies "development-dependency-name-"
        , vibrate ()
        ]
      )

    UpdateDevelopmentDependencyValue index value ->
      ( { model
            | developmentDependencies = List.Extra.updateAt index ( updateDevelopmentDependencyValue ( DevelopmentDependencyValue value ) ) model.developmentDependencies
            , notification = ""
        }
      , Cmd.none
      )

    UpdateDevelopmentDependencyKey index key ->
      ( { model
          | developmentDependencies = List.Extra.updateAt index ( updateDevelopmentDependencyKey ( DevelopmentDependencyKey key ) ) model.developmentDependencies
          , notification = ""
        }
      , Cmd.none
      )

    RemoveDevelopmentDependency index ->
      ( { model
          | developmentDependencies = List.Extra.removeAt index model.developmentDependencies
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.developmentDependencies "development-dependency-name-"
        , vibrate ()
        ]
      )

    AddPeerDependency ->
      ( { model
          | peerDependencies = List.append model.peerDependencies [ PeerDependency { key = PeerDependencyKey "", value = PeerDependencyValue "" } ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.peerDependencies "peer-dependency-name-"
        , vibrate ()
        ]
      )

    UpdatePeerDependencyKey index key ->
      ( { model
          | peerDependencies = List.Extra.updateAt index ( updatePeerDependencyKey ( PeerDependencyKey key ) ) model.peerDependencies
          , notification = ""
        }
      , Cmd.none
      )

    UpdatePeerDependencyValue index value ->
      ( { model
          | peerDependencies = List.Extra.updateAt index ( updatePeerDependencyValue ( PeerDependencyValue value ) ) model.peerDependencies
          , notification = ""
        }
      , Cmd.none
      )

    RemovePeerDependency index ->
      ( { model
          | peerDependencies = List.Extra.removeAt index model.peerDependencies
          , notification = ""
        }
      , Cmd.batch 
        [ focusBeforeRemove model.peerDependencies "peer-dependency-name-"
        , vibrate ()
        ]
      )

    AddBundledDependency ->
      ( { model
          | bundledDependencies = List.append model.bundledDependencies [ BundledDependency { key = BundledDependencyKey "", value = BundledDependencyValue "" } ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.bundledDependencies "bundled-dependency-name-"
        , vibrate ()
        ]
      )

    RemoveBundledDependency index ->
      ( { model
          | bundledDependencies = List.Extra.removeAt index model.bundledDependencies
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.bundledDependencies "bundled-dependency-name-"
        , vibrate ()
        ]
      )

    UpdateBundledDependencyKey index key ->
      ( { model
          | bundledDependencies = List.Extra.updateAt index ( updateBundledDependencyKey ( BundledDependencyKey key ) ) model.bundledDependencies
          , notification = ""
        }
      , Cmd.none
      )

    UpdateBundledDependencyValue index value ->
      ( { model
          | bundledDependencies = List.Extra.updateAt index ( updateBundledDependencyValue ( BundledDependencyValue value ) ) model.bundledDependencies
          , notification = ""
        }
      , Cmd.none
      )

    AddOptionalDependency ->
      ( { model
          | optionalDependencies = List.append model.optionalDependencies [ OptionalDependency { key = OptionalDependencyKey "", value = OptionalDependencyValue "" } ]
          , notification = ""
        }
      , Cmd.batch
        [ focusAfterAdd model.optionalDependencies "optional-dependency-name-"
        , vibrate ()
        ]
      )

    UpdateOptionalDependencyKey index key ->
      ( { model
          | optionalDependencies = List.Extra.updateAt index ( updateOptionalDependencyKey ( OptionalDependencyKey key ) ) model.optionalDependencies
          , notification = ""
        }
      , Cmd.none
      )

    UpdateOptionalDependencyValue index value ->
      ( { model
          | optionalDependencies = List.Extra.updateAt index ( updateOptionalDependencyValue ( OptionalDependencyValue value ) ) model.optionalDependencies
          , notification = ""
        }
      , Cmd.none
      )
  
    RemoveOptionalDependency index ->
      ( { model
          | optionalDependencies = List.Extra.removeAt index model.optionalDependencies
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.optionalDependencies "optional-dependency-name-"
        , vibrate ()
        ]
      )

    AddWorkspace ->
      ( { model
          | workspaces = List.append model.workspaces [ Workspace "" ]
          , notification = ""
        } 
      , Cmd.batch
        [ focusAfterAdd model.workspaces "workspace-"
        , vibrate ()
        ]
      )

    RemoveWorkspace index ->
      ( { model
          | workspaces = List.Extra.removeAt index model.workspaces
          , notification = ""
        }
      , Cmd.batch
        [ focusBeforeRemove model.workspaces "workspace-"
        , vibrate ()
        ]
      )

    UpdateWorkspace index workspace ->
      ( { model
          | workspaces = List.Extra.updateAt index ( always ( Workspace workspace ) ) model.workspaces
          , notification = ""
        }
      , Cmd.none
      )

    UpdateLibraryDirectory libraryDirectory ->
      ( { model
          | directories = updateLibraryDirectory ( LibraryDirectory libraryDirectory ) model.directories
          , notification = ""
        }
      , Cmd.none
      )

    UpdateBinaryDirectory binaryDirectory ->
      ( { model
          | directories = updateBinaryDirectory ( BinaryDirectory binaryDirectory ) model.directories
          , notification = ""
        }
      , Cmd.none
      )

    UpdateManualDirectory manualDirectory ->
      ( { model
          | directories = updateManualDirectory ( ManualDirectory manualDirectory ) model.directories
          , notification = ""
        }
      , Cmd.none
      )

    UpdateDocumentationDirectory documentationDirectory ->
      ( { model
          | directories = updateDocumentationDirectory ( DocumentationDirectory documentationDirectory ) model.directories
          , notification = ""
        }
      , Cmd.none
      )

    UpdateExampleDirectory exampleDirectory ->
      ( { model
          | directories = updateExampleDirectory ( ExampleDirectory exampleDirectory ) model.directories
          , notification = ""
        }
      , Cmd.none
      )

    UpdateTestDirectory testDirectory ->
      ( { model
          | directories = updateTestDirectory ( TestDirectory testDirectory ) model.directories
          , notification = ""
        }
      , Cmd.none
      )

    UpdateSpaces spaces ->
      ( { model
          | spaces = updateSpaces spaces
          , notification = ""
        }
      , Cmd.none
      )

    CopyToClipboard ->
      ( { model | notification = "" }
      , Cmd.batch
        [ copyToClipboard <| encodeModel model
        , vibrate ()
        ]
      )

    CopyToClipboardNotification notification ->
      ( { model | notification = notification }
      , Cmd.none
      )

    WindowResized width height ->
      ( { model
          | windowWidth = width
          , notification = ""
        }
      , Cmd.none
      )

    SaveToDisk ->
      ( { model | notification = "" }
      , Cmd.batch
        [ model |> encodeModel |> saveToDisk
        , vibrate ()
        ]
      )

    Reset ->
      ( initialModel model.windowWidth, vibrate () )

    ResetName ->
      ( { model | name = Name "" }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "name"
        ]
      )

    ResetDescription ->
      ( { model | description = Description "" }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "description"
        ]
      )

    ResetVersion ->
      ( { model | version = Version "" }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "version"
        ]
      )

    ResetHomepage ->
      ( { model | homepage = Homepage "" }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "homepage"
        ]
      )

    ResetLicense ->
      ( { model | license = License "" }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "license"
        ]
      )

    ResetMain ->
      ( { model | main = Main "" }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "main"
        ]
      )

    ResetBrowser ->
      ( { model | browser = Browser "" }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "browser"
        ]
      )

    ResetBugs ->
      ( { model | bugs = Bugs { url = BugsUrl "" , email = BugsEmail "" } }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "bugs-url"
        ]
      )

    ResetAuthor ->
      ( { model | author = Author { name = AuthorName "", url = AuthorUrl "", email = AuthorEmail ""} }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "author-name"
        ]
      )

    ResetRepository ->
      ( { model | repository = Repository { kind = RepositoryKind "", url = RepositoryUrl "" } }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "repository-type"
        ]
      )

    ResetEngines ->
      ( { model | engines = Engines { node = NodeEngine "", npm = NpmEngine "" } }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "engines-node"
        ]
      )

    ResetDirectories ->
      ( { model | directories = Directories { library = LibraryDirectory "", binary = BinaryDirectory "", manual = ManualDirectory "", documentation = DocumentationDirectory "", example = ExampleDirectory "", test = TestDirectory "" } }
      , Cmd.batch
        [ vibrate ()
        , focusElementById "directories-library"
        ]
      )

    ResetCpus ->
      ( { model | cpus = [] }
      , vibrate ()
      )

    ResetOperatingSystems ->
      ( { model | operatingSystems = [] }
      , vibrate ()
      )

    ResetFiles ->
      ( { model | files = [] }
      , vibrate ()
      )

    ResetKeywords ->
      ( { model | keywords = [] }
      , vibrate ()
      )

    ResetWorkspaces ->
      ( { model | workspaces = [] }
      , vibrate ()
      )

    ResetContributors ->
      ( { model | contributors = [] }
      , vibrate ()
      )

    ResetFundings ->
      ( { model | fundings = [] }
      , vibrate ()
      )

    ResetScripts ->
      ( { model | scripts = [] }
      , vibrate ()
      )

    ResetConfigurations ->
      ( { model | configurations = [] }
      , vibrate ()
      )

    ResetDependencies ->
      ( { model | dependencies = [] }
      , vibrate ()
      )

    ResetDevelopmentDependencies ->
      ( { model | developmentDependencies = [] }
      , vibrate ()
      )

    ResetPeerDependencies ->
      ( { model | peerDependencies = [] }
      , vibrate ()
      )

    ResetBundledDependencies ->
      ( { model | bundledDependencies = [] }
      , vibrate ()
      )

    ResetOptionalDependencies ->
      ( { model | optionalDependencies = [] }
      , vibrate ()
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


focusElementById : String -> Cmd Message
focusElementById identifier =
  Task.attempt
    ( always None )
    ( Browser.Dom.focus identifier )


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


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions _ =
  Sub.batch
    [ copyToClipboardNotification CopyToClipboardNotification
    , Browser.Events.onResize WindowResized
    , Browser.Events.onKeyDown ( onControlAltKey [ ( "c", CopyToClipboard ), ( "s", SaveToDisk ), ( "r", Reset ) ] )
    ]


-- OUTGOING PORTS


port vibrate : () -> Cmd message


port saveToDisk : String -> Cmd message


port copyToClipboard : String -> Cmd message


-- INCOMING PORTS


port copyToClipboardNotification : ( String -> message ) -> Sub message


-- INIT


initialModel : Flags -> Model
initialModel windowWidth =
  { windowWidth = windowWidth
  , notification = ""
  , name = Name ""
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


init : Flags -> ( Model, Cmd Message )
init windowWidth =
  ( initialModel windowWidth , Cmd.none )


-- TYPES ( Flags )


type alias Flags =
  Int


-- TYPES ( MODEL )


type alias Model =
  { windowWidth : Int
  , notification : String
  , name : Name
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


type LibraryDirectory =
  LibraryDirectory String


type BinaryDirectory =
  BinaryDirectory String


type ManualDirectory = 
  ManualDirectory String


type DocumentationDirectory =
  DocumentationDirectory String


type ExampleDirectory =
  ExampleDirectory String


type TestDirectory =
  TestDirectory String


type Keyword =
  Keyword String


type File =
  File String


type OperatingSystem =
  OperatingSystem String


type Cpu =
  Cpu String


type Access
  = Private
  | Public


type Browser =
  Browser String


type Main =
  Main String


type License =
  License String


type Homepage =
  Homepage String


type Version =
  Version String


type Description =
  Description String


type Name =
  Name String


type Workspace =
  Workspace String


type Engines =
  Engines
    { node : NodeEngine
    , npm : NpmEngine
    }


type NodeEngine =
  NodeEngine String


type NpmEngine =
  NpmEngine String


type Repository =
  Repository
    { kind : RepositoryKind
    , url : RepositoryUrl
    }


type RepositoryKind =
  RepositoryKind String


type RepositoryUrl =
  RepositoryUrl String


type Author =
  Author
    { name : AuthorName
    , url : AuthorUrl
    , email : AuthorEmail
    }


type AuthorName =
  AuthorName String


type AuthorUrl =
  AuthorUrl String


type AuthorEmail =
  AuthorEmail String


type Bugs =
  Bugs
    { url : BugsUrl
    , email : BugsEmail
    }


type BugsUrl =
  BugsUrl String


type BugsEmail =
  BugsEmail String


type OptionalDependency =
  OptionalDependency
    { key : OptionalDependencyKey
    , value : OptionalDependencyValue
    }


type OptionalDependencyKey =
  OptionalDependencyKey String


type OptionalDependencyValue =
  OptionalDependencyValue String


type BundledDependency =
  BundledDependency
    { key : BundledDependencyKey
    , value : BundledDependencyValue
    }


type BundledDependencyKey =
  BundledDependencyKey String


type BundledDependencyValue =
  BundledDependencyValue String


type PeerDependency =
  PeerDependency 
    { key : PeerDependencyKey
    , value : PeerDependencyValue
    }


type PeerDependencyKey =
  PeerDependencyKey String


type PeerDependencyValue =
  PeerDependencyValue String


type DevelopmentDependency =
  DevelopmentDependency
    { key : DevelopmentDependencyKey
    , value : DevelopmentDependencyValue
    }


type DevelopmentDependencyValue =
  DevelopmentDependencyValue String


type DevelopmentDependencyKey =
  DevelopmentDependencyKey String


type Dependency =
  Dependency
    { key : DependencyKey
    , value : DependencyValue
    }


type DependencyKey =
  DependencyKey String


type DependencyValue =
  DependencyValue String


type Configuration =
  Configuration
    { key : ConfigurationKey
    , value : ConfigurationValue
    }


type ConfigurationKey =
  ConfigurationKey String


type ConfigurationValue =
  ConfigurationValue String


type Script =
  Script
    { key : ScriptKey
    , command : ScriptCommand
    }


type ScriptKey =
  ScriptKey String


type ScriptCommand =
  ScriptCommand String


type Funding =
  Funding 
    { kind : FundingKind
    , url : FundingUrl
    }


type FundingKind =
  FundingKind String


type FundingUrl =
  FundingUrl String


type Contributor =
  Contributor
    { name : ContributorName
    , email : ContributorEmail
    , url : ContributorUrl
    }


type ContributorName = 
  ContributorName String


type ContributorEmail =
  ContributorEmail String


type ContributorUrl =
  ContributorUrl String


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
  | CopyToClipboard
  | CopyToClipboardNotification String
  | WindowResized Int Int
  | SaveToDisk
  | Reset
  | ResetName
  | ResetDescription
  | ResetVersion
  | ResetHomepage
  | ResetLicense
  | ResetMain
  | ResetBrowser
  | ResetBugs
  | ResetAuthor
  | ResetRepository
  | ResetEngines
  | ResetDirectories
  | ResetCpus
  | ResetOperatingSystems
  | ResetFiles
  | ResetKeywords
  | ResetWorkspaces
  | ResetContributors
  | ResetFundings
  | ResetScripts
  | ResetConfigurations
  | ResetDependencies
  | ResetDevelopmentDependencies
  | ResetPeerDependencies
  | ResetBundledDependencies
  | ResetOptionalDependencies
