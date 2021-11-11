Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892D1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60B3F6112E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhKKP23 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhKKP23 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:28:29 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2012D6112E;
        Thu, 11 Nov 2021 15:25:40 +0000 (UTC)
Date:   Thu, 11 Nov 2021 10:25:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: A new API for trace page size
Message-ID: <20211111102538.00f56c47@gandalf.local.home>
In-Reply-To: <20211001062338.2389024-1-tz.stoyanov@gmail.com>
References: <20211001062338.2389024-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  1 Oct 2021 09:23:38 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Currently, the size of a trace buffer page is equal to the system memory
> page size. This may change in the future, so this assumption may not be
> valid. The proper way to determine the trace buffer page size is by
> using the information from "events/header_page" ftrace file:
>  ...
>  field: char data;	offset:16;	size:4080;	signed:1;
> The trace buffer page size is the size of the "data" filed + its offset.
> 
> A new libtraceevent API is introduced, for getting the trace buffer page
> size using that formula:
>  tep_get_trace_page_size()
> 
> Note, that some old kernels may not have "events/header_page" file. For
> those, the API returns the system memory page size.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  src/event-parse-api.c | 16 ++++++++++++++++
>  src/event-parse.h     |  1 +
>  2 files changed, 17 insertions(+)
> 
> diff --git a/src/event-parse-api.c b/src/event-parse-api.c
> index f8361e4..b5be8d3 100644
> --- a/src/event-parse-api.c
> +++ b/src/event-parse-api.c
> @@ -4,6 +4,7 @@
>   *
>   */
>  
> +#include <unistd.h>
>  #include "event-parse.h"
>  #include "event-parse-local.h"
>  #include "event-utils.h"
> @@ -248,6 +249,21 @@ void tep_set_page_size(struct tep_handle *tep, int _page_size)
>  		tep->page_size = _page_size;
>  }
>  
> +/**
> + * tep_get_trace_page_size - get the size of a trace page on the traced machine
> + * @tep: a handle to the tep_handle
> + *
> + * This returns the size of a trace page on the traced machine
> + * If @tep is NULL or the kernel is old, user space page size is returned.
> + */
> +int tep_get_trace_page_size(struct tep_handle *tep)

Let's call it:

  tep_get_sub_buffer_size()

as it has nothing to do with pages. (the header_page is really a misnomer).

> +{
> +	if (tep && !tep->old_format)

The old format should be updated to produce the same, and not have the
check here. And if tep is NULL, it should return -1;

> +		return tep->header_page_data_size + tep->header_page_data_offset;
> +
> +	return getpagesize();
> +}

That is, in tep_parse_header_page() we should have:

	if (!size) {
		/*
		 * Old kernels did not have header page info.
		 * Sorry but we just use what we find here in user space.
		 */
		tep->header_page_ts_size = sizeof(long long);
		tep->header_page_size_size = long_size;
		tep->header_page_data_offset = sizeof(long long) + long_size;
+		tep->header_page_data_size = getpagesize() - tep->header_page_data_offset;
		tep->old_format = 1;
		return -1;
	}

-- Steve


> +
>  /**
>   * tep_is_file_bigendian - return the endian of the file
>   * @tep: a handle to the tep_handle
> diff --git a/src/event-parse.h b/src/event-parse.h
> index 0833893..ea8df35 100644
> --- a/src/event-parse.h
> +++ b/src/event-parse.h
> @@ -572,6 +572,7 @@ void tep_set_cpus(struct tep_handle *tep, int cpus);
>  int tep_get_long_size(struct tep_handle *tep);
>  void tep_set_long_size(struct tep_handle *tep, int long_size);
>  int tep_get_page_size(struct tep_handle *tep);
> +int tep_get_trace_page_size(struct tep_handle *tep);
>  void tep_set_page_size(struct tep_handle *tep, int _page_size);
>  bool tep_is_file_bigendian(struct tep_handle *tep);
>  void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian);

