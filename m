Return-Path: <SRS0=mCQn=SN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADF4C10F13
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A1CA2186A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:09:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FeYTKpFs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfDKWJT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 18:09:19 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46254 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbfDKWJR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 18:09:17 -0400
Received: by mail-io1-f65.google.com with SMTP id p23so6735891iol.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Apr 2019 15:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N+KHzpPEzxiX0Ro0ISDWs6yLhJrXHxEIc70pati1wqs=;
        b=FeYTKpFszOooF+/VXmGwfotFmY6sJjBJgnEw8svTmrSBBHwzbiFTO6v/mrOiGed1Cw
         /G6E25Z2LmpBH4gNc2CNAEa/9GYdk1IDDxciHbuLdKx70RtfF/+ro028wJ9eMlP/mCyC
         jGD2RhdiRsP51Y6TJ/JtvHNwAZ46PLUDQ9CYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N+KHzpPEzxiX0Ro0ISDWs6yLhJrXHxEIc70pati1wqs=;
        b=WTyj5vaCfOjM3ToDw3YPgGr6ZwpPbQHC196c9XMeDzhB/zkkVGBpbtBqCnDUo1IFgJ
         dwhBKk7OqqgAGLLnzZx6teO6lYcRjTL1voLwbQC9v+H1PpuLxCpsRDaElW566W7wHsc7
         Xp8gI2fxuvepe/6+OsYj0M7A8aGkgO0IRQdiDb8nQ4fPCS+uF7ybzcG/HaReShl3ypmF
         ivIaoSIpA5/aJ5EmiKzHaN4867dbXOtEgy/dmaUx81eiVLSsR/SHqe4ZrKbyi4guHfvJ
         gtwy3dKTMLKImlCowiTgCnq7fWC3dkFfB6wpg+UnRsP9wQNJzah1BQv/eK1mwWZygOZY
         m1Fw==
X-Gm-Message-State: APjAAAV67DRsoUvFZwcJB3JkIfYrXE1E4WQh2cIV24f7Y8qCGlUVj5hd
        6Mrf+87COqzMVmhaZUuULjBKhFK72nnb4JxS
X-Google-Smtp-Source: APXvYqzZvqo2Fa50VZvneu8l4Ia4IBaVyJuX+A7oLhdoPC0oid4xoRz96FTFJ4LlnFDP6yZL7pr/7A==
X-Received: by 2002:a5e:c019:: with SMTP id u25mr34184557iol.104.1555020556664;
        Thu, 11 Apr 2019 15:09:16 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id m81sm3327620itm.33.2019.04.11.15.09.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 15:09:16 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-trace-devel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc:     djkurtz@chromium.org, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v1 4/4] mmc/host/sdhci: Make sdhci_read/sdhci_write call trace functions
Date:   Thu, 11 Apr 2019 16:08:22 -0600
Message-Id: <20190411220822.81845-5-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190411220822.81845-1-rrangel@chromium.org>
References: <20190411220822.81845-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

An example trace can be seen here: https://pastebin.com/x73d5cvL

I was unable to leave sdhci_readX and sdhci_writeX as macros because
they are used in other modules (i.e., sdhci-pci). This means they can't
call the trace_sdhci_XXX functions without explicitly exporting the
private trace function name.

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

 drivers/mmc/host/sdhci-core.c | 136 ++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.h      |  89 ++--------------------
 2 files changed, 142 insertions(+), 83 deletions(-)

diff --git a/drivers/mmc/host/sdhci-core.c b/drivers/mmc/host/sdhci-core.c
index a8141ff9be03..9e3f114629d9 100644
--- a/drivers/mmc/host/sdhci-core.c
+++ b/drivers/mmc/host/sdhci-core.c
@@ -36,6 +36,7 @@
 #include <linux/mmc/slot-gpio.h>
 
 #include "sdhci.h"
+#include "sdhci-trace.h"
 
 #define DRIVER_NAME "sdhci"
 
@@ -54,6 +55,141 @@ static void sdhci_finish_data(struct sdhci_host *);
 
 static void sdhci_enable_preset_value(struct sdhci_host *host, bool enable);
 
