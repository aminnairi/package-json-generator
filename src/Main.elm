module Main exposing ( main )

{--

platforms:

'aix'
'darwin'
'freebsd'
'linux'
'openbsd'
'sunos'
'win32'

archs:

'arm', 'arm64', 'ia32', 'mips','mipsel', 'ppc', 'ppc64', 's390', 's390x', 'x32', and 'x64'.
--}

import Html exposing ( Html )
import Html.Attributes
import Html.Events
import Browser
import Json.Encode

type alias ViewInputsOptions =
    { label     : String
    , onAdd     : Msg
    , onUpdate  : Int -> String -> Msg
    , onRemove  : Int -> Msg
    }

type alias ViewInputOptions =
    { placeholder   : String
    , value         : String
    , onInput       : String -> Msg
    }

type alias ViewDropdownOptions =
    { value         : String
    , label         : String
    , identifier    : String
    , onSelection   : String -> Msg
    }

type alias ViewDropdownValue =
    ( String , String )

type alias ViewDropdownValues =
    List ViewDropdownValue

type alias Model =
    { keywords              : List String
    , name                  : String
    , version               : String
    , description           : String
    , homePage              : String
    , mainScript            : String
    , browserScript         : String
    , files                 : List String
    , manPages              : List String
    , operatingSystems      : List String
    , centralProcessUnits   : List String
    , private               : Bool
    , nodeEngine            : String
    , npmEngine             : String
    , bugUrl                : String
    , bugEmail              : String
    , license               : String
    , authorName            : String
    , authorEmail           : String
    , authorUrl             : String
    , binary                : String
    , repositoryType        : String
    , repositoryUrl         : String
    , repositoryDirectory   : String
    , spaces                : Int
    }

type Msg
    = AddKeyword
    | UpdateKeyword Int String
    | RemoveKeyword Int
    | UpdateName String
    | UpdateVersion String
    | UpdateDescription String
    | UpdateHomePage String
    | AddFile
    | UpdateFile Int String
    | RemoveFile Int
    | UpdateMainScript String
    | UpdateBrowserScript String
    | AddManPage
    | UpdateManPage Int String
    | RemoveManPage Int
    | AddOperatingSystem
    | UpdateOperatingSystem Int String
    | RemoveOperatingSystem Int
    | AddCentralProcessUnit
    | UpdateCentralProcessUnit Int String
    | RemoveCentralProcessUnit Int
    | UpdatePrivate String
    | UpdateNodeEngine String
    | UpdateNpmEngine String
    | UpdateBugUrl String
    | UpdateBugEmail String
    | UpdateLicense String
    | UpdateAuthorName String
    | UpdateAuthorEmail String
    | UpdateAuthorUrl String
    | UpdateBinary String
    | UpdateRepositoryType String
    | UpdateRepositoryUrl String
    | UpdateRepositoryDirectory String
    | UpdateSpaces String

init : Model
init =
    { keywords              = [""]
    , name                  = ""
    , version               = ""
    , description           = ""
    , homePage              = ""
    , mainScript            = ""
    , browserScript         = ""
    , files                 = [""]
    , manPages              = [""]
    , operatingSystems      = [""]
    , centralProcessUnits   = [""]
    , private               = True
    , nodeEngine            = ""
    , npmEngine             = ""
    , bugUrl                = ""
    , bugEmail              = ""
    , license               = ""
    , authorName            = ""
    , authorEmail           = ""
    , authorUrl             = ""
    , binary                = ""
    , repositoryType        = ""
    , repositoryUrl         = ""
    , repositoryDirectory   = ""
    , spaces                = 2 
    }


maybeJsonEncodeList : ( String, List String ) -> Maybe ( String, Json.Encode.Value )
maybeJsonEncodeList ( property, list ) =
    let
        filteredList : List String
        filteredList =
            list
                |> List.map String.trim
                |> List.filter ( String.isEmpty >> not )

    in
        if List.isEmpty filteredList || List.all String.isEmpty filteredList then
            Nothing

        else
            Just ( property, Json.Encode.list Json.Encode.string filteredList )


