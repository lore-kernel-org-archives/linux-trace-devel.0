Return-Path: <SRS0=efs/=J4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:47734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbeGLNnI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Jul 2018 09:43:08 -0400
Date: Thu, 12 Jul 2018 09:33:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/6] kernel-shark-qt: Add generic instruments for
 searching inside the trace data
Message-ID: <20180712093331.3ce9b089@gandalf.local.home>
In-Reply-To: <834b37c8-103a-b17f-b6a6-e5ac563e5a1a@gmail.com>
References: <20180711133814.26854-1-y.karadz@gmail.com>
        <20180711133814.26854-2-y.karadz@gmail.com>
        <20180711124147.2bbf5b02@gandalf.local.home>
        <834b37c8-103a-b17f-b6a6-e5ac563e5a1a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 12 Jul 2018 15:49:33 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 11.07.2018 19:41, Steven Rostedt wrote:
> >> +/**
> >> + * @brief Simple Pid matching function to be user for data requests.
> >> + * @param kshark_ctx: Input location for the session context pointer.
> >> + * @param e: kshark_entry to be checked.
> >> + * @param pid: Matching condition value.
> >> + * @returns True if the Pid of the entry matches the value of "pid".
> >> + *	    Else false.  
> > Is this going to be extended in the future? Why the kshark_ctx?
> >   
> 
> Yes, this is something we need to discuss.
> 
> in the header we have
> 
> /** Matching condition function type. To be user for data requests */
> typedef bool (matching_condition_func)(struct kshark_context*,
> 				       struct kshark_entry*,
> 				       int);
> 
> I wanted the type of the abstract condition function to be such that it 
> can accommodate complicated logic in the future.
> What do you think?
> 

Makes sense. I just didn't realize that the kshark_check_pid is one of
the matching functions. Hmm, perhaps we should rename it to:

 kshark_match_pid() ?

-- Steve
