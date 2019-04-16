Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	UPPERCASE_50_75 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68530C10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 11:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 321292077C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 11:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfDPLeB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 07:34:01 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49948 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbfDPLeA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 07:34:00 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: eballetbo)
        with ESMTPSA id 25EDD281C61
Subject: Re: [PATCH v5] chrome/platform: cros_ec_proto: Add trace event to
 trace EC commands
To:     Raul E Rangel <rrangel@chromium.org>,
        linux-trace-devel@vger.kernel.org
Cc:     eballetbo@gmail.com, zwisler@chromium.org, djkurtz@chromium.org,
        Ross Zwisler <zwisler@google.com>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>
References: <20190415205704.46726-1-rrangel@chromium.org>
From:   Enric Balletbo i Serra <enric.balletbo@collabora.com>
Message-ID: <dd557117-647c-f324-7c18-60bc28aba483@collabora.com>
Date:   Tue, 16 Apr 2019 13:33:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415205704.46726-1-rrangel@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Raul,

I really like the idea to have trace functionality in cros-ec. Only some few
comments below and the patch looks good to me.

On 15/4/19 22:57, Raul E Rangel wrote:
> This is useful to see which EC commands are being executed and when.
> 
> To enable:
> 
>     echo 'cros_ec:*' >> /sys/kernel/debug/tracing/set_event
> 

For next version could you use the "new" way as suggested by Steven?

> Example:
> 
>     /* cros_ec_cmd: version: 0, command: EC_CMD_GET_VERSION */
>     /* cros_ec_cmd: version: 0, command: EC_CMD_GET_PROTOCOL_INFO */
>     /* cros_ec_cmd: version: 1, command: EC_CMD_GET_CMD_VERSIONS */
>     /* cros_ec_cmd: version: 1, command: EC_CMD_USB_PD_CONTROL */
> 
> Signed-off-by: Raul E Rangel <rrangel@chromium.org>
> Reviewed-by: Ross Zwisler <zwisler@google.com>
> ---
> 
> Changes in v5:
> - Rebased on upstream/master. It turns out upstream/master is missing a
>   lot of changes to cros_ec_commands.h.
> - Replace SYM with SYMBOL in macro name.
> 
> Changes in v4:
> - Use the full command name so go to definition continues to work in my
> editor.
> 
> Changes in v3:
> - Use a macro to avoid duplicating the ec command names.
> 
> Changes in v2:
> - Changed comment style to match other cros_ec files.
> - Fixed commit tag.
> 
>  drivers/platform/chrome/Makefile        |   4 +-
>  drivers/platform/chrome/cros_ec_proto.c |   4 +
>  drivers/platform/chrome/cros_ec_trace.c | 121 ++++++++++++++++++++++++
>  drivers/platform/chrome/cros_ec_trace.h |  51 ++++++++++
>  4 files changed, 179 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/platform/chrome/cros_ec_trace.c
>  create mode 100644 drivers/platform/chrome/cros_ec_trace.h
> 
> diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/Makefile
> index 1e2f0029b597..e542268454a4 100644
> --- a/drivers/platform/chrome/Makefile
> +++ b/drivers/platform/chrome/Makefile
> @@ -3,12 +3,14 @@
>  obj-$(CONFIG_CHROMEOS_LAPTOP)		+= chromeos_laptop.o
>  obj-$(CONFIG_CHROMEOS_PSTORE)		+= chromeos_pstore.o
>  obj-$(CONFIG_CHROMEOS_TBMC)		+= chromeos_tbmc.o
> +# tell define_trace.h where to find the cros ec trace header
> +CFLAGS_cros_ec_trace.o:=		-I$(src)

Add this on top of the file, just below the SPDX license comment

