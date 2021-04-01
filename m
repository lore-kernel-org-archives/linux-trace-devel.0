Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DD5C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 16:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928556100B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 16:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhCaQc4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbhCaQcb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 12:32:31 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B10C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 09:32:30 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id x14so19902424qki.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 09:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=fgcxOTUWHWV/pKxOUCJoCQqEv5RvDDdDuAXR242gbpM=;
        b=PWCtIr/aGE2DBBH+BOFaX11/vBj6OUWXC1eZywF0CfHkSf/5M+k+JayeyX4z0USC8Y
         JqfZxvYiaM2cB8wM6N+Ar4XEzdIlXFtz3WvusXxnLIWOMy/0CbY7QksbypZ4oJrgBDrw
         em1oGY/CLDgGChUgw+VEI70+rtwqGUmMsYsj++nsjyAKpVsnwaPCMBWNU2qs7IZYQlhA
         e32hg8R22JqEyt9G+1wUjVqAQP6zk9E5ag1fV/M33XFm3DnM8MPykcE6hqyJsFsIpG5V
         HA6/OV7DnWRNTE4Eff0frVfUl/Kyts33cXi99ZgmmGmT4LKgBV9GSNRKtg7H+t7qQd3q
         gMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fgcxOTUWHWV/pKxOUCJoCQqEv5RvDDdDuAXR242gbpM=;
        b=H71aezz2obGblnFMxOuJtI1dj2oGXHjrPWASAU5JUWCGIKSiN6cGKCIUT3gTlNmZoc
         Rh3ohqhiNIb5EuYoWIGbvMy58jPfXWLpHPa16NuLk53I+m5aBW72OYFB18OpnRBfwGku
         hCaWcjZ8Nq2vx0N3X7Zd2I1L4bqMbX5g2qKSkhbMp70hTUvHUiaXkksb3VfLPIvahJIU
         6OIrL149I6LqPFNwx8BJ5D9Nitn+IDi7d1m9TDav8Fl3RlXm7LcJv8c7brDC2EOQ52bT
         AV16vVfP9RsBQd6cih6T08XOG0A2o3nVobXZpEeJIUtpV+l9Y8R6Hx0dvnOTmQOztO2h
         y1Gw==
X-Gm-Message-State: AOAM531n84XsFqcExbUF1c5CwEam7qHbGVpKqIS+2ljLsUQLNk2aILeK
        wM0/pqwuTXXS6/fHpQArmKcRKeKH6kY=
X-Google-Smtp-Source: ABdhPJyCu3IAHN+XDl4y2aFDvSfHoUlI+xh0xMo/8TrE6qIt7SVq2gHWQmsMdC2uTJ6KogXS+bQrRw==
X-Received: by 2002:ae9:e518:: with SMTP id w24mr3929472qkf.78.1617208349619;
        Wed, 31 Mar 2021 09:32:29 -0700 (PDT)
Received: from [192.168.1.143] ([27.6.52.172])
        by smtp.gmail.com with ESMTPSA id a207sm1801709qkc.135.2021.03.31.09.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 09:32:28 -0700 (PDT)
Subject: Re: [PATCH 08/13 v2] libtracefs: Allow for setting filters with regex
 expressions
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20210330005123.151740983@goodmis.org>
 <20210330005248.391852830@goodmis.org>
From:   sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Message-ID: <96e9fc99-53c5-ea5a-7e5d-5ea6dafc1f7c@gmail.com>
Date:   Thu, 1 Apr 2021 22:03:02 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210330005248.391852830@goodmis.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi steve,

