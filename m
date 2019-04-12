Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EC0C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 19:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AED1C218A3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 19:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oeghV1xE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfDLTv3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 15:51:29 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:51901 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbfDLTv2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 15:51:28 -0400
Received: by mail-it1-f195.google.com with SMTP id s3so3108203itk.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 12:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HlfDz4PF9tdAjIwyaWfidRJ9LFGIrm1jbr/xBoNJt9Q=;
        b=oeghV1xEtppHFFM0Bmspo5/kbJ64cVWVNT0Rqh6ybaA8LwPIlQK+e+K15+R87pNSvV
         1LbjBtk5IkhTIDAQfBJMLVoHEOcyoPAZtuz4xMkNrIaNrGnI55CRHvwU9qO3RJ5uYj4p
         yZgVgUcXCEw6RsEsD8BogzvNOOxtjjuLTSxG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HlfDz4PF9tdAjIwyaWfidRJ9LFGIrm1jbr/xBoNJt9Q=;
        b=ChaD8ZtBPr9W15gHlwkekq8liSIFHRdmQ77TviYtDXL1dEA+eCbmh6xZc7KNR4jnKt
         /l/BCtQ+GwPoD5ETGYWyqNTVKIwYo06aJs5+q/wpNnHh7jAxh753pOylryjyakVItgXa
         FMT2Ln/iqEO8e1YlTYLo9lUvTVzr7PPeNOBzPBbrMrRYNNOVUSwX+q3mmkYiq3PDrMHb
         959pvHlzVnayg9bl1f5CvZX+4vVh3uF8om0Xe+XrD9oNKFHP+M7FNUmAb6bvrgWqL3pW
         SL3QA6YC//4TyX1IlU7AhAlp43BdaCSaeAaAiHZJv7jZbazlO3Ho1WPYHgj8Vj1+4pHh
         20fQ==
X-Gm-Message-State: APjAAAXWAzM7yTwdY68SPY5B/4xcQoTx4yN9eieAIp1P+Basvn8TTQK4
        ARjRdcTyqBlkVjMt0UZ//l/vCmf7Zw1/lA==
X-Google-Smtp-Source: APXvYqxGjGgQZYbhvCLyornHOlnQV6TO7P+njbbIat1yv4zrN/laTngsUO06DPhHje2g5mrWngVc5A==
X-Received: by 2002:a02:5bc2:: with SMTP id g185mr41373960jab.31.1555098687149;
        Fri, 12 Apr 2019 12:51:27 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id h77sm4646618ith.2.2019.04.12.12.51.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 12:51:26 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     eballetbo@gmail.com, zwisler@chromium.org, djkurtz@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>
Subject: [PATCH v3] chrome/platform: cros_ec_proto: Add trace event to trace EC commands
Date:   Fri, 12 Apr 2019 13:51:23 -0600
Message-Id: <20190412195124.8998-1-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is useful to see which EC commands are being executed and when.

To enable:

    echo 'cros_ec:*' >> /sys/kernel/debug/tracing/set_event

Example:

    /* cros_ec_cmd: version: 0, command: GET_VERSION */
    /* cros_ec_cmd: version: 0, command: GET_PROTOCOL_INFO */
    /* cros_ec_cmd: version: 1, command: GET_CMD_VERSIONS */
    /* cros_ec_cmd: version: 1, command: USB_PD_CONTROL */

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

Changes in v3:
- Use a macro to avoid duplicating the ec command names.

Changes in v2:
- Changed comment style to match other cros_ec files.
- Fixed commit tag.

 drivers/platform/chrome/Makefile        |   4 +-
 drivers/platform/chrome/cros_ec_proto.c |   4 +
 drivers/platform/chrome/cros_ec_trace.c | 162 ++++++++++++++++++++++++
 drivers/platform/chrome/cros_ec_trace.h |  51 ++++++++
 4 files changed, 220 insertions(+), 1 deletion(-)
 create mode 100644 drivers/platform/chrome/cros_ec_trace.c
 create mode 100644 drivers/platform/chrome/cros_ec_trace.h

diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/Makefile
index 1e2f0029b597..e542268454a4 100644
--- a/drivers/platform/chrome/Makefile
+++ b/drivers/platform/chrome/Makefile
@@ -3,12 +3,14 @@
 obj-$(CONFIG_CHROMEOS_LAPTOP)		+= chromeos_laptop.o
 obj-$(CONFIG_CHROMEOS_PSTORE)		+= chromeos_pstore.o
 obj-$(CONFIG_CHROMEOS_TBMC)		+= chromeos_tbmc.o
