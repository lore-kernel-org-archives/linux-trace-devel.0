Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0032C54EBD
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 18:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjAFSjf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 13:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjAFSjd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 13:39:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7017CDD1
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 10:39:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D52961F1D
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1DBC433F1;
        Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDrco-0003Kj-33;
        Fri, 06 Jan 2023 13:39:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 00/10] trace-cmd: Fix trace-cmd stream
Date:   Fri,  6 Jan 2023 13:39:20 -0500
Message-Id: <20230106183930.12565-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Looking at https://bugzilla.kernel.org/show_bug.cgi?id=216577 and analyzing
the fix, I found a bunch of other issues with trace-cmd stream.

This series is to address them.

Steven Rostedt (Google) (10):
  trace-cmd library: Set recorder to nonblock when finished
  trace-cmd stream: Do not block when stopping threads
  trace-cmd stream: Add a flush signal to kick the output
  trace-cmd stream: Do one last flush when finished
  trace-cmd library: Fix read_data() with error from tracefs_cpu_read()
  trace-cmd: Have trace_stream_read() use poll()
  trace-cmd stream: Set default sleep time to half a second
  trace-cmd library: Return the result of tracefs_cpu_stop()
  trace-cmd record: Set sleep_time to zero at end of recording
  trace-cmd record: Keep stopping the recording when finished

 .../include/private/trace-cmd-private.h       |  4 +-
 lib/trace-cmd/trace-recorder.c                | 33 ++++++---
 tracecmd/include/trace-local.h                |  2 +-
 tracecmd/trace-record.c                       | 72 +++++++++++++++----
 tracecmd/trace-stream.c                       | 34 ++++-----
 5 files changed, 99 insertions(+), 46 deletions(-)

-- 
2.35.1

