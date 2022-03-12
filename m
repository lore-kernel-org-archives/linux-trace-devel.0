Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9ACCC43217
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Mar 2022 23:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiCLXln (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 18:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiCLXlm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 18:41:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8806B0BB
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 15:40:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C26360B23
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 23:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FF4C340F4;
        Sat, 12 Mar 2022 23:40:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nTBLe-000X7H-2W;
        Sat, 12 Mar 2022 18:40:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd library: Do not read CPU greater than CPUs registered
Date:   Sat, 12 Mar 2022 18:40:32 -0500
Message-Id: <20220312234032.127108-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220312234032.127108-1-rostedt@goodmis.org>
References: <20220312234032.127108-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If tracecmd_read_cpu_first() is called with a CPU that is greater than the
number of CPUs in the handle, just return NULL.

This happened when kernelshark would get the number of CPUs returned by
the tep handler, but they are not stored in the trace.dat file.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index da922834de1f..313534d09e86 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2025,9 +2025,15 @@ int tracecmd_refresh_record(struct tracecmd_input *handle,
 struct tep_record *
 tracecmd_read_cpu_first(struct tracecmd_input *handle, int cpu)
 {
+	unsigned long long page_offset;
 	int ret;
 
-	ret = get_page(handle, cpu, handle->cpu_data[cpu].file_offset);
+	if (cpu > handle->cpus)
+		return NULL;
+
+	page_offset = calc_page_offset(handle, handle->cpu_data[cpu].file_offset);
+
+	ret = get_page(handle, cpu, page_offset);
 	if (ret < 0)
 		return NULL;
 
-- 
2.35.1

