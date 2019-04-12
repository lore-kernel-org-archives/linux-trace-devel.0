Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D7DC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 21:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FC6A2171F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 21:18:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iJXqMSTn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfDLVR7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 17:17:59 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34542 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfDLVR7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 17:17:59 -0400
Received: by mail-io1-f68.google.com with SMTP id n11so9777752ioh.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 14:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WUyr87eSer1HBWyaGicm8IWFsZgSu9dc5jOkdwo8frc=;
        b=iJXqMSTnD7qU7Wg2f0BY6taNInr3++ZSjldz/YDz6yi1yj68etNvtwD/wxKjhMLuo9
         N88u4m9RGTtwo7obtEu7cTyyPLSGfKjEmWR2lx3wp4+VuLMTnm192J2bLd9jP3NXdnhp
         lXkzmdlSxIE2viMKoIs/YCeg52/LidF6ylcoM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WUyr87eSer1HBWyaGicm8IWFsZgSu9dc5jOkdwo8frc=;
        b=DERct0efeLJAxqEb+L7WTy4YVW1Wz3b1hpv8tlHWeZOMKM3dz3WiRiuyTcrV1u6KAp
         pya89qtR7QOTpRiWO4J4z2/iolzlCEsKGTAA5MVCK9n/bFVjPY4+js+o4yCpje33cvA3
         a9yhe0DL2JcbBkcXJs8ejLTL/PbX0o9TcUvra3FWG4HKxdGYoakkjeFk+7cdN8OpZnbt
         /dqiqmFwXmtjCqBitYVtWp3ul6xmln0k1d41wrksGEnqZIh93ka2WG1MhsoT1osduYyk
         CCDgsQn+/8g/nWM0hOoqt9bwXaK4cboChQJ54Xp/q1qVoPP8DCaEq00cdTtm3fViR0Mn
         FFCQ==
X-Gm-Message-State: APjAAAXJ8bVRtYPW3voR/jnKXm2ZOdXlum61FSdT8EYFWzjfZk8POfX4
        ijIRK2T1i4zvYPw5Gtung38E1k0s9dBx+g==
X-Google-Smtp-Source: APXvYqzatVO+MeFEo5Yw2S2T997Hj85CoLxyOgI9exGA2LUmyHw9E2Im5hnE3s3sGgr/ELrkhhzkzQ==
X-Received: by 2002:a6b:6e05:: with SMTP id d5mr38720482ioh.77.1555103878372;
        Fri, 12 Apr 2019 14:17:58 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id s3sm14935712ioo.65.2019.04.12.14.17.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 14:17:57 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     eballetbo@gmail.com, zwisler@chromium.org, djkurtz@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Ross Zwisler <zwisler@google.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>
Subject: [PATCH v4] chrome/platform: cros_ec_proto: Add trace event to trace EC commands
Date:   Fri, 12 Apr 2019 15:17:44 -0600
Message-Id: <20190412211745.175610-1-rrangel@chromium.org>
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

    /* cros_ec_cmd: version: 0, command: EC_CMD_GET_VERSION */
    /* cros_ec_cmd: version: 0, command: EC_CMD_GET_PROTOCOL_INFO */
    /* cros_ec_cmd: version: 1, command: EC_CMD_GET_CMD_VERSIONS */
    /* cros_ec_cmd: version: 1, command: EC_CMD_USB_PD_CONTROL */

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Reviewed-by: Ross Zwisler <zwisler@google.com>
---

