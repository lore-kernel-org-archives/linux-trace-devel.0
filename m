Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727608AbeHAVGz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 17:06:55 -0400
Date: Wed, 1 Aug 2018 15:19:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 01/24] tools/lib/traceevent, tools/perf: Rename struct
 pevent
Message-ID: <20180801151938.0930401f@gandalf.local.home>
In-Reply-To: <20180801124156.20894-2-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
        <20180801124156.20894-2-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed,  1 Aug 2018 15:41:33 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to make libtraceevent into a proper library, variables, data
> structures and functions require a unique prefix to prevent name space
> conflicts. That prefix will be "tep_" and not "pevent_". This changes
> the struct pevent.

In the change log, you want to also say what you changed it to.

  This changes the struct pevent to struct tep_handle.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>
