Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2E8C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 22:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82AE420854
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 22:53:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WoXuGsbR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfDOWxJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 18:53:09 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:56036 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbfDOWxG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 18:53:06 -0400
Received: by mail-it1-f196.google.com with SMTP id y134so29931697itc.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 15:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dCSkPH4TEhOz2CVPriVw70SoAjwKpU3zKt3o48+f2Wk=;
        b=WoXuGsbRkxzkwFjOGTtN8Hqe2wRfRX/dbzNn8LpwMLZX/HIIy0/Ap2Ki2F8YaNhDAz
         Fr/bI0g7oKJevTzjCeEOrgCWj4RCpvSJ0vIkDhX+kL67FjCA4Kb920O0HFS2L4mUddVX
         e78632JsQl/VIlJxuSJQwOmebj6lgM8gYau8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dCSkPH4TEhOz2CVPriVw70SoAjwKpU3zKt3o48+f2Wk=;
        b=KPsmjFu2QXl8Ef2w4T1ThQyzX6h5Qnpl531wV1hkxObUGFxPSEPlge4B5PUGQmg8Ho
         KlsSuSax3bO5NHV53FTARx+Fn49NLJcQ72mEC/J9EGrK/QnS4AGg0cr6pnlSWe5ebD4f
         TM5OXFMtZkjedLxBktLz7btRANpWUV1fTeHvUC9SaElxia+V8w9kuy+Ir9KEXIpe10s6
         NH/+jHzM3KD2YJum/9sqdQwkbUhA3NpqBejRlA8xgLP8XIY7LSDc0xB+ITK7Z0unZc0O
         fNOldi5EUMXh0gPL4zhln/5pQnYbTQA//iy/KSUE57tDefCoVFgejyOsAR+jlIBv7NU+
         jLGQ==
X-Gm-Message-State: APjAAAWG8eSsQPNKDo4QYZuaMfmwpTWo7BMVFvJFyAODZtOaKA+cMlCR
        zBvPN01BslNrUv8HGHpEV6T3qg==
X-Google-Smtp-Source: APXvYqxOdeCpQnCSsNDLCXeaHYXbWr7z75PVoYUDgI+R5yRn9DgBxNpGDpClFJrnFW3uHHxUbJ7hPg==
X-Received: by 2002:a24:13c7:: with SMTP id 190mr28753654itz.9.1555368785341;
        Mon, 15 Apr 2019 15:53:05 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id o203sm8021762itd.1.2019.04.15.15.53.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 15:53:04 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-mmc@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     djkurtz@chromium.org, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v1 3/4] mmc: core: Add trace event for SD OCR response
Date:   Mon, 15 Apr 2019 16:52:40 -0600
Message-Id: <20190415225241.70088-3-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190415225241.70088-1-rrangel@chromium.org>
References: <20190415225241.70088-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Example:
ocr_request: mmc0: 0x51200000 SDHC or SDXC Supported (HCS) | Maximum Performance (XPC) | Switch to 1.8V (S18R) | 3.3 ~ 3.4
ocr_response: mmc0: 0xff8000 2.7 ~ 2.8 | 2.8 ~ 2.9 | 2.9 ~ 3.0 | 3.0 ~ 3.1 | 3.1 ~ 3.2 | 3.2 ~ 3.3 | 3.3 ~ 3.4 | 3.4 ~ 3.5 | 3.5 ~ 3.6

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

 drivers/mmc/core/sd_ops.c  |  6 +++
 include/trace/events/mmc.h | 91 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/drivers/mmc/core/sd_ops.c b/drivers/mmc/core/sd_ops.c
index 0bb0b8419016..4cf0f040f896 100644
--- a/drivers/mmc/core/sd_ops.c
+++ b/drivers/mmc/core/sd_ops.c
@@ -19,6 +19,8 @@
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/sd.h>
 
+#include <trace/events/mmc.h>
+
 #include "core.h"
 #include "sd_ops.h"
 
@@ -130,11 +132,15 @@ int mmc_send_app_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr)
 		cmd.arg = ocr;
 	cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R3 | MMC_CMD_BCR;
 
