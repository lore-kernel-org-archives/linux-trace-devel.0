Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285FFC43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 15:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355985AbiASP5r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 10:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355984AbiASP5r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 10:57:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03565C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 07:57:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54487CE1C72
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 15:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDA0C340E8;
        Wed, 19 Jan 2022 15:57:43 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nADLC-007PZo-8m;
        Wed, 19 Jan 2022 10:57:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 3/4] libtracefs: Fix grammar in tracefs_instance_get_affinity() comment
Date:   Wed, 19 Jan 2022 10:57:40 -0500
Message-Id: <20220119155741.1766541-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220119155741.1766541-1-rostedt@goodmis.org>
References: <20220119155741.1766541-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

There was a grammar mistake in the comment describing the
tracefs_instance_get_affinity() function. Fix it.

Link: https://lore.kernel.org/all/CAPpZLN4n=L-ZHCXM+LDRiQu0XwR4iCnGeCKJOuOWenkz2EhESA@mail.gmail.com/

Reported-by: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 2d825b0e3bd0..db51af3818f0 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -1112,7 +1112,7 @@ static inline int update_cpu(int cpus, int cpu_set, int cpu, int s, char **set)
  * If no CPUs are set, an empty string is returned "\0", and it too needs
  * to be freed.
  *
- * Returns an allocate string containing the CPU affinity in "human readable"
+ * Returns an allocated string containing the CPU affinity in "human readable"
  *  format which needs to be freed with free(), or NULL on error.
  */
 char *tracefs_instance_get_affinity(struct tracefs_instance *instance)
-- 
2.33.0

