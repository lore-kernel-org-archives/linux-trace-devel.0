Return-Path: <SRS0=m1Zh=MO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:43974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbeJCDzA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Oct 2018 23:55:00 -0400
Date: Tue, 2 Oct 2018 17:09:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [PATCH v2 2/5] kernel-shark-qt: Add kshark_convert_nano()
 function
Message-ID: <20181002170940.6261fd8a@gandalf.local.home>
In-Reply-To: <20181001135921.32379-3-ykaradzhov@vmware.com>
References: <20181001135921.32379-1-ykaradzhov@vmware.com>
        <20181001135921.32379-3-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  1 Oct 2018 16:59:18 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
> 
> kshark_convert_nano() is used to convert the original value of the
> timestamp of the trace records (having nanosecond precision) into two
> values representing the time in seconds and milliseconds.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/libkshark.c | 14 ++++++++++++++
>  kernel-shark-qt/src/libkshark.h |  2 ++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
> index a7983eb..e7ea007 100644
> --- a/kernel-shark-qt/src/libkshark.c
> +++ b/kernel-shark-qt/src/libkshark.c
> @@ -1073,6 +1073,20 @@ const char *kshark_get_info_easy(struct kshark_entry *entry)
>  	return info;
>  }
>  
> +/**
> + * @brief Convert the timestamp of the trace record (nanosecond precision) into
> + *	  seconds and microseconds.
> + *
> + * @param time: Input location for the timestamp.
> + * @param sec: Output location for the value of the seconds.
> + * @param usec: Output location for the value of the microseconds.
> + */
> +void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec)
> +{
> +	*sec = time / 1000000000ULL;
> +	*usec = (time / 1000) % 1000000;

BTW, just a little optimization, as '%' and '/' are very expensive
operations, you can remove one by this:

{
	uint64_t s;

	s = time / 1000000000ULL;
	*sec = s;
	*usec = (time - s * 1000000000ULL) / 1000;

As '-' and '*' are fast operations.

-- Steve

> +}
> +
>  /**
>   * @brief Dump into a string the content of one entry. The function allocates
>   *	  a null terminated string and returns a pointer to this string. The
> diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
> index f00a584..d24ed8c 100644
> --- a/kernel-shark-qt/src/libkshark.h
> +++ b/kernel-shark-qt/src/libkshark.h
> @@ -160,6 +160,8 @@ const char *kshark_get_event_name_easy(struct kshark_entry *entry);
>  
>  const char *kshark_get_info_easy(struct kshark_entry *entry);
>  
> +void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec);
> +
>  char* kshark_dump_entry(const struct kshark_entry *entry);
>  
>  struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
