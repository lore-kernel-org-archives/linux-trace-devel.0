Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F84C282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7BDF20872
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:19:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SF+d/5uS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732494AbfDQOTJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:19:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56245 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732007AbfDQOTE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:19:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id o25so3602691wmf.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2019 07:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=cF8cyXmESfZh5MKqW+V47hVNkRoNRTxFs3TgrQvsuDY=;
        b=SF+d/5uSqQByKnqSZrMPw/OdNyJ/BZkdQCZ72xv+kQ2le1N57qbMd6+xE7WZzzAXjj
         p612u9+YyDZYCEKPQRBLqpLfZjsefnd2+VOGxYHuNLg3RyBAvBBZHFSRFszo94v2xssm
         IdbY/OP9w8K2B7/o5a+sTr14jUICHXpJLQFLCOEFDKgDTUCpbNDT3xl8cRM0WgnVCKH0
         5K2slgcB6YCPstM4mJg+hjKlVvEhEIQVqgDTVH6Kr33zBPYo0neIJF0hrfGh9DkzIj7s
         1AK04dhyvIB8y7DvjsZeC6Zb3Mcjw+Lg/HVAkqyb7dyc0TuWLPB8cANXWgkomwuIQWMB
         HZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:in-reply-to
         :message-id:references:user-agent:mime-version;
        bh=cF8cyXmESfZh5MKqW+V47hVNkRoNRTxFs3TgrQvsuDY=;
        b=cfhwpaEQEMKHlDqL/ObJd/xGgwm+8E7hvLONHnjZjv2HdYoWLJ9mUKBKIcs6qen98U
         vbL8UqWonUoHbVH1Huk5PuUOmbelGQQbcB2cCz24IAjglDyezVMLwk6KlKzk8Ml13RZ2
         olnqgUzqIXCM1hvYS+B86LnZLuechMoIipH/P8RPAsVgZPUjYVOfnSGrf+3RYRzGbJTI
         ThVsEivj89zDXDW6HByDylbLciZl6Su/wFWtls/q1prOe5VDHk6iqSjv1wfTb0L3H3uA
         LCejktyRVWdOCmjOh2IB+GUzmlsYJuOLWkVxBOnBjdxRLYcn2V4+5Dp/L7voC5y4oL0v
         i5JQ==
X-Gm-Message-State: APjAAAUpHPtJ/v6A5tL69zMiTdqCHlSHUZbhMkv3mjQ9dHYFljdDXwtF
        J4flps4LMQhmyLqobySX1ns=
X-Google-Smtp-Source: APXvYqwV5uuudNdU2TWhsd1qK09syROIuLHYjyitLhC9HI9kIgyKcl2y7aCtgEedwqsvvkXHqIfHxA==
X-Received: by 2002:a1c:486:: with SMTP id 128mr32666579wme.3.1555510742249;
        Wed, 17 Apr 2019 07:19:02 -0700 (PDT)
Received: from planxty ([2a02:8108:1700:1960:91dd:e2f9:ed05:ee2b])
        by smtp.gmail.com with ESMTPSA id r196sm3715822wmf.22.2019.04.17.07.19.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Apr 2019 07:19:01 -0700 (PDT)
Date:   Wed, 17 Apr 2019 16:18:50 +0200 (CEST)
From:   John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@planxty
To:     Phil Auld <pauld@redhat.com>
cc:     Slavomir Kaslev <kaslevs@vmware.com>, rostedt@goodmis.org,
        linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        jbacik@fb.com, tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: Re: [PATCH v4 1/2] trace-cmd: Optimize how pid filters are
 expressed
In-Reply-To: <20190417135858.GD6118@pauld.bos.csb>
Message-ID: <alpine.LFD.2.21.1904171616010.6386@planxty>
References: <20190417130959.10064-1-kaslevs@vmware.com> <20190417130959.10064-2-kaslevs@vmware.com> <20190417135858.GD6118@pauld.bos.csb>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On Wed, 17 Apr 2019, Phil Auld wrote:

