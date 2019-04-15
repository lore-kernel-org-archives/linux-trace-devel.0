Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2131C282DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 22:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1A1A20854
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 22:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Cb7aaKwi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfDOWxJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 18:53:09 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34472 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbfDOWxH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 18:53:07 -0400
Received: by mail-io1-f66.google.com with SMTP id n11so16052113ioh.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 15:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gdPoW9mhfi6soRZh5xEBsWtXHQf+l0G2eEYMV2IVYv0=;
        b=Cb7aaKwiFDjPX1hsQVWMdhof7UfTrhdSCipGghOvpHM29X6Q378GE+rYJ2MwWdc7HY
         7dxPhWQlRxoHIRBqY6cPWEYLJrSuzKU7zWvZlV4718swC2FM1unKHfUCW5Q+HqrhHski
         dowZmxjew6PmHD6wB8n6+BWB8tbCaur4x8a7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gdPoW9mhfi6soRZh5xEBsWtXHQf+l0G2eEYMV2IVYv0=;
        b=SW4w9040gxfGYpj7//jQYVgzMp8/+asef0EUPo0aniKSpWY0CcSyrnloFf7jhwlzQI
         SW6hDB0Gs5Hq02peFHfOrP9TpDSfY5X0rPZHgK7G4NKh4S5bYKiwdf+DJnR56kZxTAzo
         lIrKKRrRusIglr3w7yJ61k8ZcieLo7A2yA2xJADb5dq77KS8ngvp4rNDCGg9ltbUbXOL
         8fGevf4/e+PqNkCHHtrX7Zhz9T0afxxS4C+vYs0Otpz3MybjurnwQVDui2f+DZdtx28T
         VUKSj8vN4R2JlReNcsn9746ATz8YVLTNC/+knti89rgB7TcPTcNLSaRvCrX50D68G8yX
         oDbQ==
X-Gm-Message-State: APjAAAVd4KG2IfTU0GBF2V9HiYqoGxoUsilHh0RCBl85bVUHh9phM49J
        zuS6XseXCzoDhMkDveqZc9t/DQ==
X-Google-Smtp-Source: APXvYqyIPAyjx9oo54Bkr5S/JXYCCCJH5bow3kmenuIuyOIAUJLE4RhXwJ7MoxLERPst/6T7sucEIQ==
X-Received: by 2002:a5d:8b87:: with SMTP id p7mr16062565iol.64.1555368787253;
        Mon, 15 Apr 2019 15:53:07 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id t142sm8558391ita.38.2019.04.15.15.53.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 15:53:06 -0700 (PDT)
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
Subject: [PATCH v1 4/4] mmc: core: Add trace event for CSD response
Date:   Mon, 15 Apr 2019 16:52:41 -0600
Message-Id: <20190415225241.70088-4-rrangel@chromium.org>
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
mmc_csd: mmc0: struct: 0, cmdclass: 0x5b5, raw: {0x400e0032,0x5b590000,0x3b4b7f80,0xa404000}

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

 drivers/mmc/core/mmc.c     |  4 ++++
 drivers/mmc/core/sd.c      |  2 ++
 include/trace/events/mmc.h | 28 ++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

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
index cc33a4f96c6a..4e704a7280ba 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -183,6 +183,8 @@ static int mmc_decode_csd(struct mmc_card *card)
 
 	card->erase_size = csd->erase_size;
 
+	trace_mmc_csd(card);
+
 	return 0;
 }
 
diff --git a/include/trace/events/mmc.h b/include/trace/events/mmc.h
index fa82c010ae4e..58f6f7808974 100644
--- a/include/trace/events/mmc.h
+++ b/include/trace/events/mmc.h
@@ -174,6 +174,34 @@ TRACE_EVENT(sd_ssr,
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
+		__entry->structure = card->csd.structure;
+		__entry->cmdclass = card->csd.cmdclass;
+		memcpy(__entry->raw, card->raw_csd, sizeof(card->raw_csd));
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

