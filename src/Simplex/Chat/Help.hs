{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}

module Simplex.Chat.Help
  ( chatWelcome,
    chatHelpInfo,
    filesHelpInfo,
    groupsHelpInfo,
    myAddressHelpInfo,
    markdownInfo,
  )
where

import Data.List (intersperse)
import Data.Text (Text)
import qualified Data.Text as T
import Simplex.Chat.Markdown
import Simplex.Chat.Styled
import Simplex.Chat.Types (Onboarding (..), Profile (..), User (..))
import System.Console.ANSI.Types

highlight :: Text -> Markdown
highlight = Markdown (Colored Cyan)

blue :: Text -> Markdown
blue = Markdown (Colored Blue)

cyan :: Text -> Markdown
cyan = Markdown (Colored Cyan)

yellow :: Text -> Markdown
yellow = Markdown (Colored Yellow)

green :: Text -> Markdown
green = Markdown (Colored Green)

indent :: Markdown
indent = "        "

listHighlight :: [Text] -> Markdown
listHighlight = mconcat . intersperse ", " . map highlight

chatWelcome :: User -> Onboarding -> [StyledString]
chatWelcome user Onboarding {contactsCount, createdGroups, membersCount, filesSentCount, addressCount} =
  map
    styleMarkdown
    [ blue "                             __   __",
      cyan "  ___ ___ __  __ ___ _    ___" <> blue "\\ \\ / /" <> yellow " ___ _  _   _ _____",
      cyan " / __|_ _|  \\/  | _ \\ |  | __ " <> blue "\\ V /" <> yellow " / __| || | /_\\_   _|",
      cyan " \\__ \\| || |\\/| |  _/ |__| _|" <> blue " / . \\" <> yellow "| (__| __ |/ _ \\| |",
      cyan " |___/___|_|  |_|_| |____|___" <> blue "/_/ \\_\\" <> yellow "\\___|_||_/_/ \\_\\_|",
      "",
      "Welcome " <> green userName <> "!",
      "Thank you for installing SimpleX Chat!",
      "",
      "To try out how it works:",
      "[" <> check (contactsCount >= 2) <> "] connect with 2 friends - " <> highlight "/help" <> " for instructions",
      "[" <> check (createdGroups >= 1 && membersCount >= 2) <> "] create a group with them - " <> highlight "/group #friends",
      "[" <> check (filesSentCount >= 1) <> "] send your photo, e.g. to the group - " <> highlight "/file #friends ./photo.jpg",
      "[" <> check (addressCount >= 1) <> "] create your chat " <> highlight "/address" <> " and share it with your friends",
      "",
      "To help us build SimpleX Chat:",
      "> star GitHub repo: https://github.com/simplex-chat/simplex-chat",
      "> join Reddit group: https://www.reddit.com/r/SimpleXChat/",
      "",
      "To show this message again - " <> highlight "/welcome"
    ]
  where
    User {profile = Profile {displayName, fullName}} = user
    userName = if T.null fullName then displayName else fullName
    check c = if c then green "*" else " "

chatHelpInfo :: [StyledString]
chatHelpInfo =
  map
    styleMarkdown
    [ highlight "Using SimpleX Chat",
      "Follow these steps to set up a connection:",
      "",
      green "Step 1: " <> highlight "/connect" <> " - Alice adds a contact.",
      indent <> "Alice should send the one-time invitation printed by the /connect command",
      indent <> "to her contact, Bob, out-of-band, via any trusted channel.",
      "",
      green "Step 2: " <> highlight "/connect <invitation>" <> " - Bob accepts the invitation.",
      indent <> "Bob should use the invitation he received out-of-band.",
      "",
      green "Step 3: " <> "Bob and Alice are notified that the connection is set up,",
      indent <> "both can now send messages:",
      indent <> highlight "@bob Hello, Bob!" <> " - Alice messages Bob (assuming Bob has display name 'bob').",
      indent <> highlight "@alice Hey, Alice!" <> " - Bob replies to Alice.",
      "",
      green "Send file: " <> highlight "/file bob ./photo.jpg" <> " (see /help files)",
      "",
      green "Create group: " <> highlight "/group team" <> " (see /help groups)",
      "",
      green "Create your address: " <> highlight "/address" <> " (see /help address)",
      "",
      green "Other commands:",
      indent <> highlight "/profile         " <> " - show / update user profile",
      indent <> highlight "/delete <contact>" <> " - delete contact and all messages with them",
      indent <> highlight "/contacts        " <> " - list contacts",
      indent <> highlight "/markdown        " <> " - supported markdown syntax",
      indent <> highlight "/version         " <> " - SimpleX Chat version",
      indent <> highlight "/quit            " <> " - quit chat",
      "",
      "The commands may be abbreviated: " <> listHighlight ["/c", "/f", "/g", "/p", "/ad"] <> ", etc."
    ]

