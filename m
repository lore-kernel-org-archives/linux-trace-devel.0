Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9CAC43334
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jun 2022 19:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbiFFTaH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiFFT34 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 15:29:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDDE6169
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 12:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A45756144C
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 19:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262D1C385A9;
        Mon,  6 Jun 2022 19:29:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyIQE-001Oz9-7i;
        Mon, 06 Jun 2022 15:29:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Harald Seiler <hws@denx.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6/6] libtracefs sqlhist: Report errors executing the commands
Date:   Mon,  6 Jun 2022 15:29:53 -0400
Message-Id: <20220606192953.334315-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220606192953.334315-1-rostedt@goodmis.org>
References: <20220606192953.334315-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the -e option is set and the parsing succeeds but the executing does
not, sqlhist exits with success. It should instead check the return of the
creation of the histogram or synthetic event and return the error message
on failure and not succeed.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-sql.txt | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 5e48baa4da39..6d606dbcaf88 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -407,8 +407,13 @@ static int do_sql(const char *instance_name,
 			}
 		}
 		tracefs_synth_echo_cmd(&seq, synth);
-		if (execute)
-			tracefs_synth_create(synth);
+		if (execute) {
+			ret = tracefs_synth_create(synth);
+			if (ret < 0) {
+				fprintf(stderr, "%s\n", tracefs_error_last(NULL));
+				exit(-1);
+			}
+		}
 	} else {
 		struct tracefs_instance *instance = NULL;
 		struct tracefs_hist *hist;
@@ -430,8 +435,13 @@ static int do_sql(const char *instance_name,
 			}
 		}
 		tracefs_hist_echo_cmd(&seq, instance, hist, 0);
-		if (execute)
-			tracefs_hist_start(instance, hist);
+		if (execute) {
+			ret = tracefs_hist_start(instance, hist);
+			if (ret < 0) {
+				fprintf(stderr, "%s\n", tracefs_error_last(instance));
+				exit(-1);
+			}
+		}
 	}
 
 	tracefs_synth_free(synth);
-- 
2.35.1

