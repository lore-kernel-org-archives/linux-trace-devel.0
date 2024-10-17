Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA4F1D223C
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 08:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153027; cv=none; b=CdJaiYmEEp4i2WQJeXEC2+K0mYs8dfmgTX3m/JOmhOWfAiRn0pqKw9YveNxmWZtXrqP7oL+pjlpmofPUaqLjbJfwcxs2oeZQVvuXnFuwF5Q+IV6/xedVUkHlvQrrUtpu8gNYuiPSZEYCkdUIrigyew4WwRH2X3+TtxcyeixVOXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153027; c=relaxed/simple;
	bh=QIgmoTdG7fQ3o7GFOkPNcA3+t5Pery9LHOMiWPENW5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=J80CnLRxi05mDA1xKi038SpsLHwpLkA4J0FKDwdEXCHOn0OqB7Tlu9TaQDhQCY83rg73RF3B5l4/C8BMQiKxw31pw8IOKSZYrcAbAIGGjXETy4iGhxILK9nbDZBgjSZsdhQQegDx+tBedScwRkavacVJmMioaXwdXgcOR1h71fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67B03FEC;
	Thu, 17 Oct 2024 01:17:32 -0700 (PDT)
Received: from [10.57.21.119] (unknown [10.57.21.119])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4793A3F71E;
	Thu, 17 Oct 2024 01:17:02 -0700 (PDT)
Message-ID: <62449ac4-470e-48fe-adb9-7baba1662b3b@arm.com>
Date: Thu, 17 Oct 2024 09:17:00 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] libtracefs: Have tracefs_dynevent_get_all() find
 kprobes and uprobes properly
