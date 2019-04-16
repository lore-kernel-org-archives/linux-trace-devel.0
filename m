Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F20C10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 18:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF33420449
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 18:33:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dWPzuqsY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbfDPSdM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 14:33:12 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40520 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfDPSdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 14:33:10 -0400
Received: by mail-it1-f196.google.com with SMTP id k64so341832itb.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Apr 2019 11:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bSTW7AqOpoUcz9Hrx03r2HNEdf+rvps0TZy7dgoXit4=;
        b=dWPzuqsYZ0A9aJIn+T09ptu3fGP9572YWbPHuDZDO5nqkUIoC/Lh9WC/BmHzQeOMcB
         Ynq3LHCSlrYYdhmf8Ca0xu0yvfIsC/SP9zpoMOd/dGucCqx4dCab5XoRIVhM7899xuON
         SXHslIOYI5Kut/yf/VAgb/lQ6QuZdQesAmSLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bSTW7AqOpoUcz9Hrx03r2HNEdf+rvps0TZy7dgoXit4=;
        b=FE6+rPdgzZ+Xl0wwOYTkePVPlusmNVnbei9cViShopcvkJoNeydGzn0PBxtjmSinlE
         PY5ijCbwJbuJ9nPZ1AECSj57rdcEOwVl9oAkIL9HLy2hfpdNdVtkZqTf/NtX9SMSsRAD
         4IGtk6k32H0/usJ8dkWq6XoVAdvUfyEhR4BK1tIVkz28DeE7CDBU5U2Dbg6bTpT2ny+p
         LlzNAqzPOqyur1QUei8fkwegi++QhoCP8C4bgAarEWUVzUpiMMNypNU9qRxGzupMeMtO
         PxP+Nli/0ec63BLkGhXQ22kdqQx4th9GtPzvqqK+h+cbK/5Yq5XxLMmnZmCeQoVuM78M
         KT5g==
X-Gm-Message-State: APjAAAVO/AkJdqzAEn5yQ9RDMng1W4z2YWXJlZeRhY7Eej55XzVBLRZn
        EHtThoxM9vWgiD1EVMHAQa4L0Q==
X-Google-Smtp-Source: APXvYqzRn8nV7EtohhwA6QeNt4cwOH1U/CXrYp7eE+jbOyuOoGHMbrK2k+Hi/Uce9AqyTkDiZF6NzA==
X-Received: by 2002:a24:89c3:: with SMTP id s186mr32815901itd.112.1555439590031;
        Tue, 16 Apr 2019 11:33:10 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id f126sm80256ita.31.2019.04.16.11.33.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 11:33:09 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-mmc@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     djkurtz@chromium.org, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        hongjiefang <hongjiefang@asrmicro.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Kyle Roeschley <kyle.roeschley@ni.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v2 1/4] mmc: core: Add trace event for SD SCR response
Date:   Tue, 16 Apr 2019 12:32:54 -0600
Message-Id: <20190416183257.247902-2-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190416183257.247902-1-rrangel@chromium.org>
References: <20190416183257.247902-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Example:
sd_scr: mmc0: version: 2, spec3: 1, width: [1-BIT | 4-BIT], cmds: [], raw: {0x2b58000,0x0} */

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

 drivers/mmc/core/sd.c      |  6 +++++
 include/trace/events/mmc.h | 51 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 265e1aeeb9d8..f1772972d6a3 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -21,6 +21,8 @@
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/sd.h>
 
+#include <trace/events/mmc.h>
+
 #include "core.h"
 #include "card.h"
 #include "host.h"
@@ -200,6 +202,7 @@ static int mmc_decode_scr(struct mmc_card *card)
 	if (scr_struct != 0) {
 		pr_err("%s: unrecognised SCR structure version %d\n",
 			mmc_hostname(card->host), scr_struct);
+		trace_sd_scr(card, NULL);
 		return -EINVAL;
 	}
 
@@ -221,6 +224,9 @@ static int mmc_decode_scr(struct mmc_card *card)
 
 	if (scr->sda_spec3)
 		scr->cmds = UNSTUFF_BITS(resp, 32, 2);
+
+	trace_sd_scr(card, scr);
+
 	return 0;
 }
 
diff --git a/include/trace/events/mmc.h b/include/trace/events/mmc.h
index 7b706ff21335..9761d3db16db 100644
--- a/include/trace/events/mmc.h
+++ b/include/trace/events/mmc.h
@@ -10,6 +10,57 @@
 #include <linux/mmc/host.h>
 #include <linux/tracepoint.h>
 
+#define SD_SCR_WIDTH_FLAGS		\
+	{SD_SCR_BUS_WIDTH_1, "1-BIT"},	\
+	{SD_SCR_BUS_WIDTH_4, "4-BIT"}
+
+#define SD_SCR_CMD_FLAGS		\
+	{SD_SCR_CMD20_SUPPORT, "CMD20"},\
+	{SD_SCR_CMD23_SUPPORT, "CMD23"}
+
+TRACE_EVENT(sd_scr,
+
+	TP_PROTO(struct mmc_card *card, struct sd_scr *scr),
+
+	TP_ARGS(card, scr),
+
+	TP_STRUCT__entry(
+		__array(u32,			raw,	2)
+		__field(unsigned char,		sda_vsn)
+		__field(unsigned char,		sda_spec3)
+		__field(unsigned char,		bus_widths)
+		__field(unsigned char,		cmds)
+		__string(name,			mmc_hostname(card->host))
+	),
+
+	TP_fast_assign(
+		BUILD_BUG_ON(sizeof(card->raw_scr) != sizeof(__entry->raw));
+		memcpy(__entry->raw, card->raw_scr, sizeof(__entry->raw));
+		if (scr) {
+			__entry->sda_vsn = scr->sda_vsn;
+			__entry->sda_spec3 = scr->sda_spec3;
+			__entry->bus_widths = scr->bus_widths;
+			__entry->cmds = scr->cmds;
+		} else {
+			__entry->sda_vsn = 0;
+			__entry->sda_spec3 = 0;
+			__entry->bus_widths = 0;
+			__entry->cmds = 0;
+		}
+		__assign_str(name, mmc_hostname(card->host));
+	),
+
+	TP_printk("%s: version: %d, spec3: %d, width: [%s], cmds: [%s], "
+		  "raw: %s",
+		  __get_str(name),
+		  __entry->sda_vsn,
+		  __entry->sda_spec3,
+		  __print_flags(__entry->bus_widths, " | ", SD_SCR_WIDTH_FLAGS),
+		  __print_flags(__entry->cmds, " | ", SD_SCR_CMD_FLAGS),
+		  __print_array(__entry->raw, 2, sizeof(u32))
+	)
+);
+
 TRACE_EVENT(mmc_request_start,
 
 	TP_PROTO(struct mmc_host *host, struct mmc_request *mrq),
-- 
2.21.0.392.gf8f6787159e-goog

