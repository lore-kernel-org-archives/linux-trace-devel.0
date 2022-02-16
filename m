Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87686C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 03:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344112AbiBPDOD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Feb 2022 22:14:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344088AbiBPDOA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Feb 2022 22:14:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B16CD0489
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Feb 2022 19:13:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9E9C618A0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 03:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EAEC340F8;
        Wed, 16 Feb 2022 03:13:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nKAlG-00481b-EU;
        Tue, 15 Feb 2022 22:13:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] libtraceevent: Only add space on log prints if perror is used
Date:   Tue, 15 Feb 2022 22:13:42 -0500
Message-Id: <20220216031345.984113-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216031345.984113-1-rostedt@goodmis.org>
References: <20220216031345.984113-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Do not add the space is the perror is not printed, as the space was only
to separate the perror output from the rest of the output.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/parse-utils.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/parse-utils.c b/src/parse-utils.c
index 89bf1cd92273..3f4918f7468e 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -68,10 +68,10 @@ int __tep_vprint(const char *name, enum tep_loglevel level,
 {
 	int ret = errno;
 
-	if (errno && print_err)
+	if (errno && print_err) {
 		perror(name);
-
-	fprintf(stderr, "  ");
+		fprintf(stderr, "  ");
+	}
 	vfprintf(stderr, fmt, ap);
 	fprintf(stderr, "\n");
 
-- 
2.34.1

