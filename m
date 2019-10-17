Return-Path: <SRS0=xBmi=YK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B84EECE58D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Oct 2019 21:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB0AD21A49
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Oct 2019 21:24:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQgZuqji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732097AbfJQVYi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 17:24:38 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46189 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfJQVYi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 17:24:38 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so5743981qtq.13;
        Thu, 17 Oct 2019 14:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=this0OD+MBdxIZ1Ej7SetLEMsHuprbufWI70WlqvPpA=;
        b=WQgZuqjiI1LuUmrXWZ13eyzcHLR8NX8uApORspapLRKPohTGQl8txWDxtXhv7RPP2f
         I+ebv+c7csDMLTS7gETiV05cj6tXXPF3ExTwkhMGNEphxVZLc4+5l4EiiQHrAVpNS++I
         1oIg8nYLf2/DPP7LUijvorfG0NqWVxOwo4sib7qFcrONtz5tPsreY0Q3PG5/cXGpuFj8
         KHZ6a97/y5kdPpoA/GwwOasqRFx41vrxFz4awC65Ohz+owUB4SJVgo/4IAshl6FNUEfF
         SwNAAFNPfCJqNdXXXnkjDZJeUxfUuAopk3wjMLluwndLRibLXcd5eT62G1gRrTkzkcWd
         rPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=this0OD+MBdxIZ1Ej7SetLEMsHuprbufWI70WlqvPpA=;
        b=FjrImEmDhN+JoWFtCrGmfVta4Rzjh0VHBnyjyuBf0+5m7w6sDb3ySwSI0+EQeeff03
         cBzskomNh/srkSDPHxgLa/x0uudKgrKhu7mxt/3tyHNuT+EGyRuAcMy7oe5x+fVCsY7N
         YiRChXIURC9VoYQ0ROL6cwAIe2iU2N4dChxgYrIo5JusbT1XUWT//fIJU08/7jK679rU
         5XwX0Q0PKydNun23LTP6kl9nxL8Q6g+hMDzNE7XlS7uEjWvjYKNfmhPcB0QJ0eaTJOgJ
         oAppQD3xv2ZcqdjKJpd0HFn2L+kLS3KAK8nT4mFiLd8IsQV+/qit4yIq0OAqL408fDVr
         OMjw==
X-Gm-Message-State: APjAAAWNNkQQxkB3hZ1shK6H6XXeFBFr84fXA09fskIXyi4KmZ9WejEH
        PD40ARB7Dyv72AEWGjwgjZGhL8mW
X-Google-Smtp-Source: APXvYqx3WjOTOf5GBDB6RDSF2v/BR495wcLyO+mu/a0CEzI7oL8r1SxBeo96s8BnV6tFBKuLOuIfqA==
X-Received: by 2002:ac8:3476:: with SMTP id v51mr6121284qtb.285.1571347475591;
        Thu, 17 Oct 2019 14:24:35 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.158.182.196])
        by smtp.gmail.com with ESMTPSA id k2sm2486765qti.24.2019.10.17.14.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 14:24:34 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 5A1B04DD66; Thu, 17 Oct 2019 18:24:31 -0300 (-03)
Date:   Thu, 17 Oct 2019 18:24:31 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf: Iterate on tep event arrays directly
Message-ID: <20191017212431.GF3600@kernel.org>
References: <20191017210521.465613686@goodmis.org>
 <20191017210636.061448713@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017210636.061448713@goodmis.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Oct 17, 2019 at 05:05:22PM -0400, Steven Rostedt escreveu:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Instead of calling a useless (and broken) helper function to get the next
> event of a tep event array, just get the array directly and iterate over it.
> 
> Note, the broken part was from trace_find_next_event() which after this will
> no longer be used, and can be removed.
> 
> Link: http://lkml.kernel.org/r/20191017153733.630cd5eb@gandalf.local.home

I'll add a:

Fixes: bb3dd7e7c4d5 ("tools lib traceevent, perf tools: Move struct tep_handler definition in a local header file")
Cc: stable@vger.kernel.org : v4.20+

As this is when this problem starts causing the segfault when generating
python scripts from perf.data files with multiple tracepoint events, ok?

- Arnaldo
 
> Reported-by: Daniel Bristot de Oliveira <bristot@redhat.com>
> Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tools/perf/util/scripting-engines/trace-event-perl.c   | 8 ++++++--
>  tools/perf/util/scripting-engines/trace-event-python.c | 9 +++++++--
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
> index 15961854ba67..741f040648b5 100644
> --- a/tools/perf/util/scripting-engines/trace-event-perl.c
> +++ b/tools/perf/util/scripting-engines/trace-event-perl.c
> @@ -539,10 +539,11 @@ static int perl_stop_script(void)
>  
>  static int perl_generate_script(struct tep_handle *pevent, const char *outfile)
>  {
> +	int i, not_first, count, nr_events;
> +	struct tep_event **all_events;
>  	struct tep_event *event = NULL;
>  	struct tep_format_field *f;
>  	char fname[PATH_MAX];
> -	int not_first, count;
>  	FILE *ofp;
>  
>  	sprintf(fname, "%s.pl", outfile);
> @@ -603,8 +604,11 @@ sub print_backtrace\n\
>  }\n\n\
>  ");
>  
> +	nr_events = tep_get_events_count(pevent);
> +	all_events = tep_list_events(pevent, TEP_EVENT_SORT_ID);
>  
> -	while ((event = trace_find_next_event(pevent, event))) {
> +	for (i = 0; all_events && i < nr_events; i++) {
> +		event = all_events[i];
>  		fprintf(ofp, "sub %s::%s\n{\n", event->system, event->name);
>  		fprintf(ofp, "\tmy (");
>  
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 5d341efc3237..93c03b39cd9c 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -1687,10 +1687,11 @@ static int python_stop_script(void)
>  
>  static int python_generate_script(struct tep_handle *pevent, const char *outfile)
>  {
> +	int i, not_first, count, nr_events;
> +	struct tep_event **all_events;
>  	struct tep_event *event = NULL;
>  	struct tep_format_field *f;
>  	char fname[PATH_MAX];
> -	int not_first, count;
>  	FILE *ofp;
>  
>  	sprintf(fname, "%s.py", outfile);
> @@ -1735,7 +1736,11 @@ static int python_generate_script(struct tep_handle *pevent, const char *outfile
>  	fprintf(ofp, "def trace_end():\n");
>  	fprintf(ofp, "\tprint(\"in trace_end\")\n\n");
>  
> -	while ((event = trace_find_next_event(pevent, event))) {
> +	nr_events = tep_get_events_count(pevent);
> +	all_events = tep_list_events(pevent, TEP_EVENT_SORT_ID);
> +
> +	for (i = 0; all_events && i < nr_events; i++) {
> +		event = all_events[i];
>  		fprintf(ofp, "def %s__%s(", event->system, event->name);
>  		fprintf(ofp, "event_name, ");
>  		fprintf(ofp, "context, ");
> -- 
> 2.23.0
> 

-- 

- Arnaldo
