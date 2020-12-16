Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67682C2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34ED12335A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgLPEmy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:42:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgLPEmy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:42:54 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AA952312E
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:42:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOdg-000qxK-TK
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:42:12 -0500
Message-ID: <20201216044150.375001748@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:41:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/12] trace-cmd: Updates to the Makefile
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Steven Rostedt (VMware) (12):
      trace-cmd: Move do_make_pkgconfig_file to utils.mk
      trace-cmd: Have etcdir always be at the root directory
      trace-cmd: Remove unused variable LD_SO_CONF_DIR
      trace-cmd: Use the LIBTRACE{EVENT,FS}_LIBS for building libtracecmd.so
      libtracecmd: Update ld.so.conf.d/trace.conf if needed
      libtracecmd: Make installing show a nice INSTALL output
      libtracecmd: Build libtracecmd.pc when building the library
      libtracecmd: Show building of libtracecmd.pc
      libtracecmd: Install libtracecmd.pc when installing libs
      trace-cmd: Add make uninstall
      trace-cmd: Update libtracecmd.pc if prefix is different
      trace-cmd: Keep build_install files around

----
 .gitignore             |  4 ++++
 Makefile               | 62 ++++++++++++++++++++++++++++++++++----------------
 lib/trace-cmd/Makefile | 39 +++++++++++++++++++++++++++----
 lib/trace-cmd/test.c   |  7 ++++++
 scripts/utils.mk       | 21 +++++++++++++++++
 5 files changed, 109 insertions(+), 24 deletions(-)
 create mode 100644 lib/trace-cmd/test.c