+	trace_sd_ocr_request(host, ocr);
+
 	for (i = 100; i; i--) {
 		err = mmc_wait_for_app_cmd(host, NULL, &cmd);
 		if (err)
 			break;
 
+		trace_sd_ocr_response(host, cmd.resp[0]);
+
 		/* if we're just probing, do a single pass */
 		if (ocr == 0)
 			break;
diff --git a/include/trace/events/mmc.h b/include/trace/events/mmc.h
index cad604ee800f..fa82c010ae4e 100644
--- a/include/trace/events/mmc.h
+++ b/include/trace/events/mmc.h
@@ -10,6 +10,97 @@
 #include <linux/mmc/host.h>
 #include <linux/tracepoint.h>
 
+#define SD_OCR_REQUEST \
+	{SD_OCR_CCS, "SDHC or SDXC Supported (HCS)"}, \
+	{SD_OCR_XPC, "Maximum Performance (XPC)"}, \
+	{SD_ROCR_S18A, "Switch to 1.8V (S18R)"}, \
+	{MMC_VDD_165_195, "1.65 - 1.95"}, \
+	{MMC_VDD_20_21, "2.0 ~ 2.1"}, \
+	{MMC_VDD_21_22, "2.1 ~ 2.2"}, \
+	{MMC_VDD_22_23, "2.2 ~ 2.3"}, \
+	{MMC_VDD_23_24, "2.3 ~ 2.4"}, \
+	{MMC_VDD_24_25, "2.4 ~ 2.5"}, \
+	{MMC_VDD_25_26, "2.5 ~ 2.6"}, \
+	{MMC_VDD_26_27, "2.6 ~ 2.7"}, \
+	{MMC_VDD_27_28, "2.7 ~ 2.8"}, \
+	{MMC_VDD_28_29, "2.8 ~ 2.9"}, \
+	{MMC_VDD_29_30, "2.9 ~ 3.0"}, \
+	{MMC_VDD_30_31, "3.0 ~ 3.1"}, \
+	{MMC_VDD_31_32, "3.1 ~ 3.2"}, \
+	{MMC_VDD_32_33, "3.2 ~ 3.3"}, \
+	{MMC_VDD_33_34, "3.3 ~ 3.4"}, \
+	{MMC_VDD_34_35, "3.4 ~ 3.5"}, \
+	{MMC_VDD_35_36, "3.5 ~ 3.6"} \
+
+TRACE_EVENT(sd_ocr_request,
+
+	TP_PROTO(struct mmc_host *host, u32 ocr),
+
+	TP_ARGS(host, ocr),
+
+	TP_STRUCT__entry(
+		__field(u32,			ocr)
+		__string(name,			mmc_hostname(host))
+	),
+
+	TP_fast_assign(
+		__entry->ocr = ocr;
+		__assign_str(name, mmc_hostname(host));
+	),
+
+	TP_printk("%s: %#x %s",
+		  __get_str(name),
+		  __entry->ocr,
+		  __print_flags(__entry->ocr, " | ", SD_OCR_REQUEST)
+	)
+);
+
+#define SD_OCR_RESPONSE \
+	{MMC_CARD_BUSY, "Ready"}, \
+	{SD_OCR_CCS, "SDHC or SDXC (CCS)"}, \
+	{(1<<29), "UHS-II Card"}, \
+	{SD_ROCR_S18A, "1.8V Accepted (S18A)"}, \
+	{MMC_VDD_165_195, "1.65 - 1.95"}, \
+	{MMC_VDD_20_21, "2.0 ~ 2.1"}, \
+	{MMC_VDD_21_22, "2.1 ~ 2.2"}, \
+	{MMC_VDD_22_23, "2.2 ~ 2.3"}, \
+	{MMC_VDD_23_24, "2.3 ~ 2.4"}, \
+	{MMC_VDD_24_25, "2.4 ~ 2.5"}, \
+	{MMC_VDD_25_26, "2.5 ~ 2.6"}, \
+	{MMC_VDD_26_27, "2.6 ~ 2.7"}, \
+	{MMC_VDD_27_28, "2.7 ~ 2.8"}, \
+	{MMC_VDD_28_29, "2.8 ~ 2.9"}, \
+	{MMC_VDD_29_30, "2.9 ~ 3.0"}, \
+	{MMC_VDD_30_31, "3.0 ~ 3.1"}, \
+	{MMC_VDD_31_32, "3.1 ~ 3.2"}, \
+	{MMC_VDD_32_33, "3.2 ~ 3.3"}, \
+	{MMC_VDD_33_34, "3.3 ~ 3.4"}, \
+	{MMC_VDD_34_35, "3.4 ~ 3.5"}, \
+	{MMC_VDD_35_36, "3.5 ~ 3.6"}
+
+TRACE_EVENT(sd_ocr_response,
+
+	TP_PROTO(struct mmc_host *host, u32 ocr),
+
+	TP_ARGS(host, ocr),
+
+	TP_STRUCT__entry(
+		__field(u32,			ocr)
+		__string(name,			mmc_hostname(host))
+	),
+
+	TP_fast_assign(
+		__entry->ocr = ocr;
+		__assign_str(name, mmc_hostname(host));
+	),
+
+	TP_printk("%s: %#x %s",
+		  __get_str(name),
+		  __entry->ocr,
+		  __print_flags(__entry->ocr, " | ", SD_OCR_RESPONSE)
+	)
+);
+
 TRACE_EVENT(sd_scr,
 
 	TP_PROTO(struct mmc_card *card, struct sd_scr *scr),
-- 
2.21.0.392.gf8f6787159e-goog

