module Animals.OutsideWorld.Cmd exposing
  ( fetchAnimals
  , askTodaysDate
  , saveAnimal
  , createAnimal
  )
import Animals.OutsideWorld.Json as Json
import Animals.Animal.Types exposing (..)
import Animals.Msg exposing (..)
import Date
import Dict exposing (Dict)
import Task
import Http

askTodaysDate =
  Task.perform (SetToday << Just) Date.now

fetchAnimals =
  let
    url = "/api/v2animals"
    request = Http.get url (Json.withinData Json.decodeAnimals)
  in
    Http.send (handleResult "I could not retrieve animals." SetAnimals) request

saveAnimal animal =
  let
    url = "/api/v2animals/"
    body = animal |> Json.encodeAnimal |> Json.asData |> Http.jsonBody
    request = Http.post url body (Json.withinData Json.decodeSaveResult)
  in
    Http.send NoticeAnimalSaveResults request

createAnimal animal =
  let
    url = "/api/v2animals/create/" ++ animal.id
    body = animal |> Json.encodeAnimal |> Json.asData |> Http.jsonBody
    request = Http.post url body (Json.withinData Json.decodeCreationResult)
  in
    Http.send NoticeAnimalCreationResults request

handleResult failureContext successF result =
  case result of
    Ok data ->
      successF data
    Err e ->
      Incoming (HttpError failureContext e)
