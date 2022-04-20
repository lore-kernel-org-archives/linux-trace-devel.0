Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DB9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 15:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380232AbiDTP3g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 11:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380235AbiDTP3a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 11:29:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE5545AC7
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6B3AB81FEB
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 15:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066EEC385AD;
        Wed, 20 Apr 2022 15:26:40 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nhCE2-0003Rh-Ms;
        Wed, 20 Apr 2022 11:26:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 09/11] trace-cmd agent: Have agent work without vsockets available
Date:   Wed, 20 Apr 2022 11:26:35 -0400
Message-Id: <20220420152637.13105-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220420152637.13105-1-rostedt@goodmis.org>
References: <20220420152637.13105-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Compile agent code without vsockets available to allow it to work with
networking. This includes allowing the ptp time synchronization protocol
to be used.

Link: https://lore.kernel.org/linux-trace-devel/20220417184538.1044417-10-rostedt@goodmis.org

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/Makefile                    | 2 +-
 lib/trace-cmd/include/trace-tsync-local.h | 6 +-----
 tracecmd/Makefile                         | 5 ++---
 tracecmd/trace-cmd.c                      | 2 --
 tracecmd/trace-usage.c                    | 2 --
 5 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index da0ad4deeb4f..9374b163b5f3 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -21,8 +21,8 @@ ifeq ($(PERF_DEFINED), 1)
 OBJS += trace-perf.o
 endif
 OBJS += trace-timesync.o
-ifeq ($(VSOCK_DEFINED), 1)
 OBJS += trace-timesync-ptp.o
+ifeq ($(VSOCK_DEFINED), 1)
 OBJS += trace-timesync-kvm.o
 endif
 OBJS += trace-compress.o
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 885c9f51d891..5bbc1db622c4 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -64,15 +64,11 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int role
 					      long long *, long long *, long long*,
 					      long long *, unsigned int));
 int tracecmd_tsync_proto_unregister(char *proto_name);
+int ptp_clock_sync_register(void);
 
 #ifdef VSOCK
-int ptp_clock_sync_register(void);
 int kvm_clock_sync_register(void);
 #else
-static inline int ptp_clock_sync_register(void)
-{
-	return 0;
-}
 static inline int kvm_clock_sync_register(void)
 {
 	return 0;
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 13f7776e8e45..0114948fe385 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -37,11 +37,10 @@ TRACE_CMD_OBJS += trace-dump.o
 TRACE_CMD_OBJS += trace-clear.o
 TRACE_CMD_OBJS += trace-vm.o
 TRACE_CMD_OBJS += trace-convert.o
-TRACE_CMD_OBJS += trace-vsock.o
-
-ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-agent.o
 TRACE_CMD_OBJS += trace-setup-guest.o
+ifeq ($(VSOCK_DEFINED), 1)
+TRACE_CMD_OBJS += trace-vsock.o
 endif
 
 ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 3f3e69a7f1e2..69800d26c5ee 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -127,10 +127,8 @@ struct command commands[] = {
 	{"hist", trace_hist},
 	{"mem", trace_mem},
 	{"listen", trace_listen},
-#ifdef VSOCK
 	{"agent", trace_agent},
 	{"setup-guest", trace_setup_guest},
-#endif
 	{"split", trace_split},
 	{"restore", trace_restore},
 	{"stack", trace_stack},
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index ec6376557394..88eac10a4e75 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -325,7 +325,6 @@ static struct usage_help usage_help[] = {
 		"          -l logfile to write messages to.\n"
 		"          --verbose 'level' Set the desired log level\n"
 	},
-#ifdef VSOCK
 	{
 		"agent",
 		"listen on a vsocket for trace clients",
@@ -344,7 +343,6 @@ static struct usage_help usage_help[] = {
 		"          -g FIFOs group owner\n"
 		"          -a Attach FIFOs to guest VM config\n"
 	},
-#endif
 	{
 		"list",
 		"list the available events, plugins or options",
-- 
2.35.1

