Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830D8C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 21:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D36661102
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 21:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhHEVP2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 17:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232716AbhHEVP1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 17:15:27 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E02A860E52;
        Thu,  5 Aug 2021 21:15:12 +0000 (UTC)
Date:   Thu, 5 Aug 2021 17:15:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 17/87] trace-cmd library: New API to configure
 compression on an output handler
Message-ID: <20210805171509.6c09c6b9@oasis.local.home>
In-Reply-To: <20210729050959.12263-18-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-18-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:08:49 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +	}
> +	if (handler->compress && handler->file_version < 7) {
> +		handler->file_version = 7;
> +		if (handler->msg_handle)
> +			tracecmd_msg_handle_cache(handler->msg_handle);
> +	}

I was thinking that in all places that we check '7' for support of
compression, we should instead make that a macro.


/* The version that compression was added */
#define FILE_VERSION_COMPRESSION	7

[..]

	if (handler->compress && handler->file_version < FILE_VERSION_COMPRESSION) {
		handler->file_version = FILE_VERSION_COMPRESSION;
		if (handler->msg_handle)
			tracecmd_msg_handle_cache(handler->msg_handle);
	}

Then we don't need to memorize what version compression was added in.

?

-- Steve
