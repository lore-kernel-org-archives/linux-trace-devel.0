Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936B0C636CD
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Feb 2023 12:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjBGMqj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 07:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjBGMqi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 07:46:38 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF8AAF
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Feb 2023 04:46:37 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1750738D10;
        Tue,  7 Feb 2023 12:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675773996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=q3Iq5tbVVzTzfQPe5btlEi3X5IuvBVz4YtsCDvO2VLQ=;
        b=YAwP/9HtAwxQqngE68Ea2UFtjxmNbAjmE+OpbGyghdgxkPMy3XtRa+wq+0uHu1Jb6ngZrW
        gbTd4nGZfkBBKx29sinbjKuQJhCfgXhxTCOruN279U+IDMn+SFOF/uLPQipwG4fCsXEEHC
        GcigC+0nrDVcffoQeehouk88AiFfgHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675773996;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=q3Iq5tbVVzTzfQPe5btlEi3X5IuvBVz4YtsCDvO2VLQ=;
        b=capbot/yhHX+ihX+NphMVBEgcmtS3VgWM0/SUOrIvnvPZmsG2p2F/WoI8/7BDtG4u/8rCW
        PpKn4KVYyZTBinAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0786E13467;
        Tue,  7 Feb 2023 12:46:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bkWVASxI4mN2XwAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 07 Feb 2023 12:46:36 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v6 0/2] Add initial support for meson
Date:   Tue,  7 Feb 2023 13:46:32 +0100
Message-Id: <20230207124634.6515-1-dwagner@suse.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This version brings a few cleanups on the documentation intallation path
and pkg-config depenedency updates.

Changes:

v6:
  - lib: isntall trace-cmd.h directly in /usr/include and not subdir
    trace-cmd. kernelshark builds breaks otherwise

v5:
  - lib: set default html doc path to share/doc/libtracemd-doc
  - lib: list libtraceevent and libtracefs in Required pkg-config section.
  - lib: install (any) man5 pages (keep it in sync with other projects)
  - trace-cmd: install (any) man5 pages (keep it in sync with other projects)
  - trace-cmd: set default html doch patch to share/doc/trace-cmd-doc

v4:
  - changed project defaults to --default-library=both
  - code style consistency updates
  - hardening doc install script (shellcheck)
  - renamed install-man.sh.in to install-docs.sh.in
  - install-docs.sh.in installs html pages too
  - introduces docs target
  - updated copyright year
  - streamlined documentation meson build file

v3:
  - generate tc_version.h file
  - lib: cleaning up the standalone build vs trace-cmd build
  - s/conf10.set/conf.set10/
  - default build target is debug
  - do not install man pages into subdirs

v2:
  - make audit dependency optional as default
  - integrate static libtracecmd build into trace-cmd directly
  - remove check-manpages target in trace-cmd

v1:
  - initial version

Daniel Wagner (2):
  libtracecmd: Add initial support for meson
  trace-cmd: Add initial support for meson

 Documentation/libtracecmd/install-docs.sh.in |  20 ++
 Documentation/libtracecmd/meson.build        | 168 +++++++++++++++++
 Documentation/trace-cmd/install-docs.sh.in   |  20 ++
 Documentation/trace-cmd/meson.build          | 187 +++++++++++++++++++
 lib/Documentation                            |   1 +
 lib/check-manpages.sh                        |   1 +
 lib/meson.build                              | 112 +++++++++++
 lib/meson_options.txt                        |  19 ++
 lib/trace-cmd/include/meson.build            |   5 +
 lib/trace-cmd/include/private/meson.build    |  14 ++
 lib/trace-cmd/meson.build                    |  87 +++++++++
 meson-vcs-tag.sh                             |  17 ++
 meson.build                                  | 149 +++++++++++++++
 meson_options.txt                            |  23 +++
 python/meson.build                           |  40 ++++
 tracecmd/meson.build                         |  59 ++++++
 utest/meson.build                            |  26 +++
 17 files changed, 948 insertions(+)
 create mode 100755 Documentation/libtracecmd/install-docs.sh.in
 create mode 100644 Documentation/libtracecmd/meson.build
 create mode 100755 Documentation/trace-cmd/install-docs.sh.in
 create mode 100644 Documentation/trace-cmd/meson.build
 create mode 120000 lib/Documentation
 create mode 120000 lib/check-manpages.sh
 create mode 100644 lib/meson.build
 create mode 100644 lib/meson_options.txt
 create mode 100644 lib/trace-cmd/include/meson.build
 create mode 100644 lib/trace-cmd/include/private/meson.build
 create mode 100644 lib/trace-cmd/meson.build
 create mode 100755 meson-vcs-tag.sh
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100644 python/meson.build
 create mode 100644 tracecmd/meson.build
 create mode 100644 utest/meson.build

-- 
2.39.1

