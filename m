Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4B0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 May 2022 09:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239154AbiEJJti (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 May 2022 05:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239144AbiEJJth (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 May 2022 05:49:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121E91CFC8;
        Tue, 10 May 2022 02:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5BCD8CE1D4B;
        Tue, 10 May 2022 09:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C70C385C6;
        Tue, 10 May 2022 09:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652175936;
        bh=IeHcJjkEm22HUoN9FJufk1mDHii1OmdmHxmFKC/HWxA=;
        h=From:To:Cc:Subject:Date:From;
        b=WbjDsGFWixCGQi5LOctylCqHBWVoKQJU4mszBuElgMgmYLVYUeiBWtPFBq4kXq/zv
         biwsVcQ0Badjw/APckLrCK0nevW1rxr0gZjon++6qToYxVmROIzLTVO8lo691OI4RI
         5kn7OGGF0hTvsyxpuNW1wzEuQKTan01rIf0exHhqKiFmyZIZfIdRWccf754rOdiAk4
         ERcQxofrHODkaoVQzSqHRorPrfFXss1gmtoc/Q3D9K0pAyRDTE7lu12p3TrWSB7II6
         ZNVE/04wu+/T8tFSYrHskgbnW+Eg75yIJAg3vjGTCKkthhlyOM4Fok8oFgul71++Rd
         fVq7Ww+nhNtdg==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Clark Williams <williams@redhat.com>
Subject: [PATCH 1/3] tracing/timerlat: Notify IRQ new max latency only if stop tracing is set
Date:   Tue, 10 May 2022 11:45:23 +0200
Message-Id: <2c2d9a56c0886c8402ba320de32856cbbb10c2bb.1652175637.git.bristot@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently, the notification of a new max latency is sent from
timerlat's IRQ handler anytime a new max latency is found.

While this behavior is not wrong, the send IPI overhead itself
will increase the thread latency and that is not the desired
effect (tracing overhead).

Moreover, the thread will notify a new max latency again because
the thread latency as it is always higher than the IRQ latency
that woke it up.

The only case in which it is helpful to notify a new max latency
from IRQ is when stop tracing (for the IRQ) is set, as in this
case, the thread will not be dispatched.

Notify a new max latency from the IRQ handler only if stop tracing is
set for the IRQ handler.

Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Reported-by: Clark Williams <williams@redhat.com>
Fixes: a955d7eac177 ("trace: Add timerlat tracer")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 kernel/trace/trace_osnoise.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index e9ae1f33a7f0..6494ca27ea6f 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1578,11 +1578,12 @@ static enum hrtimer_restart timerlat_irq(struct hrtimer *timer)
 
 	trace_timerlat_sample(&s);
 
-	notify_new_max_latency(diff);
-
-	if (osnoise_data.stop_tracing)
-		if (time_to_us(diff) >= osnoise_data.stop_tracing)
+	if (osnoise_data.stop_tracing) {
+		if (time_to_us(diff) >= osnoise_data.stop_tracing) {
 			osnoise_stop_tracing();
+			notify_new_max_latency(diff);
+		}
+	}
 
 	wake_up_process(tlat->kthread);
 
-- 
2.32.0

