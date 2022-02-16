Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D62C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 03:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbiBPDOD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Feb 2022 22:14:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344109AbiBPDOB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Feb 2022 22:14:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01131D10AF
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Feb 2022 19:13:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FB35B81DC8
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 03:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5708BC340F5;
        Wed, 16 Feb 2022 03:13:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nKAlG-00481e-FK;
        Tue, 15 Feb 2022 22:13:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] libtraceevent: Have logs only print to stderr on WARNING or higher
Date:   Tue, 15 Feb 2022 22:13:43 -0500
Message-Id: <20220216031345.984113-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216031345.984113-1-rostedt@goodmis.org>
References: <20220216031345.984113-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tep logs should only print to stderr for WARNINGS and higher. Info
messages can go to stdout.

Also, only print perror on warnings or higher.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/parse-utils.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/src/parse-utils.c b/src/parse-utils.c
index 3f4918f7468e..09059edf0159 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -67,13 +67,17 @@ int __tep_vprint(const char *name, enum tep_loglevel level,
 		      bool print_err, const char *fmt, va_list ap)
 {
 	int ret = errno;
-
-	if (errno && print_err) {
-		perror(name);
-		fprintf(stderr, "  ");
+	FILE *fp = stdout;
+
+	if (level <= TEP_LOG_WARNING) {
+		fp = stderr;
+		if (errno && print_err) {
+			perror(name);
+			fprintf(stderr, "  ");
+		}
 	}
-	vfprintf(stderr, fmt, ap);
-	fprintf(stderr, "\n");
+	vfprintf(fp, fmt, ap);
+	fprintf(fp, "\n");
 
 	return ret;
 }
-- 
2.34.1

