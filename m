Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4653CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Jul 2022 18:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiGKSPF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 14:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiGKSPF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 14:15:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A75E2A735
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 11:15:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF551B810FA
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 18:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9BCC34115;
        Mon, 11 Jul 2022 18:15:01 +0000 (UTC)
Date:   Mon, 11 Jul 2022 14:14:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Nick Hainke <vincent@systemli.org>
Subject: [PATCH] libtracefs: fix compiling with musl
Message-ID: <20220711141459.2972e95b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Nick Hainke <vincent@systemli.org>

The library does not build with musl due to a missing pthread.h include.
This commit adds the missing include.

Fixes errors in the form of:

  In file included from tracefs-utils.c:21:
  ...cortex-a53_musl/libtracefs-1.4.1/include/tracefs-local.h:30:9:
    error: unknown type name 'pthread_mutex_t'
     30 |         pthread_mutex_t                 lock;
        |         ^~~~~~~~~~~~~~~
  .../cortex-a53_musl/libtracefs-1.4.1/include/tracefs-local.h:41:8:
    error: unknown type name 'pthread_mutex_t'
     41 | extern pthread_mutex_t toplevel_lock;
        |        ^~~~~~~~~~~~~~~
  ...cortex-a53_musl/libtracefs-1.4.1/include/tracefs-local.h:43:15:
    error: unknown type name 'pthread_mutex_t'
     43 | static inline pthread_mutex_t *trace_get_lock(struct ...
        |               ^~~~~~~~~~~~~~~

Signed-off-by: Nick Hainke <vincent@systemli.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Taken from a github pull request.
  https://github.com/rostedt/libtracefs/commit/01bb4cd9d4e408bf2ec45623760ec5b90a3253c0

 include/tracefs-local.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 1652a27..2267007 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -6,6 +6,8 @@
 #ifndef _TRACE_FS_LOCAL_H
 #define _TRACE_FS_LOCAL_H
 
+#include <pthread.h>
+
 #define __hidden __attribute__((visibility ("hidden")))
 #define __internal __attribute__((visibility ("internal")))
 #define __weak __attribute__((weak))
