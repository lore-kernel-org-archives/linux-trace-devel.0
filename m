Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED5EC282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A3B7206BA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731454AbfDQN7C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:59:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730209AbfDQN7C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 09:59:02 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D1A03001764;
        Wed, 17 Apr 2019 13:59:01 +0000 (UTC)
Received: from pauld.bos.csb (dhcp-17-51.bos.redhat.com [10.18.17.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B30E608A7;
        Wed, 17 Apr 2019 13:59:00 +0000 (UTC)
Date:   Wed, 17 Apr 2019 09:58:58 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: Re: [PATCH v4 1/2] trace-cmd: Optimize how pid filters are expressed
Message-ID: <20190417135858.GD6118@pauld.bos.csb>
References: <20190417130959.10064-1-kaslevs@vmware.com>
 <20190417130959.10064-2-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417130959.10064-2-kaslevs@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 17 Apr 2019 13:59:01 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Apr 17, 2019 at 04:09:58PM +0300 Slavomir Kaslev wrote:
> Express pid filters as allowed/disallowed filter ranges
> 
>   (pid>=100&&pid<=103)
> 
> instead of specifying them per pid
> 
>   (pid==100||pid==101||pid==102||pid==103)
> 
> This makes the size of the resulting filter smaller (and faster) and avoids
> overflowing the filter size limit of one page which we can hit on bigger
> machines (say >160 CPUs).

This one works as well :)

I finally hit a case where my trace-cmd pids were non-contiguous and 
this split the range up correctly. 


FILTER write /sys/kernel/debug/tracing/events/sched/sched_kthread_stop/filter (len 74) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)"
FILTER write /sys/kernel/debug/tracing/events/sched/sched_kthread_stop_ret/filter (len 74) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)"
...
FILTER write /sys/kernel/debug/tracing/events/sched/sched_switch/filter (len 142) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)||(next_pid<21420||next_pid>21425)&&(next_pid<21265||next_pid>21418)"


The latter is correct given precendce of && before || but I wonder if () don't make sense? I always have to look
that one up :)

If I were writing that in code I'd probably put in the extra ()s, but since it's generated and no
one actually sees it, probably okay and simpler as is. 

 
Having seen that and having tried it on a few other machines I'd be more willing to have a

Tested-by: Phil Auld <pauld@redhat.com>  

on it, if you want it.

Cheers,
Phil


> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> Reported-by: Phil Auld <pauld@redhat.com>
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tracecmd/trace-record.c | 117 +++++++++++++++++++++++++++-------------
>  1 file changed, 81 insertions(+), 36 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index a3a34f1..4523128 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -951,10 +951,63 @@ static void update_ftrace_pids(int reset)
>  static void update_event_filters(struct buffer_instance *instance);
>  static void update_pid_event_filters(struct buffer_instance *instance);
>  
> +static void append_filter_pid_range(char **filter, int *curr_len,
> +				    const char *field,
> +				    int start_pid, int end_pid, bool exclude)
> +{
> +	const char *op = "", *op1, *op2, *op3;
> +	int len;
> +
> +	if (*filter && **filter)
> +		op = exclude ? "&&" : "||";
> +
> +	/* Handle thus case explicitly so that we get `pid==3` instead of
> +	 * `pid>=3&&pid<=3` for singleton ranges
> +	 */
> +	if (start_pid == end_pid) {
> +#define FMT	"%s(%s%s%d)"
> +		len = snprintf(NULL, 0, FMT, op,
> +			       field, exclude ? "!=" : "==", start_pid);
> +		*filter = realloc(*filter, *curr_len + len + 1);
> +		if (!*filter)
> +			die("realloc");
> +
> +		len = snprintf(*filter + *curr_len, len + 1, FMT, op,
> +			       field, exclude ? "!=" : "==", start_pid);
> +		*curr_len += len;
> +
> +		return;
> +#undef FMT
> +	}
> +
> +	if (exclude) {
> +		op1 = "<";
> +		op2 = "||";
> +		op3 = ">";
> +	} else {
> +		op1 = ">=";
> +		op2 = "&&";
> +		op3 = "<=";
> +	}
> +
> +#define FMT	"%s(%s%s%d%s%s%s%d)"
> +	len = snprintf(NULL, 0, FMT, op,
> +		       field, op1, start_pid, op2,
> +		       field, op3, end_pid);
> +	*filter = realloc(*filter, *curr_len + len + 1);
> +	if (!*filter)
> +		die("realloc");
> +
> +	len = snprintf(*filter + *curr_len, len + 1, FMT, op,
> +		       field, op1, start_pid, op2,
> +		       field, op3, end_pid);
> +	*curr_len += len;
> +}
> +
>  /**
>   * make_pid_filter - create a filter string to all pids against @field
>   * @curr_filter: Append to a previous filter (may realloc). Can be NULL
> - * @field: The fild to compare the pids against
> + * @field: The field to compare the pids against
>   *
>   * Creates a new string or appends to an existing one if @curr_filter
>   * is not NULL. The new string will contain a filter with all pids
> @@ -964,54 +1017,46 @@ static void update_pid_event_filters(struct buffer_instance *instance);
>   */
>  static char *make_pid_filter(char *curr_filter, const char *field)
>  {
> +	int start_pid = -1, last_pid = -1;
> +	int last_exclude = -1;
>  	struct filter_pids *p;
> -	char *filter;
> -	char *orit;
> -	char *match;
> -	char *str;
> +	char *filter = NULL;
>  	int curr_len = 0;
> -	int len;
>  
>  	/* Use the new method if possible */
>  	if (have_set_event_pid)
>  		return NULL;
>  
> -	len = len_filter_pids + (strlen(field) + strlen("(==)||")) * nr_filter_pids;
> -
> -	if (curr_filter) {
> -		curr_len = strlen(curr_filter);
> -		filter = realloc(curr_filter, curr_len + len + strlen("(&&())"));
> -		if (!filter)
> -			die("realloc");
> -		memmove(filter+1, curr_filter, curr_len);
> -		filter[0] = '(';
> -		strcat(filter, ")&&(");
> -		curr_len = strlen(filter);
> -	} else
> -		filter = malloc(len);
> -	if (!filter)
> -		die("Failed to allocate pid filter");
> -
> -	/* Last '||' that is not used will cover the \0 */
> -	str = filter + curr_len;
> +	if (!filter_pids)
> +		return curr_filter;
>  
>  	for (p = filter_pids; p; p = p->next) {
> -		if (p->exclude) {
> -			match = "!=";
> -			orit = "&&";
> -		} else {
> -			match = "==";
> -			orit = "||";
> +		/*
> +		 * PIDs are inserted in `filter_pids` from the front and that's
> +		 * why we expect them in descending order here.
> +		 */
> +		if (p->pid == last_pid - 1 && p->exclude == last_exclude) {
> +			last_pid = p->pid;
> +			continue;
>  		}
> -		if (p == filter_pids)
> -			orit = "";
>  
> -		len = sprintf(str, "%s(%s%s%d)", orit, field, match, p->pid);
> -		str += len;
> +		if (start_pid != -1)
> +			append_filter_pid_range(&filter, &curr_len, field,
> +						last_pid, start_pid,
> +						last_exclude);
> +
> +		start_pid = last_pid = p->pid;
> +		last_exclude = p->exclude;
> +
>  	}
> +	append_filter_pid_range(&filter, &curr_len, field,
> +				last_pid, start_pid, last_exclude);
>  
> -	if (curr_len)
> -		sprintf(str, ")");
> +	if (curr_filter) {
> +		char *save = filter;
> +		asprintf(&filter, "(%s)&&(%s)", curr_filter, filter);
> +		free(save);
> +	}
>  
>  	return filter;
>  }
> -- 
> 2.19.1
> 

-- 
