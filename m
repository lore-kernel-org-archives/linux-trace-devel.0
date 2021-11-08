Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBE1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 17:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 014AB6113D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 17:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238057AbhKHRQY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 12:16:24 -0500
Received: from linux.microsoft.com ([13.77.154.182]:37088 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbhKHRQY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 12:16:24 -0500
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id E118B20B417F;
        Mon,  8 Nov 2021 09:13:39 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E118B20B417F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636391620;
        bh=0YlRQO6T1q4juozmday3MwfnxwiUktPKoBtxc2ee7Iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gyb0HWxnX8Wkev9OMxBThNU2bQ7tOxo1dgN/sG3/keS56wMcn62CG+oY8mxzRgQ6u
         Tjc6g3KvipoVqJhGTCQjCjig8IUN9XabC5vnjjZWYS8nfTumuWXJfhkisq5Mk5a3J4
         tB0zF+Phh71kGdGFn8tLadXBzVq0kmQ+i2SEqJyI=
Date:   Mon, 8 Nov 2021 09:13:36 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211108171336.GA1690@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
 <20211104170433.2206-3-beaub@linux.microsoft.com>
 <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, Nov 07, 2021 at 11:31:15PM +0900, Masami Hiramatsu wrote:
> Hi Beau,
> 
> At first, thanks for breaking down your patch into this series!
> 
> Now I found that a suspicious security design issue in this patch.
> 
> On Thu,  4 Nov 2021 10:04:25 -0700
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > +
> > +static enum print_line_t user_event_print_trace(struct trace_iterator *iter,
> > +						int flags,
> > +						struct trace_event *event)
> > +{
> > +	/* Unsafe to try to decode user provided print_fmt, use hex */
> > +	trace_print_hex_dump_seq(&iter->seq, "", DUMP_PREFIX_OFFSET, 16,
> > +				 1, iter->ent, iter->ent_size, true);
> 
> You said this is "Unsafe to try to decode user provided" here, because
> this doesn't check the event data sanity, especially non-fixed size data.
> 
> However, it is not enough that you don't decode it here. Because synthetic
> events (histograms) and event filters need to decode this recorded data entry
> using the event format information.
> 
> This means this can cause a buffer overrun issue on the ring buffer, because
> __data_loc (and __rel_loc too) can be compromised by the user.
> 
> If you want to just trace the user events with digit parameters, there is
> a way to close this issue - support only the fixed size types (IOW, drop
> __data_loc/rel_loc support) and always checks the 'length' of the written
> data size. This ensures that those filters/synthetic events can access
> those parameters as 'values'. Maybe eprobes still has to reject the user
> events but the other parts will work well.
> 
> If you want to log some "string", it is hard. Maybe it needs a special
> check when writing the event (address, length, and null termination.),
> but it will increase the recording overhead.
> 
> Thank you,
> 
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>

Does that mean the decoders in eprobes/histogram don't check event
record sizes before accessing the data? Shouldn't that get fix
centrally? That would mean a loaded module could do the same thing
(user_events only works if the user has access to tracefs, so it's not
like it's open to all users).

Is it possible to mark trace_events with a flag that says "don't trust
this"? That way eBPF, ftrace and perf would still allow recording and
decoding offline (in a safer context).

From user_events code, an entry is always allocated with enough data and
if it fails (either too big or alloc failure) the event is not written
out. This appears to be purely in the decode logic that is not within
this patch?

Thanks,
-Beau
