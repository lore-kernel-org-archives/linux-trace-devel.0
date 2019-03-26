Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1480EC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57512084B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731516AbfCZNRf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731511AbfCZNRf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 09:17:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B090A20823;
        Tue, 26 Mar 2019 13:17:33 +0000 (UTC)
Date:   Tue, 26 Mar 2019 09:17:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] tools/lib/traceevent: Implement new traceevent
 APIs for accessing struct tep_handler fields
Message-ID: <20190326091732.5cd73b5d@gandalf.local.home>
In-Reply-To: <20190325145017.30246-4-tstoyanov@vmware.com>
References: <20190325145017.30246-1-tstoyanov@vmware.com>
        <20190325145017.30246-4-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 25 Mar 2019 16:50:17 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> As struct tep_handler definition is not exposed as part of libtraceevent API, its fields
> cannot be accessed directly by the library users. This patch implements new APIs, which
> can be used to access the struct tep_handler fields:
> 
> tep_get_event() - retrieves an event pointer at a specific index
> tep_get_first_event() is modified to use tep_get_event()
> tep_clear_flag() - clears a tep handle flag
> tep_test_flag() - test if a given flag is set
> tep_get_header_timestamp_size() - returns the size of the timestamp stored in the header.
> tep_get_cpus() - returns the number of CPUs
> tep_is_old_format() - returns true if data was created by an
>                       older kernel with the old data format
> tep_set_print_raw() - have the output print in the raw format
> tep_set_test_filters() - debugging utility for testing tep filters

This looks good, but one nit, it can be a bit more formatted ;-)

 tep_get_event()        - retrieves an event pointer at a specific index
 tep_get_first_event()  - is modified to use tep_get_event()
 tep_clear_flag()       - clears a tep handle flag
 tep_test_flag()        - test if a given flag is set
 tep_get_header_timestamp_size() - returns the size of the timestamp
                          stored in the header.
 tep_get_cpus()         - returns the number of CPUs
 tep_is_old_format()    - returns true if data was created by an
                          older kernel with the old data format
 tep_set_print_raw()    - have the output print in the raw format
 tep_set_test_filters() - debugging utility for testing tep filters

I'll update it.

-- Steve


> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/event-parse-api.c | 106 ++++++++++++++++++++++++-
>  tools/lib/traceevent/event-parse.h     |   6 ++
>  2 files changed, 108 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
> index 3716a9142aef..36672b9e18e0 100644
> --- a/tools/lib/traceevent/event-parse-api.c
> +++ b/tools/lib/traceevent/event-parse-api.c
> @@ -8,6 +8,22 @@
>  #include "event-parse-local.h"
>  #include "event-utils.h"
>  
> +/**
> + * tep_get_event - returns the event with the given index
> + * @tep: a handle to the tep_handle
> + * @index: index of the requested event, in the range 0 .. nr_events
> + *
> + * This returns pointer to the element of the events array with the given index
> + * If @tep is NULL, or @index is not in the range 0 .. nr_events, NULL is returned.
> + */
> +struct tep_event *tep_get_event(struct tep_handle *tep, int index)
> +{
> +	if (tep && tep->events && index < tep->nr_events)
> +		return tep->events[index];
> +
> +	return NULL;
> +}
> +
>  /**
>   * tep_get_first_event - returns the first event in the events array
>   * @tep: a handle to the tep_handle
> @@ -17,10 +33,7 @@
>   */
>  struct tep_event *tep_get_first_event(struct tep_handle *tep)
>  {
> -	if (tep && tep->events)
> -		return tep->events[0];
> -
> -	return NULL;
> +	return tep_get_event(tep, 0);
>  }
>  
>  /**
> @@ -51,6 +64,34 @@ void tep_set_flag(struct tep_handle *tep, int flag)
>  		tep->flags |= flag;
>  }
>  
> +/**
> + * tep_clear_flag - clear event parser flag
> + * @tep: a handle to the tep_handle
> + * @flag: flag to be cleared
> + *
> + * This clears a tep flag
> + */
> +void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag)
> +{
> +	if (tep)
> +		tep->flags &= ~flag;
> +}
> +
> +/**
> + * tep_test_flag - check the state of event parser flag
> + * @tep: a handle to the tep_handle
> + * @flag: flag to be checked
> + *
> + * This returns the state of the requested tep flag.
> + * Returns: true if the flag is set, false otherwise.
> + */
> +bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
> +{
> +	if (tep)
> +		return (tep->flags & flag);
> +	return false;
> +}
> +
>  unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data)
>  {
>  	unsigned short swap;
> @@ -113,6 +154,20 @@ int tep_get_header_page_size(struct tep_handle *pevent)
>  	return 0;
>  }
>  
> +/**
> + * tep_get_header_timestamp_size - get size of the time stamp in the header page
> + * @tep: a handle to the tep_handle
> + *
> + * This returns size of the time stamp in the header page
> + * If @tep is NULL, 0 is returned.
> + */
> +int tep_get_header_timestamp_size(struct tep_handle *tep)
> +{
> +	if (tep)
> +		return tep->header_page_ts_size;
> +	return 0;
> +}
> +
>  /**
>   * tep_get_cpus - get the number of CPUs
>   * @pevent: a handle to the tep_handle
> @@ -273,3 +328,46 @@ void tep_set_latency_format(struct tep_handle *pevent, int lat)
>  	if (pevent)
>  		pevent->latency_format = lat;
>  }
> +
> +/**
> + * tep_is_old_format - get if an old kernel is used
> + * @tep: a handle to the tep_handle
> + *
> + * This returns true, if an old kernel is used to generate the tracing events or
> + * false if a new kernel is used. Old kernels did not have header page info.
> + * If @pevent is NULL, false is returned.
> + */
> +bool tep_is_old_format(struct tep_handle *tep)
> +{
> +	if (tep)
> +		return !!(tep->old_format);
> +	return false;
> +}
> +
> +/**
> + * tep_set_print_raw - set a flag to force print in raw format
> + * @tep: a handle to the tep_handle
> + * @print_raw: the new value of the print_raw flag
> + *
> + * This sets a flag to force print in raw format
> + */
> +void tep_set_print_raw(struct tep_handle *tep, int print_raw)
> +{
> +	if (tep)
> +		tep->print_raw = print_raw;
> +}
> +
> +/**
> + * tep_set_test_filters - set a flag to test a filter string
> + * @tep: a handle to the tep_handle
> + * @test_filters: the new value of the test_filters flag
> + *
> + * This sets a flag to test a filter string. If this flag is set, when
> + * tep_filter_add_filter_str() API as called,it will print the filter string
> + * instead of adding it.
> + */
> +void tep_set_test_filters(struct tep_handle *tep, int test_filters)
> +{
> +	if (tep)
> +		tep->test_filters = test_filters;
> +}
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index aec48f2aea8a..6e1d493738b4 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -409,6 +409,8 @@ void tep_print_plugins(struct trace_seq *s,
>  typedef char *(tep_func_resolver_t)(void *priv,
>  				    unsigned long long *addrp, char **modp);
>  void tep_set_flag(struct tep_handle *tep, int flag);
> +void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag);
> +bool tep_check_flags(struct tep_handle *tep, enum tep_flag flags);
>  
>  static inline int tep_host_bigendian(void)
>  {
> @@ -565,6 +567,10 @@ void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian);
>  int tep_is_latency_format(struct tep_handle *pevent);
>  void tep_set_latency_format(struct tep_handle *pevent, int lat);
>  int tep_get_header_page_size(struct tep_handle *pevent);
> +int tep_get_header_timestamp_size(struct tep_handle *tep);
> +bool tep_is_old_format(struct tep_handle *pevent);
> +void tep_set_print_raw(struct tep_handle *tep, int print_raw);
> +void tep_set_test_filters(struct tep_handle *tep, int test_filters);
>  
>  struct tep_handle *tep_alloc(void);
>  void tep_free(struct tep_handle *pevent);

