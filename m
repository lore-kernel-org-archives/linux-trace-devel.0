Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729373AbeKTAhZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 19:37:25 -0500
Date: Mon, 19 Nov 2018 09:13:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent: Rename struct cmdline to struct
 tep_cmdline
Message-ID: <20181119091338.43665df1@gandalf.local.home>
In-Reply-To: <20181119125255.19155-1-tstoyanov@vmware.com>
References: <20181119125255.19155-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 19 Nov 2018 12:53:08 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> @@ -250,9 +250,9 @@ int tep_pid_is_registered(struct tep_handle *pevent, int pid)
>  static int add_new_comm(struct tep_handle *pevent,
>  			const char *comm, int pid, bool override)
>  {
> -	struct cmdline *cmdlines = pevent->cmdlines;
> -	struct cmdline *cmdline;
> -	struct cmdline key;
> +	struct tep_cmdline *cmdlines = pevent->cmdlines;
> +	struct tep_cmdline *cmdline;
> +	struct tep_cmdline key;
>  	char *new_comm;
>  

Hi Tzvetomir,

This part failed for me, and I'm curious to know why. The code I have,
has the variable cmdline as "const struct cmdline", but the patch does
not. Was this added to a different change?

Thanks!

-- Steve
