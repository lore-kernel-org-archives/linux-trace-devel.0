Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A87C43219
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 15:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355984AbiASP5s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 10:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355867AbiASP5r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 10:57:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DE9C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 07:57:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6B9FFCE1D3F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 15:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71468C340E6;
        Wed, 19 Jan 2022 15:57:43 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nADLC-007PZr-9R;
        Wed, 19 Jan 2022 10:57:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 4/4] libtracefs: Do not count CPUs beyond set size in get_affinity
Date:   Wed, 19 Jan 2022 10:57:41 -0500
Message-Id: <20220119155741.1766541-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220119155741.1766541-1-rostedt@goodmis.org>
References: <20220119155741.1766541-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the string of CPUs has bits set that are beyond the size that the
passed in cpu_set_t size can hold, do not set them.

This relies on the _S version of the CPU_SET macros from not crashing if
the size if too big. One would think that the _S versions would be made
specifically to protect against being too big.

If a CPU is set in the string but is outside the size limit of the
cpu_set_t passed in, then do not add it to the count that is returned by
tracefs_instance_get_affinity_set().

Link: https://lore.kernel.org/all/CAPpZLN4n=L-ZHCXM+LDRiQu0XwR4iCnGeCKJOuOWenkz2EhESA@mail.gmail.com/

Reported-by: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index db51af3818f0..1493938fa445 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -1000,7 +1000,16 @@ static inline int update_cpu_set(int cpus, int cpu_set, int cpu,
 		return 0;
 
 	CPU_SET_S(cpu_set + cpu, set_size, set);
-	return 1;
+
+	/*
+	 * It is possible that the passed in set_size is not big enough
+	 * to hold the cpu we just set. If that's the case, do not report
+	 * it as being set.
+	 *
+	 * The CPU_ISSET_S() should return false if the CPU given to it
+	 * is bigger than the set itself.
+	 */
+	return CPU_ISSET_S(cpu_set + cpu, set_size, set) ? 1 : 0;
 }
 
 /**
-- 
2.33.0