filesHelpInfo :: [StyledString]
filesHelpInfo =
  map
    styleMarkdown
    [ green "File transfer commands:",
      indent <> highlight "/file @<contact> <file_path>     " <> " - send file to contact",
      indent <> highlight "/file #<group> <file_path>       " <> " - send file to group",
      indent <> highlight "/freceive <file_id> [<file_path>]" <> " - accept to receive file",
      indent <> highlight "/fcancel <file_id>               " <> " - cancel sending / receiving file",
      indent <> highlight "/fstatus <file_id>               " <> " - show file transfer status",
      "",
      "The commands may be abbreviated: " <> listHighlight ["/f", "/fr", "/fc", "/fs"]
    ]

groupsHelpInfo :: [StyledString]
groupsHelpInfo =
  map
    styleMarkdown
    [ green "Group management commands:",
      indent <> highlight "/group <group> [<full_name>]   " <> " - create group",
      indent <> highlight "/add <group> <contact> [<role>]" <> " - add contact to group, roles: " <> highlight "owner" <> ", " <> highlight "admin" <> " (default), " <> highlight "member",
      indent <> highlight "/join <group>                  " <> " - accept group invitation",
      indent <> highlight "/remove <group> <member>       " <> " - remove member from group",
      indent <> highlight "/leave <group>                 " <> " - leave group",
      indent <> highlight "/delete <group>                " <> " - delete group",
      indent <> highlight "/members <group>               " <> " - list group members",
      indent <> highlight "/groups                        " <> " - list groups",
      indent <> highlight "#<group> <message>             " <> " - send message to group",
      "",
      "The commands may be abbreviated: " <> listHighlight ["/g", "/a", "/j", "/rm", "/l", "/d", "/ms", "/gs"]
    ]

myAddressHelpInfo :: [StyledString]
myAddressHelpInfo =
  map
    styleMarkdown
    [ green "Your contact address commands:",
      indent <> highlight "/address       " <> " - create your address",
      indent <> highlight "/delete_address" <> " - delete your address (accepted contacts will remain connected)",
      indent <> highlight "/show_address  " <> " - show your address",
      indent <> highlight "/accept <name> " <> " - accept contact request",
      indent <> highlight "/reject <name> " <> " - reject contact request",
      "",
      "Please note: you can receive spam contact requests, but it's safe to delete the address!",
      "",
      "The commands may be abbreviated: " <> listHighlight ["/ad", "/da", "/sa", "/ac", "/rc"]
    ]

markdownInfo :: [StyledString]
markdownInfo =
  map
    styleMarkdown
    [ green "Markdown:",
      indent <> highlight "*bold*         " <> " - " <> Markdown Bold "bold text",
      indent <> highlight "_italic_       " <> " - " <> Markdown Italic "italic text" <> " (shown as underlined)",
      indent <> highlight "+underlined+   " <> " - " <> Markdown Underline "underlined text",
      indent <> highlight "~strikethrough~" <> " - " <> Markdown StrikeThrough "strikethrough text" <> " (shown as inverse)",
      indent <> highlight "`code snippet` " <> " - " <> Markdown Snippet "a + b // no *markdown* here",
      indent <> highlight "!1 text!       " <> " - " <> Markdown (Colored Red) "red text" <> " (1-6: red, green, blue, yellow, cyan, magenta)",
      indent <> highlight "#secret#       " <> " - " <> Markdown Secret "secret text" <> " (can be copy-pasted)"
    ]
