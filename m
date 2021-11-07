Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F2DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun,  7 Nov 2021 14:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0C1061101
	for <linux-trace-devel@archiver.kernel.org>; Sun,  7 Nov 2021 14:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhKGOeB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 7 Nov 2021 09:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:37906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232667AbhKGOeA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 7 Nov 2021 09:34:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DB4561284;
        Sun,  7 Nov 2021 14:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636295478;
        bh=YvN6x+FYckLXqvws23F2HjZqFpEGKboXCYvZiNrhpSs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P2uiPTIwNQI8ENAeWsJ/VEn9y15GvtL+NE0Ccu5I2BI3jzfeNyedsOE5RoKOdYAEG
         lVcL37BEoDD78nChgr1N+SA1T0vBiaTg1XGIap5pUwKUyKVkov6WW4zj51EDnM5p3I
         tVpkuRz+aK72UXxarHCfP97RQl+x3jjcVB584etlp9l/8yYIIf2dY9i4v6Ab/QPmU9
         Gysg9hMTvb2WijFEz2KYDwzKoq6j65dD1UK8MDwAiwI4iiPMTPh9SwVeb4psMOexcM
         ksGIblsdUPVepLiRXJYDT5VXruwIKHV9bdNbc3i9Jq+GRqqi1u9FUOpRREmhZ2jKAp
         /duDq28Oe8H5w==
Date:   Sun, 7 Nov 2021 23:31:15 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-Id: <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
In-Reply-To: <20211104170433.2206-3-beaub@linux.microsoft.com>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-3-beaub@linux.microsoft.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Beau,

At first, thanks for breaking down your patch into this series!

Now I found that a suspicious security design issue in this patch.

On Thu,  4 Nov 2021 10:04:25 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> +
> +static enum print_line_t user_event_print_trace(struct trace_iterator *iter,
> +						int flags,
> +						struct trace_event *event)
> +{
> +	/* Unsafe to try to decode user provided print_fmt, use hex */
> +	trace_print_hex_dump_seq(&iter->seq, "", DUMP_PREFIX_OFFSET, 16,
> +				 1, iter->ent, iter->ent_size, true);

You said this is "Unsafe to try to decode user provided" here, because
this doesn't check the event data sanity, especially non-fixed size data.

However, it is not enough that you don't decode it here. Because synthetic
events (histograms) and event filters need to decode this recorded data entry
using the event format information.

This means this can cause a buffer overrun issue on the ring buffer, because
__data_loc (and __rel_loc too) can be compromised by the user.

If you want to just trace the user events with digit parameters, there is
a way to close this issue - support only the fixed size types (IOW, drop
__data_loc/rel_loc support) and always checks the 'length' of the written
data size. This ensures that those filters/synthetic events can access
those parameters as 'values'. Maybe eprobes still has to reject the user
events but the other parts will work well.

If you want to log some "string", it is hard. Maybe it needs a special
check when writing the event (address, length, and null termination.),
but it will increase the recording overhead.

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