+# tell define_trace.h where to find the cros ec trace header
+CFLAGS_cros_ec_trace.o:=		-I$(src)
 obj-$(CONFIG_CROS_EC_I2C)		+= cros_ec_i2c.o
 obj-$(CONFIG_CROS_EC_SPI)		+= cros_ec_spi.o
 cros_ec_lpcs-objs			:= cros_ec_lpc.o cros_ec_lpc_reg.o
 cros_ec_lpcs-$(CONFIG_CROS_EC_LPC_MEC)	+= cros_ec_lpc_mec.o
 obj-$(CONFIG_CROS_EC_LPC)		+= cros_ec_lpcs.o
-obj-$(CONFIG_CROS_EC_PROTO)		+= cros_ec_proto.o
+obj-$(CONFIG_CROS_EC_PROTO)		+= cros_ec_proto.o cros_ec_trace.o
 obj-$(CONFIG_CROS_KBD_LED_BACKLIGHT)	+= cros_kbd_led_backlight.o
 obj-$(CONFIG_CROS_EC_LIGHTBAR)		+= cros_ec_lightbar.o
 obj-$(CONFIG_CROS_EC_VBC)		+= cros_ec_vbc.o
diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index 97a068dff192..3d02c8259ac6 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -10,6 +10,8 @@
 #include <linux/slab.h>
 #include <asm/unaligned.h>
 
