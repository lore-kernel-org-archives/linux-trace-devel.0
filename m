Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEEFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 17:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5D086135E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 17:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhKKRg3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 12:36:29 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53086 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbhKKRg2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 12:36:28 -0500
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 01EE720C359F;
        Thu, 11 Nov 2021 09:33:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 01EE720C359F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636652019;
        bh=7U99bjDYm24pDBGfnRysUQ1K18qet1ytsQFDtTd8BeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nF3GMnpb+5a/Dqcg0yrBiAhB6vNWYbbGkUCVo1OYXBi8nn8ZrW4wWytycxp7Vx2Pb
         dmU2HjJHsmubbKjPseShSroDjZTjU0WrAVEeuF/9X5tZwQQMOshXYHyjYCDgLt9ICp
         Rpux1aE8DGA7y92LKceN9Xc08rU8WcgArp8rQEvk=
Date:   Thu, 11 Nov 2021 09:33:34 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211111173334.GA1433@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
 <20211104170433.2206-3-beaub@linux.microsoft.com>
 <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
 <20211108171336.GA1690@kbox>
 <20211108131639.33a4f186@gandalf.local.home>
 <20211108202527.GA1862@kbox>
 <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
 <20211109190844.GA1529@kbox>
 <20211110225630.babcd70ec85f97e369b0e446@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110225630.babcd70ec85f97e369b0e446@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Nov 10, 2021 at 10:56:30PM +0900, Masami Hiramatsu wrote:
> On Tue, 9 Nov 2021 11:08:44 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:

> I would like to keep verifying in writer side then we can ensure the
> data on ring buffer (of perf and of ftrace) is sane. If you add the unsafe
> flag, you have to change all the code which access the ring buffer, not only
> the filter but also eprobes, histograms, perf-tools, and other user-space
> tracing tools which reads the tracing buffer directly.
> 
> > It sounded like Steven wanted to think about this a bit, so I'll wait a
> > bit before poking again for consensus :)
> > 
> > Do you have any strong feelings about where it goes?
> 
> I recommend you to start verifying the writer side, it should make the
> change as small as possible. Unsafe flag idea may involve many other
> tools. And it is not fundamentary required for user-events.
> 
> Thank you,
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>

Ok, I will start there.

Are static string buffers required as well for the null check?

Or is this only for dyn strings that require the check?

Also, I am assuming that __rel_loc offset is based after the __rel_loc
payload, IE: Offset 0 of __rel_loc is immediately after the 4 byte
__rel_loc description?

Thanks,
-Beau
