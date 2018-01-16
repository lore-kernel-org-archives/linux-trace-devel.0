Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f53.google.com ([74.125.82.53]:45037 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbeAPStZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 13:49:25 -0500
Message-ID: <1516128562.4042.12.camel@gmail.com>
Subject: Re: [PATCH v2 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
From: Vladislav Valtchev <vladislav.valtchev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Jan 2018 20:49:22 +0200
In-Reply-To: <20180116112710.283b90f4@gandalf.local.home>
References: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
         <20171221152520.25867-2-vladislav.valtchev@gmail.com>
         <20180112101323.547a026e@gandalf.local.home>
         <1516114053.12026.20.camel@gmail.com>
         <20180116112710.283b90f4@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 2018-01-16 at 11:27 -0500, Steven Rostedt wrote:
> 
> 
> :-)  That was totally lost in translation. :-)
> 
> No, I didn't mean to have a comment literally saying "why would strtol
> return zero and this not be an error", I meant for the comment to
> explain it.
> 
> Actually, looking at the man page which states:
> 

Yep, I got it.
Sometimes I interpret words too literally. My fault :-)


> I say we simply remove the comment. Or say what the man page example
> says:
> 
> 	/* Check for various possible errors */
> 
> and leave it at that.

Sure, "Check for various possible errors" sounds good to me.

> 
> Sure it could be negative. The point was, you don't want it to be if
> you do:
> 
> 	buf[0] = new_status + '0';
> 
> As that will break if new_status is negative or greater than 9.
> 
> Also, whether you use unsigned, or do the above, they both have the
> same result. A negative produces a warning. Which is fine. As long as
> it doesn't kill the program. It's only an implementation detail.
> 
> That is, using unsigned char as new_status, and checking
> 
> 	if (new_status > 9)
> 
> Is no different than using int and checking
> 
> 	if (new_status < 0 || new_status > 9)
> 
> except that you use more instructions to accomplish the same thing.
> 

Sure, using two checks with 'int' is less efficient then using the 'unsigned trick',
but my point is that such a function (at interface level) should accept exactly
the same type 'returned' (via OUT param) by read_proc(). It should be symmetric,
as if instead of 'int/unsigned' we used an opaque type 'value_t' for which we cannot
make assumptions. Clearly, the implementation may in practice accept a subset of the values
allowed by the parameter type. 

What about accepting 'int' but doing the check this way:

	if ((unsigned)new_status > 9) {
		warning(...);
		return;
	}

This way, we'll keep the interface symmetric (with read_proc()) but, at the same time,
we use a more efficient check.



-- 
Vladislav Valtchev
VMware Open Source Technology Center
