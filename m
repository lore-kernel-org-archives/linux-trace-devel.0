Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F90C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 20:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344118AbiBJUJE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 15:09:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344113AbiBJUJD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 15:09:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1F32734;
        Thu, 10 Feb 2022 12:09:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 295ABB8273B;
        Thu, 10 Feb 2022 20:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6F3C340F2;
        Thu, 10 Feb 2022 20:09:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nIFkT-002zK0-2N;
        Thu, 10 Feb 2022 15:09:01 -0500
Message-ID: <20220210200900.908862071@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 10 Feb 2022 15:05:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [for-linus][PATCH 2/6] rtla/utils: Fix session duration parsing
References: <20220210200509.089236997@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

Use gmtime to format the duration time. This avoids problems when the
system uses local time different of Pisa's Local Time.

Link: https://lkml.kernel.org/r/a2f0a37bc006c2561bb8ecd871cd70532b4a9f2d.1643990447.git.bristot@kernel.org

Fixes: b1696371d865 ("rtla: Helper functions for rtla")
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tools/tracing/rtla/src/utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index 1c9f0eea6166..ffaf8ec84001 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -77,11 +77,11 @@ void get_duration(time_t start_time, char *output, int output_size)
 	time_t duration;
 
 	duration = difftime(now, start_time);
-	tm_info = localtime(&duration);
+	tm_info = gmtime(&duration);
 
 	snprintf(output, output_size, "%3d %02d:%02d:%02d",
 			tm_info->tm_yday,
-			tm_info->tm_hour - 1,
+			tm_info->tm_hour,
 			tm_info->tm_min,
 			tm_info->tm_sec);
 }
-- 
2.34.1
