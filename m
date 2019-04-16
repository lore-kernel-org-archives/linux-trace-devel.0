Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D89C10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 21:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 933A520684
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 21:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iaM382AF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfDPVDd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 17:03:33 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40057 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbfDPVDd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 17:03:33 -0400
Received: by mail-io1-f65.google.com with SMTP id d201so18840852iof.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Apr 2019 14:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C+KGMcAwL2dava25sI3t47/wFsCGSy6YzYB0zHQQ7G4=;
        b=iaM382AFidgEN9b+X3uGPafkGFVUJTAPVf+jGI+pljC7O5FLdbv5PWXoMXhonOCosY
         EClQnYUuJJqAYgdquyG/8P5DxzMwNYS8y66aamY7x7eM6U8A8GQ6+H4H1aWFGuonxPlV
         zNqnRNsJkB4Z102TTCUhXV2ju9WjWkN5p8ToM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C+KGMcAwL2dava25sI3t47/wFsCGSy6YzYB0zHQQ7G4=;
        b=h+HOrDOVdEumyAC0DaKIO0etW7eON3cSvKSI9bwXY6sTQg8Mq9utB5tMoQaYwcponj
         2lNS1yBWKBJPt8K0NjBaRwGjgE5Z0fzgAaICZ829YDecp32bx3HTvz6A1Zl+54KwTa2L
         PIACzpWxz1OUTjIyqtl0c61vElz7ZBpjhgG8/oCqn+Act87zg1yJLSJ71J/h2/UWCtiV
         58Mg8f8apJVCKdx9GgihBYva8efGodcmC1gbNlGk6Q2AjLVhKnq26a6fPsQVgsWoVpGk
         SiH/ohX5ATN1Fq1d+DEsVaq3So15KPdSAsjcaGNgshDleJLJCGS5XX2z0vFfgtLE0rQ2
         4DKw==
X-Gm-Message-State: APjAAAXOMP/PqkzlR7sAttSrtiuiaql8r5uKrQzaOtZR2QXD/xG9WCSk
        jmCPh5U1qim4MOBExN8vuExM7IQOFWQKlA==
X-Google-Smtp-Source: APXvYqyfVAoV4mzB3p97uC9+Oio+kDJWDxOmOCf+P+1fyfYfu99dLQn7hQ92G6euWHEdW1WF1lzxHg==
X-Received: by 2002:a6b:3ec3:: with SMTP id l186mr52616806ioa.255.1555448612094;
        Tue, 16 Apr 2019 14:03:32 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id x10sm1655022ita.4.2019.04.16.14.03.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 14:03:31 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     eballetbo@gmail.com, zwisler@chromium.org, djkurtz@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Ross Zwisler <zwisler@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>
Subject: [PATCH v6] platform/chrome: cros_ec: Add trace event to trace EC commands
Date:   Tue, 16 Apr 2019 15:03:28 -0600
Message-Id: <20190416210328.204078-1-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is useful to see which EC commands are being executed and when.

To enable:

    echo 1 > /sys/kernel/debug/tracing/events/cros_ec/enable

Example:

    /* cros_ec_cmd: version: 0, command: EC_CMD_GET_VERSION */
    /* cros_ec_cmd: version: 0, command: EC_CMD_GET_PROTOCOL_INFO */
    /* cros_ec_cmd: version: 1, command: EC_CMD_GET_CMD_VERSIONS */
    /* cros_ec_cmd: version: 1, command: EC_CMD_USB_PD_CONTROL */

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Reviewed-by: Ross Zwisler <zwisler@google.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
I did not add cros_ec_commands.h as an include to cros_ec_trace.c.
It's not strictly required because the macro doesn't get evaluated until
after cros_ec_trace.h has been included. That transitively brings in
cros_ec_ommands.h. I did try it, but since cros_ec_commands.h doesn't
include linux/types.h it fails to find uint32_t. I could have included
both headers, but since they aren't required I just skipped it.

My reasoning for not putting EC_CMDS in the cros_ec_trace.h was that I
didn't want to clutter the file. I think it's visually easier to find
all the trace events without having to parse through all the
implementation details.

