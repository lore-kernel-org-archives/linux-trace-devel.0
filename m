Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DE3C2BBCF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC9AC23B19
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgLIEWC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 23:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgLIEWC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 23:22:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76AE823AFE
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 04:21:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmqye-0002yU-57
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 23:21:20 -0500
Message-ID: <20201209041946.131377586@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 23:19:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/6] libtraceevent: Clean up source directory
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Did some Makefile maintenance and cleaned up the source directory. Added a
"lib" directory for the libraries to be installed in, and a "src" directory
to hold the C code and header files. And some various other Makefile
maintenance.

Steven Rostedt (VMware) (6):
      libtraceevent: Use macro names for libtraceevent library binaries
      libtraceevent: Remove "src" and "obj" from Makefile
      libtraceevent: Move creation of PKG_CONFIG_FILE to after Makefile.include
      libtraceevent: Have make clean honor the output (O=foo) directory
      libtraceevent: Have binary libraries build into lib directory
      libtraceevent: Move source files into src/ directory

----
 Makefile                                       | 53 ++++++++++++++++----------
 plugins/Makefile                               |  9 +++--
 Build => src/Build                             |  0
 src/Makefile                                   | 12 ++++++
 event-parse-api.c => src/event-parse-api.c     |  0
 event-parse-local.h => src/event-parse-local.h |  0
 event-parse.c => src/event-parse.c             |  0
 event-parse.h => src/event-parse.h             |  0
 event-plugin.c => src/event-plugin.c           |  0
 event-utils.h => src/event-utils.h             |  0
 kbuffer-parse.c => src/kbuffer-parse.c         |  0
 kbuffer.h => src/kbuffer.h                     |  0
 parse-filter.c => src/parse-filter.c           |  0
 parse-utils.c => src/parse-utils.c             |  0
 tep_strerror.c => src/tep_strerror.c           |  0
 trace-seq.c => src/trace-seq.c                 |  0
 trace-seq.h => src/trace-seq.h                 |  0
 17 files changed, 50 insertions(+), 24 deletions(-)
 rename Build => src/Build (100%)
 create mode 100644 src/Makefile
 rename event-parse-api.c => src/event-parse-api.c (100%)
 rename event-parse-local.h => src/event-parse-local.h (100%)
 rename event-parse.c => src/event-parse.c (100%)
 rename event-parse.h => src/event-parse.h (100%)
 rename event-plugin.c => src/event-plugin.c (100%)
 rename event-utils.h => src/event-utils.h (100%)
 rename kbuffer-parse.c => src/kbuffer-parse.c (100%)
 rename kbuffer.h => src/kbuffer.h (100%)
 rename parse-filter.c => src/parse-filter.c (100%)
 rename parse-utils.c => src/parse-utils.c (100%)
 rename tep_strerror.c => src/tep_strerror.c (100%)
 rename trace-seq.c => src/trace-seq.c (100%)
 rename trace-seq.h => src/trace-seq.h (100%)
