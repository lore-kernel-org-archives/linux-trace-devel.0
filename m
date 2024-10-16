Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6AB2BD19
	for <linux-trace-devel@vger.kernel.org>; Wed, 16 Oct 2024 06:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729060838; cv=none; b=FXKYrpnUwH/hiOfTm4KWgnHRFR8vJ1F0QRDl1yd9/QhnJImeTi5T46zQ5BYPk21E+z/+ZoyAYXnnIbbCph0wQaeAcwNm71FhilC3paP9f10Wm73xA4ChPl9B2BEHoR6hYul/NTMZZkt6xLiPrppx/tm68FBCPrIbwXTYPUTYNzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729060838; c=relaxed/simple;
	bh=eyyvdeDZKa8Ya2t8AsGvpdjYKH2p+YLiRmiG/ZtUxho=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=MUnJzWXoUX3SaDv/5x/M+STMq2KWGO9iwjPzqy02n7inWPrNkaTkLsW1gEJeOmXr2LsoNwSnuRVD/VImZVHhRqLrLFZPZ4l4P14XWHg584ppZfpNnWW6uj2o9GkZskUgDr16dKKG6zNUuacSykleLY+NSSkUIZ/UeW1PHfaQs5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0F2BFEC;
	Tue, 15 Oct 2024 23:40:57 -0700 (PDT)
Received: from [10.57.21.119] (unknown [10.57.21.119])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B98423F528;
	Tue, 15 Oct 2024 23:40:27 -0700 (PDT)
Message-ID: <3c199734-5ece-4895-92b5-a15cc8b1edf1@arm.com>
Date: Wed, 16 Oct 2024 07:40:25 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libtracefs: Have tracefs_dynevent_get_all() find kprobes
 and uprobes properly
To: Steven Rostedt <rostedt@goodmis.org>
References: <20241015151117.5562bd41@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
In-Reply-To: <20241015151117.5562bd41@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/10/2024 8:11 pm, Steven Rostedt wrote:
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
>   src/tracefs-dynevents.c | 113 +++++++++++++++++++++-------------------
>   1 file changed, 60 insertions(+), 53 deletions(-)
> 
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> index 85c1fcd9d5d5..6b9ba539fde3 100644
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
> @@ -480,16 +483,15 @@ int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force)
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
> @@ -499,6 +501,9 @@ static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system
>   	if (!content)
>   		return -1;
>   
> +	if (ret_all)
> +		all = *ret_all;
> +
>   	line = content;
>   	do {
>   		next = strchr(line, '\n');
> @@ -507,11 +512,12 @@ static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system
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
> @@ -521,12 +527,38 @@ static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system
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
> @@ -561,41 +593,16 @@ void tracefs_dynevent_list_free(struct tracefs_dynevent **events)
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


I could successfully apply the patch on 4cbebed79b1f ("libtracefs: 
Documentation: Add missing documentation to meson.build").
The unit tests at [1] passes with this patch.

Just for the records, there are some unit test failures in libtracefs 
(they were there even before the patch):

$ sudo ./utest/trace-utest
      CUnit - A unit testing framework for C - Version 2.1-3
      http://cunit.sourceforge.net/

Memory mapped buffers not supported

Suite: tracefs library
   Test: Test tracefs/debugfs mounting ...FAILED
     1. tracefs-utest.c:1806  - ret == 0
   Test: trace cpu read ...passed
   Test: trace cpu read_buf_percent ...passed
   Test: trace cpu pipe ...passed
   Test: trace pid events filter ...passed
   Test: trace pid function filter ...passed
   Test: trace sql ...passed
   Test: trace sql trace onmax ...passed
   Test: trace sql trace onchange ...passed
   Test: trace sql snapshot onmax ...passed
   Test: trace sql snapshot onchange ...passed
   Test: trace sql save onmax ...passed
   Test: trace sql save onchange ...passed
   Test: trace sql trace and snapshot onmax ...passed
   Test: trace sql trace and snapshot onchange ...passed
   Test: tracing file / directory APIs ...passed
   Test: instance file / directory APIs ...passed
   Test: instance file descriptor ...passed
   Test: instance reset ...passed
   Test: systems and events APIs ...passed
   Test: tracefs_iterate_snapshot_events API ...passed
   Test: tracefs_iterate_raw_events API ...FAILED
     1. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
     2. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
   Test: Follow events ...passed
   Test: Follow events clear ...passed
   Test: tracefs_tracers API ...passed
   Test: tracefs_local events API ...passed
   Test: tracefs_instances_walk API ...passed
   Test: tracefs_get_clock API ...passed
   Test: tracing on / off ...passed
   Test: tracing options ...passed
   Test: custom system directory ...passed
   Test: ftrace marker ...passed
   Test: kprobes ...passed
   Test: synthetic events ...passed
   Test: eprobes ...passed
   Test: uprobes ...FAILED
     1. tracefs-utest.c:2222  - ret == 0
     2. tracefs-utest.c:2222  - ret == 0

Run Summary:    Type    Total      Ran   Passed Failed Inactive
               suites        1        1      n/a      0        0
                tests       36       36       33      3        0
              asserts 30341119 30341119 30341114      5      n/a

Elapsed time =  124.937 seconds

With that,

Reviewed-by: Metin Kaya <metin.kaya@arm.com>


Thanks a lot for fixing it promptly!

[1] https://lore.kernel.org/all/20241015140840.4183007-1-metin.kaya@arm.com/

