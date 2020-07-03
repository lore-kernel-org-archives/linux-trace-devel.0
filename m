Return-Path: <SRS0=Auw7=AO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7D7C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jul 2020 11:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 424BE20870
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jul 2020 11:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593775870;
	bh=OvhPzbqJkJ5GRRhzdA1dbeaEPuJdpc6C/TvRvw6IVao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0+VngfYHq4yizJ2A4GoNd0WoDNM8dH8ZNKZzOMPdMekVBONIpMRmJBumRgjaDOfQJ
	 0g563Ht7LYgV79XoS159m9V0+ioTKE1ZcDnDHqf8DBjJfy2GBRIUdV8TamXFbREONv
	 DDhd0CNkzodFilX9nCn4ipzlLZ3Wfeh2eroweNSE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgGCLbK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 07:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgGCLbJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 07:31:09 -0400
Received: from quaco.ghostprotocols.net (unknown [179.162.131.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52885207FF;
        Fri,  3 Jul 2020 11:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593775869;
        bh=OvhPzbqJkJ5GRRhzdA1dbeaEPuJdpc6C/TvRvw6IVao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sCkoxnZ4JnKx56OrD4+fVLJ+j8+FqIbyuuHkrzSNoFbXetmGZO08MZ+Lm4JLLTh3P
         ghvW8JffnoNyG8aNZjsK9AZFEuPzmgEkbJEBMX8fD2aj2HNyUFHwe14I+PVjYx+VCl
         O1wsKnJPOH9QweW53cLOIc3xf5LHPjn5QHNjSgLM=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 3C98D405FF; Fri,  3 Jul 2020 08:31:07 -0300 (-03)
Date:   Fri, 3 Jul 2020 08:31:07 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2 01/15] tools lib traceevent: Add API to read time
 information from kbuffer
Message-ID: <20200703113107.GD1320@kernel.org>
References: <20200702185344.913492689@goodmis.org>
 <20200702185703.619656282@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702185703.619656282@goodmis.org>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Jul 02, 2020 at 02:53:45PM -0400, Steven Rostedt escreveu:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Add the functions kbuffer_subbuf_timestamp() and kbuffer_ptr_delta() to get
> the timing data stored in the ring buffer that is used to produced the time
> stamps of the records.
> 
> This is useful for tools like trace-cmd to be able to display the content of
> the read data to understand why the records show the time stamps that they
> do.
> 
> Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-2-tz.stoyanov@gmail.com
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> [ Ported from trace-cmd.git ]
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Humm, is that intentional, i.e. two signed-off-by you?

- Arnaldo

> ---
>  tools/lib/traceevent/kbuffer-parse.c | 28 ++++++++++++++++++++++++++++
>  tools/lib/traceevent/kbuffer.h       |  2 ++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/tools/lib/traceevent/kbuffer-parse.c b/tools/lib/traceevent/kbuffer-parse.c
> index 27f3b07fdae8..583db99aee94 100644
> --- a/tools/lib/traceevent/kbuffer-parse.c
> +++ b/tools/lib/traceevent/kbuffer-parse.c
> @@ -546,6 +546,34 @@ int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer)
>  	return 0;
>  }
>  
> +/**
> + * kbuffer_subbuf_timestamp - read the timestamp from a sub buffer
> + * @kbuf:      The kbuffer to load
> + * @subbuf:    The subbuffer to read from.
> + *
> + * Return the timestamp from a subbuffer.
> + */
> +unsigned long long kbuffer_subbuf_timestamp(struct kbuffer *kbuf, void *subbuf)
> +{
> +	return kbuf->read_8(subbuf);
> +}
> +
> +/**
> + * kbuffer_ptr_delta - read the delta field from a record
> + * @kbuf:      The kbuffer to load
> + * @ptr:       The record in the buffe.
> + *
> + * Return the timestamp delta from a record
> + */
> +unsigned int kbuffer_ptr_delta(struct kbuffer *kbuf, void *ptr)
> +{
> +	unsigned int type_len_ts;
> +
> +	type_len_ts = read_4(kbuf, ptr);
> +	return ts4host(kbuf, type_len_ts);
> +}
> +
> +
>  /**
>   * kbuffer_read_event - read the next event in the kbuffer subbuffer
>   * @kbuf:	The kbuffer to read from
> diff --git a/tools/lib/traceevent/kbuffer.h b/tools/lib/traceevent/kbuffer.h
> index ed4d697fc137..5fa8292e341b 100644
> --- a/tools/lib/traceevent/kbuffer.h
> +++ b/tools/lib/traceevent/kbuffer.h
> @@ -49,6 +49,8 @@ int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer);
>  void *kbuffer_read_event(struct kbuffer *kbuf, unsigned long long *ts);
>  void *kbuffer_next_event(struct kbuffer *kbuf, unsigned long long *ts);
>  unsigned long long kbuffer_timestamp(struct kbuffer *kbuf);
> +unsigned long long kbuffer_subbuf_timestamp(struct kbuffer *kbuf, void *subbuf);
> +unsigned int kbuffer_ptr_delta(struct kbuffer *kbuf, void *ptr);
>  
>  void *kbuffer_translate_data(int swap, void *data, unsigned int *size);
>  
> -- 
> 2.26.2
> 
> 

-- 

- Arnaldo
