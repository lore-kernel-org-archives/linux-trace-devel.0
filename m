Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DD2C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 14:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A16620830
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 14:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfCVOeU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbfCVOeT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 10:34:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67EC120830;
        Fri, 22 Mar 2019 14:34:18 +0000 (UTC)
Date:   Fri, 22 Mar 2019 10:34:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/perf,tools/lib/traceevent: Make traceevent APIs
 more consistent
Message-ID: <20190322103417.3f7eb84e@gandalf.local.home>
In-Reply-To: <20190322130816.13903-1-tstoyanov@vmware.com>
References: <20190322130816.13903-1-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Mar 2019 15:08:16 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

>  /**
> - * tep_get_header_page_ts_size - get size of the time stamp in the header page
> + * tep_get_header_timestamp_size - get size of the time stamp in the header page

Let's change "time stamp" to "timestamp". Even though it's not quite a
correct English word.


>  
>  /**
> - * tep_file_bigendian - get if the file is in big endian order
> + * tep_is_file_bigendian - get if the file is in big endian order

 tep_is_file_bigendian - return the endian of the file


>   * @pevent: a handle to the tep_handle
>   *
> - * This returns if the file is in big endian order
> - * If @pevent is NULL, 0 is returned.
> + * This returns true if the file is in big endian order
> + * If @pevent is NULL, false is returned.
>   */
> -int tep_file_bigendian(struct tep_handle *pevent)
> +bool tep_is_file_bigendian(struct tep_handle *pevent)
>  {
>  	if (pevent)
> -		return pevent->file_bigendian;
> -	return 0;
> +		return (pevent->file_bigendian == TEP_BIG_ENDIAN);
> +	return false;
>  }
>  
>  /**
> @@ -277,27 +277,27 @@ void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian)
>  }
>  
>  /**
> - * tep_is_host_bigendian - get if the order of the current host is big endian
> + * tep_is_local_bigendian - get if the local order is big endian


 tep_is_local_bigendian - return the endian of the saved local machine

>   * @pevent: a handle to the tep_handle

 s/@pevent/@tep/

>   *
> - * This gets if the order of the current host is big endian
> + * This gets if the local order is big endian

 This returns true if the saved local machine in @tep is big endian.

>   * If @pevent is NULL, 0 is returned.

 s/@pevent/@tep/

>   */
> -int tep_is_host_bigendian(struct tep_handle *pevent)
> +bool tep_is_local_bigendian(struct tep_handle *pevent)
>  {
>  	if (pevent)
> -		return pevent->host_bigendian;
> +		return (pevent->host_bigendian == TEP_BIG_ENDIAN);
>  	return 0;
>  }
>  
>  /**
> - * tep_set_host_bigendian - set the order of the local host
> + * tep_set_local_bigendian - set the local endian order

 - set the stored local machine endian order

>   * @pevent: a handle to the tep_handle
>   * @endian: non zero, if the local host has big endian order
>   *
> - * This sets the order of the local host
> + * This sets the local endian order

  This sets the endian order for the local machine.


> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 69af77896283..7d553a72469b 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -199,23 +199,23 @@ static const char *find_cmdline(struct tep_handle *pevent, int pid)

>  /**
> - * tep_data_lat_fmt - parse the data for the latency format
> + * tep_data_latency_format - parse the data for the latency format
>   * @pevent: a handle to the pevent

While we modify the functions here, we should also change @pevent to
@tep.

That needs to be stated in the change log too:

  Where modified, the legacy "pevent" name is changed to "tep".

Hmm, actually, lets make this a two patch series. One that removes all
references to "pevent" (in the tools/lib/traceevent/ directory), and
then this one on top of it.

-- Steve


>   * @s: the trace_seq to write to
>   * @record: the record to read from
> @@ -5180,8 +5180,8 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
>   * need rescheduling, in hard/soft interrupt, preempt count
>   * and lock depth) and places it into the trace_seq.
>   */
> -void tep_data_lat_fmt(struct tep_handle *pevent,
> -		      struct trace_seq *s, struct tep_record *record)
> +void tep_data_latency_format(struct tep_handle *pevent,
> +			     struct trace_seq *s, struct tep_record *record)
>  {
>  	static int check_lock_depth = 1;
>  	static int check_migrate_disable = 1;
> @@ -5530,7 +5530,7 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
>  	}
>  
>  	if (pevent->latency_format) {
> -		tep_data_lat_fmt(pevent, s, record);
> +		tep_data_latency_format(pevent, s, record);
>  	}
>  
>  	if (use_usec_format) {
> @@ -6758,7 +6758,7 @@ struct tep_handle *tep_alloc(void)
>  
>  	if (pevent) {
>  		pevent->ref_count = 1;
> -		pevent->host_bigendian = tep_host_bigendian();
> +		pevent->host_bigendian = tep_is_bigendian();
>  	}

