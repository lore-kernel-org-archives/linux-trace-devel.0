Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E427C7EE29
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jun 2023 07:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbjFBHhx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 03:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbjFBHhd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 03:37:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C69E44
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jun 2023 00:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA8EC64CFB
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jun 2023 07:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DD3C4339B;
        Fri,  2 Jun 2023 07:37:29 +0000 (UTC)
Date:   Fri, 2 Jun 2023 03:37:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Douglas RAILLARD <douglas.raillard@arm.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] trace-cmd: Update v7 trace.dat documentation to clarify the
 strings section
Message-ID: <20230602033726.3c0ac34a@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The string section description in the trace.dat v7 man page is a little
confusing. It is missing its section id, and so is the buffer text
section. Add the ids and clear up the description slightly.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217351
Reported-by: Douglas RAILLARD <douglas.raillard@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd.dat.v7.5.txt | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
index b19d2842a745..2f7e6a4a4654 100644
--- a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
+++ b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
@@ -226,6 +226,10 @@ OPTIONS SECTION
        <4 bytes> unsigned integer, time shift.
        <8 bytes> unsigned long long integer, time offset.
 
+  STRINGS: id 15, size vary
+    The STRINGS option holds a list of nul terminated strings that holds the names of the
+    other sections.
+
   HEADER_INFO: id 16, size 8
     The HEADER_INFO option data is:
       <8 bytes> long long unsigned integer, offset into the trace file where the HEADER INFO
@@ -419,14 +423,18 @@ BUFFER FLYRECORD SECTION
 BUFFER TEXT SECTION
 ------------------------
 
+  Section ID: 22
+
   This section contains latency tracing data, ASCII text taken from the
   target's debugfs/tracing/trace file.
 
 STRINGS SECTION
 ------------------------
 
-  All strings from trace file metadata are stored in string section in the file. The section
-  contains a list of NULL terminated ASCII strings. An ID of the string is used in the file
+  Section ID: 15
+
+  All strings of the trace file metadata are stored in a string section within the file. The section
+  contains a list of nul terminated ASCII strings. An ID of the string is used in the file
   meta data, which is the offset of the actual string into the string section. Strings can be stored
   into multiple string sections in the file.
 
-- 
2.39.2