Changes in v6:
- Added script to generate the EC_CMDS trace symbols. They were
  originally sorted by value, now they are sorted by declaration order.
  There is one duplicate: EC_CMD_PORT80_LAST_BOOT and
  EC_CMD_PORT80_READ. They both resolve to the same value. Not sure if
  this is a bug in the cros_ec_commands.h file or not. Anyway it doesn't
  hurt anything.
- Changed the example in the commit

Changes in v5:
- Rebased on upstream/master. It turns out upstream/master is missing a
  lot of changes to cros_ec_commands.h.
- Replace SYM with SYMBOL in macro name.

Changes in v4:
- Use the full command name so go to definition continues to work in my
editor.

Changes in v3:
- Use a macro to avoid duplicating the ec command names.

Changes in v2:
- Changed comment style to match other cros_ec files.
- Fixed commit tag.

 drivers/platform/chrome/Makefile        |   5 +-
 drivers/platform/chrome/cros_ec_proto.c |   4 +
 drivers/platform/chrome/cros_ec_trace.c | 124 ++++++++++++++++++++++++
 drivers/platform/chrome/cros_ec_trace.h |  51 ++++++++++
 4 files changed, 183 insertions(+), 1 deletion(-)
 create mode 100644 drivers/platform/chrome/cros_ec_trace.c
 create mode 100644 drivers/platform/chrome/cros_ec_trace.h

diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/Makefile
index 1e2f0029b597..a6c0f5438e15 100644
--- a/drivers/platform/chrome/Makefile
+++ b/drivers/platform/chrome/Makefile
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
+# tell define_trace.h where to find the cros ec trace header
+CFLAGS_cros_ec_trace.o:=		-I$(src)
+
 obj-$(CONFIG_CHROMEOS_LAPTOP)		+= chromeos_laptop.o
 obj-$(CONFIG_CHROMEOS_PSTORE)		+= chromeos_pstore.o
 obj-$(CONFIG_CHROMEOS_TBMC)		+= chromeos_tbmc.o