maybeListValues : Maybe item -> List item -> List item
maybeListValues maybeItem items =
    case maybeItem of
        Nothing ->
            items

        Just item ->
            item :: items


maybeJsonEncodeString : ( String, String ) -> Maybe ( String, Json.Encode.Value )
maybeJsonEncodeString ( property, value ) =
    let
        sanitizedValue : String
        sanitizedValue =
            String.trim value

    in
        case String.isEmpty sanitizedValue of
            True ->
                Nothing

            False ->
                Just ( property, Json.Encode.string sanitizedValue )


maybeJsonEncodeBool : ( String, Bool ) -> Maybe ( String, Json.Encode.Value )
maybeJsonEncodeBool ( property, value ) =
    case value of
        True ->
            Just ( property, Json.Encode.bool value )

        False ->
            Nothing


maybeJsonEncodeObject : List ( Maybe ( String, Json.Encode.Value ) ) -> Json.Encode.Value
maybeJsonEncodeObject maybeProperties =
    List.foldr maybeListValues [] maybeProperties
        |> Json.Encode.object


maybeJsonEncodeNamedObject : String -> List ( Maybe ( String, Json.Encode.Value ) ) -> Maybe ( String, Json.Encode.Value )
maybeJsonEncodeNamedObject name maybeProperties =
    case List.foldr maybeListValues [] maybeProperties of
        [] ->
            Nothing

        properties ->
            Just ( name, maybeJsonEncodeObject maybeProperties )


viewJsonModel : Model -> Html Msg
viewJsonModel model =
    Html.div
        [ Html.Attributes.class "row" ]
        [ Html.div
            [ Html.Attributes.class "col s12" ]
            [ Html.pre
                []
                [ Html.code
                    []
                    [ Html.text <| Json.Encode.encode model.spaces <|
                        maybeJsonEncodeObject
                                [ maybeJsonEncodeString ( "name", model.name )
                                , maybeJsonEncodeString ( "version", model.version )
                                , maybeJsonEncodeString ( "description", model.description )
                                , maybeJsonEncodeString ( "homepage", model.homePage )
                                , maybeJsonEncodeString ( "main", model.mainScript )
                                , maybeJsonEncodeString ( "browser", model.browserScript )
                                , maybeJsonEncodeString ( "license", model.license )
                                , maybeJsonEncodeString ( "binary", model.binary )
                                , maybeJsonEncodeList ( "keywords", model.keywords )
                                , maybeJsonEncodeList ( "files", model.files )
                                , maybeJsonEncodeList ( "man", model.manPages )
                                , maybeJsonEncodeList ( "os", model.operatingSystems )
                                , maybeJsonEncodeBool ( "private", model.private )
                                , maybeJsonEncodeNamedObject
                                    "engines"
                                    [ maybeJsonEncodeString ( "node", model.nodeEngine )
                                    , maybeJsonEncodeString ( "npm", model.npmEngine )
                                    ]
                                , maybeJsonEncodeNamedObject
                                    "bugs"
                                    [ maybeJsonEncodeString ( "url", model.bugUrl )
                                    , maybeJsonEncodeString ( "email", model.bugEmail )
                                    ]
                                , maybeJsonEncodeNamedObject
                                    "author"
                                    [ maybeJsonEncodeString ( "name", model.authorName )
                                    , maybeJsonEncodeString ( "email", model.authorEmail )
                                    , maybeJsonEncodeString ( "url", model.authorUrl )
                                    ]
                                , maybeJsonEncodeNamedObject
                                    "repository"
                                    [ maybeJsonEncodeString ( "type", model.repositoryType )
                                    , maybeJsonEncodeString ( "url", model.repositoryUrl )
                                    , maybeJsonEncodeString ( "directory", model.repositoryDirectory )
                                    ]
                                , maybeJsonEncodeList ( "cpu", model.centralProcessUnits ) ]
                    ]
                ]
            ]
        ]