On 30/03/21 6:21 am, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> All for full "regex(3)" processing of setting functions in the
> set_ftrace_filter file. Check if the filter passed in is just a glob
> expression that the kernel can process, or if it is a regex that should look
> at the available_filter_functions list instead.
>
> If it is a regex, it will read the available_filter_functions and write in
> each function as it finds it.
>
> Link: https://lore.kernel.org/linux-trace-devel/20210323013225.451281989@goodmis.org
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   Documentation/libtracefs-function-filter.txt |  10 ++
>   src/tracefs-tools.c                          | 139 ++++++++++++++++---
>   2 files changed, 128 insertions(+), 21 deletions(-)
>
> diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
> index c0c89f372c21..88aa3b923d54 100644
> --- a/Documentation/libtracefs-function-filter.txt
> +++ b/Documentation/libtracefs-function-filter.txt
> @@ -32,6 +32,16 @@ _errs_, is a pointer to an array of strings, which will be allocated if
>   any of filters fail to match any available function, If _errs_ is NULL, it will
>   be ignored.
>   
> +A filter in the array of _filters_ may be either a straight match of a
> +function, a glob or regex(3). a glob is where '*' matches zero or more
> +characters, '?' will match zero or one character, and '.' only matches a
> +period. If the filter is determined to be a regex (where it contains
> +anything other than alpha numeric characters, or '.', '*', '?') the filter
> +will be processed as a regex(3) following the rules of regex(3), and '.' is
> +not a period, but will match any one character. To force a regular
> +expression, either prefix the filter with a '^' or append it with a '$' as
> +all filters will act as complete matches of functions anyway.
> +

if we give the filter as regex "^ext4*$" from user side, ideally it 
should match the ext4 filter functions, if i am not wrong, its not 
matching any filter in the available_filter_functions

is this expected behaviour?

if we give the filter as glob "ext4*" from userside, its making the 
regex and matching the ext4 filter functions in the 
available_filter_functions.

