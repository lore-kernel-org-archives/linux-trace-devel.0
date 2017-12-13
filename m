Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:40734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751916AbdLMPta (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Dec 2017 10:49:30 -0500
Date: Wed, 13 Dec 2017 10:49:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vladislav Valtchev <vladislav.valtchev@gmail.com>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH v3 5/9] trace-cmd: Move libparsevent *.c files in
 lib/pevent
Message-ID: <20171213104928.17c0f34c@gandalf.local.home>
In-Reply-To: <1513166659.2565.37.camel@gmail.com>
References: <20171212162534.31144-1-vladislav.valtchev@gmail.com>
        <20171212162534.31144-6-vladislav.valtchev@gmail.com>
        <20171212192116.5e99d9aa@gandalf.local.home>
        <1513166659.2565.37.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 13 Dec 2017 14:04:19 +0200
Vladislav Valtchev <vladislav.valtchev@gmail.com> wrote:

> > > +
> > > +DEFAULT_TARGET = libparsevent.a
> > > +
> > > +OBJS =  
> > 
> > Is the above really necessary?  
> 
> DEFAULT_TARGET is just a label, I can remove it.

I didn't mean the DEFAULT_TARGET when I said "the above", I was just
referring to OBJS, which I now see that could be somewhat ambiguous in
what I meant.

> While OBJS = is a "coding style" thing in order to have all the
> objects added with +=, one per line.

I like the "+=" but do we really need to initialize it to nothing
first? Doesn't make work if you just simply remove the "OBJS =" blank
line, and a "OBJS += blah" will make OBJS equal to "blah" if OBJS
doesn't exist yet.

-- Steve

> 
> How would you like the objects to be listed?
