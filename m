Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UPPERCASE_50_75,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA90C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 18:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 689CE20869
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 18:49:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="I3OmFouv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfDLSty (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 14:49:54 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34800 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbfDLSty (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 14:49:54 -0400
Received: by mail-io1-f65.google.com with SMTP id n11so9403292ioh.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 11:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CHlKpQhIgw3crZyGfv226WxxRHuDEwrcaWRgRrNnR9w=;
        b=I3OmFouvfmu4GraaIvlFwEKrA0IE2JaOY4wWd/VxYAFBzZDs7iQV3Kl8LTbhf+FmNT
         KA0KM2WyPB67jo/BFQXn7xImFPSawbdiBLLIQN0Jsjzypb7JmRsqpWoVNUo9HB8U+hw/
         /QAZLoTskOnjUFNsccouH7nSW6DDya2ubYib4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CHlKpQhIgw3crZyGfv226WxxRHuDEwrcaWRgRrNnR9w=;
        b=fAWfo5Pwgr+KcM1LR3PZ+PdI04M9mWqegFneLxosTahPPQOx9Q2uXU9JQhA7wn3eUM
         KK+s9YNw1rBUpNNX8NaOORtChdokNRn3Gy4areZ30e1GCJDsRmyTZxjmg3Nj/EV4M6eA
         GIx7rWGdfaVlSVVkIrmvx9OMZfb6jYC88zfUoJfnBy8OOEKltUEwdGbZYTNnpoc+Enc8
         YtiSxfFu+uwi426KV4LX3xsZezBuEjUwea0LlYUUcDesnltO0UiL2oV2EeOfBOKv9+BJ
         hmWHGA5z8yhgh6rnrjp7IEIwbLI1ypF7cEMBB1N35bVHKTdvQk2bxD4abdPfngOt4blE
         XATw==
X-Gm-Message-State: APjAAAUhO68SqP7RU7CpS6F9o5jeI6B9JiegVt10KFsJALanAAlinzOP
        2zTXJYwN09ZfFLE4Fni96td24PkI5A7U3IJS
X-Google-Smtp-Source: APXvYqw/jFmOd5Hv9FnBk4ZfSynyJlDJ5p2yPxNXmL3PdqgA/0j8jSpI2eeBdxKH7sBGGqNirillEw==
X-Received: by 2002:a5e:9912:: with SMTP id t18mr38556818ioj.157.1555094993001;
        Fri, 12 Apr 2019 11:49:53 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id y24sm15480787iol.8.2019.04.12.11.49.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 11:49:52 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     eballetbo@gmail.com, zwisler@chromium.org, djkurtz@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>
Subject: [PATCH v2] chrome/platform: cros_ec_proto:: Add trace event to trace EC commands
Date:   Fri, 12 Apr 2019 12:49:44 -0600
Message-Id: <20190412184944.125338-1-rrangel@chromium.org>
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

