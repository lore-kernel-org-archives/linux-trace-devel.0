Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B97C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiASI2z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352474AbiASI2z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:28:55 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEDEC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:54 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id p12so7538426edq.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fFkYoRlcZ7DAuy50t2oA1H8v1K6tu2QEpYiT33cX9Cw=;
        b=hxIC+Rh7bZahwbk3Kk6AiQHDWMrB8h4witOpPq7BUzDGs2R+uaZHTOqJLfSeS+Eku7
         V9hvtRTJSgSWFmEazKZUeIwhvtqF+CNrEkL13bdRglLh83PfdVxwd+XASbCsQozkLGHy
         9JRcAdDAgwy5Rvr5cXmOrBYEN+zZHg9tw+n9kbYvOFLLPXdYGSe7LmvFcrCv3h2Z7Iej
         agR5Oh2y4eDO9+59flU8ax4jYQTshTheKmQMwQo2RYj1sRxUfN2Ux6b/QON0UL2I2NkJ
         V6kuQ8mVjVWYioZ6Sxm13JmtDx9tbZ6XIOMBnAQUVfLCH0eZr/R5/p9u+GJwvZTAnx1u
         Ur7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fFkYoRlcZ7DAuy50t2oA1H8v1K6tu2QEpYiT33cX9Cw=;
        b=wZF/sT6NtoEkqBrg+6gl444yBm3AAJ7++xP7JLQxoe1oaNZ/i9OlDrkAIL+34Q6OY/
         qP4I6MZNZT6l76I+S5sW+/Qjvv48nVpOU1iBDk725GtYVEg4BdU8+2ai4R6iv9e3nw8b
         FTBV4ICgN/jR0l1JiVdPEMyPpMH1rN60q1bSTnca8pjZvzME//kSagKZE9K0upgDe33m
         IzGh6UdKQ0yHcc8q5m1rzUp8i0jJTPE5f6d+X6jJwb6vJbO60oLPjw1fW7gRY7oFrun2
         996UlHXFP6L3C+zCD4BJDh8gxdpvPUty0Qlyhgce+cJolCCpkVNYO2VlhG7KkooQlCEL
         iCcg==
X-Gm-Message-State: AOAM531v+iiZuED7P51TrDfAfjIdt7NJGAnUnE7MJFhUN6EKRfohivdb
        kOqJQ3V3YHZSruf5gaJdWpiL1+6GAqQ=
X-Google-Smtp-Source: ABdhPJwK0gq6ZUYwHQWB/ZzpMtztB6lOLkMn5+4PmCnDXKCKnS+2oZx4RzdNLQ7Fl0hadfUQb9M/+g==
X-Received: by 2002:a17:907:2daa:: with SMTP id gt42mr18785092ejc.583.1642580933114;
        Wed, 19 Jan 2022 00:28:53 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t14sm860838edq.24.2022.01.19.00.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:28:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 7/9] trace-cmd library: Avoid memory leak when setting trace clock
Date:   Wed, 19 Jan 2022 10:28:43 +0200
Message-Id: <20220119082845.245993-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082845.245993-1-tz.stoyanov@gmail.com>
References: <20220119082845.245993-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The API for setting a trace clock to a input handle did not check if the
clock is already set:
 tracecmd_set_out_clock()
This could cause a memory leak, if the clock is already set - the old
clock string is overwritten. The old clock should be freed before
setting the new one.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 612cb63d..78232bc9 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -216,8 +216,10 @@ void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet)
 
 void tracecmd_set_out_clock(struct tracecmd_output *handle, const char *clock)
 {
-	if (handle && clock)
+	if (handle && clock) {
+		free(handle->trace_clock);
 		handle->trace_clock = strdup(clock);
+	}
 }
 
 /**
-- 
2.34.1