Changes in v4:
- Use the full command name so go to definition continues to work in my
editor.

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
index 000000000000..21c497e7a2d1
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_trace.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+// Trace events for the ChromeOS Embedded Controller
+//
+// Copyright 2019 Google LLC.
+
+#define TRACE_SYM(a) {a, #a}
+
+#define ec_cmds \
+	TRACE_SYM(EC_CMD_PROTO_VERSION), \
+	TRACE_SYM(EC_CMD_HELLO), \
+	TRACE_SYM(EC_CMD_GET_VERSION), \
+	TRACE_SYM(EC_CMD_READ_TEST), \
+	TRACE_SYM(EC_CMD_GET_BUILD_INFO), \
+	TRACE_SYM(EC_CMD_GET_CHIP_INFO), \
+	TRACE_SYM(EC_CMD_GET_BOARD_VERSION), \
+	TRACE_SYM(EC_CMD_READ_MEMMAP), \
+	TRACE_SYM(EC_CMD_GET_CMD_VERSIONS), \
+	TRACE_SYM(EC_CMD_GET_COMMS_STATUS), \
+	TRACE_SYM(EC_CMD_TEST_PROTOCOL), \
+	TRACE_SYM(EC_CMD_GET_PROTOCOL_INFO), \
+	TRACE_SYM(EC_CMD_GSV_PAUSE_IN_S5), \
+	TRACE_SYM(EC_CMD_GET_FEATURES), \
+	TRACE_SYM(EC_CMD_GET_SKU_ID), \
+	TRACE_SYM(EC_CMD_SET_SKU_ID), \
+	TRACE_SYM(EC_CMD_FLASH_INFO), \
+	TRACE_SYM(EC_CMD_FLASH_READ), \
+	TRACE_SYM(EC_CMD_FLASH_WRITE), \
+	TRACE_SYM(EC_CMD_FLASH_ERASE), \
+	TRACE_SYM(EC_CMD_FLASH_PROTECT), \
+	TRACE_SYM(EC_CMD_FLASH_REGION_INFO), \
+	TRACE_SYM(EC_CMD_VBNV_CONTEXT), \
+	TRACE_SYM(EC_CMD_FLASH_SPI_INFO), \
+	TRACE_SYM(EC_CMD_FLASH_SELECT), \
+	TRACE_SYM(EC_CMD_PWM_GET_FAN_TARGET_RPM), \
+	TRACE_SYM(EC_CMD_PWM_SET_FAN_TARGET_RPM), \
+	TRACE_SYM(EC_CMD_PWM_GET_KEYBOARD_BACKLIGHT), \
+	TRACE_SYM(EC_CMD_PWM_SET_KEYBOARD_BACKLIGHT), \
+	TRACE_SYM(EC_CMD_PWM_SET_FAN_DUTY), \
+	TRACE_SYM(EC_CMD_PWM_SET_DUTY), \
+	TRACE_SYM(EC_CMD_PWM_GET_DUTY), \
+	TRACE_SYM(EC_CMD_LIGHTBAR_CMD), \
+	TRACE_SYM(EC_CMD_LED_CONTROL), \
+	TRACE_SYM(EC_CMD_VBOOT_HASH), \
+	TRACE_SYM(EC_CMD_MOTION_SENSE_CMD), \
+	TRACE_SYM(EC_CMD_FORCE_LID_OPEN), \
+	TRACE_SYM(EC_CMD_CONFIG_POWER_BUTTON), \
+	TRACE_SYM(EC_CMD_USB_CHARGE_SET_MODE), \
+	TRACE_SYM(EC_CMD_PSTORE_INFO), \
+	TRACE_SYM(EC_CMD_PSTORE_READ), \
+	TRACE_SYM(EC_CMD_PSTORE_WRITE), \
+	TRACE_SYM(EC_CMD_RTC_GET_VALUE), \
+	TRACE_SYM(EC_CMD_RTC_GET_ALARM), \
+	TRACE_SYM(EC_CMD_RTC_SET_VALUE), \
+	TRACE_SYM(EC_CMD_RTC_SET_ALARM), \
+	TRACE_SYM(EC_CMD_PORT80_READ), \
+	TRACE_SYM(EC_CMD_VSTORE_INFO), \
+	TRACE_SYM(EC_CMD_VSTORE_READ), \
+	TRACE_SYM(EC_CMD_VSTORE_WRITE), \
+	TRACE_SYM(EC_CMD_THERMAL_SET_THRESHOLD), \
+	TRACE_SYM(EC_CMD_THERMAL_GET_THRESHOLD), \
+	TRACE_SYM(EC_CMD_THERMAL_AUTO_FAN_CTRL), \
+	TRACE_SYM(EC_CMD_TMP006_GET_CALIBRATION), \
+	TRACE_SYM(EC_CMD_TMP006_SET_CALIBRATION), \
+	TRACE_SYM(EC_CMD_TMP006_GET_RAW), \
+	TRACE_SYM(EC_CMD_MKBP_STATE), \
+	TRACE_SYM(EC_CMD_MKBP_INFO), \
+	TRACE_SYM(EC_CMD_MKBP_SIMULATE_KEY), \
+	TRACE_SYM(EC_CMD_MKBP_SET_CONFIG), \
+	TRACE_SYM(EC_CMD_MKBP_GET_CONFIG), \
+	TRACE_SYM(EC_CMD_KEYSCAN_SEQ_CTRL), \
+	TRACE_SYM(EC_CMD_GET_NEXT_EVENT), \
+	TRACE_SYM(EC_CMD_KEYBOARD_FACTORY_TEST), \
+	TRACE_SYM(EC_CMD_TEMP_SENSOR_GET_INFO), \
+	TRACE_SYM(EC_CMD_ACPI_READ), \
+	TRACE_SYM(EC_CMD_ACPI_WRITE), \
+	TRACE_SYM(EC_CMD_ACPI_BURST_ENABLE), \
+	TRACE_SYM(EC_CMD_ACPI_BURST_DISABLE), \
+	TRACE_SYM(EC_CMD_ACPI_QUERY_EVENT), \
+	TRACE_SYM(EC_CMD_HOST_EVENT_GET_B), \
+	TRACE_SYM(EC_CMD_HOST_EVENT_GET_SMI_MASK), \
+	TRACE_SYM(EC_CMD_HOST_EVENT_GET_SCI_MASK), \
+	TRACE_SYM(EC_CMD_HOST_EVENT_SET_SMI_MASK), \
+	TRACE_SYM(EC_CMD_HOST_EVENT_SET_SCI_MASK), \
+	TRACE_SYM(EC_CMD_HOST_EVENT_CLEAR), \
+	TRACE_SYM(EC_CMD_HOST_EVENT_GET_WAKE_MASK), \
+	TRACE_SYM(EC_CMD_HOST_EVENT_SET_WAKE_MASK), \
+	TRACE_SYM(EC_CMD_HOST_EVENT_CLEAR_B), \
+	TRACE_SYM(EC_CMD_SWITCH_ENABLE_BKLIGHT), \
+	TRACE_SYM(EC_CMD_SWITCH_ENABLE_WIRELESS), \
+	TRACE_SYM(EC_CMD_GPIO_SET), \
+	TRACE_SYM(EC_CMD_GPIO_GET), \
+	TRACE_SYM(EC_CMD_I2C_READ), \
+	TRACE_SYM(EC_CMD_I2C_WRITE), \
+	TRACE_SYM(EC_CMD_CHARGE_CONTROL), \
+	TRACE_SYM(EC_CMD_CONSOLE_SNAPSHOT), \
+	TRACE_SYM(EC_CMD_CONSOLE_READ), \
+	TRACE_SYM(EC_CMD_BATTERY_CUT_OFF), \
+	TRACE_SYM(EC_CMD_USB_MUX), \
+	TRACE_SYM(EC_CMD_LDO_SET), \
+	TRACE_SYM(EC_CMD_LDO_GET), \
+	TRACE_SYM(EC_CMD_POWER_INFO), \
+	TRACE_SYM(EC_CMD_I2C_PASSTHRU), \
+	TRACE_SYM(EC_CMD_HANG_DETECT), \
+	TRACE_SYM(EC_CMD_CHARGE_STATE), \
+	TRACE_SYM(EC_CMD_CHARGE_CURRENT_LIMIT), \
+	TRACE_SYM(EC_CMD_EXTERNAL_POWER_LIMIT), \
+	TRACE_SYM(EC_CMD_OVERRIDE_DEDICATED_CHARGER_LIMIT), \
+	TRACE_SYM(EC_CMD_HOST_EVENT), \
+	TRACE_SYM(EC_CMD_HIBERNATION_DELAY), \
+	TRACE_SYM(EC_CMD_HOST_SLEEP_EVENT), \
+	TRACE_SYM(EC_CMD_DEVICE_EVENT), \
+	TRACE_SYM(EC_CMD_SB_READ_WORD), \
+	TRACE_SYM(EC_CMD_SB_WRITE_WORD), \
+	TRACE_SYM(EC_CMD_SB_READ_BLOCK), \
+	TRACE_SYM(EC_CMD_SB_WRITE_BLOCK), \
+	TRACE_SYM(EC_CMD_BATTERY_VENDOR_PARAM), \
+	TRACE_SYM(EC_CMD_SB_FW_UPDATE), \
+	TRACE_SYM(EC_CMD_ENTERING_MODE), \
+	TRACE_SYM(EC_CMD_I2C_PASSTHRU_PROTECT), \
+	TRACE_SYM(EC_CMD_REBOOT), \
+	TRACE_SYM(EC_CMD_REBOOT_EC), \
+	TRACE_SYM(EC_CMD_GET_PANIC_INFO), \
+	TRACE_SYM(EC_CMD_RESEND_RESPONSE), \
+	TRACE_SYM(EC_CMD_VERSION0), \
+	TRACE_SYM(EC_CMD_PD_EXCHANGE_STATUS), \
+	TRACE_SYM(EC_CMD_USB_PD_CONTROL), \
+	TRACE_SYM(EC_CMD_USB_PD_PORTS), \
+	TRACE_SYM(EC_CMD_USB_PD_POWER_INFO), \
+	TRACE_SYM(EC_CMD_PD_HOST_EVENT_STATUS), \
+	TRACE_SYM(EC_CMD_USB_PD_FW_UPDATE), \
+	TRACE_SYM(EC_CMD_USB_PD_RW_HASH_ENTRY), \
+	TRACE_SYM(EC_CMD_USB_PD_DEV_INFO), \
+	TRACE_SYM(EC_CMD_USB_PD_DISCOVERY), \
+	TRACE_SYM(EC_CMD_PD_CHARGE_PORT_OVERRIDE), \
+	TRACE_SYM(EC_CMD_PD_GET_LOG_ENTRY), \
+	TRACE_SYM(EC_CMD_USB_PD_GET_AMODE), \
+	TRACE_SYM(EC_CMD_USB_PD_SET_AMODE), \
+	TRACE_SYM(EC_CMD_PD_WRITE_LOG_ENTRY), \
+	TRACE_SYM(EC_CMD_PD_CONTROL), \
+	TRACE_SYM(EC_CMD_USB_PD_MUX_INFO), \
+	TRACE_SYM(EC_CMD_PD_CHIP_INFO), \
+	TRACE_SYM(EC_CMD_RWSIG_CHECK_STATUS), \
+	TRACE_SYM(EC_CMD_RWSIG_ACTION), \
+	TRACE_SYM(EC_CMD_CR51_BASE), \
+	TRACE_SYM(EC_CMD_CR51_LAST), \
+	TRACE_SYM(EC_CMD_FP_PASSTHRU), \
+	TRACE_SYM(EC_CMD_FP_SENSOR_CONFIG), \
+	TRACE_SYM(EC_CMD_FP_MODE), \
+	TRACE_SYM(EC_CMD_FP_INFO), \
+	TRACE_SYM(EC_CMD_FP_FRAME), \
+	TRACE_SYM(EC_CMD_TP_SELF_TEST), \
+	TRACE_SYM(EC_CMD_TP_FRAME_INFO), \
+	TRACE_SYM(EC_CMD_TP_FRAME_SNAPSHOT), \
+	TRACE_SYM(EC_CMD_TP_FRAME_GET), \
+	TRACE_SYM(EC_CMD_BATTERY_GET_STATIC), \
+	TRACE_SYM(EC_CMD_BATTERY_GET_DYNAMIC), \
+	TRACE_SYM(EC_CMD_CHARGER_CONTROL), \
+	TRACE_SYM(EC_CMD_BOARD_SPECIFIC_BASE), \
+	TRACE_SYM(EC_CMD_BOARD_SPECIFIC_LAST)
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

