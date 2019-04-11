Return-Path: <SRS0=mCQn=SN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C352DC10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85E082186A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UHt7t4Si"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfDKWJQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 18:09:16 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:37340 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbfDKWJQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 18:09:16 -0400
Received: by mail-it1-f194.google.com with SMTP id u65so12276172itc.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Apr 2019 15:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+QeQLX0mAL0xDYapFvSc2hvWKP5EN3qUUM0s87Z38NA=;
        b=UHt7t4SiHx29JFZhRo0elM+V8rZZIk3rSHCq8/0Uk4vbSlGAW2tVW/R4YVvdr/FAK3
         evhhCl6LQs4W6Q/HEFXUmChU8dVTbYnSMbzRRMZhEQEsqbK5Z4K7pmLIwYVQPJ2QVJqd
         kviOCraNPqshq8BayjWCxQHyAWgdPEisp9zpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QeQLX0mAL0xDYapFvSc2hvWKP5EN3qUUM0s87Z38NA=;
        b=U76R5JIsE/EAou8zoY0YCjZvI0gLghFeZUH2y9IK/D78Apm7uEhIuSxeIwXBzW1Krz
         3yahgccbs9UDewmQbysWOWEcM6j9AoqXdtjHAJL+fVqbP/vgeitA9/w/1Y5/ZyXrWtAj
         o+etBBJD6J2HKcydS0Q8O+bfDe2Zsb6OZ3JPznZ/f2YPWvz1a6Yb9uSeyEqQSaPxsRVI
         dVBuFuLCa1t8L5J53BeR8tndask0SFeUXlfdT8ul83kKXXM9hHJhLKLj4h6xYtcJgOGj
         KvFJL+5V2Bp7dyWBiTNL2c0zLfs18d9jZxltOPN/wnO5psrpH2a6yNm+oHZrCVNdmLAd
         QR/Q==
X-Gm-Message-State: APjAAAWhhkm6xpXFI9VTy9sZXeQSes33rtXu2CwT4BxP1uGmPVfSNmgI
        6Gwcx3j7mN4KhXThnRmERaW42zSPdj8Yut5f
X-Google-Smtp-Source: APXvYqwQjmXcMSo2q5aOS1N1gm3IzbNsvBP4QwldAS/RJHHQR/R5wsMbVHwqk6zmbqIaCcQzT0ncVg==
X-Received: by 2002:a24:4746:: with SMTP id t67mr10049857itb.123.1555020554030;
        Thu, 11 Apr 2019 15:09:14 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id 67sm3339214itz.37.2019.04.11.15.09.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 15:09:13 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-trace-devel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc:     djkurtz@chromium.org, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Ludovic Barre <ludovic.barre@st.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Liming Sun <lsun@mellanox.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Prabu Thangamuthu <Prabu.T@synopsys.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v1 3/4] mmc/host/sdhci: Add register read and write trace events
Date:   Thu, 11 Apr 2019 16:08:21 -0600
Message-Id: <20190411220822.81845-4-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190411220822.81845-1-rrangel@chromium.org>
References: <20190411220822.81845-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adds an sdhci-trace object file that is linked with the sdhci module.
This will allow sdhci-core to call the trace functions.

There weren't constants defined for some of the fields, so I just used
the raw values.

See the next change for usage.

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

 drivers/mmc/host/Makefile      |   5 +-
 drivers/mmc/host/sdhci-trace.c | 319 +++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci-trace.h |  93 ++++++++++
 3 files changed, 416 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mmc/host/sdhci-trace.c
 create mode 100644 drivers/mmc/host/sdhci-trace.h

diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 11174945c116..1cb695a3b359 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -3,6 +3,9 @@
 # Makefile for MMC/SD host controller drivers
 #
 
+# tell define_trace.h where to find the sdhci trace header
+CFLAGS_sdhci-trace.o := -I$(src)
+
 obj-$(CONFIG_MMC_ARMMMCI) += armmmci.o
 armmmci-y := mmci.o
 armmmci-$(CONFIG_MMC_QCOM_DML) += mmci_qcom_dml.o
