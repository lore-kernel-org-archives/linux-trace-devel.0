Return-Path: <SRS0=h6hK=JU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43979 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932997AbeGDL7I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jul 2018 07:59:08 -0400
Received: by mail-ed1-f66.google.com with SMTP id u11-v6so3858286eds.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Jul 2018 04:59:08 -0700 (PDT)
Subject: Re: [PATCH 3/3] kernel-shark-qt: Add helper function to find the
 next_cpu in kshark_load_data_*()
To: Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20180703162432.480139641@goodmis.org>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <7fff27a8-f24e-ec79-a3a2-d7dfc09d99b7@gmail.com>
Date: Wed, 4 Jul 2018 14:59:05 +0300
MIME-Version: 1.0
In-Reply-To: <20180703162432.480139641@goodmis.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  3.07.2018 19:21, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> The two functions kshark_load_data_entries() and
> kshark_load_data_records() both do the same thing to find the next cpu to
> load. Add a helper function pick_next_cpu() for both of them to use to
> simplify the code.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   kernel-shark-qt/src/libkshark.c | 53 +++++++++++++++++----------------
>   1 file changed, 27 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
> index 680949077b7f..fe8aada75149 100644
> --- a/kernel-shark-qt/src/libkshark.c
> +++ b/kernel-shark-qt/src/libkshark.c
> @@ -566,6 +566,25 @@ static size_t get_records(struct kshark_context *kshark_ctx,
>   	return -ENOMEM;
>   }
>   


The consolidate the kshark load_data*() functions will be very useful, 
because we have to add at least one more function of this type. I mean 
the one used by the NumPy interface.

Please apply those patches.
Thanks!
Yordan


> +static int pick_next_cpu(struct rec_list **rec_list, int n_cpus)
> +{
> +	uint64_t ts = 0;
> +	int next_cpu = -1;
> +	int cpu;
> +
> +	for (cpu = 0; cpu < n_cpus; ++cpu) {
> +		if (!rec_list[cpu])
> +			continue;
> +
> +		if (!ts || rec_list[cpu]->rec->ts < ts) {
> +			ts = rec_list[cpu]->rec->ts;
> +			next_cpu = cpu;
> +		}
> +	}
> +
> +	return next_cpu;
> +}
> +
>   /**
>    * @brief Load the content of the trace data file into an array of
>    *	  kshark_entries. This function provides fast loading, however the
> @@ -593,9 +612,8 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
>   	struct rec_list **rec_list;
>   	struct rec_list *temp_rec;
>   	struct pevent_record *rec;
> -	int cpu, n_cpus, next_cpu;
>   	size_t count, total = 0;
> -	uint64_t ts;
> +	int n_cpus;
>   	int ret;
>   
>   	if (*data_rows)
> @@ -612,17 +630,9 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
>   	n_cpus = tracecmd_cpus(kshark_ctx->handle);
>   
>   	for (count = 0; count < total; count++) {
> -		ts = 0;
> -		next_cpu = -1;
> -		for (cpu = 0; cpu < n_cpus; ++cpu) {
> -			if (!rec_list[cpu])
> -				continue;
> -
> -			if (!ts || rec_list[cpu]->rec->ts < ts) {
> -				ts = rec_list[cpu]->rec->ts;
> -				next_cpu = cpu;
> -			}
> -		}
> +		int next_cpu;
> +
> +		next_cpu = pick_next_cpu(rec_list, n_cpus);
>   
>   		if (next_cpu >= 0) {
>   			entry = malloc(sizeof(struct kshark_entry));
> @@ -694,9 +704,8 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
>   	struct pevent_record *rec;
>   	struct rec_list **rec_list;
>   	struct rec_list *temp_rec;
> -	int cpu, n_cpus, next_cpu;
>   	size_t count, total = 0;
> -	uint64_t ts;
> +	int n_cpus;
>   	int pid;
>   
>   	total = get_records(kshark_ctx, &rec_list);
> @@ -710,17 +719,9 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
>   	n_cpus = tracecmd_cpus(kshark_ctx->handle);
>   
>   	for (count = 0; count < total; count++) {
> -		ts = 0;
> -		next_cpu = -1;
> -		for (cpu = 0; cpu < n_cpus; ++cpu) {
> -			if (!rec_list[cpu])
> -				continue;
> -
> -			if (!ts || rec_list[cpu]->rec->ts < ts) {
> -				ts = rec_list[cpu]->rec->ts;
> -				next_cpu = cpu;
> -			}
> -		}
> +		int next_cpu;
> +
> +		next_cpu = pick_next_cpu(rec_list, n_cpus);
>   
>   		if (next_cpu >= 0) {
>   			rec = rec_list[next_cpu]->rec;
> 
