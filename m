Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8875C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 03:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhKWDdl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhKWDdl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 22:33:41 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77E6B60E95;
        Tue, 23 Nov 2021 03:30:33 +0000 (UTC)
Date:   Mon, 22 Nov 2021 22:30:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] libtraceevent: A new API for trace page size
Message-ID: <20211122223032.07817622@rorschach.local.home>
In-Reply-To: <20211112041211.23458-1-tz.stoyanov@gmail.com>
References: <20211112041211.23458-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Nov 2021 06:12:11 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Currently, the size of a trace buffer page is equal to the size of the
> system memory page. This may change in the future, so this assumption
> may not be valid. The proper way to determine the trace buffer page size
> is by using the information from "events/header_page" ftrace file:
>  ...
>  field: char data;	offset:16;	size:4080;	signed:1;
>  ...
> The trace buffer page size is the size of the "data" filed + its offset.
> 
> A new libtraceevent API is introduced, for getting the trace buffer page
> size using that formula:
>  tep_get_sub_buffer_size()
> 
> Note, that some old kernels may not have "events/header_page" file. For
> those, the system memory page size is returned.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
> 
> v2 changes:
>  - Renamed tep_get_trace_page_size() to tep_get_sub_buffer_size().
>  - Handle the old kernels in tep_parse_header_page() instead of in
>    tep_get_sub_buffer_size().
> 
>  src/event-parse-api.c | 16 ++++++++++++++++
>  src/event-parse.c     |  2 ++
>  src/event-parse.h     |  1 +
>  3 files changed, 19 insertions(+)
> 
> diff --git a/src/event-parse-api.c b/src/event-parse-api.c
> index f8361e4..f8433e5 100644
> --- a/src/event-parse-api.c
> +++ b/src/event-parse-api.c
> @@ -4,6 +4,7 @@
>   *
>   */
>  
> +#include <unistd.h>

The above include isn't needed here anymore due to moving the
getpagesize into the C file.

-- Steve


>  #include "event-parse.h"
>  #include "event-parse-local.h"
>  #include "event-utils.h"
> @@ -248,6 +249,21 @@ void tep_set_page_size(struct tep_handle *tep, int _page_size)
>  		tep->page_size = _page_size;
>  }
>  
> +/**
> + * tep_get_sub_buffer_size - get the size of a trace buffer page
> + * @tep: a handle to the tep_handle
> + *
> + * This returns the size of a trace buffer page on the traced machine.
> + * If @tep is NULL then -1 is returned.
> + */
> +int tep_get_sub_buffer_size(struct tep_handle *tep)
> +{
> +	if (!tep)
> +		return -1;
> +
> +	return tep->header_page_data_size + tep->header_page_data_offset;
> +}
> +
>  /**
>   * tep_is_file_bigendian - return the endian of the file
>   * @tep: a handle to the tep_handle
> diff --git a/src/event-parse.c b/src/event-parse.c
> index f42ae38..4b67289 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -17,6 +17,7 @@
>  #include <ctype.h>
>  #include <errno.h>
>  #include <stdint.h>
> +#include <unistd.h>
>  #include <limits.h>
>  #include <linux/time64.h>
>  
> @@ -6905,6 +6906,7 @@ int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
>  		tep->header_page_ts_size = sizeof(long long);
>  		tep->header_page_size_size = long_size;
>  		tep->header_page_data_offset = sizeof(long long) + long_size;
> +		tep->header_page_data_size = getpagesize() - tep->header_page_data_offset;
>  		tep->old_format = 1;
>  		return -1;
>  	}
> diff --git a/src/event-parse.h b/src/event-parse.h
> index d4a876f..e4ecde5 100644
> --- a/src/event-parse.h
> +++ b/src/event-parse.h
> @@ -565,6 +565,7 @@ void tep_set_cpus(struct tep_handle *tep, int cpus);
>  int tep_get_long_size(struct tep_handle *tep);
>  void tep_set_long_size(struct tep_handle *tep, int long_size);
>  int tep_get_page_size(struct tep_handle *tep);
> +int tep_get_sub_buffer_size(struct tep_handle *tep);
>  void tep_set_page_size(struct tep_handle *tep, int _page_size);
>  bool tep_is_file_bigendian(struct tep_handle *tep);
>  void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian);