> On Wed, Apr 17, 2019 at 04:09:58PM +0300 Slavomir Kaslev wrote:
> > Express pid filters as allowed/disallowed filter ranges
> > 
> >   (pid>=100&&pid<=103)
> > 
> > instead of specifying them per pid
> > 
> >   (pid==100||pid==101||pid==102||pid==103)
> > 
> > This makes the size of the resulting filter smaller (and faster) and avoids
> > overflowing the filter size limit of one page which we can hit on bigger
> > machines (say >160 CPUs).
> 
> This one works as well :)
> 
> I finally hit a case where my trace-cmd pids were non-contiguous and 
> this split the range up correctly. 
> 
> 
> FILTER write /sys/kernel/debug/tracing/events/sched/sched_kthread_stop/filter (len 74) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)"
> FILTER write /sys/kernel/debug/tracing/events/sched/sched_kthread_stop_ret/filter (len 74) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)"
> ...
> FILTER write /sys/kernel/debug/tracing/events/sched/sched_switch/filter (len 142) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)||(next_pid<21420||next_pid>21425)&&(next_pid<21265||next_pid>21418)"

It seems crazy that we write "common_pid", instead of "pid" or "cpid", or 
something like that.



> 
> 
> The latter is correct given precendce of && before || but I wonder if () don't make sense? I always have to look
> that one up :)
> 
> If I were writing that in code I'd probably put in the extra ()s, but since it's generated and no
> one actually sees it, probably okay and simpler as is. 
> 
>  
> Having seen that and having tried it on a few other machines I'd be more willing to have a
> 
> Tested-by: Phil Auld <pauld@redhat.com>  
> 
> on it, if you want it.
> 
> Cheers,
> Phil
> 
> 
> > 
> > Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> > Reported-by: Phil Auld <pauld@redhat.com>
> > Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
> >  tracecmd/trace-record.c | 117 +++++++++++++++++++++++++++-------------
> >  1 file changed, 81 insertions(+), 36 deletions(-)
> > 
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index a3a34f1..4523128 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -951,10 +951,63 @@ static void update_ftrace_pids(int reset)
> >  static void update_event_filters(struct buffer_instance *instance);
> >  static void update_pid_event_filters(struct buffer_instance *instance);
> >  
> > +static void append_filter_pid_range(char **filter, int *curr_len,
> > +				    const char *field,
> > +				    int start_pid, int end_pid, bool exclude)
> > +{
> > +	const char *op = "", *op1, *op2, *op3;
> > +	int len;
> > +
> > +	if (*filter && **filter)
> > +		op = exclude ? "&&" : "||";
> > +
> > +	/* Handle thus case explicitly so that we get `pid==3` instead of
> > +	 * `pid>=3&&pid<=3` for singleton ranges
> > +	 */
> > +	if (start_pid == end_pid) {
> > +#define FMT	"%s(%s%s%d)"
> > +		len = snprintf(NULL, 0, FMT, op,
> > +			       field, exclude ? "!=" : "==", start_pid);
> > +		*filter = realloc(*filter, *curr_len + len + 1);
> > +		if (!*filter)
> > +			die("realloc");
> > +
> > +		len = snprintf(*filter + *curr_len, len + 1, FMT, op,
> > +			       field, exclude ? "!=" : "==", start_pid);
> > +		*curr_len += len;
> > +
> > +		return;
> > +#undef FMT
> > +	}
> > +
> > +	if (exclude) {
> > +		op1 = "<";
> > +		op2 = "||";
> > +		op3 = ">";
> > +	} else {
> > +		op1 = ">=";
> > +		op2 = "&&";
> > +		op3 = "<=";
> > +	}
> > +
> > +#define FMT	"%s(%s%s%d%s%s%s%d)"
> > +	len = snprintf(NULL, 0, FMT, op,
> > +		       field, op1, start_pid, op2,
> > +		       field, op3, end_pid);
> > +	*filter = realloc(*filter, *curr_len + len + 1);
> > +	if (!*filter)
> > +		die("realloc");
> > +
> > +	len = snprintf(*filter + *curr_len, len + 1, FMT, op,
> > +		       field, op1, start_pid, op2,
> > +		       field, op3, end_pid);
> > +	*curr_len += len;
> > +}
> > +
> >  /**
> >   * make_pid_filter - create a filter string to all pids against @field
> >   * @curr_filter: Append to a previous filter (may realloc). Can be NULL
> > - * @field: The fild to compare the pids against
> > + * @field: The field to compare the pids against
> >   *
> >   * Creates a new string or appends to an existing one if @curr_filter
> >   * is not NULL. The new string will contain a filter with all pids
> > @@ -964,54 +1017,46 @@ static void update_pid_event_filters(struct buffer_instance *instance);
> >   */
> >  static char *make_pid_filter(char *curr_filter, const char *field)
> >  {
> > +	int start_pid = -1, last_pid = -1;
> > +	int last_exclude = -1;
> >  	struct filter_pids *p;
> > -	char *filter;
> > -	char *orit;
> > -	char *match;
> > -	char *str;
> > +	char *filter = NULL;
> >  	int curr_len = 0;
> > -	int len;
> >  
> >  	/* Use the new method if possible */
> >  	if (have_set_event_pid)
> >  		return NULL;
> >  
> > -	len = len_filter_pids + (strlen(field) + strlen("(==)||")) * nr_filter_pids;
> > -
> > -	if (curr_filter) {
> > -		curr_len = strlen(curr_filter);
> > -		filter = realloc(curr_filter, curr_len + len + strlen("(&&())"));
> > -		if (!filter)
> > -			die("realloc");
> > -		memmove(filter+1, curr_filter, curr_len);
> > -		filter[0] = '(';
> > -		strcat(filter, ")&&(");
> > -		curr_len = strlen(filter);
> > -	} else
> > -		filter = malloc(len);
> > -	if (!filter)
> > -		die("Failed to allocate pid filter");
> > -
> > -	/* Last '||' that is not used will cover the \0 */
> > -	str = filter + curr_len;
> > +	if (!filter_pids)
> > +		return curr_filter;
> >  
> >  	for (p = filter_pids; p; p = p->next) {
> > -		if (p->exclude) {
> > -			match = "!=";
> > -			orit = "&&";
> > -		} else {
> > -			match = "==";
> > -			orit = "||";
> > +		/*
> > +		 * PIDs are inserted in `filter_pids` from the front and that's
> > +		 * why we expect them in descending order here.
> > +		 */
> > +		if (p->pid == last_pid - 1 && p->exclude == last_exclude) {
> > +			last_pid = p->pid;
> > +			continue;
> >  		}
> > -		if (p == filter_pids)
> > -			orit = "";
> >  
> > -		len = sprintf(str, "%s(%s%s%d)", orit, field, match, p->pid);
> > -		str += len;
> > +		if (start_pid != -1)
> > +			append_filter_pid_range(&filter, &curr_len, field,
> > +						last_pid, start_pid,
> > +						last_exclude);
> > +
> > +		start_pid = last_pid = p->pid;
> > +		last_exclude = p->exclude;
> > +
> >  	}
> > +	append_filter_pid_range(&filter, &curr_len, field,
> > +				last_pid, start_pid, last_exclude);
> >  
> > -	if (curr_len)
> > -		sprintf(str, ")");
> > +	if (curr_filter) {
> > +		char *save = filter;
> > +		asprintf(&filter, "(%s)&&(%s)", curr_filter, filter);
> > +		free(save);
> > +	}
> >  
> >  	return filter;
> >  }
> > -- 
> > 2.19.1
> > 
> 
> -- 
> 
