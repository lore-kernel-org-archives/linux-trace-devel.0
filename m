Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1465C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Nov 2022 23:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiKIXvn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 18:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiKIXvm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 18:51:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1116212AEF
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 15:51:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A16F461CE8
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 23:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D198C433D6;
        Wed,  9 Nov 2022 23:51:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1osurg-009C69-0g;
        Wed, 09 Nov 2022 18:52:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 0/8] libtracefs: Add reading from per_cpu trace_pipe_raw helper functions
Date:   Wed,  9 Nov 2022 18:52:06 -0500
Message-Id: <20221109235214.2191393-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add functions that allow applications to read the trace_pipe_raw files:

    tracefs_cpu_alloc_fd()
    tracefs_cpu_free_fd()
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

Changes since v2: https://lore.kernel.org/all/20221025183212.1775523-1-rostedt@goodmis.org/

 - Renamed tracefs_cpu_create_fd() to tracefs_cpu_alloc_fd()

 - Added tracefs_cpu_free_fd()

Steven Rostedt (Google) (8):
  libtracefs: Add reading of per cpu files
  libtracefs: Add tracefs_cpu_alloc_fd() and tracefs_cpu_free_fd()
  libtracefs: Add tracefs_cpu_pipe()
  libtracefs utest: Make helper functions for affinity
  libtracefs: Add unit tests for tracefs_cpu functions
  libtracefs: Move tracefs_cpu_open/close into its own man page
  libtracefs: Add man pages for tracefs_cpu_alloc_fd() and
    tracefs_cpu_free_fd()
  libtracefs: Add man pages for tracefs_cpu_pipe()

 Documentation/libtracefs-cpu-open.txt | 100 +++++
 Documentation/libtracefs-cpu.txt      | 240 +++++++++++
 Documentation/libtracefs.txt          |  15 +
 include/tracefs.h                     |  16 +
 samples/Makefile                      |   1 +
 scripts/utils.mk                      |   2 +-
 src/Makefile                          |   1 +
 src/tracefs-record.c                  | 598 ++++++++++++++++++++++++++
 utest/tracefs-utest.c                 | 372 +++++++++++++++-
 9 files changed, 1330 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/libtracefs-cpu-open.txt
 create mode 100644 Documentation/libtracefs-cpu.txt
 create mode 100644 src/tracefs-record.c

-- 
2.35.1