@@ -11,7 +14,7 @@ obj-$(CONFIG_MMC_PXA)		+= pxamci.o
 obj-$(CONFIG_MMC_MXC)		+= mxcmmc.o
 obj-$(CONFIG_MMC_MXS)		+= mxs-mmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
-sdhci-objs			+= sdhci-core.o
+sdhci-objs			+= sdhci-core.o sdhci-trace.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
 sdhci-pci-y			+= sdhci-pci-core.o sdhci-pci-o2micro.o sdhci-pci-arasan.o \
 				   sdhci-pci-dwc-mshc.o
diff --git a/drivers/mmc/host/sdhci-trace.c b/drivers/mmc/host/sdhci-trace.c
new file mode 100644
index 000000000000..a7d803470664
--- /dev/null
+++ b/drivers/mmc/host/sdhci-trace.c
@@ -0,0 +1,319 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright 2019 Google LLC.
+
+#include <linux/trace_events.h>
+#include "sdhci.h"
+
+#define SDHCI_REGS \
+	{SDHCI_DMA_ADDRESS, "DMA_ADDRESS"}, \
+	{SDHCI_BLOCK_SIZE, "BLOCK_SIZE"}, \
+	{SDHCI_ARGUMENT, "ARGUMENT"}, \
+	{SDHCI_TRANSFER_MODE, "TRANSFER_MODE"}, \
+	{SDHCI_RESPONSE, "RESP10"}, \
+	{SDHCI_RESPONSE + 4, "RESP32"}, \
+	{SDHCI_RESPONSE + 8, "RESP54"}, \
+	{SDHCI_RESPONSE + 12, "RESP76"}, \
+	{SDHCI_BUFFER, "BUFFER"}, \
+	{SDHCI_PRESENT_STATE, "PRESENT_STATE"}, \
+	{SDHCI_HOST_CONTROL, "HOST_CONTROL"}, \
+	{SDHCI_CLOCK_CONTROL, "CLOCK_CONTROL"}, \
+	{SDHCI_INT_STATUS, "INT_STATUS"}, \
+	{SDHCI_INT_ENABLE, "INT_ENABLE"}, \
+	{SDHCI_SIGNAL_ENABLE, "SIGNAL_ENABLE"}, \
+	{SDHCI_ACMD12_ERR, "ACMD12_ERR"}, \
+	{SDHCI_CAPABILITIES, "CAPABILITIES"}, \
+	{SDHCI_CAPABILITIES_1, "CAPABILITIES_1"}, \
+	{SDHCI_MAX_CURRENT, "MAX_CURRENT"}, \
+	{SDHCI_SET_ACMD12_ERROR, "SET_ACMD12_ERROR"}, \
+	{SDHCI_ADMA_ERROR, "ADMA_ERROR"}, \
+	{SDHCI_ADMA_ADDRESS, "ADMA_ADDRESS"}, \
+	{SDHCI_ADMA_ADDRESS_HI, "ADMA_ADDRESS_HI"}, \
+	{SDHCI_SLOT_INT_STATUS, "SLOT_INT_STATUS"}
+
+static const struct trace_print_flags const int_flags[] = {
+	{SDHCI_INT_RESPONSE, "RESPONSE"},
+	{SDHCI_INT_DATA_END, "DATA_END"},
+	{SDHCI_INT_BLK_GAP, "BLK_GAP"},
+	{SDHCI_INT_DMA_END, "DMA_END"},
+	{SDHCI_INT_SPACE_AVAIL, "SPACE_AVAIL"},
+	{SDHCI_INT_DATA_AVAIL, "DATA_AVAIL"},
+	{SDHCI_INT_CARD_INSERT, "CARD_INSERT"},
+	{SDHCI_INT_CARD_REMOVE, "CARD_REMOVE"},
+	{SDHCI_INT_CARD_INT, "CARD_INT"},
+	{SDHCI_INT_RETUNE, "RETUNE"},
+	{SDHCI_INT_CQE, "CQE"},
+	{SDHCI_INT_ERROR, "ERROR"},
+	{SDHCI_INT_TIMEOUT, "TIMEOUT"},
+	{SDHCI_INT_CRC, "CRC"},
+	{SDHCI_INT_END_BIT, "END_BIT"},
+	{SDHCI_INT_INDEX, "INDEX"},
+	{SDHCI_INT_DATA_TIMEOUT, "DATA_TIMEOUT"},
+	{SDHCI_INT_DATA_CRC, "DATA_CRC"},
+	{SDHCI_INT_DATA_END_BIT, "DATA_END_BIT"},
+	{SDHCI_INT_BUS_POWER, "BUS_POWER"},
+	{SDHCI_INT_ACMD12ERR, "ACMD12ERR"},
+	{SDHCI_INT_ADMA_ERROR, "ADMA_ERROR"},
+	{ -1, NULL }
+};
+
+static const struct trace_print_flags const present_state_flags[] = {
+	{SDHCI_CMD_INHIBIT, "CMD_INHIBIT"},
+	{SDHCI_DATA_INHIBIT, "DATA_INHIBIT"},
+	{1<<2, "DAT_LINE_ACTIVE"},
+	{SDHCI_DOING_WRITE, "DOING_WRITE"},
+	{SDHCI_DOING_READ, "DOING_READ"},
+	{SDHCI_SPACE_AVAILABLE, "SPACE_AVAILABLE"},
+	{SDHCI_DATA_AVAILABLE, "DATA_AVAILABLE"},
+	{SDHCI_CARD_PRESENT, "CARD_PRESENT"},
+	{1<<17, "CARD_STABLE"},
+	{1<<18, "CD_HIGH"},
+	{SDHCI_WRITE_PROTECT, "WRITE_PROTECT"},
+	{1<<20, "DATA0"},
+	{1<<21, "DATA1"},
+	{1<<22, "DATA2"},
+	{1<<23, "DATA3"},
+	{SDHCI_CMD_LVL, "CMD_LVL"},
+	{ -1, NULL }
+};
+
+static const struct trace_print_field block_cnt_reg[] = {
+	{
+		.mask = 0xFFF,
+		.name = "BLOCK_SIZE"
+	},
+	{
+		.mask = 7 << 12,
+		.name = "DMA_BUF_BOUNDARY",
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "4K"},
+			{1, "8K"},
+			{2, "16K"},
+			{3, "32K"},
+			{4, "64K"},
+			{5, "128K"},
+			{6, "256K"},
+			{7, "512K"},
+			{}
+		}
+	},
+	{
+		.mask = 0xFFFF << 16,
+		.name = "BLOCK_CNT"
+	},
+};
+
+static const struct trace_print_field host_control_reg[] = {
+	{
+		.mask = SDHCI_CTRL_LED,
+		.name = "LED",
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "OFF"},
+			{1, "ON"},
+			{}
+		}
+	}, {
+		.mask = SDHCI_CTRL_4BITBUS,
+		.name = "TX_WIDTH",
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "1-BIT"},
+			{1, "4-BIT"},
+			{}
+		}
+	}, {
+		.mask = SDHCI_CTRL_HISPD,
+		.name = "HIGH_SPEED"
+	}, {
+		.mask = SDHCI_CTRL_DMA_MASK,
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "SDMA"},
+			{1, "ADMA-32"},
+			{2, "ADMA2-32"},
+			{3, "ADMA2-64"},
+			{}
+		}
+	}, {
+		.mask = SDHCI_CTRL_8BITBUS,
+		.name = "MMC_WIDTH",
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "DAT_WIDTH"},
+			{1, "8-BIT"},
+			{}
+		}
+	},
+	{SDHCI_CTRL_CDTEST_INS, "CDTEST_INS"},
+	{SDHCI_CTRL_CDTEST_EN, "CDTEST_EN"},
+	{1<<8, "BUS_POWER"},
+	{
+		.mask = 0x7 << 9,
+		.name = "BUS_VOLTAGE",
+		.symbols = (const struct trace_print_flags[]) {
+			{0x00, "0.0V"},
+			{0x05, "1.8V"},
+			{0x06, "3.0V"},
+			{0x07, "3.3V"},
+			{}
+		}
+	},
+	{1<<16, "BLOCK_GAP_STOP"},
+	{1<<17, "CONT_REQ"},
+	{1<<18, "READ_WAIT_EN"},
+	{1<<19, "BLOCK_GAP_INT_EN"},
+	{1<<24, "INT_WAKE_EN"},
+	{1<<25, "INS_WAKE_EN"},
+	{1<<26, "REM_WAKE_EN"},
+	{},
+};
+
+static const struct trace_print_field transfer_mode_reg[] = {
+	{SDHCI_TRNS_DMA, "DMA_EN"},
+	{SDHCI_TRNS_BLK_CNT_EN, "BLK_CNT_EN"},
+	{
+		.mask = 0xC,
+		.name = "AUTO_CMD",
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "DISABLED"},
+			{1, "12"},
+			{2, "23"},
+			{3, "RESERVED"},
+			{}
+		}
+	}, {
+		.mask = SDHCI_TRNS_READ,
+		.name = "DATA_DIR",
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "WRITE"},
+			{1, "READ"},
+			{}
+		}
+	},
+	{SDHCI_TRNS_MULTI, "MULTI_BLK"},
+	{
+		.mask = 0x3 << 16,
+		.name = "RESP_TYPE",
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "NONE"},
+			{1, "136-BITS"},
+			{2, "48-BITS"},
+			{3, "48-BITS W/ BUSY"},
+			{}
+		}
+	},
+	{1<<19, "CRC_CHECK_EN"},
+	{1<<20, "CMD_IDX_CHECK_EN"},
+	{1<<21, "DATA_PRESENT"},
+	{
+		.mask = 0x3 << 22,
+		.name = "CMD_TYPE",
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "NORMAL"},
+			{1, "SUSPEND CMD52"},
+			{2, "RESUME CMD52"},
+			{3, "ABORT"},
+			{}
+		}
+	},
+	{0x3f << 24, "CMD"},
+	{},
+};
+
+static const struct trace_print_field const clk_control_reg[] = {
+	{1<<0, "SYSCLK_EN"},
+	{1<<1, "SYSCLK_STABLE"},
+	{1<<2, "SDCLK_EN"},
+	{1<<5, "PRG_CLK_MODE"},
+	{0xc0, "SD_CLK_DIV[9:8]"},
+	{0xFF00, "SD_CLK_DIV"},
+	{0xF0000, "DATA_TIMEOUT_CNT"},
+	{1<<24, "SOFT_RESET_ALL"},
+	{1<<25, "SOFT_RESET_CMD"},
+	{1<<26, "SOFT_RESET_DAT"},
+	{}
+};
+
+static const struct trace_print_field const acmd_err_flags[] = {
+	{1<<0, "EXEC_ERROR"},
+	{1<<1, "TIMEOUT_ERROR"},
+	{1<<2, "CRC_ERROR"},
+	{1<<3, "END_BIT_ERROR"},
+	{1<<4, "INDEX_ERROR"},
+	{1<<7, "CMD_ERROR"},
+	{
+		.mask = 7 << 16,
+		.name = "UHS_MODE",
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "SDR12"},
+			{1, "SDR25"},
+			{2, "SDR50"},
+			{3, "SDR104"},
+			{4, "DDR50"},
+			{}
+		}
+	},
+	{
+		.mask = 1 << 19,
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "3.3V"},
+			{1, "1.8V"},
+			{}
+		}
+	},
+	{
+		.mask = 3 << 20,
+		.name = "DRIVE_STRENGTH",
+		.symbols = (const struct trace_print_flags[]) {
+			{0, "B"},
+			{1, "A"},
+			{2, "C"},
+			{3, "D"},
+			{}
+		}
+	},
+	{1<<22, "TUNING"},
+	{1<<23, "SAMPLE_CLK"},
+	{1<<30, "ASYNC_INT_EN"},
+	{1<<31, "AUTO_PRESENT_VAL"},
+	{}
+};
+
+/**
+ * sdhci_decode_register() - Decodes a SDHCI register
+ *
+ * @reg: Register offset that was accessed
+ * @val: Value written to the register
+ * @mask: Mask containing the number of bits written to the register. e.g.,
+ *        byte = 0xFF, word = 0xFFFF, long = 0xFFFFFFFF.
+ */
+static const char *sdhci_decode_register(struct trace_seq *p, u32 reg, u32 val,
+					 u32 mask)
+{
+	u32 aligned = reg & ~3UL;
+	int shift = (reg - aligned) * 8;
+
+	val <<= shift;
+	mask <<= shift;
+
+	switch (aligned) {
+	case SDHCI_BLOCK_SIZE:
+		return trace_print_register(p, block_cnt_reg, val, mask);
+	case SDHCI_INT_STATUS:
+	case SDHCI_INT_ENABLE:
+	case SDHCI_SIGNAL_ENABLE:
+		return trace_print_flags_seq(p, " | ", val, int_flags);
+	case SDHCI_PRESENT_STATE:
+		return trace_print_flags_seq(p, " | ", val,
+					     present_state_flags);
+	case SDHCI_HOST_CONTROL:
+		return trace_print_register(p, host_control_reg, val, mask);
+	case SDHCI_TRANSFER_MODE:
+		return trace_print_register(p, transfer_mode_reg, val, mask);
+	case SDHCI_CLOCK_CONTROL:
+		return trace_print_register(p, clk_control_reg, val, mask);
+	case SDHCI_ACMD12_ERR:
+		return trace_print_register(p, acmd_err_flags, val, mask);
+	default:
+		return "";
+	}
+}
+
+#define CREATE_TRACE_POINTS
+#include "sdhci-trace.h"
diff --git a/drivers/mmc/host/sdhci-trace.h b/drivers/mmc/host/sdhci-trace.h
new file mode 100644
index 000000000000..938a032ea38a
--- /dev/null
+++ b/drivers/mmc/host/sdhci-trace.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright 2019 Google LLC. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM sdhci
+
+#if !defined(_TRACE_SDHCI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SDHCI_H
+
+#include <linux/mmc/host.h>
+#include <linux/tracepoint.h>
+#include "sdhci.h"
+
+TRACE_EVENT(sdhci_read,
+
+	TP_PROTO(struct sdhci_host *host, u32 reg, u32 val, u32 mask),
+
+	TP_ARGS(host, reg, val, mask),
+
+	TP_STRUCT__entry(
+		__field(u32,	reg)
+		__field(u32,	val)
+		__field(u32,	mask)
+		__string(name,	mmc_hostname(host->mmc))
+	),
+
+	TP_fast_assign(
+		__entry->reg = reg;
+		__entry->val = val;
+		__entry->mask = mask;
+		__assign_str(name, mmc_hostname(host->mmc));
+	),
+
+	TP_printk("%s: %#x [%s] => %#x: %s",
+		  __get_str(name),
+		  __entry->reg,
+		  __print_symbolic(__entry->reg & ~3UL, SDHCI_REGS),
+		  __entry->val,
+		  sdhci_decode_register(
+			p,
+			__entry->reg,
+			__entry->val,
+			__entry->mask
+		  )
+	)
+);
+
+TRACE_EVENT(sdhci_write,
+
+	TP_PROTO(struct sdhci_host *host, u32 reg, u32 val, u32 mask),
+
+	TP_ARGS(host, reg, val, mask),
+
+	TP_STRUCT__entry(
+		__field(u32,	reg)
+		__field(u32,	val)
+		__field(u32,	mask)
+		__string(name,	mmc_hostname(host->mmc))
+	),
+
+	TP_fast_assign(
+		__entry->reg = reg;
+		__entry->val = val;
+		__entry->mask = mask;
+		__assign_str(name, mmc_hostname(host->mmc));
+	),
+
+	TP_printk("%s: %#x [%s] <= %#x: %s",
+		  __get_str(name),
+		  __entry->reg,
+		  __print_symbolic(__entry->reg & ~3UL, SDHCI_REGS),
+		  __entry->val,
+		  sdhci_decode_register(
+			p,
+			__entry->reg,
+			__entry->val,
+			__entry->mask
+		  )
+	)
+);
+
+
+#endif /* _TRACE_SDHCI_H */
+
+/* this part must be outside header guard */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE sdhci-trace
+
+#include <trace/define_trace.h>
-- 
2.21.0.392.gf8f6787159e-goog

