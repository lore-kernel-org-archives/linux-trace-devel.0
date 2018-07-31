Return-Path: <SRS0=gflo=KP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbeGaSuK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jul 2018 14:50:10 -0400
Date: Tue, 31 Jul 2018 13:08:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/6] kernel-shark-qt: Define Data collections
Message-ID: <20180731130853.6dbb15a3@gandalf.local.home>
In-Reply-To: <d626ba01-430b-7be7-d8aa-2582ebdcf906@gmail.com>
References: <20180711133814.26854-1-y.karadz@gmail.com>
        <20180711133814.26854-5-y.karadz@gmail.com>
        <20180712193316.537feb32@gandalf.local.home>
        <d626ba01-430b-7be7-d8aa-2582ebdcf906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 31 Jul 2018 16:50:47 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Steven,
> 
> On 13.07.2018 02:33, Steven Rostedt wrote:
> > On a styling point. I realized that reading the doxygen output I find
> > more difficult than kerneldoc. But then I realized it can be better if
> > we add spacing. By putting in a blank comment line after @brief, and
> > after the last @param, I think it is easier to read. For example:
> > 
> >   
> >> + * @brief Allocate and process data collection, defined with a given Matching
> >> + *	  condition function and value. Add this collection to the list of
> >> + *	  collections used by the session.  
> >    + *  
> >> + * @param kshark_ctx: Input location for the session context pointer.
> >> + * @param data: Input location for the trace data.
> >> + * @param n_rows: The size of the inputted data.
> >> + * @param cond: Matching condition function for the collection to be
> >> + *	        registered.
> >> + * @param val: Matching condition value of for collection to be registered.
> >> + * @param margin: The size of the additional (margin) data which do not
> >> + *		  satisfying the data condition, but is added at the beginning
> >> + *		  and at the end of each interval of the collection. If "0",
> >> + *		  no margin data is added.
> >> + *
> >> + * @returns Pointer to the registered Data collections on success, or NULL
> >> + *	    on failure.
> >> + */  
> > What do you think?  
> 
> 
> Do you mean that it makes it easy to read in the source file?
> I can make this change in a separate patch.
> 

Yes, thanks!

-- Steve
