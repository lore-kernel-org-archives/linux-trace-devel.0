Return-Path: <SRS0=uqUN=NT=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729589AbeKIIBI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 03:01:08 -0500
Date: Thu, 8 Nov 2018 17:23:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: tep_*host_bigendian()
Message-ID: <20181108172330.2182459e@gandalf.local.home>
In-Reply-To: <CACqStodfPXL6vP5Raj4dUOA3AytSN2r-k1QO90Ug8ANDo_EAmg@mail.gmail.com>
References: <20181108133053.6eb22596@gandalf.local.home>
        <CACqStodfPXL6vP5Raj4dUOA3AytSN2r-k1QO90Ug8ANDo_EAmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 8 Nov 2018 19:40:32 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Hi Steven,
> Ok, I''ll rename tep_is_file_bigendian() to tep_file_bigendian().
> But about tep_is_host_bigendian() - I think it makes sense to remove completely
> tep_is_host_bigendian() / tep_set_host_bigendian() APIs, what do you think ?
> The tep_set_host_bigendian() API is used only in perf code, to set the
> order in tep handler - and it uses tep_host_bigendian() to get the
> local host byte order.
> I think it is safe to the remove tep_set_host_bigendian() API and
> replace tep_is_host_bigendian() with tep_host_bigendian().

I'm fine with this, as long as we don't calculate the endianess each
time. We still need the tep->host_bigendian setting. But we can set it
when we allocate a tep handle.

-- Steve

> 
> On Thu, Nov 8, 2018 at 8:30 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Hi Tzvetomir,
> >
> > I was looking at the code for tep_is_file_bigendian(),
> > tep_is_host_bigendian() and tep_host_bigendian().
> >
> > The tep_host_bigendian() checks if the current machine that is
> > executing is bigendian or not.
> >
> > tep_is_host_bigendian() looks at the pevent to see what it has, which
> > should be the same as tep_host_bigendian().
> >
> > tep_is_file_bigendian() is if the raw file format is bigendian or not.
> > If the file does not mach the host, byte swapping needs to be made.
> >
> > Looking at this deeper, I think the names are backwards.
> >
> > Let's rename tep_host_bigendian() to tep_is_host_bigendian()
> >       rename tep_is_host_bigendian() to tep_host_bigendian()
> >       rename tep_is_file_bigendian() to tep_file_bigendian()
> >
> >
> > The "is_host" to me sounds more like we are testing the actual host,
> > where as just saying 'tep_host_bigendian' sounds to me that it's what
> > the pevent has the host set as.
> >
> > -- Steve  
> 
> 
> 