viewInputs : ViewInputsOptions -> List String -> List ( Html Msg )
viewInputs options values =
    List.indexedMap
        ( \index value ->
            if index == 0 then
                Html.div
                    [ Html.Attributes.class "row" ]
                    [ Html.div
                        [ Html.Attributes.class "col s12 input-field" ]
                        [ Html.i
                            [ Html.Events.onClick options.onAdd
                            , Html.Attributes.class "material-icons"
                            , Html.Attributes.class "prefix"
                            , Html.Attributes.class "green-text"
                            ]
                            [ Html.text "add_circle" ]
                        , Html.input
                            [ Html.Attributes.value value
                            , Html.Events.onInput ( options.onUpdate index )
                            , Html.Attributes.id ( options.label ++ String.fromInt index )
                            , Html.Attributes.type_ "text"
                            ]
                            []
                        , Html.label
                            [ Html.Attributes.for ( options.label ++ String.fromInt index ) ]
                            [ Html.text ( options.label ++ " " ) ]
                        ]
                    ]

            else
                Html.div
                    [ Html.Attributes.class "row" ]
                    [ Html.div
                        [ Html.Attributes.class "col s12 input-field" ]
                        [ Html.i
                            [ Html.Events.onClick ( options.onRemove index )
                            , Html.Attributes.class "material-icons"
                            , Html.Attributes.class "prefix"
                            , Html.Attributes.class "red-text"
                            ]
                            [ Html.text "remove_circle" ]
                        , Html.input
                            [ Html.Attributes.value value
                            , Html.Events.onInput ( options.onUpdate index )
                            , Html.Attributes.id ( options.label ++ String.fromInt index )
                            , Html.Attributes.type_ "text"
                            ]
                            []
                        , Html.label
                            [ Html.Attributes.for ( options.label ++ String.fromInt index) ]
                            [ Html.text ( options.label ++ " " ) ]
                        ]
                    ]

        )
        values


toHtmlOption : ViewDropdownValue -> Html Msg
toHtmlOption ( value, text ) =
    Html.option
        [ Html.Attributes.value value ]
        [ Html.text text ]
        

viewDropdownValues : ViewDropdownValues -> List ( Html Msg )
viewDropdownValues values =
    List.map toHtmlOption values 


viewDropdown : ViewDropdownOptions -> ViewDropdownValues -> Html Msg
viewDropdown options values =
    Html.div
        [ Html.Attributes.class "row" ]
        [ Html.div
            [ Html.Attributes.class "col s12" ]
            [ Html.label
                [ Html.Attributes.for options.identifier ]
                [ Html.text options.label ]
            , Html.select
                [ Html.Events.onInput options.onSelection
                , Html.Attributes.id options.identifier
                , Html.Attributes.class "browser-default"
                ]
                ( viewDropdownValues values )
            ]
        ]


