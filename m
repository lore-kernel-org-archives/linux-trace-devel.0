Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28A0C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 18:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A558420449
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 18:33:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TYgdyooD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfDPSd1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 14:33:27 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:52384 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730280AbfDPSdT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 14:33:19 -0400
Received: by mail-it1-f193.google.com with SMTP id x132so375108itf.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Apr 2019 11:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F3GPaWxyQHkj77z2s2eVPCGI01KnC8ViCHmTdyBvcOU=;
        b=TYgdyooDOXKuuhaht5S5dTCrXIc6mB+6oviKJo14tF4ChMKI0wLDdf3QmJW8ZscNB+
         fKSjrQSrEV81py88vVUlJlbjxUy7eMW0FJBjzq8t9voUlRuPpiM7Crpp2tjMjKfEyOe1
         4qsbNscB/a3xXglB+tPSE78EmnwpZY50JeAh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F3GPaWxyQHkj77z2s2eVPCGI01KnC8ViCHmTdyBvcOU=;
        b=jfArLHeY0tklmA6296csyflaqTVQPwdVYDoqI5PVpAj0H/kxrEoG2xvBdGy1UgFxP7
         2sG5EsN71GW56kKdq3OptSsmBlgjM58hQinS5SieimEgfO3JZ51DQ/5O2rYJxmqiwsOg
         esefWWs5PHGTgDOtDD9bgqcNK1MGZOwrf1Fg0lRBa3VTYH5Hbv/ippDubS4Xkf3h2zUV
         16XDfJzd6DpfnVuJd4IsbrUG/riDO837XHkJ28X/HvHR4D9bh5rktG8tTMh9CoO5Igo7
         /OSS3CDpShFz+NryTjSSgFIH1bxvZjry70RbEZ/ZfeWqNJklol3nBl13zDKvrvIrKUm1
         wpuA==
X-Gm-Message-State: APjAAAVtLYaX4Vk7o3+BqeTBuOSL22X5OZSAYEtV/53Crba7tmaDbxQL
        PfgHPZyHXg2S28XzQFIv/luexQ==
X-Google-Smtp-Source: APXvYqyUEAIZVeWfBmzRRg9tdYk+hBJwi3c2BMG1LanJailJTOvWT5vm8VLN+5bDqavqhvrdcAMEOA==
X-Received: by 2002:a24:4161:: with SMTP id x94mr31426514ita.83.1555439598146;
        Tue, 16 Apr 2019 11:33:18 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id m25sm92094iti.24.2019.04.16.11.33.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 11:33:17 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-mmc@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     djkurtz@chromium.org, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        hongjiefang <hongjiefang@asrmicro.com>,
        Jennifer Dahm <jennifer.dahm@ni.com>,
        linux-kernel@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Kyle Roeschley <kyle.roeschley@ni.com>,
        Ingo Molnar <mingo@redhat.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH v2 4/4] mmc: core: Add trace event for CSD response
Date:   Tue, 16 Apr 2019 12:32:57 -0600
Message-Id: <20190416183257.247902-5-rrangel@chromium.org>
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
mmc_csd: mmc0: struct: 0, cmdclass: 0x5b5, raw: {0x400e0032,0x5b590000,0x3b4b7f80,0xa404000}

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

 drivers/mmc/core/mmc.c     |  4 ++++
 drivers/mmc/core/sd.c      |  2 ++
 include/trace/events/mmc.h | 29 +++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 3e786ba204c3..46ce894f7c03 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -20,6 +20,8 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/mmc.h>
 
+#include <trace/events/mmc.h>
+
 #include "core.h"
 #include "card.h"
 #include "host.h"
@@ -182,6 +184,8 @@ static int mmc_decode_csd(struct mmc_card *card)
 		csd->erase_size <<= csd->write_blkbits - 9;
 	}
 
+	trace_mmc_csd(card);
+
 	return 0;
 }
 
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 908c3087cdcd..3b2e09fa72c5 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -183,6 +183,8 @@ static int mmc_decode_csd(struct mmc_card *card)
 
 	card->erase_size = csd->erase_size;
 
+	trace_mmc_csd(card);
+
 	return 0;
 }
 
diff --git a/include/trace/events/mmc.h b/include/trace/events/mmc.h
index 8d97810221cd..46fd918bcae3 100644
--- a/include/trace/events/mmc.h
+++ b/include/trace/events/mmc.h
@@ -185,6 +185,35 @@ TRACE_EVENT(sd_ssr,
 	)
 );
 
+TRACE_EVENT(mmc_csd,
+
+	TP_PROTO(struct mmc_card *card),
+
+	TP_ARGS(card),
+
+	TP_STRUCT__entry(
+		__array(u32,			raw,	4)
+		__field(unsigned char,		structure)
+		__field(unsigned short,		cmdclass)
+		__string(name,			mmc_hostname(card->host))
+	),
+
+	TP_fast_assign(
+		BUILD_BUG_ON(sizeof(card->raw_csd) != sizeof(__entry->raw));
+		memcpy(__entry->raw, card->raw_csd, sizeof(__entry->raw));
+		__entry->structure = card->csd.structure;
+		__entry->cmdclass = card->csd.cmdclass;
+		__assign_str(name, mmc_hostname(card->host));
+	),
+
+	TP_printk("%s: struct: %d, cmdclass: %#x, raw: %s",
+		  __get_str(name),
+		  __entry->structure,
+		  __entry->cmdclass,
+		  __print_array(__entry->raw, 4, sizeof(u32))
+	)
+);
+
 TRACE_EVENT(mmc_request_start,
 
 	TP_PROTO(struct mmc_host *host, struct mmc_request *mrq),
-- 
2.21.0.392.gf8f6787159e-goog

