Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 509BEC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 21:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26B5F20880
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 21:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfDOVqe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 17:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbfDOVqe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 17:46:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A148206B6;
        Mon, 15 Apr 2019 21:46:33 +0000 (UTC)
Date:   Mon, 15 Apr 2019 17:46:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     linux-trace-devel@vger.kernel.org, eballetbo@gmail.com,
        zwisler@chromium.org, djkurtz@chromium.org,
        Ross Zwisler <zwisler@google.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH v5] chrome/platform: cros_ec_proto: Add trace event to
 trace EC commands
Message-ID: <20190415174631.471a8e87@gandalf.local.home>
In-Reply-To: <20190415205704.46726-1-rrangel@chromium.org>
References: <20190415205704.46726-1-rrangel@chromium.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 15 Apr 2019 14:57:04 -0600
Raul E Rangel <rrangel@chromium.org> wrote:

> This is useful to see which EC commands are being executed and when.
> 
> To enable:
> 
>     echo 'cros_ec:*' >> /sys/kernel/debug/tracing/set_event

Note, you can accomplish the same thing with:

  echo 1 > /sys/kernel/debug/tracing/events/cros_ec/enable

That's the "new" way to do things. The set_event only hangs around for
historical (and compatibility) reasons.


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

For the tracing side of things:

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

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
