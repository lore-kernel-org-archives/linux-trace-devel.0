Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9671C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Oct 2022 08:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiJFIom (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 04:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiJFIom (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 04:44:42 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90DBFA1A3;
        Thu,  6 Oct 2022 01:44:40 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F6592B;
        Thu,  6 Oct 2022 01:44:46 -0700 (PDT)
Received: from pierre123.arm.com (unknown [10.57.35.228])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7EEAF3F73B;
        Thu,  6 Oct 2022 01:44:38 -0700 (PDT)
From:   Pierre Gondois <pierre.gondois@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     Pierre Gondois <pierre.gondois@arm.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-trace-devel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] Documentation: rtla: Correct command line example
Date:   Thu,  6 Oct 2022 10:44:09 +0200
Message-Id: <20221006084409.3882542-1-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The '-t/-T' parameters seem to have been swapped:
-t/--trace[=file]: save the stopped trace
to [file|timerlat_trace.txt]
-T/--thread us: stop trace if the thread latency
is higher than the argument in us

Swap them back.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 Documentation/tools/rtla/rtla-timerlat-top.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/tools/rtla/rtla-timerlat-top.rst b/Documentation/tools/rtla/rtla-timerlat-top.rst
index 1c321de1c171..7c4e4b109493 100644
--- a/Documentation/tools/rtla/rtla-timerlat-top.rst
+++ b/Documentation/tools/rtla/rtla-timerlat-top.rst
@@ -39,7 +39,7 @@ higher than *30 us*. It is also set to stop the session if a *Thread* timer
 latency higher than *30 us* is hit. Finally, it is set to save the trace
 buffer if the stop condition is hit::
 
-  [root@alien ~]# rtla timerlat top -s 30 -t 30 -T
+  [root@alien ~]# rtla timerlat top -s 30 -T 30 -t
                    Timer Latency
     0 00:00:59   |          IRQ Timer Latency (us)        |         Thread Timer Latency (us)
   CPU COUNT      |      cur       min       avg       max |      cur       min       avg       max
-- 
2.25.1

