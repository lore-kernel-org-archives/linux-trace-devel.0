Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CA0FA373E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Oct 2022 18:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJYScG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 14:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiJYScF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 14:32:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73581C1DB5
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 11:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5232CE1BF6
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 18:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1876EC433D7;
        Tue, 25 Oct 2022 18:32:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1onOij-007Rz0-12;
        Tue, 25 Oct 2022 14:32:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/5] Add reading from per_cpu trace_pipe_raw helper functions
Date:   Tue, 25 Oct 2022 14:32:07 -0400
Message-Id: <20221025183212.1775523-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add functions that allow applications to read the trace_pipe_raw files:

    tracefs_cpu_create_fd()
    tracefs_cpu_open()
    tracefs_cpu_close()
    tracefs_cpu_read_size()
    tracefs_cpu_read()
    tracefs_cpu_buffered_read()
    tracefs_cpu_write()
    tracefs_cpu_stop()
    tracefs_cpu_flush()
    tracefs_cpu_flush_write()
    tracefs_cpu_pipe()

Changes since v1: https://lore.kernel.org/all/20221021182345.092cdb50@gandalf.local.home/

 - Changed the names of tracefs_cpu_pipe_read() to tracefs_cpu_buffered_read()
   and tracefs_cpu_pipe_write() to just tracefs_cpu_write()

 - Added tracefs_cpu_create_fd() to attach to an already opened file descriptor
   that could be just a copy of a trace_pipe_raw file, or to a socket for
   remote tracing.

 - Added tracefs_cpu_pipe() to write directly into a pipe (saves on a splice).

 - Fixed some blocking issues.

 - Added unit tests

Steven Rostedt (Google) (5):
  libtracefs: Add reading of per cpu files
  libtracefs: Add tracefs_cpu_create_fd()
  libtracefs: Add tracefs_cpu_pipe()
  libtracefs utest: Make helper functions for affinity
  libtracefs: Add unit tests for tracefs_cpu functions

 Documentation/libtracefs-cpu.txt | 239 +++++++++++++
 Documentation/libtracefs.txt     |  12 +
 include/tracefs.h                |  15 +
 samples/Makefile                 |   1 +
 scripts/utils.mk                 |   2 +-
 src/Makefile                     |   1 +
 src/tracefs-record.c             | 586 +++++++++++++++++++++++++++++++
 utest/tracefs-utest.c            | 372 +++++++++++++++++++-
 8 files changed, 1213 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/libtracefs-cpu.txt
 create mode 100644 src/tracefs-record.c

-- 
2.35.1

