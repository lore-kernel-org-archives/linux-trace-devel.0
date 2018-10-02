Return-Path: <SRS0=m1Zh=MO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbeJCD3e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Oct 2018 23:29:34 -0400
Date: Tue, 2 Oct 2018 16:44:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [PATCH v2 1/5] kernel-shark-qt: Add kshark_get_X_easy()
 functions.
Message-ID: <20181002164420.37d75e18@gandalf.local.home>
In-Reply-To: <20181001135921.32379-2-ykaradzhov@vmware.com>
References: <20181001135921.32379-1-ykaradzhov@vmware.com>
        <20181001135921.32379-2-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  1 Oct 2018 16:59:17 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
> 
> The kshark_get_X_easy() functions allow for an easy access to the
> tep_record's fields. Using these functions can be inefficient if you
> need access to more than one of the fields of the record.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/libkshark.c | 185 ++++++++++++++++++++++++++++++++
>  kernel-shark-qt/src/libkshark.h |  12 +++
>  2 files changed, 197 insertions(+)
> 
> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
> index 506511d..a7983eb 100644
> --- a/kernel-shark-qt/src/libkshark.c
> +++ b/kernel-shark-qt/src/libkshark.c
> @@ -888,6 +888,191 @@ static const char *kshark_get_info(struct tep_handle *pe,
>  	return seq.buffer;
>  }
>  
> +/**
> + * @brief This function allows for an easy access to the original value of the
> + *	  Process Id as recorded in the tep_record object. The record is read
> + *	  from the file only in the case of an entry being touched by a plugin.
> + *	  Be aware that using the kshark_get_X_easy functions can be
> + *	  inefficient if you need an access to more than one of the data fields
> + *	  of the record.
> + *
> + * @param entry: Input location for the KernelShark entry.
> + *
> + * @returns The original value of the Process Id as recorded in the
> + *	    tep_record object on success, otherwise negative error code.
> + */
> +int kshark_get_pid_easy(struct kshark_entry *entry)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct tep_record *data;
> +	int pid;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return -EFAULT;

Perhaps this should return -ENODEV;

> +
> +	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {

What's the "UNTOUCHED_MASK" mean?

> +		pid = entry->pid;
> +	} else {
> +		data = kshark_read_at(kshark_ctx, entry->offset);
> +		pid = tep_data_pid(kshark_ctx->pevent, data);
> +		free_record(data);

Would it be possible to do:

		entry->visible |= KS_PLUGIN_UNTOUCHED_MASK;
		entry->pid = pid;

?

Of course this depends on what that mask means.

> +	}
> +
> +	return pid;
> +}
> +
> +/**
> + * @brief This function allows for an easy access to the original value of the
> + *	  Task name as recorded in the tep_record object. The record is read
> + *	  from the file only in the case of an entry being touched by a plugin.
> + *	  Be aware that using the kshark_get_X_easy functions can be
> + *	  inefficient if you need an access to more than one of the data fields
> + *	  of the record.
> + *
> + * @param entry: Input location for the KernelShark entry.
> + *
> + * @returns The original name of the task, retrieved from the Process Id
> + *	    recorded in the tep_record object on success, otherwise NULL.
> + */
> +const char *kshark_get_task_easy(struct kshark_entry *entry)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	int pid = kshark_get_pid_easy(entry);
> +
> +	if (pid < 0 || !kshark_instance(&kshark_ctx))

The second part is redundant, as kshark_get_pid_easy() will return 
pid < 0 if that was true.