viewInput : ViewInputOptions -> Html Msg
viewInput options =
    Html.div
        [ Html.Attributes.class "row" ]
        [ Html.div
            [ Html.Attributes.class "col s12 input-field" ]
            [ Html.label
                [ Html.Attributes.for options.placeholder ]
                [ Html.text ( options.placeholder ++ " " ) ]
            , Html.input
                [ Html.Attributes.value options.value
                , Html.Events.onInput options.onInput
                , Html.Attributes.id options.placeholder
                , Html.Attributes.type_ "text"
                ]
                []
            ]
        ]


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Attributes.id "root"
        ]
        [ Html.ul
            [ Html.Attributes.class "sidenav"
            , Html.Attributes.id "mobile-menu"
            ]
            [ Html.li
                []
                [ Html.a
                    [ Html.Attributes.target "blank"
                    , Html.Attributes.href "https://github.com/aminnairi/package-json-generator"
                    ]
                    [ Html.i [ Html.Attributes.class "material-icons" ] [ Html.text "exit_to_app" ]
                    , Html.text "GitHub"
                    ]
                ]
            , Html.li
                []
                [ Html.a
                    [ Html.Attributes.target "blank"
                    , Html.Attributes.href "https://github.com/aminnairi/package-json-generator/issues"
                    ]
                    [ Html.i [ Html.Attributes.class "material-icons" ] [ Html.text "exit_to_app" ]
                    , Html.text "Issues"
                    ]
                ]
            , Html.li
                []
                [ Html.a
                    [ Html.Attributes.target "blank"
                    , Html.Attributes.href "https://docs.npmjs.com/files/package.json"
                    ]
                    [ Html.i [ Html.Attributes.class "material-icons" ] [ Html.text "exit_to_app" ]
                    , Html.text "Docs"
                    ]
                ]
            ]
        , Html.header
            []
            [ Html.div
                [ Html.Attributes.class "navbar-fixed" ]
                [ Html.nav
                    []
                    [ Html.div
                        [ Html.Attributes.class "nav-wrapper container" ]
                        [ Html.a
                            [ Html.Attributes.class "brand-logo" ]
                            [ Html.text "PJSONGEN" ]
                        , Html.a
                            [ Html.Attributes.class "sidenav-trigger"
                            , Html.Attributes.attribute "data-target" "mobile-menu"
                            ]
                            [ Html.i
                                [ Html.Attributes.class "material-icons" ]
                                [ Html.text "menu" ]
                            ]
                        , Html.ul
                            [ Html.Attributes.class "right"
                            , Html.Attributes.class "hide-on-med-and-down"
                            ]
                            [ Html.li
                                []
                                [ Html.a
                                    [ Html.Attributes.target "blank"
                                    , Html.Attributes.href "https://github.com/aminnairi/package-json-generator"
                                    ]
                                    [ Html.text "GitHub" ]
                                ]
                            , Html.li
                                []
                                [ Html.a
                                    [ Html.Attributes.target "blank"
                                    , Html.Attributes.href "https://github.com/aminnairi/package-json-generator/issues"
                                    ]
                                    [ Html.text "Issues" ]
                                ]
                            , Html.li
                                []
                                [ Html.a
                                    [ Html.Attributes.target "blank"
                                    , Html.Attributes.href "https://docs.npmjs.com/files/package.json"
                                    ]
                                    [ Html.text "Docs" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , Html.main_
            []
            [ Html.div
                [ Html.Attributes.class "container"
                ]
                [ Html.div
                    [ Html.Attributes.class "row" ]
                    [ Html.div
                        [ Html.Attributes.class "col s12 m6"
                        , Html.Attributes.id "settings"
                        ]
                        ( List.concat
                            [ [ Html.div [ Html.Attributes.class "row" ] [] ]
                            , [ viewDropdown
                                    { value         = if model.private then "true" else "false"
                                    , label         = "Private"
                                    , identifier    = "private"
                                    , onSelection   = UpdatePrivate
                                    }
                                    [ ( "true", "Yes" )
                                    , ( "false", "No" )
                                    ]
                              , viewDropdown
                                    { value         = String.fromInt model.spaces
                                    , label         = "Spaces"
                                    , identifier    = "spaces"
                                    , onSelection   = UpdateSpaces
                                    }
                                    [ ( "2", "2" )
                                    , ( "4", "4" )
                                    ]
                              , viewInput
                                    { placeholder   = "Name"
                                    , value         = model.name
                                    , onInput       = UpdateName
                                    }
                              , viewInput
                                    { placeholder   = "Version"
                                    , value         = model.version
                                    , onInput       = UpdateVersion
                                    }
                              , viewInput
                                    { placeholder   = "Description"
                                    , value         = model.description
                                    , onInput       = UpdateDescription
                                    }
                              , viewInput
                                    { placeholder   = "Home Page"
                                    , value         = model.homePage
                                    , onInput       = UpdateHomePage
                                    }
                              , viewInput
                                    { placeholder   = "Main Script"
                                    , value         = model.mainScript
                                    , onInput       = UpdateMainScript
                                    }
                              , viewInput
                                    { placeholder   = "Browser Script"
                                    , value         = model.browserScript
                                    , onInput       = UpdateBrowserScript
                                    }
                              , viewInput
                                    { placeholder   = "Node Engine"
                                    , value         = model.nodeEngine
                                    , onInput       = UpdateNodeEngine
                                    }
                              , viewInput
                                    { placeholder   = "NPM Engine"
                                    , value         = model.npmEngine
                                    , onInput       = UpdateNpmEngine
                                    }
                              , viewInput
                                    { placeholder   = "Bug URL"
                                    , value         = model.bugUrl
                                    , onInput       = UpdateBugUrl
                                    }
                              , viewInput
                                    { placeholder   = "Bug Email"
                                    , value         = model.bugEmail
                                    , onInput       = UpdateBugEmail
                                    }
                              , viewInput
                                    { placeholder   = "License"
                                    , value         = model.license
                                    , onInput       = UpdateLicense
                                    }
                              , viewInput
                                    { placeholder   = "Author Name"
                                    , value         = model.authorName
                                    , onInput       = UpdateAuthorName
                                    }
                              , viewInput
                                    { placeholder   = "Author Email"
                                    , value         = model.authorEmail
                                    , onInput       = UpdateAuthorEmail
                                    }
                              , viewInput
                                    { placeholder   = "Author URL"
                                    , value         = model.authorUrl
                                    , onInput       = UpdateAuthorUrl
                                    }
                              , viewInput
                                    { placeholder   = "Binary"
                                    , value         = model.binary
                                    , onInput       = UpdateBinary
                                    }
                              , viewInput
                                    { placeholder   = "Repository Type"
                                    , value         = model.repositoryType
                                    , onInput       = UpdateRepositoryType
                                    }
                              , viewInput
                                    { placeholder   = "Repository URL"
                                    , value         = model.repositoryUrl
                                    , onInput       = UpdateRepositoryUrl
                                    }
                              , viewInput
                                    { placeholder   = "Repository Directory"
                                    , value         = model.repositoryDirectory
                                    , onInput       = UpdateRepositoryDirectory
                                    }
                              ]
                            , viewInputs
                                { onAdd     = AddKeyword
                                , onUpdate  = UpdateKeyword
                                , onRemove  = RemoveKeyword
                                , label     = "Keyword"
                                } 
                                model.keywords
                            , viewInputs
                                { onAdd     = AddFile
                                , onUpdate  = UpdateFile
                                , onRemove  = RemoveFile
                                , label     = "File"
                                }
                                model.files
                            , viewInputs
                                { onAdd     = AddManPage
                                , onUpdate  = UpdateManPage
                                , onRemove  = RemoveManPage
                                , label     = "Man Page"
                                }
                                model.manPages
                            , viewInputs
                                { onAdd     = AddOperatingSystem
                                , onUpdate  = UpdateOperatingSystem
                                , onRemove  = RemoveOperatingSystem
                                , label     = "OS"
                                }
                                model.operatingSystems
                            , viewInputs
                                { onAdd     = AddCentralProcessUnit
                                , onUpdate  = UpdateCentralProcessUnit
                                , onRemove  = RemoveCentralProcessUnit
                                , label     = "CPU"
                                }
                                model.centralProcessUnits
                            ]
                        )
                    , Html.div
                        [ Html.Attributes.class "col"
                        , Html.Attributes.class "s12"
                        , Html.Attributes.class "m6"
                        , Html.Attributes.id "json"
                        ]
                        [  Html.div [ Html.Attributes.class "row" ] []
                        , viewJsonModel model
                        ]
                    ]
                ]
            ]
        ]

update : Msg -> Model -> Model
update msg model =
    case msg of
        AddKeyword ->
            { model | keywords = model.keywords ++ [ "" ] }

        UpdateKeyword index keyword ->
            { model | keywords = (List.take index model.keywords) ++ [keyword] ++ (List.drop (index + 1) model.keywords) }

        RemoveKeyword index ->
            { model | keywords = List.take index model.keywords ++ List.drop (index + 1) model.keywords }

        AddFile ->
            { model | files = model.files ++ [ "" ] }

        UpdateFile index file ->
            { model | files = (List.take index model.files) ++ [file] ++ (List.drop (index + 1) model.files) }

        RemoveFile index ->
            { model | files = List.take index model.files ++ List.drop (index + 1) model.files }

        AddManPage ->
            { model | manPages = model.manPages ++ [ "" ] }

        UpdateManPage index manPage ->
            { model | manPages = (List.take index model.manPages) ++ [manPage] ++ (List.drop (index + 1) model.manPages) }

        RemoveManPage index ->
            { model | manPages = List.take index model.manPages ++ List.drop (index + 1) model.manPages }

        AddOperatingSystem ->
            { model | operatingSystems = model.operatingSystems ++ [ "" ] }

        UpdateOperatingSystem index operatingSystem ->
            { model | operatingSystems = (List.take index model.operatingSystems) ++ [operatingSystem] ++ (List.drop (index + 1) model.operatingSystems) }

        RemoveOperatingSystem index ->
            { model | operatingSystems = List.take index model.operatingSystems ++ List.drop (index + 1) model.operatingSystems }

        AddCentralProcessUnit ->
            { model | centralProcessUnits = model.centralProcessUnits ++ [ "" ] }

        UpdateCentralProcessUnit index centralProcessUnit ->
            { model | centralProcessUnits = (List.take index model.centralProcessUnits) ++ [centralProcessUnit] ++ (List.drop (index + 1) model.centralProcessUnits) }

        RemoveCentralProcessUnit index ->
            { model | centralProcessUnits = List.take index model.centralProcessUnits ++ List.drop (index + 1) model.centralProcessUnits }

        UpdateName name ->
            { model | name = name }
            
        UpdateVersion version ->
            { model | version = version }

        UpdateDescription description ->
            { model | description = description }

        UpdateHomePage homePage ->
            { model | homePage = homePage }

        UpdateMainScript mainScript ->
            { model | mainScript = mainScript }

        UpdateBrowserScript browserScript ->
            { model | browserScript = browserScript }

        UpdatePrivate private ->
            { model | private = if private == "true" then True else False }

        UpdateNodeEngine nodeEngine ->
            { model | nodeEngine = nodeEngine }

        UpdateNpmEngine npmEngine ->
            { model | npmEngine = npmEngine }

        UpdateBugUrl bugUrl ->
            { model | bugUrl = bugUrl }

        UpdateBugEmail bugEmail ->
            { model | bugEmail = bugEmail }

        UpdateLicense license ->
            { model | license = license }

        UpdateAuthorName authorName ->
            { model | authorName = authorName }

        UpdateAuthorEmail authorEmail ->
            { model | authorEmail = authorEmail }

        UpdateAuthorUrl authorUrl ->
            { model | authorUrl = authorUrl }

        UpdateBinary binary ->
            { model | binary = binary }

        UpdateRepositoryType repositoryType ->
            { model | repositoryType = repositoryType }

        UpdateRepositoryUrl repositoryUrl ->
            { model | repositoryUrl = repositoryUrl }

        UpdateRepositoryDirectory repositoryDirectory ->
            { model | repositoryDirectory = repositoryDirectory }

        UpdateSpaces spaces ->
            { model | spaces = String.toInt spaces |> Maybe.withDefault 2 }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
