Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E97DC433E9
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35506650AC
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCEW7w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 17:59:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhCEW7s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 17:59:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 760996509E
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 22:59:48 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lIJQB-00208K-BI
        for linux-trace-devel@vger.kernel.org; Fri, 05 Mar 2021 17:59:47 -0500
Message-ID: <20210305225223.794554327@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 05 Mar 2021 17:52:23 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/9 v2] trace-cmd: Fixes for trace-cmd restore
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd restore has been broken for some time. This series
fixes it.

Changes since v1:

 - Have tracecmd_read_headers() pass in the state to stop at.
   It can also be called multiple times and it will continue where
   it left off.

 - tracecmd_copy_headers() now takes a start and end state, to
   allow it to be called more than once (and uses tracecmd_read_headers()
   ability to be called more than once and restart where it left off)

 - tracecmd_get_file_state() returns an enum and not long.


Steven Rostedt (VMware) (9):
      trace-cmd restore: Fix to add saved cmdlines after calling tracecmd_create_init_file_override()
      trace-cmd: Move tracecmd_write_cmdlines() out of tracecmd_append_cpu_data()
      trace-cmd: Move the output state updates into the functions that change the state
      trace-cmd: Move the input state updates into the functions that change the state
      trace-cmd input: Validate the input handle when copying from it
      trace-cmd: Have tracecmd_read_headers() specify the state to read up to
      trace-cmd: Have tracecmd_get_file_state() return the enum
      trace-cmd input: Add validation updates to the copy of a handle
      trace-cmd: Have tracecmd_copy_headers() have a start and stop state

----
 lib/trace-cmd/include/private/trace-cmd-private.h |  13 +-
 lib/trace-cmd/trace-input.c                       | 229 +++++++++++++++++++---
 lib/trace-cmd/trace-output.c                      | 113 +++++++----
 tracecmd/trace-hist.c                             |   2 +-
 tracecmd/trace-mem.c                              |   2 +-
 tracecmd/trace-read.c                             |   2 +-
 tracecmd/trace-record.c                           |   3 +
 tracecmd/trace-restore.c                          |   4 +-
 tracecmd/trace-split.c                            |   4 +
 tracecmd/trace-stream.c                           |   2 +-
 10 files changed, 292 insertions(+), 82 deletions(-)
