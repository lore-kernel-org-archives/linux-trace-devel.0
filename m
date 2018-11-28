Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:45438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbeK2HEo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Nov 2018 02:04:44 -0500
Date: Wed, 28 Nov 2018 15:01:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 01/15] tools/lib/traceevent: Implemented new API
 tep_get_ref()
Message-ID: <20181128150154.219fc32a@gandalf.local.home>
In-Reply-To: <20181128090711.17792-2-tstoyanov@vmware.com>
References: <20181128090711.17792-1-tstoyanov@vmware.com>
        <20181128090711.17792-2-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 28 Nov 2018 09:07:29 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch implements new API of the tracevent library:
> int tep_get_ref(struct tep_handle *pevent);
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
> index f327c990dedc..c0dd72141a44 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -6774,6 +6774,13 @@ void tep_ref(struct tep_handle *pevent)
>  	pevent->ref_count++;
>  }
>  
> +int tep_get_ref(struct tep_handle *pevent)

New functions should use "tep" instead of "pevent". We need to start
removing that name.

I'll just change this patch directly so that you don't need to send a
v4. But for future patches, lets avoid pevent. And when we start
touching functions that use it, we should rename it.

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
> index cacd0b9f4807..9af316862ed4 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -583,6 +583,7 @@ struct tep_handle *tep_alloc(void);
>  void tep_free(struct tep_handle *pevent);
>  void tep_ref(struct tep_handle *pevent);
>  void tep_unref(struct tep_handle *pevent);
> +int tep_get_ref(struct tep_handle *pevent);
>  
>  /* access to the internal parser */
>  void tep_buffer_init(const char *buf, unsigned long long size);
