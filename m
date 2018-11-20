Return-Path: <SRS0=VnmA=N7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:56968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730148AbeKTOVK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Nov 2018 09:21:10 -0500
Date: Mon, 19 Nov 2018 22:54:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] tools/lib/traceevent: Implemented new API
 tep_ref_get()
Message-ID: <20181119225404.6a10fe56@vmware.local.home>
In-Reply-To: <20180928071940.29810-2-tstoyanov@vmware.com>
References: <20180928071940.29810-1-tstoyanov@vmware.com>
        <20180928071940.29810-2-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 28 Sep 2018 10:19:38 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch implements new API of the tracevent library:
> int tep_ref_get(struct tep_handle *pevent);
> The API returns the reference counter "ref_count" of the tep handler.
> As "struct tep_handle" is internal only, its members cannot be accessed
> by the library users, the API is used to get the reference counter.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/event-parse.c | 7 +++++++
>  tools/lib/traceevent/event-parse.h | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index f327c990dedc..aa26d0e7c074 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -6774,6 +6774,13 @@ void tep_ref(struct tep_handle *pevent)
>  	pevent->ref_count++;
>  }
>  
> +int tep_ref_get(struct tep_handle *pevent)

Hmm, I'm thinking we should call this "tep_get_ref" as that fits more
the naming convention of the Linux kernel.

-- Steve


> +{
> +	if (pevent)
> +		return pevent->ref_count;
> +	return 0;
> +}
> +
>  void tep_free_format_field(struct tep_format_field *field)
>  {
>  	free(field->type);
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 100b0b7b29fc..cda21a67160e 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -577,6 +577,7 @@ struct tep_handle *tep_alloc(void);
>  void tep_free(struct tep_handle *pevent);
>  void tep_ref(struct tep_handle *pevent);
>  void tep_unref(struct tep_handle *pevent);
> +int tep_ref_get(struct tep_handle *pevent);
>  
>  /* access to the internal parser */
>  void tep_buffer_init(const char *buf, unsigned long long size);
