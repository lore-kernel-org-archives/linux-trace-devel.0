Return-Path: <SRS0=5iTX=JO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:53224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933993AbeF1UlO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jun 2018 16:41:14 -0400
Date: Thu, 28 Jun 2018 16:41:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] kernel-shark-qt: Add API for loading trace.dat
 files
Message-ID: <20180628164111.772498cf@gandalf.local.home>
In-Reply-To: <20180628163235.3a2422f7@gandalf.local.home>
References: <20180628163012.21477-1-y.karadz@gmail.com>
        <20180628163012.21477-4-y.karadz@gmail.com>
        <20180628163235.3a2422f7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 28 Jun 2018 16:32:35 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> I understand the rational for having it above the prototype, because
> you would think that's where people may look if they don't have the
> source (just the headers). But realistically, people who use etags and
> such, when they want to see a function, the vim and emacs commands will
> bring the user to the C code and not the prototype. This is why Linux
> enforces the comments above the C code.

One more reason for having the comments above the code and not the
prototype (which I'm struggling with right now), is that when reviewing
a function, I have no idea what it's suppose to be doing. I need to
search the header to find the comments associated with it. Makes
reviewing much more time consuming.

-- Steve
