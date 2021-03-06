function main()
    local account = IMAP {
        server = 'imap.gmail.com',
        username = 'baptiste.wicht@gmail.com',
        password = get_imap_password(".password.offlineimaprc"),
        ssl = 'tls1',
    }

    -- Make sure the account is configured properly
    account.INBOX:check_status()
    account['[Gmail]/Trash']:check_status()
    account['[Gmail]/Spam']:check_status()

    -- Get all mail from INBOX
    mails = account.INBOX:select_all()

    -- Move mailing lists from INBOX to correct folders
    move_mailing_lists(account, mails)

    -- Delete some trash
    delete_mail_from(account, mails, "enews@rockabilia.com");
    delete_mail_from(account, mails, "updates@comms.packtpub.com");
    delete_mail_from(account, mails, "vaultlist@enterthevault.com");
    delete_mail_from(account, mails, "Inneke.Berghmans@PPW.KULEUVEN.BE");

    delete_mail_if_subject_contains(account, mails, "[CSSeminars] ");

    -- Get all mail from trash
    mails = account['[Gmail]/Trash']:select_all()

    -- Move mailing lists from trash to correct folders
    move_mailing_lists(account, mails)

    -- Get all mail from spam
    mails = account['[Gmail]/Spam']:select_all()

    -- Move mailing lists from spam to correct folders
    move_mailing_lists(account, mails)

    move_if_from_contains(account, mails, "edarling.ch", "INBOX")
end

function move_mailing_lists(account, mails)
    -- ISOCPP mailing lists
    move_if_subject_contains(account, mails, "[std-proposals]", "ML/ISOCPP")
    move_if_subject_contains(account, mails, "[std-discussion]", "ML/ISOCPP")

    -- Boost mailing lists
    move_if_subject_contains(account, mails, "[Boost-users]", "ML/Boost")
    move_if_subject_contains(account, mails, "[Spirit-general]", "ML/Boost Spirit")

    -- Gentoo mailing lists
    move_if_subject_contains(account, mails, "[gentoo-announce]", "ML/Gentoo")
    move_if_subject_contains(account, mails, "[gentoo-amd64]", "ML/Gentoo")
    move_if_subject_contains(account, mails, "[gentoo-kernel]", "ML/Gentoo")

    -- Doxygen mailing list
    move_if_subject_contains(account, mails, "[Doxygen-users]", "ML/Doxygen")

    -- CLang mailing list
    move_if_subject_contains(account, mails, "[cfe-users]", "ML/CLang")

    -- Mutt mailing list
    move_if_to_contains(account, mails, "mutt-users@mutt.org", "ML/Mutt")

    -- Awesome mailing List
    move_if_to_contains(account, mails, "awesome@naquadah.org", "ML/Awesome")

    -- Awesome mailing List
    move_if_to_contains(account, mails, "ranger-users@nongnu.org", "ML/Ranger")
end

function move_if_subject_contains(account, mails, subject, mailbox)
    filtered = mails:contain_subject(subject)
    filtered:move_messages(account[mailbox]);
end

function move_if_to_contains(account, mails, to, mailbox)
    filtered = mails:contain_to(to)
    filtered:move_messages(account[mailbox]);
end

function move_if_from_contains(account, mails, from, mailbox)
    filtered = mails:contain_from(from)
    filtered:move_messages(account[mailbox]);
end

function delete_mail_from(account, mails, from)
    filtered = mails:contain_from(from)
    filtered:delete_messages()
end

function delete_mail_if_subject_contains(account, mails, subject)
    filtered = mails:contain_subject(subject)
    filtered:delete_messages()
end

-- Utility function to get IMAP password from file
function get_imap_password(file)
    local home = os.getenv("HOME")
    local file = home .. "/" .. file
    local str = io.open(file):read()
    return str;
end

main() -- Call the main function