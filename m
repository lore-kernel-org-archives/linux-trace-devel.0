Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0148CC61DB3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Jan 2023 16:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbjAJQW7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Jan 2023 11:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238019AbjAJQWu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Jan 2023 11:22:50 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3AC5E096
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Jan 2023 08:22:48 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 949D57629A;
        Tue, 10 Jan 2023 16:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673367766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=MKEpr8IboAKEZ3siAlYMqHYhaRa2VuKVBeVufLMeWL8=;
        b=tXTLKULlpOoQltjSKEZ1/8OSHW7w1cgknXifm6IDRtv5ePAL2n2b4Mj0Q6its+v9edA9tw
        33ThTPSCGaYoMbKXjRjG2vTTlOLBM9Nru8qMTop8mXOUwfEREXWy1MRNgEA2mLBBgJP7G1
        beCfQTcYQMPW/q8qCqvkpW/0upRBSHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673367766;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=MKEpr8IboAKEZ3siAlYMqHYhaRa2VuKVBeVufLMeWL8=;
        b=j/0cliAGZbc4ukHDE9G0W4y8dIm4Ol/8tzlTa3W2ezPIrHOBQ3JHDjutdjWv8S1Ei8OBpJ
        ImPGuSqZ75M6qABg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 859A81358A;
        Tue, 10 Jan 2023 16:22:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ucqFINaQvWNyIAAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 10 Jan 2023 16:22:46 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v5 0/2] Add initial support for meson
Date:   Tue, 10 Jan 2023 17:22:42 +0100
Message-Id: <20230110162244.23742-1-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This version brings a few cleanups on the documentation intallation path
and pkg-config depenedency updates.

Changes:

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
 lib/meson.build                              | 114 +++++++++++
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
 17 files changed, 950 insertions(+)
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

