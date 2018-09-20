Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbeITTcI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 15:32:08 -0400
Date: Thu, 20 Sep 2018 09:48:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 2/7] kernel-shark-qt: Add Plugin event handlers to
 session.
Message-ID: <20180920094832.7e3a0cfb@gandalf.local.home>
In-Reply-To: <e79dde81-68a4-4310-348d-a7da677a5d4d@gmail.com>
References: <20180919143657.19472-1-y.karadz@gmail.com>
        <20180919143657.19472-3-y.karadz@gmail.com>
        <20180919232432.52be5d1b@vmware.local.home>
        <e79dde81-68a4-4310-348d-a7da677a5d4d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 20 Sep 2018 16:26:11 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 20.09.2018 06:24, Steven Rostedt wrote:
> >>   	/** Special mask used whene filtering events. */
> >>   	KS_EVENT_VIEW_FILTER_MASK	= 1 << 2,
> >> +
> >> +	/**
> >> +	 * Use this mask to check if the content of the entry has been accessed
> >> +	 * by a plugin-defined function.
> >> +	 */
> >> +	KS_PLUGIN_UNTOUCHED_MASK	= 1 << 7  
> > Why the jump to 7?  
> 
> The "visible" field of the entry will use 8 bits. I know that it is 
> uint16_t now, but my plan is to use 8 of its bits for the stream_id field.
> 
> Currently we use the first 3 bits as different visibility flags and we 
> have 4 unused bits available for adding more visibility flags in the 
> future. Because the PLUGIN_UNTOUCHED flag has a different meaning I 
> decided to place it at the very end.
> 
> Is this a problem?

No, it just seems out of place. Can you add a comment after the
VIEW_FILTER_MASK stating that the next 4 bits are reserved for more
VIEW bits.

-- Steve
