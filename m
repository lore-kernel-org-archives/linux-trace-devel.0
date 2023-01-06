Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EACAC61DB3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 18:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjAFSjk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 13:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235416AbjAFSjf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 13:39:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315767CDDB
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 10:39:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E39FFB81E42
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 18:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DA7C43396;
        Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDrcp-0003LA-0L;
        Fri, 06 Jan 2023 13:39:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 07/10] trace-cmd stream: Set default sleep time to half a second
Date:   Fri,  6 Jan 2023 13:39:27 -0500
Message-Id: <20230106183930.12565-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230106183930.12565-1-rostedt@goodmis.org>
References: <20230106183930.12565-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When in streaming mode, set the default to half a second instead of 1
millisecond (which should be changed for record as well).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 03f990e3b2d1..9eb10cd8ccdf 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -7161,11 +7161,15 @@ void trace_stream(int argc, char **argv)
 {
 	struct common_record_context ctx;
 
+	/* Default sleep time is half a second for streaming */
+	sleep_time = 500000;
+
 	parse_record_options(argc, argv, CMD_stream, &ctx);
 	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
+
 void trace_profile(int argc, char **argv)
 {
 	struct common_record_context ctx;
-- 
2.35.1