@@ -8,7 +11,7 @@ obj-$(CONFIG_CROS_EC_SPI)		+= cros_ec_spi.o
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
index 000000000000..0a76412095a9
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_trace.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+// Trace events for the ChromeOS Embedded Controller
+//
+// Copyright 2019 Google LLC.
+
+#define TRACE_SYMBOL(a) {a, #a}
+
+// Generate the list using the following script:
+// sed -n 's/^#define \(EC_CMD_[[:alnum:]_]*\)\s.*/\tTRACE_SYMBOL(\1), \\/p' include/linux/mfd/cros_ec_commands.h
+#define EC_CMDS \
+	TRACE_SYMBOL(EC_CMD_PROTO_VERSION), \
+	TRACE_SYMBOL(EC_CMD_HELLO), \
+	TRACE_SYMBOL(EC_CMD_GET_VERSION), \
+	TRACE_SYMBOL(EC_CMD_READ_TEST), \
+	TRACE_SYMBOL(EC_CMD_GET_BUILD_INFO), \
+	TRACE_SYMBOL(EC_CMD_GET_CHIP_INFO), \
+	TRACE_SYMBOL(EC_CMD_GET_BOARD_VERSION), \
+	TRACE_SYMBOL(EC_CMD_READ_MEMMAP), \
+	TRACE_SYMBOL(EC_CMD_GET_CMD_VERSIONS), \
+	TRACE_SYMBOL(EC_CMD_GET_COMMS_STATUS), \
+	TRACE_SYMBOL(EC_CMD_TEST_PROTOCOL), \
+	TRACE_SYMBOL(EC_CMD_GET_PROTOCOL_INFO), \
+	TRACE_SYMBOL(EC_CMD_GSV_PAUSE_IN_S5), \
+	TRACE_SYMBOL(EC_CMD_GET_FEATURES), \
+	TRACE_SYMBOL(EC_CMD_FLASH_INFO), \
+	TRACE_SYMBOL(EC_CMD_FLASH_READ), \
+	TRACE_SYMBOL(EC_CMD_FLASH_WRITE), \
+	TRACE_SYMBOL(EC_CMD_FLASH_ERASE), \
+	TRACE_SYMBOL(EC_CMD_FLASH_PROTECT), \
+	TRACE_SYMBOL(EC_CMD_FLASH_REGION_INFO), \
+	TRACE_SYMBOL(EC_CMD_VBNV_CONTEXT), \
+	TRACE_SYMBOL(EC_CMD_PWM_GET_FAN_TARGET_RPM), \
+	TRACE_SYMBOL(EC_CMD_PWM_SET_FAN_TARGET_RPM), \
+	TRACE_SYMBOL(EC_CMD_PWM_GET_KEYBOARD_BACKLIGHT), \
+	TRACE_SYMBOL(EC_CMD_PWM_SET_KEYBOARD_BACKLIGHT), \
+	TRACE_SYMBOL(EC_CMD_PWM_SET_FAN_DUTY), \
+	TRACE_SYMBOL(EC_CMD_PWM_SET_DUTY), \
+	TRACE_SYMBOL(EC_CMD_PWM_GET_DUTY), \
+	TRACE_SYMBOL(EC_CMD_LIGHTBAR_CMD), \
+	TRACE_SYMBOL(EC_CMD_LED_CONTROL), \
+	TRACE_SYMBOL(EC_CMD_VBOOT_HASH), \
+	TRACE_SYMBOL(EC_CMD_MOTION_SENSE_CMD), \
+	TRACE_SYMBOL(EC_CMD_USB_CHARGE_SET_MODE), \
+	TRACE_SYMBOL(EC_CMD_PSTORE_INFO), \
+	TRACE_SYMBOL(EC_CMD_PSTORE_READ), \
+	TRACE_SYMBOL(EC_CMD_PSTORE_WRITE), \
+	TRACE_SYMBOL(EC_CMD_RTC_GET_VALUE), \
+	TRACE_SYMBOL(EC_CMD_RTC_GET_ALARM), \
+	TRACE_SYMBOL(EC_CMD_RTC_SET_VALUE), \
+	TRACE_SYMBOL(EC_CMD_RTC_SET_ALARM), \
+	TRACE_SYMBOL(EC_CMD_PORT80_LAST_BOOT), \
+	TRACE_SYMBOL(EC_CMD_PORT80_READ), \
+	TRACE_SYMBOL(EC_CMD_THERMAL_SET_THRESHOLD), \
+	TRACE_SYMBOL(EC_CMD_THERMAL_GET_THRESHOLD), \
+	TRACE_SYMBOL(EC_CMD_THERMAL_AUTO_FAN_CTRL), \
+	TRACE_SYMBOL(EC_CMD_TMP006_GET_CALIBRATION), \
+	TRACE_SYMBOL(EC_CMD_TMP006_SET_CALIBRATION), \
+	TRACE_SYMBOL(EC_CMD_TMP006_GET_RAW), \
+	TRACE_SYMBOL(EC_CMD_MKBP_STATE), \
+	TRACE_SYMBOL(EC_CMD_MKBP_INFO), \
+	TRACE_SYMBOL(EC_CMD_MKBP_SIMULATE_KEY), \
+	TRACE_SYMBOL(EC_CMD_MKBP_SET_CONFIG), \
+	TRACE_SYMBOL(EC_CMD_MKBP_GET_CONFIG), \
+	TRACE_SYMBOL(EC_CMD_KEYSCAN_SEQ_CTRL), \
+	TRACE_SYMBOL(EC_CMD_GET_NEXT_EVENT), \
+	TRACE_SYMBOL(EC_CMD_TEMP_SENSOR_GET_INFO), \
+	TRACE_SYMBOL(EC_CMD_HOST_EVENT_GET_B), \
+	TRACE_SYMBOL(EC_CMD_HOST_EVENT_GET_SMI_MASK), \
+	TRACE_SYMBOL(EC_CMD_HOST_EVENT_GET_SCI_MASK), \
+	TRACE_SYMBOL(EC_CMD_HOST_EVENT_GET_WAKE_MASK), \
+	TRACE_SYMBOL(EC_CMD_HOST_EVENT_SET_SMI_MASK), \
+	TRACE_SYMBOL(EC_CMD_HOST_EVENT_SET_SCI_MASK), \
+	TRACE_SYMBOL(EC_CMD_HOST_EVENT_CLEAR), \
+	TRACE_SYMBOL(EC_CMD_HOST_EVENT_SET_WAKE_MASK), \
+	TRACE_SYMBOL(EC_CMD_HOST_EVENT_CLEAR_B), \
+	TRACE_SYMBOL(EC_CMD_SWITCH_ENABLE_BKLIGHT), \
+	TRACE_SYMBOL(EC_CMD_SWITCH_ENABLE_WIRELESS), \
+	TRACE_SYMBOL(EC_CMD_GPIO_SET), \
+	TRACE_SYMBOL(EC_CMD_GPIO_GET), \
+	TRACE_SYMBOL(EC_CMD_I2C_READ), \
+	TRACE_SYMBOL(EC_CMD_I2C_WRITE), \
+	TRACE_SYMBOL(EC_CMD_CHARGE_CONTROL), \
+	TRACE_SYMBOL(EC_CMD_CONSOLE_SNAPSHOT), \
+	TRACE_SYMBOL(EC_CMD_CONSOLE_READ), \
+	TRACE_SYMBOL(EC_CMD_BATTERY_CUT_OFF), \
+	TRACE_SYMBOL(EC_CMD_USB_MUX), \
+	TRACE_SYMBOL(EC_CMD_LDO_SET), \
+	TRACE_SYMBOL(EC_CMD_LDO_GET), \
+	TRACE_SYMBOL(EC_CMD_POWER_INFO), \
+	TRACE_SYMBOL(EC_CMD_I2C_PASSTHRU), \
+	TRACE_SYMBOL(EC_CMD_HANG_DETECT), \
+	TRACE_SYMBOL(EC_CMD_CHARGE_STATE), \
+	TRACE_SYMBOL(EC_CMD_CHARGE_CURRENT_LIMIT), \
+	TRACE_SYMBOL(EC_CMD_EXTERNAL_POWER_LIMIT), \
+	TRACE_SYMBOL(EC_CMD_HOST_SLEEP_EVENT), \
+	TRACE_SYMBOL(EC_CMD_SB_READ_WORD), \
+	TRACE_SYMBOL(EC_CMD_SB_WRITE_WORD), \
+	TRACE_SYMBOL(EC_CMD_SB_READ_BLOCK), \
+	TRACE_SYMBOL(EC_CMD_SB_WRITE_BLOCK), \
+	TRACE_SYMBOL(EC_CMD_BATTERY_VENDOR_PARAM), \
+	TRACE_SYMBOL(EC_CMD_CODEC_I2S), \
+	TRACE_SYMBOL(EC_CMD_REBOOT_EC), \
+	TRACE_SYMBOL(EC_CMD_GET_PANIC_INFO), \
+	TRACE_SYMBOL(EC_CMD_ACPI_READ), \
+	TRACE_SYMBOL(EC_CMD_ACPI_WRITE), \
+	TRACE_SYMBOL(EC_CMD_ACPI_QUERY_EVENT), \
+	TRACE_SYMBOL(EC_CMD_CEC_WRITE_MSG), \
+	TRACE_SYMBOL(EC_CMD_CEC_SET), \
+	TRACE_SYMBOL(EC_CMD_CEC_GET), \
+	TRACE_SYMBOL(EC_CMD_REBOOT), \
+	TRACE_SYMBOL(EC_CMD_RESEND_RESPONSE), \
+	TRACE_SYMBOL(EC_CMD_VERSION0), \
+	TRACE_SYMBOL(EC_CMD_PD_EXCHANGE_STATUS), \
+	TRACE_SYMBOL(EC_CMD_USB_PD_CONTROL), \
+	TRACE_SYMBOL(EC_CMD_USB_PD_PORTS), \
+	TRACE_SYMBOL(EC_CMD_USB_PD_POWER_INFO), \
+	TRACE_SYMBOL(EC_CMD_CHARGE_PORT_COUNT), \
+	TRACE_SYMBOL(EC_CMD_USB_PD_DISCOVERY), \
+	TRACE_SYMBOL(EC_CMD_PD_CHARGE_PORT_OVERRIDE), \
+	TRACE_SYMBOL(EC_CMD_PD_GET_LOG_ENTRY), \
+	TRACE_SYMBOL(EC_CMD_USB_PD_MUX_INFO)
+
+#define CREATE_TRACE_POINTS
+#include "cros_ec_trace.h"
diff --git a/drivers/platform/chrome/cros_ec_trace.h b/drivers/platform/chrome/cros_ec_trace.h
new file mode 100644
index 000000000000..7ae3b89c78b9
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
+		  __print_symbolic(__entry->command, EC_CMDS))
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

