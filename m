Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067F0C001DB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 03:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjHIDNX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 23:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjHIDNS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 23:13:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5E71FC3
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 20:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF5DC62EFA
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 03:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C16C433CA;
        Wed,  9 Aug 2023 03:13:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qTZdL-005Rvd-2f;
        Tue, 08 Aug 2023 23:13:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/6] libtraceeval histogram: Updates
Date:   Tue,  8 Aug 2023 23:13:07 -0400
Message-Id: <20230809031313.1298605-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

This patch set is based on top of:

 https://lore.kernel.org/all/20230808161204.5704-1-stevie.6strings@gmail.com/

I added a sample program task-eval which is one of the tools that will be
using this library. The first patch adds task-eval but that is still using
the old API (defined in trace-analysis.c).

The next patches modify the new API to fit with the use case of task-eval.
One is to use "pointer" as I'm not sure exactly the usecase of the dynamic
structure.

The cmp and release callbacks are changed to be more generic, and they get
called if they simply exist for a given type. I can imagine wanting a
release function for event the most mundane types (like number_32).

The cmp was also updated to pass in the traceeval descriptor, as I found
that I needed access to it while doing a compare (although, I rewrote the
code a bit where that use case isn't in the tool anymore).

Some fixes were made to the query.

The last patch updates the task-eval to use the new API. It added stubs that
are needed for the display portion. These can be implemented later.

Note, when running the new task-eval, it crashes immediately, so there's
lots of bugs to still fix in the existing histogram code.

Happy programming!

Steven Rostedt (Google) (6):
  libtraceeval: Add sample task-eval program
  libtraceeval hist: Add pointer and const string types
  libtraceeval histogram: Have cmp and release functions be generic
  libtraceeval histograms: Add traceeval struct to compare function
  libtraceeval histogram: Fix the return value of traceeval_query()
  libtraceeval samples: Update task-eval to use the histogram logic

 Makefile                 |   3 +
 include/traceeval-hist.h |  38 +-
 samples/Makefile         |  29 ++
 samples/task-eval.c      | 948 +++++++++++++++++++++++++++++++++++++++
 src/histograms.c         |  48 +-
 5 files changed, 1026 insertions(+), 40 deletions(-)
 create mode 100644 samples/Makefile
 create mode 100644 samples/task-eval.c

-- 
2.40.1