+#include "cros_ec_trace.h"
+
 #define EC_COMMAND_RETRIES	50
 
 static int prepare_packet(struct cros_ec_device *ec_dev,
@@ -51,6 +53,8 @@ static int send_command(struct cros_ec_device *ec_dev,
 	int ret;
 	int (*xfer_fxn)(struct cros_ec_device *ec, struct cros_ec_command *msg);
 
+	trace_cros_ec_cmd(msg);
+
 	if (ec_dev->proto_version > 2)
 		xfer_fxn = ec_dev->pkt_xfer;
 	else
diff --git a/drivers/platform/chrome/cros_ec_trace.c b/drivers/platform/chrome/cros_ec_trace.c
new file mode 100644
index 000000000000..1f817aa9d886
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_trace.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+// Trace events for the ChromeOS Embedded Controller
+//
+// Copyright 2019 Google LLC.
+
+#define EC_CMD(a) {EC_CMD_##a, #a}
+
+#define ec_cmds \
+	EC_CMD(PROTO_VERSION), \
+	EC_CMD(HELLO), \
+	EC_CMD(GET_VERSION), \
+	EC_CMD(READ_TEST), \
+	EC_CMD(GET_BUILD_INFO), \
+	EC_CMD(GET_CHIP_INFO), \
+	EC_CMD(GET_BOARD_VERSION), \
+	EC_CMD(READ_MEMMAP), \
+	EC_CMD(GET_CMD_VERSIONS), \
+	EC_CMD(GET_COMMS_STATUS), \
+	EC_CMD(TEST_PROTOCOL), \
+	EC_CMD(GET_PROTOCOL_INFO), \
+	EC_CMD(GSV_PAUSE_IN_S5), \
+	EC_CMD(GET_FEATURES), \
+	EC_CMD(GET_SKU_ID), \
+	EC_CMD(SET_SKU_ID), \
+	EC_CMD(FLASH_INFO), \
+	EC_CMD(FLASH_READ), \
+	EC_CMD(FLASH_WRITE), \
+	EC_CMD(FLASH_ERASE), \
+	EC_CMD(FLASH_PROTECT), \
+	EC_CMD(FLASH_REGION_INFO), \
+	EC_CMD(VBNV_CONTEXT), \
+	EC_CMD(FLASH_SPI_INFO), \
+	EC_CMD(FLASH_SELECT), \
+	EC_CMD(PWM_GET_FAN_TARGET_RPM), \
+	EC_CMD(PWM_SET_FAN_TARGET_RPM), \
+	EC_CMD(PWM_GET_KEYBOARD_BACKLIGHT), \
+	EC_CMD(PWM_SET_KEYBOARD_BACKLIGHT), \
+	EC_CMD(PWM_SET_FAN_DUTY), \
+	EC_CMD(PWM_SET_DUTY), \
+	EC_CMD(PWM_GET_DUTY), \
+	EC_CMD(LIGHTBAR_CMD), \
+	EC_CMD(LED_CONTROL), \
+	EC_CMD(VBOOT_HASH), \
+	EC_CMD(MOTION_SENSE_CMD), \
+	EC_CMD(FORCE_LID_OPEN), \
+	EC_CMD(CONFIG_POWER_BUTTON), \
+	EC_CMD(USB_CHARGE_SET_MODE), \
+	EC_CMD(PSTORE_INFO), \
+	EC_CMD(PSTORE_READ), \
+	EC_CMD(PSTORE_WRITE), \
+	EC_CMD(RTC_GET_VALUE), \
+	EC_CMD(RTC_GET_ALARM), \
+	EC_CMD(RTC_SET_VALUE), \
+	EC_CMD(RTC_SET_ALARM), \
+	EC_CMD(PORT80_READ), \
+	EC_CMD(VSTORE_INFO), \
+	EC_CMD(VSTORE_READ), \
+	EC_CMD(VSTORE_WRITE), \
+	EC_CMD(THERMAL_SET_THRESHOLD), \
+	EC_CMD(THERMAL_GET_THRESHOLD), \
+	EC_CMD(THERMAL_AUTO_FAN_CTRL), \
+	EC_CMD(TMP006_GET_CALIBRATION), \
+	EC_CMD(TMP006_SET_CALIBRATION), \
+	EC_CMD(TMP006_GET_RAW), \
+	EC_CMD(MKBP_STATE), \
+	EC_CMD(MKBP_INFO), \
+	EC_CMD(MKBP_SIMULATE_KEY), \
+	EC_CMD(MKBP_SET_CONFIG), \
+	EC_CMD(MKBP_GET_CONFIG), \
+	EC_CMD(KEYSCAN_SEQ_CTRL), \
+	EC_CMD(GET_NEXT_EVENT), \
+	EC_CMD(KEYBOARD_FACTORY_TEST), \
+	EC_CMD(TEMP_SENSOR_GET_INFO), \
+	EC_CMD(ACPI_READ), \
+	EC_CMD(ACPI_WRITE), \
+	EC_CMD(ACPI_BURST_ENABLE), \
+	EC_CMD(ACPI_BURST_DISABLE), \
+	EC_CMD(ACPI_QUERY_EVENT), \
+	EC_CMD(HOST_EVENT_GET_B), \
+	EC_CMD(HOST_EVENT_GET_SMI_MASK), \
+	EC_CMD(HOST_EVENT_GET_SCI_MASK), \
+	EC_CMD(HOST_EVENT_SET_SMI_MASK), \
+	EC_CMD(HOST_EVENT_SET_SCI_MASK), \
+	EC_CMD(HOST_EVENT_CLEAR), \
+	EC_CMD(HOST_EVENT_GET_WAKE_MASK), \
+	EC_CMD(HOST_EVENT_SET_WAKE_MASK), \
+	EC_CMD(HOST_EVENT_CLEAR_B), \
+	EC_CMD(SWITCH_ENABLE_BKLIGHT), \
+	EC_CMD(SWITCH_ENABLE_WIRELESS), \
+	EC_CMD(GPIO_SET), \
+	EC_CMD(GPIO_GET), \
+	EC_CMD(I2C_READ), \
+	EC_CMD(I2C_WRITE), \
+	EC_CMD(CHARGE_CONTROL), \
+	EC_CMD(CONSOLE_SNAPSHOT), \
+	EC_CMD(CONSOLE_READ), \
+	EC_CMD(BATTERY_CUT_OFF), \
+	EC_CMD(USB_MUX), \
+	EC_CMD(LDO_SET), \
+	EC_CMD(LDO_GET), \
+	EC_CMD(POWER_INFO), \
+	EC_CMD(I2C_PASSTHRU), \
+	EC_CMD(HANG_DETECT), \
+	EC_CMD(CHARGE_STATE), \
+	EC_CMD(CHARGE_CURRENT_LIMIT), \
+	EC_CMD(EXTERNAL_POWER_LIMIT), \
+	EC_CMD(OVERRIDE_DEDICATED_CHARGER_LIMIT), \
+	EC_CMD(HOST_EVENT), \
+	EC_CMD(HIBERNATION_DELAY), \
+	EC_CMD(HOST_SLEEP_EVENT), \
+	EC_CMD(DEVICE_EVENT), \
+	EC_CMD(SB_READ_WORD), \
+	EC_CMD(SB_WRITE_WORD), \
+	EC_CMD(SB_READ_BLOCK), \
+	EC_CMD(SB_WRITE_BLOCK), \
+	EC_CMD(BATTERY_VENDOR_PARAM), \
+	EC_CMD(SB_FW_UPDATE), \
+	EC_CMD(ENTERING_MODE), \
+	EC_CMD(I2C_PASSTHRU_PROTECT), \
+	EC_CMD(REBOOT), \
+	EC_CMD(REBOOT_EC), \
+	EC_CMD(GET_PANIC_INFO), \
+	EC_CMD(RESEND_RESPONSE), \
+	EC_CMD(VERSION0), \
+	EC_CMD(PD_EXCHANGE_STATUS), \
+	EC_CMD(USB_PD_CONTROL), \
+	EC_CMD(USB_PD_PORTS), \
+	EC_CMD(USB_PD_POWER_INFO), \
+	EC_CMD(PD_HOST_EVENT_STATUS), \
+	EC_CMD(USB_PD_FW_UPDATE), \
+	EC_CMD(USB_PD_RW_HASH_ENTRY), \
+	EC_CMD(USB_PD_DEV_INFO), \
+	EC_CMD(USB_PD_DISCOVERY), \
+	EC_CMD(PD_CHARGE_PORT_OVERRIDE), \
+	EC_CMD(PD_GET_LOG_ENTRY), \
+	EC_CMD(USB_PD_GET_AMODE), \
+	EC_CMD(USB_PD_SET_AMODE), \
+	EC_CMD(PD_WRITE_LOG_ENTRY), \
+	EC_CMD(PD_CONTROL), \
+	EC_CMD(USB_PD_MUX_INFO), \
+	EC_CMD(PD_CHIP_INFO), \
+	EC_CMD(RWSIG_CHECK_STATUS), \
+	EC_CMD(RWSIG_ACTION), \
+	EC_CMD(CR51_BASE), \
+	EC_CMD(CR51_LAST), \
+	EC_CMD(FP_PASSTHRU), \
+	EC_CMD(FP_SENSOR_CONFIG), \
+	EC_CMD(FP_MODE), \
+	EC_CMD(FP_INFO), \
+	EC_CMD(FP_FRAME), \
+	EC_CMD(TP_SELF_TEST), \
+	EC_CMD(TP_FRAME_INFO), \
+	EC_CMD(TP_FRAME_SNAPSHOT), \
+	EC_CMD(TP_FRAME_GET), \
+	EC_CMD(BATTERY_GET_STATIC), \
+	EC_CMD(BATTERY_GET_DYNAMIC), \
+	EC_CMD(CHARGER_CONTROL), \
+	EC_CMD(BOARD_SPECIFIC_BASE), \
+	EC_CMD(BOARD_SPECIFIC_LAST)
+
+#define CREATE_TRACE_POINTS
+#include "cros_ec_trace.h"
diff --git a/drivers/platform/chrome/cros_ec_trace.h b/drivers/platform/chrome/cros_ec_trace.h
new file mode 100644
index 000000000000..86ef52f96fd4
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_trace.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Trace events for the ChromeOS Embedded Controller
+ *
+ * Copyright 2019 Google LLC.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM cros_ec
+
+#if !defined(_CROS_EC_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _CROS_EC_TRACE_H_
+
+#include <linux/types.h>
+#include <linux/mfd/cros_ec.h>
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(cros_ec_cmd_class,
+	TP_PROTO(struct cros_ec_command *cmd),
+	TP_ARGS(cmd),
+	TP_STRUCT__entry(
+		__field(uint32_t, version)
+		__field(uint32_t, command)
+	),
+	TP_fast_assign(
+		__entry->version = cmd->version;
+		__entry->command = cmd->command;
+	),
+	TP_printk("version: %u, command: %s", __entry->version,
+		  __print_symbolic(__entry->command, ec_cmds))
+);
+
+
+DEFINE_EVENT(cros_ec_cmd_class, cros_ec_cmd,
+	TP_PROTO(struct cros_ec_command *cmd),
+	TP_ARGS(cmd)
+);
+
+
+#endif /* _CROS_EC_TRACE_H_ */
+
+/* this part must be outside header guard */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE cros_ec_trace
+
+#include <trace/define_trace.h>
-- 
2.21.0.392.gf8f6787159e-goog

