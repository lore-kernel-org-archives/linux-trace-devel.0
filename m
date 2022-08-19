Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F8EC00140
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Aug 2022 02:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242524AbiHSCDm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Aug 2022 22:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240319AbiHSCDk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Aug 2022 22:03:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A402D5727B
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Aug 2022 19:03:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EF5C6142D
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Aug 2022 02:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6793C433D6;
        Fri, 19 Aug 2022 02:03:38 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oOrMU-0038Ru-0C;
        Thu, 18 Aug 2022 22:03:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] libtracefs sqlhist: Allow pointers to match longs
Date:   Thu, 18 Aug 2022 22:03:49 -0400
Message-Id: <20220819020349.747429-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220819020349.747429-1-rostedt@goodmis.org>
References: <20220819020349.747429-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently, if a field that is a long tries to match a field that is a
pointer, tracefs_sqlhist() will fail with incompatible fields. But the
kernel will still allow it to match, do not fail here.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 302b9a75e6ee..14988d8dc185 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -796,6 +796,7 @@ static bool verify_event_fields(struct tep_event *start_event,
 {
 	const struct tep_format_field *start_field;
 	const struct tep_format_field *end_field;
+	int start_flags, end_flags;
 
 	if (!trace_verify_event_field(start_event, start_field_name,
 				      &start_field))
@@ -806,7 +807,11 @@ static bool verify_event_fields(struct tep_event *start_event,
 					      &end_field))
 			return false;
 
-		if (start_field->flags != end_field->flags ||
+		/* A pointer can still match a long */
+		start_flags = start_field->flags & ~TEP_FIELD_IS_POINTER;
+		end_flags = end_field->flags & ~TEP_FIELD_IS_POINTER;
+
+		if (start_flags != end_flags ||
 		    start_field->size != end_field->size) {
 			errno = EBADE;
 			return false;
-- 
2.35.1