>  obj-$(CONFIG_CROS_EC_I2C)		+= cros_ec_i2c.o
>  obj-$(CONFIG_CROS_EC_SPI)		+= cros_ec_spi.o
>  cros_ec_lpcs-objs			:= cros_ec_lpc.o cros_ec_lpc_reg.o
>  cros_ec_lpcs-$(CONFIG_CROS_EC_LPC_MEC)	+= cros_ec_lpc_mec.o
>  obj-$(CONFIG_CROS_EC_LPC)		+= cros_ec_lpcs.o
> -obj-$(CONFIG_CROS_EC_PROTO)		+= cros_ec_proto.o
> +obj-$(CONFIG_CROS_EC_PROTO)		+= cros_ec_proto.o cros_ec_trace.o
>  obj-$(CONFIG_CROS_KBD_LED_BACKLIGHT)	+= cros_kbd_led_backlight.o
>  obj-$(CONFIG_CROS_EC_LIGHTBAR)		+= cros_ec_lightbar.o
>  obj-$(CONFIG_CROS_EC_VBC)		+= cros_ec_vbc.o
> diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> index 97a068dff192..3d02c8259ac6 100644
> --- a/drivers/platform/chrome/cros_ec_proto.c
> +++ b/drivers/platform/chrome/cros_ec_proto.c
> @@ -10,6 +10,8 @@
>  #include <linux/slab.h>
>  #include <asm/unaligned.h>
>  
> +#include "cros_ec_trace.h"
> +
>  #define EC_COMMAND_RETRIES	50
>  
>  static int prepare_packet(struct cros_ec_device *ec_dev,
> @@ -51,6 +53,8 @@ static int send_command(struct cros_ec_device *ec_dev,
>  	int ret;
>  	int (*xfer_fxn)(struct cros_ec_device *ec, struct cros_ec_command *msg);
>  
> +	trace_cros_ec_cmd(msg);
> +
>  	if (ec_dev->proto_version > 2)
>  		xfer_fxn = ec_dev->pkt_xfer;
>  	else
> diff --git a/drivers/platform/chrome/cros_ec_trace.c b/drivers/platform/chrome/cros_ec_trace.c
> new file mode 100644
> index 000000000000..68f429f3c5f5
> --- /dev/null
> +++ b/drivers/platform/chrome/cros_ec_trace.c
> @@ -0,0 +1,121 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Trace events for the ChromeOS Embedded Controller
> +//
> +// Copyright 2019 Google LLC.
> +

#include <linux/mfd/cros_ec_commands.h> ?

> +#define TRACE_SYMBOL(a) {a, #a}
> +
> +#define ec_cmds \
> +	TRACE_SYMBOL(EC_CMD_PROTO_VERSION), \
> +	TRACE_SYMBOL(EC_CMD_HELLO), \
> +	TRACE_SYMBOL(EC_CMD_GET_VERSION), \
> +	TRACE_SYMBOL(EC_CMD_READ_TEST), \
> +	TRACE_SYMBOL(EC_CMD_GET_BUILD_INFO), \
> +	TRACE_SYMBOL(EC_CMD_GET_CHIP_INFO), \
> +	TRACE_SYMBOL(EC_CMD_GET_BOARD_VERSION), \
> +	TRACE_SYMBOL(EC_CMD_READ_MEMMAP), \
> +	TRACE_SYMBOL(EC_CMD_GET_CMD_VERSIONS), \
> +	TRACE_SYMBOL(EC_CMD_GET_COMMS_STATUS), \
> +	TRACE_SYMBOL(EC_CMD_TEST_PROTOCOL), \
> +	TRACE_SYMBOL(EC_CMD_GET_PROTOCOL_INFO), \
> +	TRACE_SYMBOL(EC_CMD_GSV_PAUSE_IN_S5), \
> +	TRACE_SYMBOL(EC_CMD_GET_FEATURES), \
> +	TRACE_SYMBOL(EC_CMD_FLASH_INFO), \
> +	TRACE_SYMBOL(EC_CMD_FLASH_READ), \
> +	TRACE_SYMBOL(EC_CMD_FLASH_WRITE), \
> +	TRACE_SYMBOL(EC_CMD_FLASH_ERASE), \
> +	TRACE_SYMBOL(EC_CMD_FLASH_PROTECT), \
> +	TRACE_SYMBOL(EC_CMD_FLASH_REGION_INFO), \
> +	TRACE_SYMBOL(EC_CMD_VBNV_CONTEXT), \
> +	TRACE_SYMBOL(EC_CMD_PWM_GET_FAN_TARGET_RPM), \
> +	TRACE_SYMBOL(EC_CMD_PWM_SET_FAN_TARGET_RPM), \
> +	TRACE_SYMBOL(EC_CMD_PWM_GET_KEYBOARD_BACKLIGHT), \
> +	TRACE_SYMBOL(EC_CMD_PWM_SET_KEYBOARD_BACKLIGHT), \
> +	TRACE_SYMBOL(EC_CMD_PWM_SET_FAN_DUTY), \
> +	TRACE_SYMBOL(EC_CMD_PWM_SET_DUTY), \
> +	TRACE_SYMBOL(EC_CMD_PWM_GET_DUTY), \
> +	TRACE_SYMBOL(EC_CMD_LIGHTBAR_CMD), \
> +	TRACE_SYMBOL(EC_CMD_LED_CONTROL), \
> +	TRACE_SYMBOL(EC_CMD_VBOOT_HASH), \
> +	TRACE_SYMBOL(EC_CMD_MOTION_SENSE_CMD), \
> +	TRACE_SYMBOL(EC_CMD_USB_CHARGE_SET_MODE), \
> +	TRACE_SYMBOL(EC_CMD_PSTORE_INFO), \
> +	TRACE_SYMBOL(EC_CMD_PSTORE_READ), \
> +	TRACE_SYMBOL(EC_CMD_PSTORE_WRITE), \
> +	TRACE_SYMBOL(EC_CMD_RTC_GET_VALUE), \
> +	TRACE_SYMBOL(EC_CMD_RTC_GET_ALARM), \
> +	TRACE_SYMBOL(EC_CMD_RTC_SET_VALUE), \
> +	TRACE_SYMBOL(EC_CMD_RTC_SET_ALARM), \
> +	TRACE_SYMBOL(EC_CMD_PORT80_READ), \
> +	TRACE_SYMBOL(EC_CMD_THERMAL_SET_THRESHOLD), \
> +	TRACE_SYMBOL(EC_CMD_THERMAL_GET_THRESHOLD), \
> +	TRACE_SYMBOL(EC_CMD_THERMAL_AUTO_FAN_CTRL), \
> +	TRACE_SYMBOL(EC_CMD_TMP006_GET_CALIBRATION), \
> +	TRACE_SYMBOL(EC_CMD_TMP006_SET_CALIBRATION), \
> +	TRACE_SYMBOL(EC_CMD_TMP006_GET_RAW), \
> +	TRACE_SYMBOL(EC_CMD_MKBP_STATE), \
> +	TRACE_SYMBOL(EC_CMD_MKBP_INFO), \
> +	TRACE_SYMBOL(EC_CMD_MKBP_SIMULATE_KEY), \
> +	TRACE_SYMBOL(EC_CMD_MKBP_SET_CONFIG), \
> +	TRACE_SYMBOL(EC_CMD_MKBP_GET_CONFIG), \
> +	TRACE_SYMBOL(EC_CMD_KEYSCAN_SEQ_CTRL), \
> +	TRACE_SYMBOL(EC_CMD_GET_NEXT_EVENT), \
> +	TRACE_SYMBOL(EC_CMD_TEMP_SENSOR_GET_INFO), \
> +	TRACE_SYMBOL(EC_CMD_ACPI_READ), \
> +	TRACE_SYMBOL(EC_CMD_ACPI_WRITE), \
> +	TRACE_SYMBOL(EC_CMD_ACPI_QUERY_EVENT), \
> +	TRACE_SYMBOL(EC_CMD_HOST_EVENT_GET_B), \
> +	TRACE_SYMBOL(EC_CMD_HOST_EVENT_GET_SMI_MASK), \
> +	TRACE_SYMBOL(EC_CMD_HOST_EVENT_GET_SCI_MASK), \
> +	TRACE_SYMBOL(EC_CMD_HOST_EVENT_SET_SMI_MASK), \
> +	TRACE_SYMBOL(EC_CMD_HOST_EVENT_SET_SCI_MASK), \
> +	TRACE_SYMBOL(EC_CMD_HOST_EVENT_CLEAR), \
> +	TRACE_SYMBOL(EC_CMD_HOST_EVENT_GET_WAKE_MASK), \
> +	TRACE_SYMBOL(EC_CMD_HOST_EVENT_SET_WAKE_MASK), \
> +	TRACE_SYMBOL(EC_CMD_HOST_EVENT_CLEAR_B), \
> +	TRACE_SYMBOL(EC_CMD_SWITCH_ENABLE_BKLIGHT), \
> +	TRACE_SYMBOL(EC_CMD_SWITCH_ENABLE_WIRELESS), \
> +	TRACE_SYMBOL(EC_CMD_GPIO_SET), \
> +	TRACE_SYMBOL(EC_CMD_GPIO_GET), \
> +	TRACE_SYMBOL(EC_CMD_I2C_READ), \
> +	TRACE_SYMBOL(EC_CMD_I2C_WRITE), \
> +	TRACE_SYMBOL(EC_CMD_CHARGE_CONTROL), \
> +	TRACE_SYMBOL(EC_CMD_CONSOLE_SNAPSHOT), \
> +	TRACE_SYMBOL(EC_CMD_CONSOLE_READ), \
> +	TRACE_SYMBOL(EC_CMD_BATTERY_CUT_OFF), \
> +	TRACE_SYMBOL(EC_CMD_USB_MUX), \
> +	TRACE_SYMBOL(EC_CMD_LDO_SET), \
> +	TRACE_SYMBOL(EC_CMD_LDO_GET), \
> +	TRACE_SYMBOL(EC_CMD_POWER_INFO), \
> +	TRACE_SYMBOL(EC_CMD_I2C_PASSTHRU), \
> +	TRACE_SYMBOL(EC_CMD_HANG_DETECT), \
> +	TRACE_SYMBOL(EC_CMD_CHARGE_STATE), \
> +	TRACE_SYMBOL(EC_CMD_CHARGE_CURRENT_LIMIT), \
> +	TRACE_SYMBOL(EC_CMD_EXTERNAL_POWER_LIMIT), \
> +	TRACE_SYMBOL(EC_CMD_HOST_SLEEP_EVENT), \
> +	TRACE_SYMBOL(EC_CMD_SB_READ_WORD), \
> +	TRACE_SYMBOL(EC_CMD_SB_WRITE_WORD), \
> +	TRACE_SYMBOL(EC_CMD_SB_READ_BLOCK), \
> +	TRACE_SYMBOL(EC_CMD_SB_WRITE_BLOCK), \
> +	TRACE_SYMBOL(EC_CMD_BATTERY_VENDOR_PARAM), \
> +	TRACE_SYMBOL(EC_CMD_CEC_WRITE_MSG), \
> +	TRACE_SYMBOL(EC_CMD_CEC_SET), \
> +	TRACE_SYMBOL(EC_CMD_CEC_GET), \
> +	TRACE_SYMBOL(EC_CMD_CODEC_I2S), \
> +	TRACE_SYMBOL(EC_CMD_REBOOT), \
> +	TRACE_SYMBOL(EC_CMD_REBOOT_EC), \
> +	TRACE_SYMBOL(EC_CMD_GET_PANIC_INFO), \
> +	TRACE_SYMBOL(EC_CMD_RESEND_RESPONSE), \
> +	TRACE_SYMBOL(EC_CMD_VERSION0), \
> +	TRACE_SYMBOL(EC_CMD_PD_EXCHANGE_STATUS), \
> +	TRACE_SYMBOL(EC_CMD_USB_PD_CONTROL), \
> +	TRACE_SYMBOL(EC_CMD_USB_PD_PORTS), \
> +	TRACE_SYMBOL(EC_CMD_USB_PD_POWER_INFO), \
> +	TRACE_SYMBOL(EC_CMD_CHARGE_PORT_COUNT), \
> +	TRACE_SYMBOL(EC_CMD_USB_PD_DISCOVERY), \
> +	TRACE_SYMBOL(EC_CMD_PD_CHARGE_PORT_OVERRIDE), \
> +	TRACE_SYMBOL(EC_CMD_PD_GET_LOG_ENTRY), \
> +	TRACE_SYMBOL(EC_CMD_USB_PD_MUX_INFO)
> +

I suspect that maintain sync this will be a pain, can we have, at least, a
script that parses cros_ec_commands.h and generates automatically this define?

grep "#define EC_CMD_" include/linux/mfd/cros_ec_commands.h | awk '{print $2}' >
a.txt

grep "EC_CMD_" drivers/platform/chrome/cros_ec_trace.c | awk '{print $2}' | sed
s/TRACE_SYMBOL\(//g | sed s/\).*//g > b.txt

diff a.txt b.txt

Shows few differences and we can go crazy in the future :-)

> +#define CREATE_TRACE_POINTS
> +#include "cros_ec_trace.h"
> diff --git a/drivers/platform/chrome/cros_ec_trace.h b/drivers/platform/chrome/cros_ec_trace.h
> new file mode 100644
> index 000000000000..86ef52f96fd4
> --- /dev/null
> +++ b/drivers/platform/chrome/cros_ec_trace.h
> @@ -0,0 +1,51 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Trace events for the ChromeOS Embedded Controller
> + *
> + * Copyright 2019 Google LLC.
> + */
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM cros_ec
> +
> +#if !defined(_CROS_EC_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
> +#define _CROS_EC_TRACE_H_
> +
> +#include <linux/types.h>
> +#include <linux/mfd/cros_ec.h>
> +
> +#include <linux/tracepoint.h>
> +
> +DECLARE_EVENT_CLASS(cros_ec_cmd_class,
> +	TP_PROTO(struct cros_ec_command *cmd),
> +	TP_ARGS(cmd),
> +	TP_STRUCT__entry(
> +		__field(uint32_t, version)
> +		__field(uint32_t, command)
> +	),
> +	TP_fast_assign(
> +		__entry->version = cmd->version;
> +		__entry->command = cmd->command;
> +	),
> +	TP_printk("version: %u, command: %s", __entry->version,
> +		  __print_symbolic(__entry->command, ec_cmds))
> +);
> +
> +
> +DEFINE_EVENT(cros_ec_cmd_class, cros_ec_cmd,
> +	TP_PROTO(struct cros_ec_command *cmd),
> +	TP_ARGS(cmd)
> +);
> +
> +
> +#endif /* _CROS_EC_TRACE_H_ */
> +
> +/* this part must be outside header guard */
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE cros_ec_trace
> +
> +#include <trace/define_trace.h>
> 

Thanks,
 Enric
