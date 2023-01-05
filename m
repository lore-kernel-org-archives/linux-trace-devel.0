Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F99C3DA7D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 12:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjAEMMT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 07:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbjAEMMS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 07:12:18 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132EE559DE
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 04:12:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 08079200F5;
        Thu,  5 Jan 2023 12:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672920733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=uIYwpy5TsO3K7RJpBIIkZrTwfg3ap2SftDpAWFSiMiY=;
        b=PDG+7vnZmZyKD/xtU1r0++RO0sZi9IyEL2iRDKzJfegc6H+ZUNp5Lkr8Y1IattI668EDai
        m/1ZXEhpHGTDTPfac5Fb3oKZPa3mBgzVpk0Za6ECLMuO3/mNBKzHW+0t3CEO05WyP9JXQV
        LvIB6f70I3bWzL9EEdfnEG5lgfh2pi0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672920733;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=uIYwpy5TsO3K7RJpBIIkZrTwfg3ap2SftDpAWFSiMiY=;
        b=heExkU/LLAfPAd31lsf1gNjRQb/Bg67SO6em/Ckicvhmnp31gDVpEN5NIJKYUwamPqbU4+
        1v//+nH7hSA90jAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EAE6D138DF;
        Thu,  5 Jan 2023 12:12:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7LypOJy+tmPqRgAAMHmgww
        (envelope-from <dwagner@suse.de>); Thu, 05 Jan 2023 12:12:12 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v4 0/2] Add initial support for meson
Date:   Thu,  5 Jan 2023 13:12:09 +0100
Message-Id: <20230105121211.11960-1-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This version brings a lot of small changes to make all a bit more consistent and
streamlined with the version in the libraries, e.g. the documentation meson
build file differs just in the file list.

Also documantation is now build via the the new 'docs' target.


Changes:
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

*** BLURB HERE ***

Daniel Wagner (2):
  libtracecmd: Add initial support for meson
  trace-cmd: Add initial support for meson

 Documentation/libtracecmd/install-docs.sh.in |  20 ++
 Documentation/libtracecmd/meson.build        | 168 +++++++++++++++++
 Documentation/trace-cmd/install-docs.sh.in   |  20 ++
 Documentation/trace-cmd/meson.build          | 187 +++++++++++++++++++
 lib/Documentation                            |   1 +
 lib/check-manpages.sh                        |   1 +
 lib/meson.build                              | 114 +++++++++++
 lib/meson_options.txt                        |  19 ++
 lib/trace-cmd/include/meson.build            |   5 +
 lib/trace-cmd/include/private/meson.build    |  14 ++
 lib/trace-cmd/meson.build                    |  84 +++++++++
 meson-vcs-tag.sh                             |  17 ++
 meson.build                                  | 149 +++++++++++++++
 meson_options.txt                            |  23 +++
 python/meson.build                           |  40 ++++
 tracecmd/meson.build                         |  59 ++++++
 utest/meson.build                            |  26 +++
 17 files changed, 947 insertions(+)
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
2.39.0

