Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791BDC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Dec 2022 10:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiLWKPK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 05:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiLWKPJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 05:15:09 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C745596
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 02:15:06 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D769233C6A;
        Fri, 23 Dec 2022 10:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671790503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=GCELqGwmvhazyifRJfXTHdSNrVzeBrGeoTlvz2/RqgM=;
        b=uZ8Qxs3nJAUYl69b5/3b/cT4ddZIu2YWNoc6TEYUgzKni+KykurZcgI+pjOPZTiog4XsN+
        SCzyhakKKHxmb5Y8v1bxBR2ZK4M6qTF9vWPLCsqFEb8aSDZ+KCk85tP6m5uWAvfuUVxteg
        qwL/fv2SrULU9oAvZdxW3om70KxbbgE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671790503;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=GCELqGwmvhazyifRJfXTHdSNrVzeBrGeoTlvz2/RqgM=;
        b=fZnzM5LBu/UtFyVJHRIwLc792NjJviGPeirUaYMaihnoJEp6m4UVdPL8/Em1nHcetmWQtx
        1aDWm8z38jyzHbDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB897138E4;
        Fri, 23 Dec 2022 10:15:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xa6oMad/pWNTBAAAMHmgww
        (envelope-from <dwagner@suse.de>); Fri, 23 Dec 2022 10:15:03 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 0/2] Add initial support for meson
Date:   Fri, 23 Dec 2022 11:15:00 +0100
Message-Id: <20221223101502.12269-1-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This version is intergrating the libtracecmd static build directly
inside trace-cmd build. That means you don't need to build and install
libtracecmd first to be able to build trace-cmd. This should simplify
the development workflow.

The shared libtracecmd build is still possible and modelled as it's
own project (lib/meson.build).

With this, there is no need to change anything in the current project
layout or development work flow, which I assume is helping getting
meson added :)

Changes:
v2:
  - make audit dependency optional as default
  - integrate static libtracecmd build into trace-cmd directly
  - remove check-manpages target in trace-cmd

v1:
  - initial version

Daniel Wagner (2):
  libtracecmd: Add initial support for meson
  trace-cmd: Add initial support for meson

 Documentation/libtracecmd/meson.build     | 117 +++++++++++++++++++++
 Documentation/list-txt.sh                 |   5 +
 Documentation/trace-cmd/meson.build       | 117 +++++++++++++++++++++
 lib/Documentation                         |   1 +
 lib/meson.build                           | 109 ++++++++++++++++++++
 lib/meson_options.txt                     |  21 ++++
 lib/trace-cmd/include/meson.build         |   5 +
 lib/trace-cmd/include/private/meson.build |  14 +++
 lib/trace-cmd/meson.build                 |  81 +++++++++++++++
 meson.build                               | 119 ++++++++++++++++++++++
 meson_options.txt                         |  23 +++++
 python/meson.build                        |  40 ++++++++
 tracecmd/meson.build                      |  55 ++++++++++
 utest/meson.build                         |  25 +++++
 14 files changed, 732 insertions(+)
 create mode 100644 Documentation/libtracecmd/meson.build
 create mode 100644 Documentation/list-txt.sh
 create mode 100644 Documentation/trace-cmd/meson.build
 create mode 120000 lib/Documentation
 create mode 100644 lib/meson.build
 create mode 100644 lib/meson_options.txt
 create mode 100644 lib/trace-cmd/include/meson.build
 create mode 100644 lib/trace-cmd/include/private/meson.build
 create mode 100644 lib/trace-cmd/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100644 python/meson.build
 create mode 100644 tracecmd/meson.build
 create mode 100644 utest/meson.build

-- 
2.39.0

