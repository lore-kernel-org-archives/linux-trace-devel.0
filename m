Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E5BC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65DA361983
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhCVKA1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhCVJ7y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:54 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FFFC061756
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:54 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u21so2229001ejo.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zu2CdEmARU5Bf83z5GHyL4PVeIbHQU4VjDX8CrNvZp4=;
        b=mUZTKKm3e0ywIqgutieguviKenURheOE5T7y1cBpTL9r434256Zke1Fg9esvHPk9SO
         ZIX1P9BeixS8AiwIUDeombPKrd+sKBDm74HYVX2eede9zPU8E384LIPzBO28I+BuQa44
         yxRu+g5QyUVvq5O/cH3KsZaq77O08M9rwB34u7SSN/32A2b41dpKxQCim2l4L2GjU3dW
         6wL1VVGimdw5hPgwT+Q9QsDvw8cl7KPTSM1UViszog7AP05aL+Yg1WdUDj+B2EIgsc8A
         vMdTGxh+hLRXgxcUi8kDPS/9M5mEATtnNJ4DoiXscKq+njWnRsBt5vSkzjhWA/pJB+FF
         O2Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zu2CdEmARU5Bf83z5GHyL4PVeIbHQU4VjDX8CrNvZp4=;
        b=gp9HoeK+t6BYQmBQuO4u58cLyEqHPjXmQMLm9EI3WbrVNnVJjLNzMQyNU6uGG4uSxh
         yfoaXp7PujEdlMo5wEwvxksytsyA3Nv23/dIHakR+7/ZNI6pX3Ks1Zb4YfCnHy0LVnyW
         s1UyBp2y5NQCZR6Bm65VoeSKOAbZS/ksYqisNX+yzRZ66COl/Z85IfuujlPMwY43DDRX
         IWcZxTA/cnb+eFQL3/eNa6nDROzvGh03JStPsF5ZKQvM3Gqaa7AeGCJZgzyMwsZ+uY53
         9d+f2aFyFFKM+FrLasLpvG7gonZB124CCf/dB42Uz9ZHmN0lIelKUQD8tnvBkraS/kz+
         ykfg==
X-Gm-Message-State: AOAM530100bAqEtKzm+yiv0qfkOfgcsamy5X//3nhsUpMPHKTneIfKHr
        3zWmDcMksQGu3lMsQNCKBdieenBpE2e0ww==
X-Google-Smtp-Source: ABdhPJxG59iENbFurECRqkCyD/00wF854FjbDysq+tAeexvmXgAytaani0uEIBUPKWAvsrO4Z3gGbQ==
X-Received: by 2002:a17:906:75a:: with SMTP id z26mr18349900ejb.22.1616407193020;
        Mon, 22 Mar 2021 02:59:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 06/18] trace-cmd: Save information for tsc to nanoseconds conversion in trace file
Date:   Mon, 22 Mar 2021 11:59:33 +0200
Message-Id: <20210322095945.259300-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Store multiplier and shift, required for TSC clock to nanosecond
conversion in the metadata of the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 38edea2c..37a0f486 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -668,7 +668,24 @@ static void delete_thread_data(void)
 	}
 }
 
-static void host_tsync_complete(struct buffer_instance *instance)
+static void
+add_tsc2nsec(struct tracecmd_output *handle, struct tsc_nsec *tsc2nsec)
+{
+	/* multiplier, shift, offset */
+	struct iovec vector[3];
+
+	vector[0].iov_len = 4;
+	vector[0].iov_base = &tsc2nsec->mult;
+	vector[1].iov_len = 4;
+	vector[1].iov_base = &tsc2nsec->shift;
+	vector[2].iov_len = 8;
+	vector[2].iov_base = &tsc2nsec->offset;
+
+	tracecmd_add_option_v(handle, TRACECMD_OPTION_TSC2NSEC, vector, 3);
+}
+
+static void host_tsync_complete(struct common_record_context *ctx,
+				struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle = NULL;
 	int fd = -1;
@@ -682,6 +699,10 @@ static void host_tsync_complete(struct buffer_instance *instance)
 		handle = tracecmd_get_output_handle_fd(fd);
 		if (!handle)
 			die("cannot create output handle");
+
+		if (ctx->tsc2nsec.mult)
+			add_tsc2nsec(handle, &ctx->tsc2nsec);
+
 		tracecmd_write_guest_time_shift(handle, instance->tsync);
 		tracecmd_output_close(handle);
 	}
@@ -690,7 +711,7 @@ static void host_tsync_complete(struct buffer_instance *instance)
 	instance->tsync = NULL;
 }
 
-static void tell_guests_to_stop(void)
+static void tell_guests_to_stop(struct common_record_context *ctx)
 {
 	struct buffer_instance *instance;
 
@@ -702,7 +723,7 @@ static void tell_guests_to_stop(void)
 
 	for_all_instances(instance) {
 		if (is_guest(instance))
-			host_tsync_complete(instance);
+			host_tsync_complete(ctx, instance);
 	}
 
 	/* Wait for guests to acknowledge */
@@ -4269,6 +4290,9 @@ static void record_data(struct common_record_context *ctx)
 				add_guest_info(handle, instance);
 		}
 
+		if (ctx->tsc2nsec.mult)
+			add_tsc2nsec(handle, &ctx->tsc2nsec);
+
 		if (tracecmd_write_cmdlines(handle))
 			die("Writing cmdlines");
 
@@ -6573,7 +6597,7 @@ static void record_trace(int argc, char **argv,
 			trace_or_sleep(type, pwait);
 	}
 
-	tell_guests_to_stop();
+	tell_guests_to_stop(ctx);
 	tracecmd_disable_tracing();
 	if (!latency)
 		stop_threads(type);
-- 
2.30.2

