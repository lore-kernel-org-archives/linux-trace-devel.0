Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16329C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Sep 2021 22:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFA1561A51
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Sep 2021 22:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343746AbhI3WkK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:40:10 -0400
Received: from linux.microsoft.com ([13.77.154.182]:44896 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhI3WkK (ORCPT
        <rfc822;linux-trace-devel@VGER.KERNEL.ORG>);
        Thu, 30 Sep 2021 18:40:10 -0400
Received: from localhost.localdomain (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id EC9F020B8008;
        Thu, 30 Sep 2021 15:38:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC9F020B8008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1633041507;
        bh=Nu4SWT3p7uNwu4pnlMvzvFIf3rEpOhY8vp8gMJoHDnI=;
        h=From:To:Cc:Subject:Date:From;
        b=eFDd+9d/QFlnfwKySfKB6Z/fLi/yrRh809dZ5yTS/yfpcRs/jGuGv9hiyhpXtc5z7
         LShzdQqzLpUWKBxeaz8PLkCIXa6QUHaK9EwmjjQ4exJGfrR3RxpX1lL6Z8Yz4r3dsl
         lKypXZCMbXtXQEi4o+l93fKoWyUlUGqoLBfhgiqA=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     linux-trace-devel@VGER.KERNEL.ORG, rostedt@goodmis.org,
        mhiramat@kernel.org, zanussi@kernel.org
Cc:     beaub@linux.microsoft.com
Subject: [PATCH] synth_events: Do not block other dyn_event systems during create
Date:   Thu, 30 Sep 2021 15:38:21 -0700
Message-Id: <20210930223821.11025-1-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

synth_events is returning -EINVAL if the dyn_event create command does
not contain ' \t'. This prevents other systems from getting called back.
synth_events needs to return -ECANCELED in these cases when the command
is not targeting the synth_event system.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 kernel/trace/trace_events_synth.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 9315fc03e303..08b7ea639cea 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -2051,6 +2051,13 @@ static int create_synth_event(const char *raw_command)
 
 	last_cmd_set(raw_command);
 
+	name = raw_command;
+
+	/* Don't try to process if not our system */
+	if (name[0] != 's' || name[1] != ':')
+		return -ECANCELED;
+	name += 2;
+
 	p = strpbrk(raw_command, " \t");
 	if (!p) {
 		synth_err(SYNTH_ERR_INVALID_CMD, 0);
@@ -2059,12 +2066,6 @@ static int create_synth_event(const char *raw_command)
 
 	fields = skip_spaces(p);
 
-	name = raw_command;
-
-	if (name[0] != 's' || name[1] != ':')
-		return -ECANCELED;
-	name += 2;
-
 	/* This interface accepts group name prefix */
 	if (strchr(name, '/')) {
 		len = str_has_prefix(name, SYNTH_SYSTEM "/");
-- 
2.17.1