> +		return NULL;
> +
> +	return tep_data_comm_from_pid(kshark_ctx->pevent, pid);
> +}
> +
> +/**
> + * @brief This function allows for an easy access to the latency information
> + *	  recorded in the tep_record object. The record is read from the file
> + *	  using the offset field of kshark_entry. Be aware that using the
> + *	  kshark_get_X_easy functions can be inefficient if you need an access
> + *	  to more than one of the data fields of the record.
> + *
> + * @param entry: Input location for the KernelShark entry.
> + *
> + * @returns On success the function returns a string showing the latency
> + *	    information, coded into 5 fields:
> + *	    interrupts disabled, need rescheduling, hard/soft interrupt,
> + *	    preempt count and lock depth. On failure it returns NULL.
> + */
> +const char *kshark_get_latency_easy(struct kshark_entry *entry)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct tep_record *data;
> +	const char *lat;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return NULL;
> +
> +	data = kshark_read_at(kshark_ctx, entry->offset);
> +	lat = kshark_get_latency(kshark_ctx->pevent, data);
> +	free_record(data);
> +
> +	return lat;
> +}
> +
> +/**
> + * @brief This function allows for an easy access to the original value of the
> + *	  Event Id as recorded in the tep_record object. The record is read
> + *	  from the file only in the case of an entry being touched by a plugin.
> + *	  Be aware that using the kshark_get_X_easy functions can be
> + *	  inefficient if you need an access to more than one of the data fields
> + *	  of the record.
> + *
> + * @param entry: Input location for the KernelShark entry.
> + *
> + * @returns The original value of the Event Id as recorded in the
> + *	    tep_record object on success, otherwise negative error code.
> + */
> +int kshark_get_event_id_easy(struct kshark_entry *entry)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct tep_record *data;
> +	int event_id;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return -EFAULT;
> +
> +	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
> +		event_id = entry->event_id;
> +	} else {
> +		data = kshark_read_at(kshark_ctx, entry->offset);
> +		event_id = tep_data_type(kshark_ctx->pevent, data);
> +		free_record(data);

If the above can update "easy" untouch flag, then this too.

> +	}
> +
> +	return event_id;
> +}
> +
> +/**
> + * @brief This function allows for an easy access to the original name of the
> + * 	  trace event as recorded in the tep_record object. The record is read
> + *	  from the file only in the case of an entry being touched by a plugin.
> + *	  Be aware that using the kshark_get_X_easy functions can be
> + *	  inefficient if you need an access to more than one of the data fields
> + *	  of the record.
> + *
> + * @param entry: Input location for the KernelShark entry.
> + *
> + * @returns The mane of the trace event recorded in the tep_record object on
> + * 	    success, otherwise "[UNKNOWN EVENT]" or NULL.
> + */
> +const char *kshark_get_event_name_easy(struct kshark_entry *entry)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct event_format *event;
> +
> +	int event_id = kshark_get_event_id_easy(entry);
> +
> +	if (event_id < 0 || !kshark_instance(&kshark_ctx))

Again this is redundant.

-- Steve

> +		return NULL;
> +
> +	event = tep_data_event_from_type(kshark_ctx->pevent, event_id);
> +	if (event)
> +		return event->name;
> +
> +	return "[UNKNOWN EVENT]";
> +}
> +
> +/**
> + * @brief This function allows for an easy access to the tep_record's info
> + *	  streang. The record is read from the file using the offset field of
> + *	  kshark_entry. Be aware that using the kshark_get_X_easy functions can
> + *	  be inefficient if you need an access to more than one of the data
> + *	  fields of the record.
> + *
> + * @param entry: Input location for the KernelShark entry.
> + *
> + * @returns A string showing the data output of the trace event on success,
> + *	    otherwise NULL.
> + */
> +const char *kshark_get_info_easy(struct kshark_entry *entry)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct event_format *event;
> +	struct tep_record *data;
> +	const char *info = NULL;
> +	int event_id;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return NULL;
> +
> +	data = kshark_read_at(kshark_ctx, entry->offset);
> +
> +	event_id = tep_data_type(kshark_ctx->pevent, data);
> +	event = tep_data_event_from_type(kshark_ctx->pevent, event_id);
> +	if (event)
> +		info = kshark_get_info(kshark_ctx->pevent, data, event);
> +
> +	free_record(data);
> +
> +	return info;
> +}
> +
>  /**
>   * @brief Dump into a string the content of one entry. The function allocates
>   *	  a null terminated string and returns a pointer to this string. The
> diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
> index e846c85..f00a584 100644
> --- a/kernel-shark-qt/src/libkshark.h
> +++ b/kernel-shark-qt/src/libkshark.h
> @@ -148,6 +148,18 @@ void kshark_close(struct kshark_context *kshark_ctx);
>  
>  void kshark_free(struct kshark_context *kshark_ctx);
>  
> +int kshark_get_pid_easy(struct kshark_entry *entry);
> +
> +const char *kshark_get_task_easy(struct kshark_entry *entry);
> +
> +const char *kshark_get_latency_easy(struct kshark_entry *entry);
> +
> +int kshark_get_event_id_easy(struct kshark_entry *entry);
> +
> +const char *kshark_get_event_name_easy(struct kshark_entry *entry);
> +
> +const char *kshark_get_info_easy(struct kshark_entry *entry);
> +
>  char* kshark_dump_entry(const struct kshark_entry *entry);
>  
>  struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
