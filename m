Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40EFC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 19:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B75942171F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 19:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfDLTEl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 15:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbfDLTEl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 15:04:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 007CC20818;
        Fri, 12 Apr 2019 19:04:39 +0000 (UTC)
Date:   Fri, 12 Apr 2019 15:04:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     linux-trace-devel@vger.kernel.org, eballetbo@gmail.com,
        zwisler@chromium.org, djkurtz@chromium.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH v2] chrome/platform: cros_ec_proto:: Add trace event to
 trace EC commands
Message-ID: <20190412150438.56ba4429@gandalf.local.home>
In-Reply-To: <20190412184944.125338-1-rrangel@chromium.org>
References: <20190412184944.125338-1-rrangel@chromium.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 12:49:44 -0600
Raul E Rangel <rrangel@chromium.org> wrote:

> +#define ec_cmds \
> +	{EC_CMD_PROTO_VERSION, "PROTO_VERSION"}, \
> +	{EC_CMD_HELLO, "HELLO"}, \
> +	{EC_CMD_GET_VERSION, "GET_VERSION"}, \
> +	{EC_CMD_READ_TEST, "READ_TEST"}, \
> +	{EC_CMD_GET_BUILD_INFO, "GET_BUILD_INFO"}, \
> +	{EC_CMD_GET_CHIP_INFO, "GET_CHIP_INFO"}, \
> +	{EC_CMD_GET_BOARD_VERSION, "GET_BOARD_VERSION"}, \
> +	{EC_CMD_READ_MEMMAP, "READ_MEMMAP"}, \
> +	{EC_CMD_GET_CMD_VERSIONS, "GET_CMD_VERSIONS"}, \
> +	{EC_CMD_GET_COMMS_STATUS, "GET_COMMS_STATUS"}, \
> +	{EC_CMD_TEST_PROTOCOL, "TEST_PROTOCOL"}, \
> +	{EC_CMD_GET_PROTOCOL_INFO, "GET_PROTOCOL_INFO"}, \
> +	{EC_CMD_GSV_PAUSE_IN_S5, "GSV_PAUSE_IN_S5"}, \
> +	{EC_CMD_GET_FEATURES, "GET_FEATURES"}, \

Usually, if I have something like this, I would do:


#define ec_cmds \
	EC(PROTO_VERSION), \
	EC(HELLO), \
	EC(GET_VERSION), \
	EC(READ_TEST), \
	[...]

Then:

#define EC(a) {EC_CMD_##a, #a}

and then ec_cmds ends up with the same result with much less typing and
little risk for copy past errors.

-- Steve
