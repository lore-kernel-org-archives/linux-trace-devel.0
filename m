Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:53348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbeJFCU7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 22:20:59 -0400
Date: Fri, 5 Oct 2018 15:20:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [PATCH v3 1/5] kernel-shark-qt: Add kshark_get_X_easy()
 functions.
Message-ID: <20181005152050.06c347af@gandalf.local.home>
In-Reply-To: <20181005183241.27026-2-ykaradzhov@vmware.com>
References: <20181005183241.27026-1-ykaradzhov@vmware.com>
        <20181005183241.27026-2-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 5 Oct 2018 18:33:20 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> +/**
> + * @brief This function allows for an easy access to the original name of the
> + *	  trace event as recorded in the tep_record object. The record is read
> + *	  from the file only in the case of an entry being touched by a plugin.
> + *	  Be aware that using the kshark_get_X_easy functions can be
> + *	  inefficient if you need an access to more than one of the data fields
> + *	  of the record.
> + *
> + * @param entry: Input location for the KernelShark entry.
> + *
> + * @returns The mane of the trace event recorded in the tep_record object on
> + *	    success, otherwise "[UNKNOWN EVENT]" or NULL.
> + */
> +const char *kshark_get_event_name_easy(struct kshark_entry *entry)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct event_format *event;

I had to fix this up as it is now called tep_event_format.

I applied this series and pushed it out. You may want to rebase and do a
make clean on your repo.

Thanks!

-- Steve

> +
> +	int event_id = kshark_get_event_id_easy(entry);
> +
> +	if (event_id < 0)
> +		return NULL;
> +
> +	kshark_instance(&kshark_ctx);
> +	event = tep_data_event_from_type(kshark_ctx->pevent, event_id);
> +	if (event)
> +		return event->name;
> +
> +	return "[UNKNOWN EVENT]";
> +}
> +