>   returns 0  on success, 1 or -x (where x is an integer) on error.
>   
>   RETURN VALUE
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index 470502b07f7d..d1a448459c6f 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -18,8 +18,9 @@
>   #include "tracefs.h"
>   #include "tracefs-local.h"
>   
> -#define TRACE_CTRL	"tracing_on"
> -#define TRACE_FILTER	"set_ftrace_filter"
> +#define TRACE_CTRL		"tracing_on"
> +#define TRACE_FILTER		"set_ftrace_filter"
> +#define TRACE_FILTER_LIST	"available_filter_functions"
>   
>   static const char * const options_map[] = {
>   	"unknown",
> @@ -421,8 +422,53 @@ struct func_filter {
>   	const char		*filter;
>   	regex_t			re;
>   	bool			set;
> +	bool			is_regex;
>   };
>   
> +static bool is_regex(const char *str)
> +{
> +	int i;
> +
> +	for (i = 0; str[i]; i++) {
> +		switch (str[i]) {
> +		case 'a' ... 'z':
> +		case 'A'...'Z':
> +		case '_':
> +		case '0'...'9':
> +		case '*':
> +		case '.':
> +			/* Dots can be part of a function name */
> +		case '?':
> +			continue;
> +		default:
> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +
> +static char *update_regex(const char *reg)
> +{
> +	int len = strlen(reg);
> +	char *str;
> +
> +	if (reg[0] == '^' && reg[len - 1] == '$')
> +		return strdup(reg);
> +
> +	str = malloc(len + 3);
> +	if (reg[0] == '^') {
> +		strcpy(str, reg);
> +	} else {
> +		str[0] = '^';
> +		strcpy(str + 1, reg);
> +		len++; /* add ^ */
> +	}
> +	if (str[len - 1] != '$')
> +		str[len++]= '$';
> +	str[len] = '\0';
> +	return str;
> +}
> +
>   /*
>    * Convert a glob into a regular expression.
>    */
> @@ -488,8 +534,13 @@ static int write_filter(int fd, const char *filter, const char *module)
>   	return 0;
>   }
>   
> -static int check_available_filters(struct func_filter *func_filters,
> -				   const char *module, const char ***errs)
> +enum match_type {
> +	FILTER_CHECK,
> +	FILTER_WRITE,
> +};
> +
> +static int match_filters(int fd, struct func_filter *func_filters,
> +			 const char *module, enum match_type type)
>   {
>   	char *line = NULL;
>   	size_t size = 0;
> @@ -499,7 +550,7 @@ static int check_available_filters(struct func_filter *func_filters,
>   	int mlen;
>   	int i;
>   
> -	path = tracefs_get_tracing_file("available_filter_functions");
> +	path = tracefs_get_tracing_file(TRACE_FILTER_LIST);
>   	if (!path)
>   		return 1;
>   
> @@ -530,39 +581,76 @@ static int check_available_filters(struct func_filter *func_filters,
>   			    (mtok[mlen + 1] != ']'))
>   				goto next;
>   		}
> -		for (i = 0; func_filters[i].filter; i++) {
> -			if (match(tok, &func_filters[i]))
> -				func_filters[i].set = true;
> +		switch (type) {
> +		case FILTER_CHECK:
> +			/* Check, checks a list of filters */
> +			for (i = 0; func_filters[i].filter; i++) {
> +				if (match(tok, &func_filters[i]))
> +					func_filters[i].set = true;
> +			}
> +			break;
> +		case FILTER_WRITE:
> +			/* Writes only have one filter */
> +			if (match(tok, func_filters)) {
> +				ret = write_filter(fd, tok, module);
> +				if (ret)
> +					goto out;
> +			}
> +			break;
>   		}
>   	next:
>   		free(line);
>   		line = NULL;
>   		len = 0;
>   	}
> + out:
> +	free(line);
>   	fclose(fp);
>   
> +	return ret;
> +}
> +
> +static int check_available_filters(struct func_filter *func_filters,
> +				   const char *module, const char ***errs)
> +{
> +	int ret;
> +	int i;
> +
> +	ret = match_filters(-1, func_filters, module, FILTER_CHECK);
> +	/* Return here if success or non filter error */
> +	if (ret >= 0)
> +		return ret;
> +
> +	/* Failed on filter, set the errors */
>   	ret = 0;
>   	for (i = 0; func_filters[i].filter; i++) {
>   		if (!func_filters[i].set)
>   			add_errors(errs, func_filters[i].filter, ret--);
>   	}
> -
>   	return ret;
>   }
>   
> -static int controlled_write(int fd, const char **filters,
> +static int set_regex_filter(int fd, struct func_filter *func_filter,
> +			    const char *module)
> +{
> +	return match_filters(fd, func_filter, module, FILTER_WRITE);
> +}
> +
> +static int controlled_write(int fd, struct func_filter *func_filters,
>   			    const char *module, const char ***errs)
>   {
>   	int ret = 0;
>   	int i;
>   
> -	for (i = 0; filters[i]; i++) {
> +	for (i = 0; func_filters[i].filter; i++) {
> +		const char *filter = func_filters[i].filter;
>   		int r;
>   
> -		r = write_filter(fd, filters[i], module);
> -		if (r < 0) {
> -			add_errors(errs, filters[i], ret--);
> -		} else if (r > 0) {
> +		if (func_filters[i].is_regex)
> +			r = set_regex_filter(fd, &func_filters[i], module);
> +		else
> +			r = write_filter(fd, filter, module);
> +		if (r > 0) {
>   			/* Not filter error */
>   			if (errs) {
>   				free(*errs);
> @@ -570,6 +658,8 @@ static int controlled_write(int fd, const char **filters,
>   			}
>   			return 1;
>   		}
> +		if (r < 0)
> +			add_errors(errs, filter, ret--);
>   	}
>   	return ret;
>   }
> @@ -579,7 +669,11 @@ static int init_func_filter(struct func_filter *func_filter, const char *filter)
>   	char *str;
>   	int ret;
>   
> -	str = make_regex(filter);
> +	if (!(func_filter->is_regex = is_regex(filter)))
> +		str = make_regex(filter);
> +	else
> +		str = update_regex(filter);
> +
>   	if (!str)
>   		return -1;
>   
> @@ -679,24 +773,27 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
>   		*errs = NULL;
>   
>   	ret = check_available_filters(func_filters, module, errs);
> -	free_func_filters(func_filters);
>   	if (ret)
> -		return ret;
> +		goto out_free;
>   
> +	ret = 1;
>   	ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
>   	if (!ftrace_filter_path)
> -		return 1;
> +		goto out_free;
>   
>   	flags = reset ? O_TRUNC : O_APPEND;
>   
>   	fd = open(ftrace_filter_path, O_WRONLY | flags);
>   	tracefs_put_tracing_file(ftrace_filter_path);
>   	if (fd < 0)
> -		return 1;
> +		goto out_free;
>   
> -	ret = controlled_write(fd, filters, module, errs);
> +	ret = controlled_write(fd, func_filters, module, errs);
>   
>   	close(fd);
>   
> + out_free:
> +	free_func_filters(func_filters);
> +
>   	return ret;
>   }
