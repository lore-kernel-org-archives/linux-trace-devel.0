Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533F7C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 10:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27850206A3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 10:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfDWKCY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 06:02:24 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50912 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfDWKCY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 06:02:24 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: eballetbo)
        with ESMTPSA id EFE7727FB1F
Subject: Re: [PATCH v6] platform/chrome: cros_ec: Add trace event to trace EC
 commands
To:     Raul E Rangel <rrangel@chromium.org>,
        linux-trace-devel@vger.kernel.org
Cc:     zwisler@chromium.org, djkurtz@chromium.org,
        Ross Zwisler <zwisler@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>
References: <20190416210328.204078-1-rrangel@chromium.org>
From:   Enric Balletbo i Serra <enric.balletbo@collabora.com>
Message-ID: <a966c393-70ed-48e9-988e-a869c670e25c@collabora.com>
Date:   Tue, 23 Apr 2019 12:02:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190416210328.204078-1-rrangel@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 16/4/19 23:03, Raul E Rangel wrote:
> This is useful to see which EC commands are being executed and when.
> 
> To enable:
> 
>     echo 1 > /sys/kernel/debug/tracing/events/cros_ec/enable
> 
> Example:
> 
>     /* cros_ec_cmd: version: 0, command: EC_CMD_GET_VERSION */
>     /* cros_ec_cmd: version: 0, command: EC_CMD_GET_PROTOCOL_INFO */
>     /* cros_ec_cmd: version: 1, command: EC_CMD_GET_CMD_VERSIONS */
>     /* cros_ec_cmd: version: 1, command: EC_CMD_USB_PD_CONTROL */
> 
> Signed-off-by: Raul E Rangel <rrangel@chromium.org>
> Reviewed-by: Ross Zwisler <zwisler@google.com>
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> I did not add cros_ec_commands.h as an include to cros_ec_trace.c.
> It's not strictly required because the macro doesn't get evaluated until
> after cros_ec_trace.h has been included. That transitively brings in
> cros_ec_ommands.h. I did try it, but since cros_ec_commands.h doesn't
> include linux/types.h it fails to find uint32_t. I could have included
> both headers, but since they aren't required I just skipped it.
> 
> My reasoning for not putting EC_CMDS in the cros_ec_trace.h was that I
> didn't want to clutter the file. I think it's visually easier to find
> all the trace events without having to parse through all the
> implementation details.
> 
> Changes in v6:
> - Added script to generate the EC_CMDS trace symbols. They were
>   originally sorted by value, now they are sorted by declaration order.
>   There is one duplicate: EC_CMD_PORT80_LAST_BOOT and
>   EC_CMD_PORT80_READ. They both resolve to the same value. Not sure if
>   this is a bug in the cros_ec_commands.h file or not. Anyway it doesn't
>   hurt anything.
> - Changed the example in the commit
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
>  drivers/platform/chrome/Makefile        |   5 +-
>  drivers/platform/chrome/cros_ec_proto.c |   4 +
>  drivers/platform/chrome/cros_ec_trace.c | 124 ++++++++++++++++++++++++
>  drivers/platform/chrome/cros_ec_trace.h |  51 ++++++++++
>  4 files changed, 183 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/platform/chrome/cros_ec_trace.c
>  create mode 100644 drivers/platform/chrome/cros_ec_trace.h
> 

Tweaked a bit the commit message and applied for 5.2

Thanks,
 Enric
