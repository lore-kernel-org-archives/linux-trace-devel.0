Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:39578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752978AbdLMPrH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Dec 2017 10:47:07 -0500
Date: Wed, 13 Dec 2017 10:47:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vladislav Valtchev <vladislav.valtchev@gmail.com>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH v3 4/9] trace-cmd: Extract part of Makefile in
 utils.mk
Message-ID: <20171213104704.77a77f9c@gandalf.local.home>
In-Reply-To: <1513171955.2565.42.camel@gmail.com>
References: <20171212162534.31144-1-vladislav.valtchev@gmail.com>
        <20171212162534.31144-5-vladislav.valtchev@gmail.com>
        <20171212190037.53710fa2@gandalf.local.home>
        <1513171955.2565.42.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 13 Dec 2017 15:32:35 +0200
Vladislav Valtchev <vladislav.valtchev@gmail.com> wrote:

> On Tue, 2017-12-12 at 19:00 -0500, Steven Rostedt wrote:
> > 						\  
> > > diff --git a/utils.mk b/utils.mk  
> > 
> > I wonder if we should add a scripts/ directory here, to place the built
> > utilities in.
> >   
> 
> As you wish. Just 'scripts' seems to me more like a directory containing
> bash/perl/python scripts. Maybe something like make_utils/make_helpers?
> I don't know. I'm fine either way. Maybe we should create the directory
> in case we have more files to put in?
> 

I'm just following what we do in the Linux kernel. It has a directory
called "scripts" to help with the build process. As trace-cmd is very
tied to the Linux kernel, I want to keep as close to it as possible.
Hence, why we are doing all this crazy stuff with make and not any
other tool.

-- Steve
