Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C4BC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 15:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0B65218FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 15:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfCVPUp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 11:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbfCVPUp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 11:20:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5F7218D4;
        Fri, 22 Mar 2019 15:20:43 +0000 (UTC)
Date:   Fri, 22 Mar 2019 11:20:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] tools/lib/traceevent: Implement new traceevent
 APIs for accessing struct tep_handler fields
Message-ID: <20190322112041.1d3d9364@gandalf.local.home>
In-Reply-To: <20190322130742.13753-4-tstoyanov@vmware.com>
References: <20190322130742.13753-1-tstoyanov@vmware.com>
        <20190322130742.13753-4-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Mar 2019 15:07:42 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +/**
> + * tep_clear_flag - clear event parser flag
> + * @tep: a handle to the tep_handle
> + * @flag: flag to be cleared
> + *
> + * This clears a tep flag
> + */
> +void tep_clear_flags(struct tep_handle *tep, enum tep_flag flag)

 void tep_clear_flag(..)

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
> + * This checks the state of a tep flag.
> + * true is returned if the flag is set, false
> + * otherwise

Let's make this a bit more formal:

 * This returns the state of the requested tep flag.
 * Returns: true if the flag is set, false otherwise.

Also, set the return in the change logs to use the full 80 characters.
There's no reason to put "otherwise" on a new line. Unless we plan on
reading this on our phones ;-)

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
> @@ -113,6 +155,20 @@ int tep_get_header_page_size(struct tep_handle *pevent)
>  	return 0;
>  }
>  
> +/**
> + * tep_get_header_page_ts_size - get size of the time stamp in the header page
> + * @tep: a handle to the tep_handle

I already mentioned that we should use the new name.

> + *
> + * This returns size of the time stamp in the header page
> + * If @tep is NULL, 0 is returned.
> + */
> +int tep_get_header_page_ts_size(struct tep_handle *tep)
> +{
> +	if (tep)
> +		return tep->header_page_ts_size;
> +	return 0;
> +}
> +
>  /**
>   * tep_get_cpus - get the number of CPUs
>   * @pevent: a handle to the tep_handle
> @@ -273,3 +329,73 @@ void tep_set_latency_format(struct tep_handle *pevent, int lat)
>  	if (pevent)
>  		pevent->latency_format = lat;
>  }
> +
> +/**
> + * tep_set_parsing_failures - set parsing failures flag
> + * @tep: a handle to the tep_handle
> + * @parsing_failures: the new value of the parsing_failures flag
> + *
> + * This sets flag "parsing_failures" to the given count
> + */
> +void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures)
> +{
> +	if (tep)
> +		tep->parsing_failures = parsing_failures;
> +}
> +
> +/**
> + * tep_get_parsing_failures - get the parsing failures flag
> + * @tep: a handle to the tep_handle
> + *
> + * This returns value of flag "parsing_failures"
> + * If @tep is NULL, 0 is returned.
> + */
> +int tep_get_parsing_failures(struct tep_handle *tep)
> +{
> +	if (tep)
> +		return tep->parsing_failures;
> +	return 0;
> +}

Hmm, actually I think we can get rid of the parsing failures
completely, and use another mechanism to report these errors.

Or better yet, have tep_parse_event() set it internally and have:

 tep_has_failures() - returns true if tep_parse_event() failed
 tep_clear_failures() - resets so tep_has_failures() returns false


> +
> +/**
> + * tep_is_old_format - get if an old kernel is used

    - returns true if the data is from an old kernel

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
> + * tep_set_print_raw - set a flag to test a filter string

  tep_set_test_filters - 

> + * @tep: a handle to the tep_handle
> + * @test_filters: the new value of the test_filters flag
> + *
> + * This sets a flag to fjust test a filter string. If this flag is set,

 This causes the tep_filter_add_filter_str() to simply print the filter
 instead of adding it.

Note, we should remove the "exit(0)" from tep_filter_add_filter_str()
and have the callers do the exit. A library function should not call
exit.

-- Steve


> + * when a filter string is added, then it will print the filters strings
> + * that were created and exit.
> + */
> +void tep_set_test_filters(struct tep_handle *tep, int test_filters)
> +{
> +	if (tep)
> +		tep->test_filters = test_filters;
> +}
> diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
> index 35833ee32d6c..c5c8eb4c4ab7 100644
> --- a/tools/lib/traceevent/event-parse-local.h
> +++ b/tools/lib/traceevent/event-parse-local.h
> @@ -83,6 +83,8 @@ struct tep_handle {
>  	struct event_handler *handlers;
>  	struct tep_function_handler *func_handlers;
>  
> +	int parsing_failures;
> +
>  	/* cache */
>  	struct tep_event *last_event;
>  
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index aec48f2aea8a..4b64658334de 100644
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
> @@ -565,6 +567,12 @@ void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian);
>  int tep_is_latency_format(struct tep_handle *pevent);
>  void tep_set_latency_format(struct tep_handle *pevent, int lat);
>  int tep_get_header_page_size(struct tep_handle *pevent);
> +void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures);
> +int tep_get_parsing_failures(struct tep_handle *tep);
> +int tep_get_header_page_ts_size(struct tep_handle *tep);
> +bool tep_is_old_format(struct tep_handle *pevent);
> +void tep_set_print_raw(struct tep_handle *tep, int print_raw);
> +void tep_set_test_filters(struct tep_handle *tep, int test_filters);
>  
>  struct tep_handle *tep_alloc(void);
>  void tep_free(struct tep_handle *pevent);

