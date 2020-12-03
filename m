Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FB6C6369E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 01:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B3CE206F9
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 01:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgLCBsT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 20:48:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgLCBsT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 20:48:19 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E5AA20B80;
        Thu,  3 Dec 2020 01:47:37 +0000 (UTC)
Date:   Wed, 2 Dec 2020 20:47:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v25 09/16] trace-cmd: Add scaling ratio for timestamp
 correction
Message-ID: <20201202204735.61d112c8@oasis.local.home>
In-Reply-To: <20201029111816.247241-10-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
        <20201029111816.247241-10-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Oct 2020 13:18:09 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> @@ -2181,7 +2184,9 @@ static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
>  		host->ts_samples[i].time = tep_read_number(handle->pevent,
>  							   buf8 + i, 8);
>  		host->ts_samples[i].offset = tep_read_number(handle->pevent,
> -						buf8 + host->ts_samples_count+i, 8);
> +						buf8 + host->ts_samples_count + i, 8);
> +		host->ts_samples[i].scaling = tep_read_number(handle->pevent,
> +						buf8 + (2 * host->ts_samples_count) + i, 8);
>  	}


I was thinking the above code may read better if we changed it to:

	long long *time_buf;
	long long *offset_buf;
	long long *scaling_buf;

	time_buf = (long long *)buf;
	offset_buf = time_buf + host->ts_samples_count;
	scaling_buf = offset_buf + host->ts_samples_count;

	for (i = 0; i < host->ts_samples_count; i++) {
		host->ts_samples[i].time = tep_read_number(handle->pevent,
							   time_buf + i, 8);
		host->ts_samples[i].offset = tep_read_number(handle->	pevent,
							   offset_buf + i, 8);
		host->ts_samples[i].scaling = tep_read_number(handle->pevent,
						           scaling_buf + i, 8);
	}

-- Steve



>  	qsort(host->ts_samples, host->ts_samples_count,
>  	      sizeof(struct ts_offset_sample), tsync_offset_cmp);
> @@ -2534,6 +2539,7 @@ static int handle_options(struct tracecmd_input *handle)
>  			 * long long array of size [count] of times,
>  			 *      when the offsets were calculated.
>  			 * long long array of size [count] of timestamp offsets.
> +			 * long long array of size [count] of timestamp scaling ratios.*
>  			 */
>  			if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
>  				break;
