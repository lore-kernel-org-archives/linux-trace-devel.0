Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2D6C4708E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Jan 2023 10:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbjACKel (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Jan 2023 05:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237128AbjACKeV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Jan 2023 05:34:21 -0500
Received: from serv15.avernis.de (serv15.avernis.de [IPv6:2a01:4f8:151:30a2::163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB00AFADE;
        Tue,  3 Jan 2023 02:34:20 -0800 (PST)
Received: from iago.. (unknown [95.91.249.42])
        by serv15.avernis.de (Postfix) with ESMTPSA id 439FFBDE027B;
        Tue,  3 Jan 2023 11:34:17 +0100 (CET)
From:   Andreas Ziegler <br015@umbiko.net>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Ziegler <br015@umbiko.net>
Subject: [PATCH 2/2 v2] tools/tracing/rtla: osnoise_hist: display average with two-digit precision
Date:   Tue,  3 Jan 2023 11:34:00 +0100
Message-Id: <20230103103400.275566-3-br015@umbiko.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <f47e877c-c95f-e3e6-b96f-89b0ca582878@kernel.org>
References: <f47e877c-c95f-e3e6-b96f-89b0ca582878@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.7 at serv15.avernis.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Calculate average value in osnoise-hist summary with two-digit 
precision to avoid displaying too optimitic results. 

Signed-off-by: Andreas Ziegler <br015@umbiko.net>
---
Changes v1 -> v2:
 - output with two-digit precision instead of rounding (Daniel)

 tools/tracing/rtla/src/osnoise_hist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
index fe34452fc4ec..13e1233690bb 100644
--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -335,8 +335,8 @@ osnoise_print_summary(struct osnoise_hist_params *params,
 			continue;
 
 		if (data->hist[cpu].count)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].sum_sample / data->hist[cpu].count);
+			trace_seq_printf(trace->seq, "%9.2f ",
+				((double) data->hist[cpu].sum_sample) / data->hist[cpu].count);
 		else
 			trace_seq_printf(trace->seq, "        - ");
 	}
-- 
2.34.1

