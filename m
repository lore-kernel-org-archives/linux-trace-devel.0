Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F78C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Jan 2022 16:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380522AbiAaQgw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 11:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380516AbiAaQgu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 11:36:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C84AC06173E
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 08:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E165B82B9E
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 16:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1282C340F2;
        Mon, 31 Jan 2022 16:36:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nEZfa-00BYas-SE;
        Mon, 31 Jan 2022 11:36:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/4] libtracefs: Have synthetic events use types pid_t, gfp_t and bool
Date:   Mon, 31 Jan 2022 11:36:42 -0500
Message-Id: <20220131163642.2754485-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131163642.2754485-1-rostedt@goodmis.org>
References: <20220131163642.2754485-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The synthetic events understand pid_t, gfp_t and bool, and it is better to
use them, as some kernels have bugs where a field with one of the above
types may not match the raw format they are.

That is, pid_t may not match s32, even though they are the same type!

Fixes: 7c9000c7495b9 ("libtracefs: Create a way to create a synthetic event")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index ec63b88a0bca..e7dd279ae3f9 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -841,6 +841,15 @@ static char *add_synth_field(const struct tep_format_field *field,
 		return append_string(str, NULL, "];");
 	}
 
+	/* Synthetic events understand pid_t, gfp_t and bool */
+	if (strcmp(field->type, "pid_t") == 0 ||
+	    strcmp(field->type, "gfp_t") == 0 ||
+	    strcmp(field->type, "bool") == 0) {
+		str = strdup(field->type);
+		str = append_string(str, " ", name);
+		return append_string(str, NULL, ";");
+	}
+
 	sign = field->flags & TEP_FIELD_IS_SIGNED;
 
 	switch (field->size) {
-- 
2.33.0

