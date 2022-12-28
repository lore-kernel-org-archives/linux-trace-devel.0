Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7AFC46467
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Dec 2022 08:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiL1I3w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Dec 2022 03:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiL1I3u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Dec 2022 03:29:50 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DA3F02D
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Dec 2022 00:29:48 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6093975C69;
        Wed, 28 Dec 2022 08:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672216187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hxGDhPBnLjpNyeOofHGjuvm4ZnVzCVSn39Nuewe2ibI=;
        b=jkf+QQOXl7Fxf+Kp2pdNlGADH3Rjqq+AtHhSXoxPp9AADbmPhnmwqblOWz+9jGh064hlKh
        HhJL3lx/vk3vfeDem+OBh1z/ebpQi0Rz3Ac18eSnigclzR+y8oNYwe9ZVhYqRjGARLGJ7b
        3fFnD4Qq72J9lu5TvggQUa/Uj8NtOjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672216187;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hxGDhPBnLjpNyeOofHGjuvm4ZnVzCVSn39Nuewe2ibI=;
        b=W1OpMOQlgq0sViZBM+kzHPIduXmZQ1FUOdPpTV5xIXZ8BvBS/RCxtBLEqC4ayllfxMw1VC
        RfNih9BdAv55TRCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 54599134F5;
        Wed, 28 Dec 2022 08:29:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Lah1FHv+q2MsQQAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 28 Dec 2022 08:29:47 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v3 0/2] Add initial support for meson
Date:   Wed, 28 Dec 2022 09:29:41 +0100
Message-Id: <20221228082943.3599-1-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I had to fallback to use a workaround to install the man pages to the
correct directory. Meson insistet to install them into subdirs and
failed to install them when I forced Meson not to do this. I am sure I
am doing something wrong but couldn't figure out what. I think
it's okay to use the workaround until we figured how to do this
'correct'.

Tested this by packaging it up for OpenSUSE and the it looks
reasonable:

https://build.opensuse.org/project/show/home:wagi:branches:devel:tools

Changes:
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

 Documentation/libtracecmd/install-man.sh.in |  15 ++
 Documentation/libtracecmd/meson.build       | 148 +++++++++++++++++
 Documentation/trace-cmd/install-man.sh.in   |  10 ++
 Documentation/trace-cmd/meson.build         | 167 ++++++++++++++++++++
 lib/Documentation                           |   1 +
 lib/meson.build                             | 112 +++++++++++++
 lib/meson_options.txt                       |  21 +++
 lib/trace-cmd/include/meson.build           |   5 +
 lib/trace-cmd/include/private/meson.build   |  14 ++
 lib/trace-cmd/meson.build                   |  83 ++++++++++
 meson-vcs-tag.sh                            |  17 ++
 meson.build                                 | 144 +++++++++++++++++
 meson_options.txt                           |  25 +++
 python/meson.build                          |  40 +++++
 tracecmd/meson.build                        |  57 +++++++
 utest/meson.build                           |  25 +++
 16 files changed, 884 insertions(+)
 create mode 100755 Documentation/libtracecmd/install-man.sh.in
 create mode 100644 Documentation/libtracecmd/meson.build
 create mode 100755 Documentation/trace-cmd/install-man.sh.in
 create mode 100644 Documentation/trace-cmd/meson.build
 create mode 120000 lib/Documentation
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

