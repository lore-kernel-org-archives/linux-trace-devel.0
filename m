Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:54880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727200AbeJTBKX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 21:10:23 -0400
Date: Fri, 19 Oct 2018 13:03:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Issue with making of doxygen files
Message-ID: <20181019130324.495a6dd9@gandalf.local.home>
In-Reply-To: <95c1af05-2cce-ddbe-2ac6-3bcc9559b6d3@gmail.com>
References: <20181019114029.6ec42a95@gandalf.local.home>
        <002df723-e710-ade0-3156-eac106aaf4f5@gmail.com>
        <20181019124045.2ad35fa4@gandalf.local.home>
        <95c1af05-2cce-ddbe-2ac6-3bcc9559b6d3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 19 Oct 2018 19:45:38 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Yes, this can be automated.
> 
> Please make a patch which adds this temporary fix and go ahead.
> I will add the Cmake check in another patch.

The warning is only an issue when doing:

 cmake -D_DOXYGEN_DOC=1

before doing a make, and it doesn't break anything (the html is still
built).

I'll just wait for your patch, it's fine to currently keep that
warning. In other words, I'm not going to force the NO. I just wanted
you to know that there was a warning.

-- Steve
