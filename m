Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2565DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Mar 2022 18:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345500AbiCHSOz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Mar 2022 13:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240823AbiCHSOy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Mar 2022 13:14:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC654199A
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Mar 2022 10:13:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A9C36150C
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Mar 2022 18:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A1BC340F4
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Mar 2022 18:13:56 +0000 (UTC)
Date:   Tue, 8 Mar 2022 13:13:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd report: Document --nodate option
Message-ID: <20220308131354.52452ac1@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The option --nodate was never documented nor was it even listed in the
trace-cmd report -h usage. Fix that.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-report.1.txt | 3 +++
 tracecmd/trace-usage.c                         | 1 +
 2 files changed, 4 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index 501994a456c8..18e1c5cd0700 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -309,6 +309,9 @@ OPTIONS
      Make sure no timestamp goes backwards, and if it does, print out a warning
      message of the fact.
 
+*--nodate*::
+     Ignore converting the timestamps to the date set by *trace-cmd record*(3) --date option.
+
 *--raw-ts*::
      Display raw timestamps, without any corrections.
 
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index ec0af46f0dd2..5e96ca44e9b3 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -244,6 +244,7 @@ static struct usage_help usage_help[] = {
 		"                     previous data file, in which case it becomes default\n"
 		"          --ts-diff Show the delta timestamp between events.\n"
 		"          --ts-check Check to make sure no time stamp on any CPU goes backwards.\n"
+		"          --nodate Ignore the --date processing of trace-cmd record.\n"
 		"          --raw-ts Display raw timestamps, without any corrections.\n"
 		"          --align-ts Display timestamps aligned to the first event.\n"
 		"          --verbose[=level] Set the desired log level\n"
-- 
2.34.1