Changes in v2:
- Changed comment style to match other cros_ec files.
- Fixed commit tag.

 drivers/platform/chrome/Makefile        |   4 +-
 drivers/platform/chrome/cros_ec_proto.c |   4 +
 drivers/platform/chrome/cros_ec_trace.c | 161 ++++++++++++++++++++++++
 drivers/platform/chrome/cros_ec_trace.h |  51 ++++++++
 4 files changed, 219 insertions(+), 1 deletion(-)
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
index 000000000000..335bfce514d7
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_trace.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0
+// Trace events for the ChromeOS Embedded Controller
+//
+// Copyright 2019 Google LLC.
+
+#define ec_cmds \
+	{EC_CMD_PROTO_VERSION, "PROTO_VERSION"}, \
+	{EC_CMD_HELLO, "HELLO"}, \
+	{EC_CMD_GET_VERSION, "GET_VERSION"}, \
+	{EC_CMD_READ_TEST, "READ_TEST"}, \
+	{EC_CMD_GET_BUILD_INFO, "GET_BUILD_INFO"}, \
+	{EC_CMD_GET_CHIP_INFO, "GET_CHIP_INFO"}, \
+	{EC_CMD_GET_BOARD_VERSION, "GET_BOARD_VERSION"}, \
+	{EC_CMD_READ_MEMMAP, "READ_MEMMAP"}, \
+	{EC_CMD_GET_CMD_VERSIONS, "GET_CMD_VERSIONS"}, \
+	{EC_CMD_GET_COMMS_STATUS, "GET_COMMS_STATUS"}, \
+	{EC_CMD_TEST_PROTOCOL, "TEST_PROTOCOL"}, \
+	{EC_CMD_GET_PROTOCOL_INFO, "GET_PROTOCOL_INFO"}, \
+	{EC_CMD_GSV_PAUSE_IN_S5, "GSV_PAUSE_IN_S5"}, \
+	{EC_CMD_GET_FEATURES, "GET_FEATURES"}, \
+	{EC_CMD_GET_SKU_ID, "GET_SKU_ID"}, \
+	{EC_CMD_SET_SKU_ID, "SET_SKU_ID"}, \
+	{EC_CMD_FLASH_INFO, "FLASH_INFO"}, \
+	{EC_CMD_FLASH_READ, "FLASH_READ"}, \
+	{EC_CMD_FLASH_WRITE, "FLASH_WRITE"}, \
+	{EC_CMD_FLASH_ERASE, "FLASH_ERASE"}, \
+	{EC_CMD_FLASH_PROTECT, "FLASH_PROTECT"}, \
+	{EC_CMD_FLASH_REGION_INFO, "FLASH_REGION_INFO"}, \
+	{EC_CMD_VBNV_CONTEXT, "VBNV_CONTEXT"}, \
+	{EC_CMD_FLASH_SPI_INFO, "FLASH_SPI_INFO"}, \
+	{EC_CMD_FLASH_SELECT, "FLASH_SELECT"}, \
+	{EC_CMD_PWM_GET_FAN_TARGET_RPM, "PWM_GET_FAN_TARGET_RPM"}, \
+	{EC_CMD_PWM_SET_FAN_TARGET_RPM, "PWM_SET_FAN_TARGET_RPM"}, \
+	{EC_CMD_PWM_GET_KEYBOARD_BACKLIGHT, "PWM_GET_KEYBOARD_BACKLIGHT"}, \
+	{EC_CMD_PWM_SET_KEYBOARD_BACKLIGHT, "PWM_SET_KEYBOARD_BACKLIGHT"}, \
+	{EC_CMD_PWM_SET_FAN_DUTY, "PWM_SET_FAN_DUTY"}, \
+	{EC_CMD_PWM_SET_DUTY, "PWM_SET_DUTY"}, \
+	{EC_CMD_PWM_GET_DUTY, "PWM_GET_DUTY"}, \
+	{EC_CMD_LIGHTBAR_CMD, "LIGHTBAR_CMD"}, \
+	{EC_CMD_LED_CONTROL, "LED_CONTROL"}, \
+	{EC_CMD_VBOOT_HASH, "VBOOT_HASH"}, \
+	{EC_CMD_MOTION_SENSE_CMD, "MOTION_SENSE_CMD"}, \
+	{EC_CMD_FORCE_LID_OPEN, "FORCE_LID_OPEN"}, \
+	{EC_CMD_CONFIG_POWER_BUTTON, "CONFIG_POWER_BUTTON"}, \
+	{EC_CMD_USB_CHARGE_SET_MODE, "USB_CHARGE_SET_MODE"}, \
+	{EC_CMD_PSTORE_INFO, "PSTORE_INFO"}, \
+	{EC_CMD_PSTORE_READ, "PSTORE_READ"}, \
+	{EC_CMD_PSTORE_WRITE, "PSTORE_WRITE"}, \
+	{EC_CMD_RTC_GET_VALUE, "RTC_GET_VALUE"}, \
+	{EC_CMD_RTC_GET_ALARM, "RTC_GET_ALARM"}, \
+	{EC_CMD_RTC_SET_VALUE, "RTC_SET_VALUE"}, \
+	{EC_CMD_RTC_SET_ALARM, "RTC_SET_ALARM"}, \
+	{EC_CMD_PORT80_READ, "PORT80_READ"}, \
+	{EC_CMD_VSTORE_INFO, "VSTORE_INFO"}, \
+	{EC_CMD_VSTORE_READ, "VSTORE_READ"}, \
+	{EC_CMD_VSTORE_WRITE, "VSTORE_WRITE"}, \
+	{EC_CMD_THERMAL_SET_THRESHOLD, "THERMAL_SET_THRESHOLD"}, \
+	{EC_CMD_THERMAL_GET_THRESHOLD, "THERMAL_GET_THRESHOLD"}, \
+	{EC_CMD_THERMAL_AUTO_FAN_CTRL, "THERMAL_AUTO_FAN_CTRL"}, \
+	{EC_CMD_TMP006_GET_CALIBRATION, "TMP006_GET_CALIBRATION"}, \
+	{EC_CMD_TMP006_SET_CALIBRATION, "TMP006_SET_CALIBRATION"}, \
+	{EC_CMD_TMP006_GET_RAW, "TMP006_GET_RAW"}, \
+	{EC_CMD_MKBP_STATE, "MKBP_STATE"}, \
+	{EC_CMD_MKBP_INFO, "MKBP_INFO"}, \
+	{EC_CMD_MKBP_SIMULATE_KEY, "MKBP_SIMULATE_KEY"}, \
+	{EC_CMD_MKBP_SET_CONFIG, "MKBP_SET_CONFIG"}, \
+	{EC_CMD_MKBP_GET_CONFIG, "MKBP_GET_CONFIG"}, \
+	{EC_CMD_KEYSCAN_SEQ_CTRL, "KEYSCAN_SEQ_CTRL"}, \
+	{EC_CMD_GET_NEXT_EVENT, "GET_NEXT_EVENT"}, \
+	{EC_CMD_KEYBOARD_FACTORY_TEST, "KEYBOARD_FACTORY_TEST"}, \
+	{EC_CMD_TEMP_SENSOR_GET_INFO, "TEMP_SENSOR_GET_INFO"}, \
+	{EC_CMD_ACPI_READ, "ACPI_READ"}, \
+	{EC_CMD_ACPI_WRITE, "ACPI_WRITE"}, \
+	{EC_CMD_ACPI_BURST_ENABLE, "ACPI_BURST_ENABLE"}, \
+	{EC_CMD_ACPI_BURST_DISABLE, "ACPI_BURST_DISABLE"}, \
+	{EC_CMD_ACPI_QUERY_EVENT, "ACPI_QUERY_EVENT"}, \
+	{EC_CMD_HOST_EVENT_GET_B, "HOST_EVENT_GET_B"}, \
+	{EC_CMD_HOST_EVENT_GET_SMI_MASK, "HOST_EVENT_GET_SMI_MASK"}, \
+	{EC_CMD_HOST_EVENT_GET_SCI_MASK, "HOST_EVENT_GET_SCI_MASK"}, \
+	{EC_CMD_HOST_EVENT_SET_SMI_MASK, "HOST_EVENT_SET_SMI_MASK"}, \
+	{EC_CMD_HOST_EVENT_SET_SCI_MASK, "HOST_EVENT_SET_SCI_MASK"}, \
+	{EC_CMD_HOST_EVENT_CLEAR, "HOST_EVENT_CLEAR"}, \
+	{EC_CMD_HOST_EVENT_GET_WAKE_MASK, "HOST_EVENT_GET_WAKE_MASK"}, \
+	{EC_CMD_HOST_EVENT_SET_WAKE_MASK, "HOST_EVENT_SET_WAKE_MASK"}, \
+	{EC_CMD_HOST_EVENT_CLEAR_B, "HOST_EVENT_CLEAR_B"}, \
+	{EC_CMD_SWITCH_ENABLE_BKLIGHT, "SWITCH_ENABLE_BKLIGHT"}, \
+	{EC_CMD_SWITCH_ENABLE_WIRELESS, "SWITCH_ENABLE_WIRELESS"}, \
+	{EC_CMD_GPIO_SET, "GPIO_SET"}, \
+	{EC_CMD_GPIO_GET, "GPIO_GET"}, \
+	{EC_CMD_I2C_READ, "I2C_READ"}, \
+	{EC_CMD_I2C_WRITE, "I2C_WRITE"}, \
+	{EC_CMD_CHARGE_CONTROL, "CHARGE_CONTROL"}, \
+	{EC_CMD_CONSOLE_SNAPSHOT, "CONSOLE_SNAPSHOT"}, \
+	{EC_CMD_CONSOLE_READ, "CONSOLE_READ"}, \
+	{EC_CMD_BATTERY_CUT_OFF, "BATTERY_CUT_OFF"}, \
+	{EC_CMD_USB_MUX, "USB_MUX"}, \
+	{EC_CMD_LDO_SET, "LDO_SET"}, \
+	{EC_CMD_LDO_GET, "LDO_GET"}, \
+	{EC_CMD_POWER_INFO, "POWER_INFO"}, \
+	{EC_CMD_I2C_PASSTHRU, "I2C_PASSTHRU"}, \
+	{EC_CMD_HANG_DETECT, "HANG_DETECT"}, \
+	{EC_CMD_CHARGE_STATE, "CHARGE_STATE"}, \
+	{EC_CMD_CHARGE_CURRENT_LIMIT, "CHARGE_CURRENT_LIMIT"}, \
+	{EC_CMD_EXTERNAL_POWER_LIMIT, "EXTERNAL_POWER_LIMIT"}, \
+	{EC_CMD_OVERRIDE_DEDICATED_CHARGER_LIMIT, \
+		"OVERRIDE_DEDICATED_CHARGER_LIMIT"}, \
+	{EC_CMD_HOST_EVENT, "HOST_EVENT"}, \
+	{EC_CMD_HIBERNATION_DELAY, "HIBERNATION_DELAY"}, \
+	{EC_CMD_HOST_SLEEP_EVENT, "HOST_SLEEP_EVENT"}, \
+	{EC_CMD_DEVICE_EVENT, "DEVICE_EVENT"}, \
+	{EC_CMD_SB_READ_WORD, "SB_READ_WORD"}, \
+	{EC_CMD_SB_WRITE_WORD, "SB_WRITE_WORD"}, \
+	{EC_CMD_SB_READ_BLOCK, "SB_READ_BLOCK"}, \
+	{EC_CMD_SB_WRITE_BLOCK, "SB_WRITE_BLOCK"}, \
+	{EC_CMD_BATTERY_VENDOR_PARAM, "BATTERY_VENDOR_PARAM"}, \
+	{EC_CMD_SB_FW_UPDATE, "SB_FW_UPDATE"}, \
+	{EC_CMD_ENTERING_MODE, "ENTERING_MODE"}, \
+	{EC_CMD_I2C_PASSTHRU_PROTECT, "I2C_PASSTHRU_PROTECT"}, \
+	{EC_CMD_REBOOT, "REBOOT"}, \
+	{EC_CMD_REBOOT_EC, "REBOOT_EC"}, \
+	{EC_CMD_GET_PANIC_INFO, "GET_PANIC_INFO"}, \
+	{EC_CMD_RESEND_RESPONSE, "RESEND_RESPONSE"}, \
+	{EC_CMD_VERSION0, "VERSION0"}, \
+	{EC_CMD_PD_EXCHANGE_STATUS, "PD_EXCHANGE_STATUS"}, \
+	{EC_CMD_USB_PD_CONTROL, "USB_PD_CONTROL"}, \
+	{EC_CMD_USB_PD_PORTS, "USB_PD_PORTS"}, \
+	{EC_CMD_USB_PD_POWER_INFO, "USB_PD_POWER_INFO"}, \
+	{EC_CMD_PD_HOST_EVENT_STATUS, "PD_HOST_EVENT_STATUS"}, \
+	{EC_CMD_USB_PD_FW_UPDATE, "USB_PD_FW_UPDATE"}, \
+	{EC_CMD_USB_PD_RW_HASH_ENTRY, "USB_PD_RW_HASH_ENTRY"}, \
+	{EC_CMD_USB_PD_DEV_INFO, "USB_PD_DEV_INFO"}, \
+	{EC_CMD_USB_PD_DISCOVERY, "USB_PD_DISCOVERY"}, \
+	{EC_CMD_PD_CHARGE_PORT_OVERRIDE, "PD_CHARGE_PORT_OVERRIDE"}, \
+	{EC_CMD_PD_GET_LOG_ENTRY, "PD_GET_LOG_ENTRY"}, \
+	{EC_CMD_USB_PD_GET_AMODE, "USB_PD_GET_AMODE"}, \
+	{EC_CMD_USB_PD_SET_AMODE, "USB_PD_SET_AMODE"}, \
+	{EC_CMD_PD_WRITE_LOG_ENTRY, "PD_WRITE_LOG_ENTRY"}, \
+	{EC_CMD_PD_CONTROL, "PD_CONTROL"}, \
+	{EC_CMD_USB_PD_MUX_INFO, "USB_PD_MUX_INFO"}, \
+	{EC_CMD_PD_CHIP_INFO, "PD_CHIP_INFO"}, \
+	{EC_CMD_RWSIG_CHECK_STATUS, "RWSIG_CHECK_STATUS"}, \
+	{EC_CMD_RWSIG_ACTION, "RWSIG_ACTION"}, \
+	{EC_CMD_CR51_BASE, "CR51_BASE"}, \
+	{EC_CMD_CR51_LAST, "CR51_LAST"}, \
+	{EC_CMD_FP_PASSTHRU, "FP_PASSTHRU"}, \
+	{EC_CMD_FP_SENSOR_CONFIG, "FP_SENSOR_CONFIG"}, \
+	{EC_CMD_FP_MODE, "FP_MODE"}, \
+	{EC_CMD_FP_INFO, "FP_INFO"}, \
+	{EC_CMD_FP_FRAME, "FP_FRAME"}, \
+	{EC_CMD_TP_SELF_TEST, "TP_SELF_TEST"}, \
+	{EC_CMD_TP_FRAME_INFO, "TP_FRAME_INFO"}, \
+	{EC_CMD_TP_FRAME_SNAPSHOT, "TP_FRAME_SNAPSHOT"}, \
+	{EC_CMD_TP_FRAME_GET, "TP_FRAME_GET"}, \
+	{EC_CMD_BATTERY_GET_STATIC, "BATTERY_GET_STATIC"}, \
+	{EC_CMD_BATTERY_GET_DYNAMIC, "BATTERY_GET_DYNAMIC"}, \
+	{EC_CMD_CHARGER_CONTROL, "CHARGER_CONTROL"}, \
+	{EC_CMD_BOARD_SPECIFIC_BASE, "BOARD_SPECIFIC_BASE"}, \
+	{EC_CMD_BOARD_SPECIFIC_LAST, "BOARD_SPECIFIC_LAST"}
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