+#ifdef CONFIG_MMC_SDHCI_IO_ACCESSORS
+
+void sdhci_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	trace_sdhci_write(host, reg, val, U32_MAX);
+
+	if (unlikely(host->ops->write_l))
+		host->ops->write_l(host, val, reg);
+	else
+		writel(val, host->ioaddr + reg);
+}
+EXPORT_SYMBOL(sdhci_writel);
+
+void sdhci_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	trace_sdhci_write(host, reg, val, U16_MAX);
+
+	if (unlikely(host->ops->write_w))
+		host->ops->write_w(host, val, reg);
+	else
+		writew(val, host->ioaddr + reg);
+}
+EXPORT_SYMBOL(sdhci_writew);
+
+void sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	trace_sdhci_write(host, reg, val, U8_MAX);
+
+	if (unlikely(host->ops->write_b))
+		host->ops->write_b(host, val, reg);
+	else
+		writeb(val, host->ioaddr + reg);
+}
+EXPORT_SYMBOL(sdhci_writeb);
+
+u32 sdhci_readl(struct sdhci_host *host, int reg)
+{
+	u32 val;
+
+	if (unlikely(host->ops->read_l))
+		val = host->ops->read_l(host, reg);
+	else
+		val = readl(host->ioaddr + reg);
+
+	trace_sdhci_read(host, reg, val, U32_MAX);
+
+	return val;
+}
+EXPORT_SYMBOL(sdhci_readl);
+
+u16 sdhci_readw(struct sdhci_host *host, int reg)
+{
+	u16 val;
+
+	if (unlikely(host->ops->read_w))
+		val = host->ops->read_w(host, reg);
+	else
+		val = readw(host->ioaddr + reg);
+
+	trace_sdhci_read(host, reg, val, U16_MAX);
+
+	return val;
+}
+EXPORT_SYMBOL(sdhci_readw);
+
+u8 sdhci_readb(struct sdhci_host *host, int reg)
+{
+	u8 val;
+
+	if (unlikely(host->ops->read_b))
+		val = host->ops->read_b(host, reg);
+	else
+		val = readb(host->ioaddr + reg);
+
+	trace_sdhci_read(host, reg, val, U8_MAX);
+
+	return val;
+}
+EXPORT_SYMBOL(sdhci_readb);
+
+#else
+
+void sdhci_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	trace_sdhci_write(host, reg, val, U32_MAX);
+	writel(val, host->ioaddr + reg);
+}
+EXPORT_SYMBOL(sdhci_writel);
+
+void sdhci_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	trace_sdhci_write(host, reg, val, U16_MAX);
+	writew(val, host->ioaddr + reg);
+}
+EXPORT_SYMBOL(sdhci_writew);
+
+void sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	trace_sdhci_write(host, reg, val, U8_MAX);
+	writeb(val, host->ioaddr + reg);
+}
+EXPORT_SYMBOL(sdhci_writeb);
+
+u32 sdhci_readl(struct sdhci_host *host, int reg)
+{
+	u32 val = readl(host->ioaddr + reg);
+
+	trace_sdhci_read(host, reg, val, U32_MAX);
+
+	return val;
+}
+EXPORT_SYMBOL(sdhci_readl);
+
+u16 sdhci_readw(struct sdhci_host *host, int reg)
+{
+	u16 val = readw(host->ioaddr + reg);
+
+	trace_sdhci_read(host, reg, val, U16_MAX);
+
+	return val;
+}
+EXPORT_SYMBOL(sdhci_readw);
+
+u8 sdhci_readb(struct sdhci_host *host, int reg)
+{
+	u8 val = readb(host->ioaddr + reg);
+
+	trace_sdhci_read(host, reg, val, U8_MAX);
+
+	return val;
+}
+EXPORT_SYMBOL(sdhci_readb);
+
+#endif /* CONFIG_MMC_SDHCI_IO_ACCESSORS */
+
 void sdhci_dumpregs(struct sdhci_host *host)
 {
 	SDHCI_DUMP("============ SDHCI REGISTER DUMP ===========\n");
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 01002cba1359..052361f27ec0 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -647,89 +647,12 @@ struct sdhci_ops {
 				   dma_addr_t addr, int len, unsigned int cmd);
 };
 
-#ifdef CONFIG_MMC_SDHCI_IO_ACCESSORS
-
-static inline void sdhci_writel(struct sdhci_host *host, u32 val, int reg)
-{
-	if (unlikely(host->ops->write_l))
-		host->ops->write_l(host, val, reg);
-	else
-		writel(val, host->ioaddr + reg);
-}
-
-static inline void sdhci_writew(struct sdhci_host *host, u16 val, int reg)
-{
-	if (unlikely(host->ops->write_w))
-		host->ops->write_w(host, val, reg);
-	else
-		writew(val, host->ioaddr + reg);
-}
-
-static inline void sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
-{
-	if (unlikely(host->ops->write_b))
-		host->ops->write_b(host, val, reg);
-	else
-		writeb(val, host->ioaddr + reg);
-}
-
-static inline u32 sdhci_readl(struct sdhci_host *host, int reg)
-{
-	if (unlikely(host->ops->read_l))
-		return host->ops->read_l(host, reg);
-	else
-		return readl(host->ioaddr + reg);
-}
-
-static inline u16 sdhci_readw(struct sdhci_host *host, int reg)
-{
-	if (unlikely(host->ops->read_w))
-		return host->ops->read_w(host, reg);
-	else
-		return readw(host->ioaddr + reg);
-}
-
-static inline u8 sdhci_readb(struct sdhci_host *host, int reg)
-{
-	if (unlikely(host->ops->read_b))
-		return host->ops->read_b(host, reg);
-	else
-		return readb(host->ioaddr + reg);
-}
-
-#else
-
-static inline void sdhci_writel(struct sdhci_host *host, u32 val, int reg)
-{
-	writel(val, host->ioaddr + reg);
-}
-
-static inline void sdhci_writew(struct sdhci_host *host, u16 val, int reg)
-{
-	writew(val, host->ioaddr + reg);
-}
-
-static inline void sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
-{
-	writeb(val, host->ioaddr + reg);
-}
-
-static inline u32 sdhci_readl(struct sdhci_host *host, int reg)
-{
-	return readl(host->ioaddr + reg);
-}
-
-static inline u16 sdhci_readw(struct sdhci_host *host, int reg)
-{
-	return readw(host->ioaddr + reg);
-}
-
-static inline u8 sdhci_readb(struct sdhci_host *host, int reg)
-{
-	return readb(host->ioaddr + reg);
-}
-
-#endif /* CONFIG_MMC_SDHCI_IO_ACCESSORS */
+void sdhci_writel(struct sdhci_host *host, u32 val, int reg);
+void sdhci_writew(struct sdhci_host *host, u16 val, int reg);
+void sdhci_writeb(struct sdhci_host *host, u8 val, int reg);
+u32 sdhci_readl(struct sdhci_host *host, int reg);
+u16 sdhci_readw(struct sdhci_host *host, int reg);
+u8 sdhci_readb(struct sdhci_host *host, int reg);
 
 struct sdhci_host *sdhci_alloc_host(struct device *dev, size_t priv_size);
 void sdhci_free_host(struct sdhci_host *host);
-- 
2.21.0.392.gf8f6787159e-goog

