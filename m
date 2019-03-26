Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BBDC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 19:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BA8F2084B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 19:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbfCZTnW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730449AbfCZTnW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 15:43:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2FD020823;
        Tue, 26 Mar 2019 19:43:20 +0000 (UTC)
Date:   Tue, 26 Mar 2019 15:43:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] tools/perf,tools/lib/traceevent: Make traceevent
 APIs more consistent
Message-ID: <20190326154318.70716fbb@gandalf.local.home>
In-Reply-To: <20190326154328.28718-2-tstoyanov@vmware.com>
References: <20190326154328.28718-1-tstoyanov@vmware.com>
        <20190326154328.28718-2-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Mar 2019 17:43:21 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Rename some traceevent APIs for consistency:
> 
> tep_pid_is_registered() to tep_is_pid_registered()
> tep_file_bigendian() to tep_is_file_bigendian()
>   to make the names and return values consistent with other tep_is_... APIs
> 
> tep_data_lat_fmt() to tep_data_latency_format()
>   to make the name more descriptive
> 
> tep_host_bigendian() to tep_is_bigendian()
> tep_set_host_bigendian() to tep_set_local_bigendian()
> tep_is_host_bigendian() to tep_is_local_bigendian()
>   "host" can be confused with VMs, and "local" is about the local
>   machine. All tep_is_..._bigendian(struct tep_handle *tep) APIs return
>   the saved data in the tep handle, while tep_is_bigendian() returns
>   the running machine's endianness.
> 
> All tep_is_... functions are modified to return bool value, instead of int.

Much nicer ;-)

> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/event-parse-api.c | 44 +++++++++++++-------------
>  tools/lib/traceevent/event-parse.c     | 26 +++++++--------
>  tools/lib/traceevent/event-parse.h     | 16 +++++-----
>  tools/lib/traceevent/plugin_kvm.c      |  4 +--
>  tools/perf/util/trace-event-read.c     |  2 +-
>  tools/perf/util/trace-event.c          |  4 +--
>  6 files changed, 48 insertions(+), 48 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
> index 2ac8b44854ce..46670bb87051 100644
> --- a/tools/lib/traceevent/event-parse-api.c
> +++ b/tools/lib/traceevent/event-parse-api.c
> @@ -88,7 +88,7 @@ void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag)
>  bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
>  {
>  	if (tep)
> -		return (tep->flags & flag);
> +		return !!(tep->flags & flag);

This isn't needed. The fact hat this returns "bool", the compiler will
handle thins the same regardless.

>  	return false;
>  }
>  


> @@ -306,14 +306,14 @@ void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian)
>   * tep_is_latency_format - get if the latency output format is configured
>   * @pevent: a handle to the tep_handle
>   *
> - * This gets if the latency output format is configured
> - * If @pevent is NULL, 0 is returned.
> + * This returns true if the latency output format is configured
> + * If @pevent is NULL, false is returned.
>   */
> -int tep_is_latency_format(struct tep_handle *pevent)
> +bool tep_is_latency_format(struct tep_handle *pevent)
>  {
>  	if (pevent)
> -		return pevent->latency_format;
> -	return 0;
> +		return !!(pevent->latency_format);

Same here.

> +	return false;
>  }
>  
>  /**

The rest looks good.

-- Steve