To: Steven Rostedt <rostedt@goodmis.org>
References: <20241016104737.6a00953a@gandalf.local.home>
Content-Language: en-US
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20241016104737.6a00953a@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2024 3:47 pm, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The function tracefs_dynevent_get_all() will only look at the
> dynamic_events file if it exists to find matching probes. But because
> uprobes and kprobes both use the same prefix "p" as well as uretprobes and
> kretprobes (with prefix "r"), it cannot use the dynamic_events file to
> differentiate between the two.
> 
> Have kprobes and uprobes always use their own files (kprobe_events and
> uprobe_events) even if dynamic_events file exists.
> 
> Also cleaned up the code to be a bit more efficient.
> 
> Link: https://lore.kernel.org/all/20241015123831.347ff0f4@gandalf.local.home/
> 
> Fixes: b04f18b005c6b ("libtracefs: New APIs for dynamic events")
> Reported-by: Metin Kaya <metin.kaya@arm.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Changes since v1: https://lore.kernel.org/all/20241015151117.5562bd41@gandalf.local.home/
> 
> - Fixed reading an empty kprobe_events or uprobe_events file
> 
>   src/tracefs-dynevents.c | 119 ++++++++++++++++++++++------------------
>   1 file changed, 65 insertions(+), 54 deletions(-)
> 
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> index 85c1fcd9d5d5..6df7212fb38e 100644
> --- a/src/tracefs-dynevents.c
> +++ b/src/tracefs-dynevents.c
> @@ -34,23 +34,21 @@ static int dyn_generic_del(struct dyn_events_desc *, struct tracefs_dynevent *);
>   static int dyn_synth_del(struct dyn_events_desc *, struct tracefs_dynevent *);
>   
>   struct dyn_events_desc {
> -	enum tracefs_dynevent_type type;
> -	const char *file;
> -	const char *prefix;
> +	enum tracefs_dynevent_type	type;
> +	const char			*file;
> +	const char			*prefix;
>   	int (*del)(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn);
>   	int (*parse)(struct dyn_events_desc *desc, const char *group,
>   				char *line, struct tracefs_dynevent **ret_dyn);
>   } dynevents[] = {
> -	{TRACEFS_DYNEVENT_KPROBE, KPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
> +	{TRACEFS_DYNEVENT_KPROBE,    KPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
>   	{TRACEFS_DYNEVENT_KRETPROBE, KPROBE_EVENTS, "r", dyn_generic_del, dyn_generic_parse},
> -	{TRACEFS_DYNEVENT_UPROBE, UPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
> +	{TRACEFS_DYNEVENT_UPROBE,    UPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
>   	{TRACEFS_DYNEVENT_URETPROBE, UPROBE_EVENTS, "r", dyn_generic_del, dyn_generic_parse},
> -	{TRACEFS_DYNEVENT_EPROBE, "", "e", dyn_generic_del, dyn_generic_parse},
> -	{TRACEFS_DYNEVENT_SYNTH, SYNTH_EVENTS, "", dyn_synth_del, dyn_synth_parse},
> +	{TRACEFS_DYNEVENT_EPROBE,    "",            "e", dyn_generic_del, dyn_generic_parse},
> +	{TRACEFS_DYNEVENT_SYNTH,     SYNTH_EVENTS, "", dyn_synth_del, dyn_synth_parse},
>   };
>   
> -
> -
>   static int dyn_generic_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
>   {
>   	char *str;
> @@ -280,8 +278,13 @@ static void init_devent_desc(void)
>   		return;
>   
>   	/* Use  ftrace dynamic_events, if available */
> -	for (i = 0; i < EVENT_INDEX(TRACEFS_DYNEVENT_MAX); i++)
> +	for (i = 0; i < EVENT_INDEX(TRACEFS_DYNEVENT_MAX); i++) {
> +		/* kprobes and uprobes do not use default file */
> +		if (dynevents[i].prefix[0] == 'p' ||
> +		    dynevents[i].prefix[0] == 'r')
> +			continue;
>   		dynevents[i].file = DYNEVENTS_EVENTS;
> +	}
>   
>   	dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_SYNTH)].prefix = "s";
>   }
> @@ -480,24 +483,30 @@ int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force)
>   	return desc->del(desc, devent);
>   }
>   
> -static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system,
> -			     struct tracefs_dynevent ***ret_all)
> +static int get_dynevent(enum tracefs_dynevent_type type, const char *system,
> +			struct tracefs_dynevent ***ret_all, int count)
>   {
>   	struct dyn_events_desc *desc;
> -	struct tracefs_dynevent *devent, **tmp, **all = NULL;
> +	struct tracefs_dynevent *devent, **tmp, **all;
>   	char *content;
> -	int count = 0;
>   	char *line;
>   	char *next;
> -	int ret;
> +	int ret = -1;
>   
>   	desc = get_devent_desc(type);
>   	if (!desc)
>   		return -1;
>   
> +	if (!tracefs_file_exists(NULL, desc->file))
> +		return -1;
> +
>   	content = tracefs_instance_file_read(NULL, desc->file, NULL);
> +	/* File exists, but may be empty */
>   	if (!content)
> -		return -1;
> +		return 0;
> +
> +	if (ret_all)
> +		all = *ret_all;
>   
>   	line = content;
>   	do {
> @@ -507,11 +516,12 @@ static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system
>   		ret = desc->parse(desc, system, line, ret_all ? &devent : NULL);
>   		if (!ret) {
>   			if (ret_all) {
> -				tmp = realloc(all, (count + 1) * sizeof(*tmp));
> +				tmp = realloc(all, (count + 2) * sizeof(*tmp));
>   				if (!tmp)
> -					goto error;
> +					break;
>   				all = tmp;
>   				all[count] = devent;
> +				all[count + 1] = NULL;
>   			}
>   			count++;
>   		}
> @@ -521,12 +531,38 @@ static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system
>   	free(content);
>   	if (ret_all)
>   		*ret_all = all;
> +
>   	return count;
> +}
>   
> -error:
> -	free(content);
> -	free(all);
> -	return -1;
> +static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system,
> +			     struct tracefs_dynevent ***ret_all)
> +{
> +	int count = 0;
> +	int i;
> +
> +	if (ret_all)
> +		*ret_all = NULL;
> +
> +	for (i = 0; i < EVENT_INDEX(TRACEFS_DYNEVENT_MAX); i++) {
> +		if (!((1 << i) & type))
> +			continue;
> +
> +		count = get_dynevent((1 << i), system, ret_all, count);
> +		if (count < 0) {
> +			count = 0;
> +			break;
> +		}
> +	}
> +
> +	if (!count) {
> +		if (ret_all) {
> +			free(*ret_all);
> +			*ret_all = NULL;
> +		}
> +		count = -1;
> +	}
> +	return count;
>   }
>   
>   /**
> @@ -561,41 +597,16 @@ void tracefs_dynevent_list_free(struct tracefs_dynevent **events)
>   struct tracefs_dynevent **
>   tracefs_dynevent_get_all(unsigned int types, const char *system)
>   {
> -	struct tracefs_dynevent **events, **tmp, **all_events = NULL;
> -	int count, all = 0;
> -	int i;
> +	struct tracefs_dynevent **events;
> +	int count;
>   
> -	for (i = 1; i < TRACEFS_DYNEVENT_MAX; i <<= 1) {
> -		if (types) {
> -			if (i > types)
> -				break;
> -			if (!(types & i))
> -				continue;
> -		}
> -		count = get_all_dynevents(i, system, &events);
> -		if (count > 0) {
> -			tmp = realloc(all_events, (all + count + 1) * sizeof(*tmp));
> -			if (!tmp)
> -				goto error;
> -			all_events = tmp;
> -			memcpy(all_events + all, events, count * sizeof(*events));
> -			all += count;
> -			/* Add a NULL pointer at the end */
> -			all_events[all] = NULL;
> -			free(events);
> -		}
> +	count = get_all_dynevents(types, system, &events);
> +	if (count <= 0) {
> +		free(events);
> +		return NULL;
>   	}
>   
> -	return all_events;
> -
> -error:
> -	free(events);
> -	if (all_events) {
> -		for (i = 0; i < all; i++)
> -			free(all_events[i]);
> -		free(all_events);
> -	}
> -	return NULL;
> +	return events;
>   }
>   
>   /**


All unit tests (including new ones written in [1]) in trace-cmd passes 
after this patch. I also confirm this patch addresses the issues 
mentioned in v1 [2]. Hence,

Tested-by: Metin Kaya <metin.kaya@arm.com>

[1] 
https://lore.kernel.org/linux-trace-devel/20241016091731.102563-1-metin.kaya@arm.com
[2] 
https://lore.kernel.org/linux-trace-devel/6dbeb80b-03b2-4060-8737-3a08432590c6@arm.com 

