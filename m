Return-Path: <SRS0=dEKL=OV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727808AbeLLRs0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Dec 2018 12:48:26 -0500
Date: Wed, 12 Dec 2018 12:48:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 05/46] tools/lib/traceevent: libtraceevent man pages
 for tep_handler related APIs
Message-ID: <20181212124823.7e657f6c@gandalf.local.home>
In-Reply-To: <20181127154153.11315-6-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
        <20181127154153.11315-6-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 27 Nov 2018 15:42:12 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch adds 4 new man pages for:
> tep_register_comm,tep_pid_is_registered,tep_data_comm_from_pid,
> tep_data_pid_from_comm,tep_cmdline_pid,tep_alloc,tep_free,tep_get_long_size,
> tep_set_long_size,tep_set_flag, as part of the libtraceevent APIs.

FYI,

I'm finding lots of whitespace errors in your patches. Please run
check-patch on new patches. Also, perhaps looking at the output of
"git show" will display in red (it does for me) where the whitespace
errors are.

I'll handle it for this series, but it is very time consuming for a
maintainer to fix these, and most will just reject the patches because
of it.

-- Steve


> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../Documentation/libtraceevent-commands.txt  | 130 ++++++++++++++++++
>  .../Documentation/libtraceevent-handle.txt    | 101 ++++++++++++++
>  .../Documentation/libtraceevent-long_size.txt |  78 +++++++++++
>  .../Documentation/libtraceevent-set_flag.txt  |  90 ++++++++++++
>  4 files changed, 399 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-commands.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-handle.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-commands.txt b/tools/lib/traceevent/Documentation/libtraceevent-commands.txt
> new file mode 100644
> index 000000000000..e8d226f6c072
> --- /dev/null
