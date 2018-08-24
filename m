Return-Path: <SRS0=lMx0=LH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbeHXSZC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Aug 2018 14:25:02 -0400
Date: Fri, 24 Aug 2018 10:50:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] kernel-shark-qt: Add C++ API for drawing of
 Graphs
Message-ID: <20180824105001.40064c74@gandalf.local.home>
In-Reply-To: <20180824142116.21339-4-y.karadz@gmail.com>
References: <20180824142116.21339-1-y.karadz@gmail.com>
        <20180824142116.21339-4-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 24 Aug 2018 17:21:15 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +	/*
> +	 * Check the content of the very firs bin and see if the CPU is

I haven't really looked too much at this patch yet, but this spelling
stood out. Seems your 't' key is not working well when typing "first
bin". There's several places that have that ;-)

-- Steve

> +	 * active.
> +	 */
> +	bin = 0;
> +	get_pid(bin);
> +	if (pidFront >= 0) {
> +		/*
> +		 * The CPU is active and this is a regular process.
> +		 * Set this bin.
> +		 */
> +		set_bin(bin);
> +	} else {
> +		/*
> +		 * No data from this CPU in the very firs bin. Use the Lower
> +		 * Overflow Bin to retrieve the Process Id (if any). First
> +		 * get the Pid back, ignoring the filters.
> +		 */
