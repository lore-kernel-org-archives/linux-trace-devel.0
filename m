Return-Path: <SRS0=QeEN=K7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389738AbeHPSHS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Aug 2018 14:07:18 -0400
Date: Thu, 16 Aug 2018 11:08:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tools lib traceevent: Change to SPDX License format
Message-ID: <20180816110813.3556e7c0@gandalf.local.home>
In-Reply-To: <20180816110517.6f3e6b3e@gandalf.local.home>
References: <20180816110517.6f3e6b3e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 16 Aug 2018 11:05:17 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> [ Tzvetomir, I'm going to add this patch to my repo, you can build on
>   top of it. (for the trace-cmd to upstream code) ]
> 
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Replaced COPYING with a description of how the SPDX identifiers are used.
> Added a GPL-2.0 and LGPL-2.1 license file in the new LICENSES directory.
> Then removed all the license templates from the source files and replaced
> them with the corresponding SPDX identifier.

Actually, I changed the change log to this:

    Replace the GPL text with SPDX tags in the tools/lib/traceevent files.

-- Steve

> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>
