Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:32956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751760AbeAPTef (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 14:34:35 -0500
Date: Tue, 16 Jan 2018 14:34:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vladislav Valtchev <vladislav.valtchev@gmail.com>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
Message-ID: <20180116143432.5b7d9219@gandalf.local.home>
In-Reply-To: <1516128562.4042.12.camel@gmail.com>
References: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
        <20171221152520.25867-2-vladislav.valtchev@gmail.com>
        <20180112101323.547a026e@gandalf.local.home>
        <1516114053.12026.20.camel@gmail.com>
        <20180116112710.283b90f4@gandalf.local.home>
        <1516128562.4042.12.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 16 Jan 2018 20:49:22 +0200
Vladislav Valtchev <vladislav.valtchev@gmail.com> wrote:


> Sure, using two checks with 'int' is less efficient then using the 'unsigned trick',
> but my point is that such a function (at interface level) should accept exactly
> the same type 'returned' (via OUT param) by read_proc(). It should be symmetric,
> as if instead of 'int/unsigned' we used an opaque type 'value_t' for which we cannot
> make assumptions. Clearly, the implementation may in practice accept a subset of the values
> allowed by the parameter type. 
> 
> What about accepting 'int' but doing the check this way:
> 
> 	if ((unsigned)new_status > 9) {
> 		warning(...);
> 		return;
> 	}
> 
> This way, we'll keep the interface symmetric (with read_proc()) but, at the same time,
> we use a more efficient check.

The thing is, since we only accept new_status to be 0-9, it can never
be negative. Thus we should make it unsigned. Yes read_proc() is
signed, but that's because it can be negative.

We are keeping the variables the same as the values they represent,
nothing more. One variable shouldn't affect what the other variable is,
as the ranges are indeed different.

-- Steve
