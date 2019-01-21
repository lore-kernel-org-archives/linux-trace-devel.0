Return-Path: <SRS0=G/lh=P5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A95FC282F6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 09:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 543A420989
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 09:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfAUJCN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:02:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfAUJCM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jan 2019 04:02:12 -0500
Received: from vmware.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 082A12084A;
        Mon, 21 Jan 2019 09:02:10 +0000 (UTC)
Date:   Mon, 21 Jan 2019 04:02:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/7] trace-cmd: Implemented new lib API:
 tracecmd_local_events_system()
Message-ID: <20190121040201.479f8ede@vmware.local.home>
In-Reply-To: <20190116191838.32127-2-tstoyanov@vmware.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
        <20190116191838.32127-2-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Jan 2019 21:18:32 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +static int tracecmd_fill_local_events_system(const char *tracing_dir,
> +					     struct tep_handle *pevent,
> +					     char *sys_name)
>  {
>  	struct dirent *dent;
>  	char *events_dir;
> @@ -1189,7 +1161,8 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
>  		if (strcmp(name, ".") == 0 ||
>  		    strcmp(name, "..") == 0)
>  			continue;
> -
> +		if (sys_name && strcmp(name, sys_name))

Small nit. Please compare as: strcmp(name, sys_name) != 0

This to make it look like it is not equal. One of the flaws of the
"strcmp" is that a match is false and a non match is true, which makes
it likely to be done wrong :-p

If you noticed, the strcmp() in the previous if uses "== 0" as a way to
say "this is true on match"


> +			continue;
>  		sys = append_file(events_dir, name);
>  		ret = stat(sys, &st);
>  		if (ret < 0 || !S_ISDIR(st.st_mode)) {
> @@ -1217,6 +1190,58 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
>  	return ret;
>  }
>  
> +/**
> + * tracecmd_local_events_system - create a tep from the
> + * events of the specified subsystem.

Keep the above on one line, even though it breaks the 80 character
limit.

-- Steve

> + *
> + * @tracing_dir: The directory that contains the events.
> + * @sys_name: Name of the subsystem, to load events from
> + *
> + * Returns a tep structure that contains the tep local to
> + * the system.
> + */
> +struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
> +						char *sys_name)
> +{
> +	struct tep_handle *tep = NULL;
> +
> +	tep = tep_alloc();
> +	if (!tep)
> +		return NULL;
> +
> +	if (tracecmd_fill_local_events_system(tracing_dir, tep, sys_name)) {
> +		tep_free(tep);
> +		tep = NULL;
> +	}
> +
> +	return tep;
> +}
> 
