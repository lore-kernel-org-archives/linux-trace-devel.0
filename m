Return-Path: <SRS0=5iTX=JO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:60648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966732AbeF1V5W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jun 2018 17:57:22 -0400
Date: Thu, 28 Jun 2018 17:57:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] kernel-shark-qt: Add API for loading trace.dat
 files
Message-ID: <20180628175720.0112ed4a@gandalf.local.home>
In-Reply-To: <20180628163012.21477-4-y.karadz@gmail.com>
References: <20180628163012.21477-1-y.karadz@gmail.com>
        <20180628163012.21477-4-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 28 Jun 2018 19:30:06 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +size_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
> +				struct kshark_entry ***data_rows)
> +{
> +	int n_cpus = tracecmd_cpus(kshark_ctx->handle);
> +	int cpu, next_cpu;
> +	size_t count, total = 0;
> +	uint64_t ts;
> +	

Git warned me that the above has whitespace (tab) at end of line.

> +	struct pevent_record *rec;
> +	struct kshark_entry *entry, **next;
> +	struct kshark_entry **cpu_list, **rows;
> +	struct kshark_task_list *task;

[..]

> +char* kshark_dump_entry(struct kshark_entry *entry)
> +{
> +	struct pevent_record *data;
> +	struct event_format *event;
> +
> +	const char *event_name, *task, *lat, *info;
> +	char *tmp_str, *entry_str;
> +	int event_id, size = 0;
> +	

And here too.

-- Steve

> +	struct kshark_context *kshark_ctx = NULL;
> +	kshark_instance(&kshark_ctx);
> +
> +	if (!seq.buffer)
> +		trace_seq_init(&seq);
> +
> +	if (!seq.buffer)
> +		return NULL;
> +
