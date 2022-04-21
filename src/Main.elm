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
    , viewModel model
    ]


viewCheckbox : String -> Bool -> ( Bool -> Message ) -> Html Message
viewCheckbox label checked onCheck =
  Html.div
    []
    [ Html.label [ Html.Attributes.for label ] [ Html.text label ]
    , Html.input
      [ Html.Attributes.id label
      , Html.Attributes.type_ "checkbox"
      , Html.Attributes.checked checked
      , Html.Events.onCheck onCheck
      ]
      []
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
        [ ( "name", Json.Encode.string model.name )
        , ( "description", Json.Encode.string model.description )
        , ( "version", Json.Encode.string model.version )
        , ( "homapege", Json.Encode.string model.homepage )
        , ( "license", Json.Encode.string model.license )
        , ( "main", Json.Encode.string model.main )
        , ( "browser", Json.Encode.string model.browser )
        , ( "private", Json.Encode.bool model.private )
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
  , private = True
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
